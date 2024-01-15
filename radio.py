from core import Core, RadioIdentity
from generator import QueryGenerator, TX_On_AIR
from dbdriver import MSSSConnector, get_connection, get_simple_row, get_simple_column, get_multiple_row, get_file, \
    execute_no_answer_query
from threading import Timer, Thread
from datetime import datetime, timedelta
from time import sleep
import signal
from platform import system


_termination_command = [False]
_single_radio = False


class Commander(Thread):
    def __init__(self, memory, radio, logs, request_command):
        super(Commander, self).__init__(name=f"{radio.name}_Commander", daemon=True)
        self.radio = radio
        self.memory = memory
        self.log = logs['Commander']
        self.request_command = request_command
        self.select = get_file('dbfiles/select/command_history.sql').format(self.radio.name)
        self.update = get_file('dbfiles/update/command_history.sql')
        self.connection = None

        self._alive_counter = self._err_counter = self._command_counter = 0
        self._sleep_time = 5
        self.log.debug('Initiated')
        self.request = {'G': 'Get', 'S': 'Set', 'T': 'Trap'}
        self.time_period_commands = {'FFSQ': (0, 1), 'RCIT': (1, 0), 'RCPF': (1, 0), 'RCPT': (1, 0)}

    @property
    def timing(self):
        return self._sleep_time

    @timing.setter
    def timing(self, t):
        self.log.info("Timing Updated")
        self._sleep_time = t

    @property
    def alive_add(self):
        return self._alive_counter

    @alive_add.setter
    def alive_add(self, value=1):
        self._alive_counter += value
        if self._alive_counter > 65535:
            self._alive_counter -= 65535

    @property
    def err_add(self):
        return self._err_counter

    @err_add.setter
    def err_add(self, value=1):
        self._err_counter += value
        if self._err_counter > 65535:
            self._err_counter -= 65535

    @property
    def query_add(self):
        return self._command_counter

    @query_add.setter
    def query_add(self, value=1):
        self._command_counter += value
        if self._command_counter > 65535:
            self._command_counter -= 65535

    def run(self) -> None:
        self.connection = get_connection(self.log)
        self.log.info('Started')
        while self.memory.connection_is_active:
            answer = get_multiple_row(self.connection, self.select, log=self.log)
            if answer is not None:
                for command_args in answer:
                    self.run_command(*command_args)

            sleep(self.timing)

        self.log.info('Finished')

    def run_command(self, _id, key, request, value):
        if key in {'RCPF', 'RCPT'} and self.memory.on_air:
            self.update_database(_id, stat=8)
            self.log.debug(f'Command Failed (TX On AIR): {self.request[request]} {key} {value}')
            return

        if key in self.time_period_commands:
            start, end = self.time_period_commands[key]
            running_length = int(value)

            self.log.debug(f'Command Received: {self.request[request]} {key} {running_length} second')
            sending_id = self.request_command((key, request, start))
            self.memory.user_command[sending_id] = None

            self.update_database(_id, stat=3)
            self.log.debug(f'Command Requested: {self.request[request]} {key} {value}')

            if self.command_ok(sending_id):
                self.update_database(_id, stat=6)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} Executed SUCCESSFULLY!')
            else:
                self.update_database(_id, stat=5)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} FAILED')
                # Failed due to TX On AIR
                return

            sleep(running_length)

            self.log.debug(f'Command Finished: {self.request[request]} {key} {running_length} second')
            sending_id = self.request_command((key, request, end))
            self.memory.user_command[sending_id] = None

            self.update_database(_id, stat=7)
            self.log.debug(f'Command Stopping: {self.request[request]} {key} {value}')

            if self.command_ok(sending_id):
                self.update_database(_id, stat=4)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} Executed SUCCESSFULLY!')
            else:
                self.update_database(_id, stat=5)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} FAILED')

        else:
            self.log.debug(f'Command Received: {self.request[request]} {key} {value}')
            sending_id = self.request_command((key, request, value))
            self.memory.user_command[sending_id] = None

            self.update_database(_id, stat=3)
            self.log.debug(f'Command Requested: {self.request[request]} {key} {value}')

            if self.command_ok(sending_id):
                self.update_database(_id, stat=4)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} Executed SUCCESSFULLY!')
            else:
                self.update_database(_id, stat=5)
                self.log.debug(f'Command Result: {self.request[request]} {key} {value} FAILED')
                # Failed due to TX On AIR
        sleep(0.5)

    def command_ok(self, sending_id):
        while self.memory.user_command[sending_id] is None:
            sleep(0.2)

        return self.memory.user_command.pop(sending_id)

    def update_database(self, _id, stat):
        now = str(datetime.now())[:23]
        execute_no_answer_query(self.connection, self.update.format(now, stat, _id), self.log)


class RadioControl(Core):
    generator: QueryGenerator   # Thread Object
    connector: MSSSConnector    # Thread Object
    setting_updater: Timer      # Timer Object
    aging_updater: Timer        # Timer Object
    status_update: Thread       # Thread Object
    commander:     Thread       # Thread Object

    def __init__(self, name, _termination_command):
        self.connection = get_connection()

        identity, ind_on, ind_off, con, dis = self.get_identity(name)

        self.application_timing = self.application_config = self.radio_stat = None
        self.latest_radio_setting = self.latest_inventory = self.registered_cbit_codes = None
        self.first_ip = self.second_ip = self.access_list = self.software_version = None
        self.initial_commands = self.module_status_id, self.registered_cbit_settings = None
        # self.setting_key_list = None

        from log import get_all_loggers
        from dbdriver import get_logger_config, get_logger_format

        self.logs = get_all_loggers(str(identity), get_logger_config(), get_logger_format())
        # self.logs = get_default_loggers(str(identity), )
        self.log = self.logs['Core']

        import os
        self.pid = os.getpid()

        self.read_db_data(identity)
        self.connection.close()

        super(RadioControl, self).__init__(identity, self.logs, self.application_timing, self.application_config,
                                           _termination_command)
        self.memory.add_previous(ind_on, ind_off, con, dis)

        # for row in self.timing:
        #     if row[1] == 'RadioControl':
        #         self._check_period = float(row[3])

        self.max_delay_setting_fetch, self.periodic_setting_check = 60, 1440
        self.first_time_setting_fetch, self.task_scheduled, self.aging_scheduled = True, False, False
        self.event_list_request, self.disconnection_reported = False, False

        self.config_keys = ['AIAI', 'AIEL', 'AISE', 'AISF', 'ERBE', 'EVSR', 'FFBL', 'FFEA', 'FFFC', 'FFFE', 'FFLM',
                            'FFLT', 'FFSC', 'GRAC', 'GRDH', 'GRDN', 'GRIE', 'GRII', 'GRIL0', 'GRIN', 'GRIP', 'GRIV',
                            'GRLO', 'GRNC', 'GRND0', 'GRND1', 'GRND2', 'GRND3', 'GRND4', 'GRND5', 'GRND6', 'GRND7',
                            'GRND8', 'GRND9', 'GRNS', 'GRSE', 'GRSN', 'GRSV', 'GRVE', 'MSTY', 'RUFL', 'RUFP']

        if self.radio.radio_code:  # for rx radio_code == 1
            self.config_keys += ['AIGA', 'AITS', 'FFCO', 'FFSL', 'GRBS', 'GRIS', 'GRLR', 'RIRO']
        else:
            self.config_keys += ['AICA', 'AIML', 'AITP', 'FFTO', 'GRAS', 'GRCO', 'GREX', 'GRLT', 'RCDP', 'RCIT', 'RCLP',
                                 'RCNP', 'RCTS', 'RIPC', 'RIVL', 'RIVP']

        self.command_groups = []
        for key in self.config_keys:
            if len(key) == 4:
                self.command_groups.append((key, 'G'))
            elif len(key) == 5:
                self.command_groups.append((key[:4], 'G', key[-1]))

        self.status = {'id': None, 'RadioModuleName': None, 'StartTime': None, 'UpdateTime': None, 'ModuleAlive': None,
                       'ReceptionAlive': None, 'KeepConnectionAlive': None, 'GeneratorAlive': None,
                       'ConnectorAlive': None, 'AnalyzerAlive': None, 'SettingUpdaterAlive': None,
                       'RadioConnected': None, 'DBConnected': None, 'SettingUpdaterInProgress': None,
                       'RadioDisconnectionCounter': None, 'DBDisconnectionCounter': None, 'ReceivedPacketCounter': None,
                       'ParameterUpdateCounter': None, 'SentPacketCounter': None, 'QueryGeneratedCounter': None,
                       'QueryExecutedCounter': None, 'PacketEvalErrorCounter': None, 'PacketSendingErrorCounter': None,
                       'QueryGenerationErrorCounter': None, 'QueryExecutionErrorCounter': None,
                       'QueryWaitingCounter': None, 'SettingUpdateCounter': None, 'PID': None}
        self.prev_generator_alive = self.prev_connector_alive = 0
        self.setting_update_counter = 0

    def get_identity(self, name):
        # Simple row
        answer = get_simple_row(self.connection, f"SELECT * FROM Common.Radio WHERE Radio_Name='{name}';")

        _id, name, station, f, t, ip, ind_on, con, dis, oph, ind_off = answer
        pos = name[-1]
        ri = RadioIdentity(ip, station, f, t, pos, _id)
        try:
            return ri, float(ind_on), float(ind_off), float(con), float(dis)
        except TypeError:
            return ri, 0.0, 0.0, 0.0, 0.0

    def read_db_data(self, radio):
        name = radio.name
        # Multiple row
        self.application_timing = get_multiple_row(self.connection, get_file('dbfiles/select/application_timing.sql'),
                                                   self.log)
        # Simple row
        sql = f"Select * From Application.RadioStatus Where Radio_Name='{name}';"
        self.radio_stat = get_simple_row(self.connection, sql, self.log)

        # Simple row
        sql = "Select AC.ConnectionTryInterval, AC.MaxDelaySettingFetch, AC.PeriodicSettingCheck, " \
              "AC.PeriodicAgeUpdate, AC.SessionWarningThreshold From Application.Configuration AC WHERE Status=1;"
        self.application_config = get_simple_row(self.connection, sql, self.log)

        # Simple row
        sql = f"Select TOP 1 * From Setting.SRadio WHERE Radio_Name='{name}' AND Record=1 ORDER BY Date DESC;"
        self.latest_radio_setting = get_simple_row(self.connection, sql, self.log, as_dict=True)

        # Multiple row
        sql = f"SELECT * From Setting.Inventory WHERE Radio_Name='{name}' AND Date in (SELECT TOP 1 " \
              f"Date FROM Setting.Inventory WHERE Radio_Name='{name}' GROUP BY Date ORDER BY Date DESC)"
        self.latest_inventory = get_multiple_row(self.connection, sql, self.log)

        # Multiple row - Simple Column
        sql = "SELECT CBIT_Code FROM Common.CBITList ORDER BY CBIT_Code;"
        self.registered_cbit_codes = get_simple_column(self.connection, sql, self.log)

        # if registered_cbit_codes is not None:
        #     self.registered_cbit_codes = np.array(registered_cbit_codes)
        # else:
        #     self.registered_cbit_codes = np.array([])
        sql = get_file(r'dbfiles/select/latest_cbit_setting.sql').format(name)
        self.registered_cbit_settings = get_multiple_row(self.connection, sql, self.log)

        # Multiple row - Simple Column
        # sql = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_CATALOG = 'RCMS' AND " \
        #       "TABLE_SCHEMA = 'Setting' AND TABLE_NAME = 'SRadio'"
        # self.setting_key_list = get_simple_column(self.connection, sql)

        # Simple row
        sql = "SELECT TOP 1 IP, Subnet, Gateway FROM Setting.IP WHERE Radio_Name = '{}' AND IP_Type='{}'" \
              " ORDER BY Date DESC"
        self.first_ip = get_simple_row(self.connection, sql.format(name, 0), self.log)
        self.second_ip = get_simple_row(self.connection, sql.format(name, 1), self.log)

        # Multiple row
        sql = f"SELECT ACL_Index, Allowed_IP FROM Setting.Access WHERE Radio_Name='{name}' AND Date in (SELECT TOP 1" \
              f" Date FROM Setting.Access WHERE Radio_Name='{name}' GROUP BY Date ORDER BY Date DESC);"
        self.access_list = get_multiple_row(self.connection, sql, self.log)

        # Multiple row
        sql = f"SELECT Partition, Version, Part_Number, Status FROM Setting.Software WHERE Radio_Name='{name}' " \
              f"AND Date IN (SELECT TOP 1 Date FROM Setting.Software WHERE Radio_Name='{name}' GROUP BY Date " \
              f"ORDER BY Date DESC) ORDER BY Partition;"
        self.software_version = get_multiple_row(self.connection, sql, self.log)

        # Multiple row
        sql = f"Select CKey, Request, Value From Command.RadioInitial WHERE rtype = {radio.radio_code} AND Active=1;"
        self.initial_commands = get_multiple_row(self.connection, sql, self.log)

        sql = f"Select id FROM Application.RadioModuleStatus WHERE RadioModuleName='{name}'"
        _id = get_simple_row(self.connection, sql, self.log)
        if _id is not None:
            self.module_status_id = _id[0]

    def objects_creation(self):
        self.connector = MSSSConnector(self.memory, self.logs)
        self.generator = QueryGenerator(self.memory, self.radio, self.connector, self.logs, self.status)
        self.commander = Commander(self.memory, self.radio, self.logs, self.transmission.request_command)
        self.status_updater = Thread(target=self.periodic_status_update, name='Status_Updater', daemon=True)

        for row in self.timing:
            if row[1] == 'MSSSConnector':
                self.connector.timing = float(row[3])
            elif row[1] == 'QueryGenerator':
                self.generator.timing = float(row[3])

    def after_connect(self):
        self.status['RadioConnected'] = 1
        self.connector.start()
        self.generator.start()
        self.commander.start()

        ts, dt = self.get_time()
        self.after_parameter_update('Connection', 1, ts, dt)
        self.disconnection_reported = False
        self.update_radio_status()
        self.set_module_start()
        self.generator.sradio_insert.save_setting(self.latest_radio_setting)
        self.generator.scbit_insert.save_cbit_codes(self.registered_cbit_codes)
        self.generator.scbit_insert.save_cbit_settings(self.registered_cbit_settings)
        self.generator.ip_insert.save_ip(self.first_ip, self.second_ip)
        self.generator.inventory_insert.save_inventory(self.latest_inventory)
        self.generator.access_insert.save_access(self.access_list)
        self.generator.software_insert.save_software(self.software_version)
        self.generator.session_insert.set_warning_threshold(self.application_config[4])

        self.status_updater.start()

    def periodic_connection_task(self):
        if not self.task_scheduled:
            self.setting_scheduler()
        if not self.aging_scheduled:
            self.age_periodic_scheduler()

    def update_child_alive(self, mk):
        if mk == 'ReceptionAlive':
            self.status[mk] = int(self.prev_reception_alive != self.reception.alive_add)
            self.prev_reception_alive = self.reception.alive_add
        elif mk == 'KeepConnectionAlive':
            self.status[mk] = int(self.prev_keeper_alive != self.keeper_alive)
            self.prev_keeper_alive = self.keeper_alive
        elif mk == 'GeneratorAlive':
            self.status[mk] = int(self.prev_generator_alive != self.generator.alive_add)
            self.prev_generator_alive = self.generator.alive_add
        elif mk == 'ConnectorAlive':
            self.status[mk] = int(self.prev_connector_alive != self.connector.alive_add)
            self.prev_connector_alive = self.connector.alive_add

    def periodic_status_update(self):
        ts, dt = self.get_time()
        self.status['ModuleAlive'] = self.alive_add
        if self.memory.connection_is_active:
            self.update_child_alive('ReceptionAlive')
            self.update_child_alive('KeepConnectionAlive')
            self.update_child_alive('GeneratorAlive')
            self.update_child_alive('ConnectorAlive')
            try:
                self.status['SettingUpdaterAlive'] = int(self.setting_updater.is_alive())
            except AttributeError:
                self.status['SettingUpdaterAlive'] = 0
            self.status['DBConnected'] = int(self.connector.connection.connected)
            self.status['RadioDisconnectionCounter'] = self.disconnect_counter
            self.status['ReceivedPacketCounter'] = self.reception.packet_add
            self.status['ParameterUpdateCounter'] = self.parameter_add
            self.status['SentPacketCounter'] = self.transmission.packet_add
            self.status['QueryGeneratedCounter'] = self.generator.query_add
            self.status['QueryExecutedCounter'] = self.connector.query_add
            self.status['PacketEvalErrorCounter'] = self.reception.err_add
            self.status['PacketSendingErrorCounter'] = self.transmission.err_add
            self.status['QueryGenerationErrorCounter'] = self.generator.err_add
            self.status['QueryExecutionErrorCounter'] = self.connector.err_add
            self.status['SettingUpdateCounter'] = self.setting_update_counter
            self.after_parameter_update('ModuleStatus', self.status, ts, dt)
        else:
            pass

        sleep(2)

    def initiate_radio(self):
        self.transmission.request_group_commands(self.initial_commands)

    def setting_scheduler(self):
        """
        default value of schedules timers are:
            self.max_delay_setting_fetch = 60 Minute
            self.periodic_setting_check = 1440 Minute
        """
        self.max_delay_setting_fetch = int(self.application_config[1])
        self.periodic_setting_check = int(self.application_config[2])

        from random import randint
        if self.first_time_setting_fetch:
            delay_setting_update = randint(1, self.max_delay_setting_fetch) * 60
            self.setting_updater = Timer(delay_setting_update, self.request_config_keys)
            self.first_time_setting_fetch = False
            target_time = datetime.now() + timedelta(seconds=delay_setting_update)
        else:
            self.setting_updater = Timer(self.periodic_setting_check * 60, self.request_config_keys)
            target_time = datetime.now() + timedelta(minutes=self.periodic_setting_check)

        self.setting_updater.daemon = True
        self.setting_updater.start()

        self.connector.add(f"Update Application.RadioStatus SET NextConfigFetch='{str(target_time)[:23]}'"
                           f" WHERE Radio_Name='{self.radio.name}';")
        self.log.debug(f'Next Config checking will be at {str(target_time)[:19]}')
        self.task_scheduled = True

    def age_periodic_scheduler(self):
        """
         default value of schedules timers are:
             self.periodic_age_update = 5 Minute
             RCOC -> periodic
         """
        self.periodic_age_update = int(self.application_config[3])
        self.aging_updater = Timer(self.periodic_age_update * 60, self.request_age_keys)
        self.aging_updater.daemon = True
        self.aging_updater.start()
        self.aging_scheduled = True

    def request_config_keys(self):
        self.status['SettingUpdaterInProgress'] = 1
        if self.memory.connection_is_active:
            self.generator.sradio_insert.set_config_request_started()
            self.generator.inventory_insert.clear()
            if self.event_list_request:
                self.transmission.request_group_commands(self.command_groups, event_request=True)
                self.event_list_request = False
            else:
                self.transmission.request_group_commands(self.command_groups)

            self.task_scheduled = False
        self.status['SettingUpdaterInProgress'] = 0
        self.setting_update_counter += 1
        if self.setting_update_counter > 65535:
            self.setting_update_counter = 0

    def request_age_keys(self):
        if self.memory.connection_is_active:
            self.transmission.request_command('RCOC', 'G')
            self.aging_scheduled = False

    def update_radio_status(self):
        if self.radio_stat is None:
            rn, dt = self.radio.name, str(datetime.now())[:23]
            self.connector.add(f"Insert Into Application.RadioStatus (Radio_Name, FirstConnection) "
                               f"VALUES ('{rn}', '{dt}');")
            self.event_list_request = True
        elif self.radio_stat[3] is None:  # EventListCollect -> Is EventList is collected or not?
            self.event_list_request = True

    def set_module_start(self):
        ts, dt = self.get_time()
        self.log.debug("Setting Starting of Radio Module")
        if self.module_status_id is None:
            _connection = get_connection()
            _connection.execute_non_query(f"Insert Into Application.RadioModuleStatus (RadioModuleName, StartTime, "
                                          f"UpdateTime, PID) VALUES ('{self.radio.name}', '{dt}', '{dt}', {self.pid});")
            self.log.debug("Creating Radio Module Record at Start")
            self.module_status_id = _connection.identity
            _connection.close()
        else:
            self.connector.add(f"Update Application.RadioModuleStatus SET StartTime='{dt}', UpdateTime='{dt}', "
                               f"PID={self.pid} WHERE id={self.module_status_id};")
            self.log.debug("Updating Radio Module Record at Start")
        self.status['id'] = self.module_status_id
        self.status['RadioModuleName'] = self.radio.name
        self.status['StartTime'] = dt
        self.status['PID'] = self.pid

    def after_disconnected(self):
        self.status['RadioConnected'] = 0
        self.disconnect_counter += 1
        if self.disconnect_counter > 65535:
            self.disconnect_counter = 0
        try:
            ts, dt = self.get_time()
            if not self.disconnection_reported:
                self.after_parameter_update('Connection', 0, ts, dt)
                self.disconnection_reported = True

            self.keeper.join()
            self.reception.join()
            self.log.info('All Object are closed')
        except AttributeError:
            pass

    def after_parameter_update(self, key, value, ts, dt):
        self.parameter_add = 1
        if key == 'RCOC':
            self.generator.add(ts, dt, key, (self.memory.on, self.memory.off, self.memory.connection,
                                             self.memory.disconnection, value))
        else:
            self.generator.add(ts, dt, key, value)

    def close(self):
        self.memory.keep_connection = False
        if hasattr(self, 'generator'):
            self.setting_updater.cancel()
            self.aging_updater.cancel()
            self.generator.join()
            self.reception.join()
            self.connector.join()
            self.commander.join()
        self.join()


_radio: RadioControl


def interface():
    global _radio
    while True:
        try:
            command = input('Please Enter Command:\n')
        except EOFError:
            break
        if command.lower() in ['q', 'quit', 'exit']:
            try:
                _radio.close()
            except AttributeError:
                pass
            break


def _signal_handler(*args):
    global _single_radio
    # rcv_sig = args[0]
    # signal_to_name = {0: 'CTRL_C_EVENT', 1: 'CTRL_BREAK_EVENT', 2: 'SIGINT', 4: 'SIGILL', 8: 'SIGFPE', 11: 'SIGSEGV',
    #                   15: 'SIGTERM', 21: 'SIGBREAK', 22: 'SIGABRT'}
    #
    # print(f"{signal_to_name.get(rcv_sig)} is received")
    # if _single_radio:
    #     condition_list = [signal.SIGTERM, signal.SIGINT]
    # else:
    #     condition_list = [signal.SIGTERM, signal.SIGBREAK]
    #
    # if rcv_sig in condition_list:
    from itertools import cycle
    global _termination_command, _radio
    _termination_command[0] = True
    waiting_progress = cycle(('[=      ]', '[==     ]', '[===    ]', '[ ===   ]', '[  ===  ]',
                              '[   === ]', '[    ===]', '[     ==]', '[      =]', '[       ]'))
    while _radio.is_alive():
        if _single_radio:
            print(f'\rPlease wait for Exiting... {next(waiting_progress)}', end='')
        sleep(0.15)


def _sigpipe_handler(*args):
    pass
#    global _radio
#    print(f'Warning: SIGPIPE Detected by {_radio.radio.name} Module!')
#    _radio.memory.connection_is_active = False


def run(radio_name, single_radio=False):
    from duplication_controller import Controller
    controller = Controller(f'temp/.{radio_name}.controller')
    if controller.allow:
        global _termination_command, _single_radio, _radio

        _single_radio = single_radio
        _radio = RadioControl(radio_name, _termination_command)

        signal.signal(signal.SIGINT, _signal_handler)
        signal.signal(signal.SIGTERM, _signal_handler)
        # signal.signal(signal.SIGILL, _signal_handler)
        # signal.signal(signal.SIGFPE, _signal_handler)
        # signal.signal(signal.SIGSEGV, _signal_handler)
        # signal.signal(signal.SIGABRT, _signal_handler)
        if system() == 'Windows':
            signal.signal(signal.SIGBREAK, _signal_handler)
        else:
            signal.signal(signal.SIGPIPE, _sigpipe_handler)

        # signal.signal(signal.CTRL_C_EVENT, _signal_handler)
        # signal.signal(signal.CTRL_BREAK_EVENT, _signal_handler)

        _radio.start()

        while _radio.is_alive():
            _radio.join(1)
            sleep(0.5)

        _radio.join()
        # print('\rFinished' + ' ' * 50)
        controller.unlock()
    else:
        print(f'Another Radio Module for radio {radio_name} is Running!')


if __name__ == '__main__':
    from sys import argv

    radio_name = 'BUZ_RX_V1M'
    if len(argv) > 1:
        radio_name = argv[1].upper()

    from dbdriver import get_available_radios

    if radio_name not in get_available_radios():
        print('Error: Radio is not available.')
        exit(-1)

    inf = Thread(target=interface, daemon=True)
    inf.start()

    run(radio_name, single_radio=True)
