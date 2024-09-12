import signal
from datetime import datetime
from multiprocessing import Queue
from platform import system
from time import sleep

from analyzer.analyzer import Analyzer
from core.core import Core
from core.identity import RadioIdentity
from execute import get_connection, get_simple_row
from execute.executor import QueryExecutor
from generator.generator import QueryGenerator
from health.health import HealthMonitor
from radio.comander import Commander
from radio.optimum import OptimumGenerator
from radio.planner import SettingsUpdatePlanner, SpecialSettingUpdatePlanner, TimerUpdatePlanner
from radio.preparer import RadioPreparer
from radio.status import Status

_break = False
_single_mode = True


class Radio(Core):
    generator: QueryGenerator  # Thread Object
    executor: QueryExecutor  # Thread Object
    commander: Commander  # Thread Object
    analyzer: Analyzer  # Thread Object
    health: HealthMonitor  # Thread Object
    setting_planner: SettingsUpdatePlanner  # Include Timer Object
    special_planner: SpecialSettingUpdatePlanner  # Include Timer Object
    timer_planner: TimerUpdatePlanner  # Include Timer Object
    portal: Queue

    def __init__(self, name, single_mode, portal=None):
        import os
        from log.logger import get_db_loggers
        from execute import get_logger_config, get_logger_format

        self.db_connection = get_connection()
        self.radio = self.get_identity(name)
        logs = get_db_loggers(self.radio.name, get_logger_config(single_mode), get_logger_format())
        super().__init__(self.radio, logs)
        self.preparer = RadioPreparer(self, self.logs['Preparer'])
        self.module_stat = Status(self, self.logs['Status'], self.preparer.module_status)
        self.module_stat.set_start(os.getpid())
        self.db_connection.close()
        self.log.info(f'initial_commands: {self.initial_commands}')

        self.single_mode = single_mode
        if not single_mode:
            self.portal = portal
            self.report = {
                'UpdateTime': datetime.utcnow(),
                'Alive': True,
                'RadioConnection': False,
                'DBStatus': False
            }
        self.try_to_connect_interval = self.preparer.application['ConnectionTryInterval']
        self.check_period = float(self.preparer.application['CoreCheckInterval'])
        self.ping_timeout = self.preparer.application['PingTimeout']
        self._first_com_id = self.preparer.application['FistCommandID']
        self._last_com_id = self.preparer.application['LastCommandID']
        self.sender.calm = float(self.preparer.application['SenderCalm'])
        self.set_timers(self.preparer.timer[0], self.preparer.timer[1])
        self.set_counters(self.preparer.counter[0], self.preparer.counter[1])
        self.executor = QueryExecutor(self, self.logs['Executor'])
        self.executor.calm = float(self.preparer.application['ExecutorCalm'])
        self.executor.set_counters(self.preparer.counter[0], self.preparer.counter[1])
        self.executor.start()
        self.timer_planner = TimerUpdatePlanner(self, self.logs['TimerUpdate'],
                                                self.preparer.application['PeriodicTimerUpdate'],
                                                self.preparer.application['MaxDelayTimerUpdate'])
        self.optimum_generator = OptimumGenerator(self, self.logs['Optimum'])

        self.timer_planner.make_plan()
        self.event_list_request = False

    def get_identity(self, name):
        query = f"SELECT id, Name, Station, Frequency_No, Sector, RadioType, MainStandBy, IP " \
                f"FROM RCMS.Radio.Radio WHERE Name='{name}';"
        answer = get_simple_row(self.db_connection, query)
        return RadioIdentity(*answer)

    def update_radio_status(self):
        if self.preparer.radio_status is None:
            self.executor.add(f"Insert Into Application.RadioStatus (Radio_Name, FirstConnection) "
                              f"VALUES ('{self.radio.name}', '{str(datetime.utcnow())[:23]}');")
            self.event_list_request = True
        elif self.preparer.radio_status[3] is None:  # EventListCollect -> Is EventList is collected or not?
            self.event_list_request = True
        else:
            self.event_list_request = False

    def event_on_connect(self, time_tag):
        super().event_on_connect(time_tag)
        self.generator = QueryGenerator(self, self.executor, self.logs['Generator'])
        self.health = HealthMonitor(self, self.executor, self.logs['HealthMonitor'])
        self.commander = Commander(self, self.logs['Commander'])
        self.setting_planner = SettingsUpdatePlanner(self, self.logs['SettingsUpdate'],
                                                     self.preparer.application['PeriodicSettingCheck'],
                                                     self.preparer.application['MaxDelaySettingCheck'])
        if self.radio.type == 'TX':
            self.special_planner = SpecialSettingUpdatePlanner(self, self.logs['SpecialUpdate'],
                                                               self.preparer.application['PeriodicSpecialUpdate'],
                                                               self.preparer.application['MaxDelaySpecialUpdate'])
        self.analyzer = Analyzer(self, self.executor, self.logs['Analyzer'])

        self.generator.calm = float(self.preparer.application['GeneratorCalm'])
        self.health.calm = float(self.preparer.application['HealthCalm'])
        self.commander.calm = float(self.preparer.application['CommanderCalm'])
        self.analyzer.calm = float(self.preparer.application['AnalyzeCalm'])

        self.generator.event_session.set_warning_threshold(self.preparer.application['SessionWarningThreshold'])
        self.generator.setting_access.save_access(self.preparer.access)
        self.generator.setting_cbit.save_cbit_codes(self.preparer.cbit_list)
        self.generator.setting_cbit.save_cbit_settings(self.preparer.cbit)
        self.generator.setting_configuration.save_setting(self.preparer.configuration)
        self.generator.setting_installation.save_setting(self.preparer.installation)
        self.generator.setting_inventory.save_inventory(self.preparer.inventory)
        self.generator.setting_ip.save_ip(self.preparer.first_ip, self.preparer.second_ip)
        self.generator.setting_network.save_setting(self.preparer.network)
        self.generator.setting_snmp.save_setting(self.preparer.snmp)
        self.generator.setting_software.save_software(self.preparer.software)
        self.generator.setting_status.save_setting(self.preparer.status)
        self.generator.setting_trx_configuration.save_setting(self.preparer.trx_configuration)

        for obj in (self.reception, self.keeper, self.generator, self.commander, self.timer_planner,
                    self.setting_planner, self.generator.event_cbit):
            obj.set_counters(self.preparer.counter[0], self.preparer.counter[1])

        if self.radio.type == 'TX':
            self.generator.event_special.save_setting(self.preparer.special)
            self.special_planner.set_counters(self.preparer.counter[0], self.preparer.counter[1])

        self.health.create_parameters(*self.preparer.health_parameters)

        self.generator.start()
        self.commander.start()
        self.analyzer.start()
        self.health.start()
        self.event_on_parameter_updated(time_tag, 'Connection', 1)
        self.optimum_generator.disconnection_updated = False

    def event_on_disconnect(self, time_tag, update_connect_time=True):
        super().event_on_disconnect(time_tag, update_connect_time)
        self.optimum_generator.update_disconnection(time_tag)

    def periodic_operation(self):
        self.timer_planner.make_plan()
        self.setting_planner.make_plan()
        if self.radio.type == 'TX':
            self.special_planner.make_plan()
        self.update_manager_status()

    def update_manager_status(self):
        if not self.single_mode:
            self.report['UpdateTime'] = datetime.utcnow()
            self.report['Alive'] = self.status()
            self.report['RadioConnection'] = self.is_connect
            self.report['DBStatus'] = self.executor.connection.connected
            self.portal.put(self.report)

    def periodic_operation_on_disconnection(self):
        self.timer_planner.make_plan()
        self.update_manager_status()

    def update_status_when_connect(self):
        self.module_stat.update_status()

    def update_status_when_disconnect(self):
        self.module_stat.update_status_when_disconnect()

    def event_on_initiate(self):
        pass

    def event_on_send_error(self, message):
        pass

    def event_on_command_sent(self, command_text):
        pass

    def event_on_message_received(self, message):
        pass

    def event_on_parameter_updated(self, time_tag, key, value):
        self.log.debug(f'Parameter Updated: {key} > {value}')
        if key == 'SCPG':
            self.ping_timeout = int(value)
        elif key in {'RCRI', 'RCTC'}:
            self.update_indicator(time_tag, int(value))

        self.health.add(key, value)
        if key == 'RCOC':
            self.operating_hour.add(int(value))
        else:
            self.generator.add(time_tag, key, value)

        if key in self.analyzer.keys:
            self.analyzer.add(key, (time_tag, value))

    def event_on_trap_accepted(self, time_tag, key, stat):
        self.log.debug(f"TrapAccepted {time_tag} {key} > { {'0': 'OFF', '1': 'ON'}.get(stat)}")

    def event_on_set_accepted(self, time_tag, key, value):
        self.log.debug(f'SetAccepted {time_tag} {key} > {value}')

    def event_on_access_error(self, time_tag, key, error_code, message):
        self.log.debug(f'AccessError {time_tag} {key} > Rejected by {error_code}: {message}')

    def event_on_command_error(self, time_tag, key, error_code, message):
        self.log.debug(f'CommandError {time_tag} {key} > Rejected by {error_code}: {message}')

    def event_on_user_command_answered(self, time_tag, key, value, error=False):
        if error:
            self.log.debug(f'User Command {time_tag} {key} > {value} is Rejected')
        else:
            self.log.debug(f'User Command {time_tag} {key} > {value} is Accepted')

    def sleep(self):
        global _break
        if self.is_connect:
            counter = self._counter_max
        else:
            counter = self._counter_max_on_disconnect

        while self.keep_alive and counter > 0 and not self.need_to_check:
            sleep(self.check_period)
            # self.alive_counter += 1
            if not self.keep_alive:
                break
            if _break:
                self.keep_alive = False
                break
            counter -= 1

    def close(self):
        self.log.debug(f'Closing App...')
        self.log.info(f'Closing: keep_alive={self.keep_alive} is_connect={self.is_connect}')
        self.keep_alive = self.is_connect = False
        self.log.info(f'Closing: keep_alive={self.keep_alive} is_connect={self.is_connect}')
        self.timer_planner.cancel()
        self.log.info(f'Closing: Time_Planner Canceled')

        if hasattr(self, 'keeper'):
            self.setting_planner.cancel()
            self.log.info(f'Closing: Setting_Planner Canceled')
            if self.radio.type == 'TX':
                self.special_planner.cancel()
                self.log.info(f'Closing: Special_Planner Canceled')
            self.keeper.close()
            self.log.info(f'Closing: Close Command sent to Keeper')
            self.reception.close()
            self.log.info(f'Closing: Close Command sent to Reception')
            self.socket.close()
            self.log.info(f'Closing: Socket Closed')

            self.keeper.join()
            self.log.info(f'Closing: Keeper Joint')
            self.reception.join(3)
            self.log.info(f'Closing: Reception Joint')
            self.generator.join(3)
            self.log.info(f'Closing: Generator Joint')
            self.executor.join(3)
            self.log.info(f'Closing: Executor Joint')

        self.log.info(f'Objects are closed')


_radio: Radio


def _signal_handler(*args):
    from itertools import cycle

    global _single_mode, _break, _radio

    _break = True
    _radio.close()
    _radio.log.info(f'SIGINT or SIGTERM Detected by {_radio.radio.name} Module!')
    waiting_progress = cycle(('[=      ]', '[==     ]', '[===    ]', '[ ===   ]', '[  ===  ]',
                              '[   === ]', '[    ===]', '[     ==]', '[      =]', '[       ]'))
    while _radio.is_alive():
        if _single_mode:
            print(f'\rPlease wait for Exiting... {next(waiting_progress)}', end='')
        sleep(0.15)

    if _single_mode:
        print(f'\rRadio Closed.' + ' ' * 30, end='')
    _radio.log.info(f'Closed')


def _sigpipe_handler(*args):
    global _radio
    _radio.log.error(f'SIGPIPE Detected by {_radio.radio.name} Module! args: {args}')


def run(radio_name, single_mode=True, _portal=None):
    from controller.controller import Controller

    controller = Controller(f'temp/.{radio_name}.controller')
    if controller.allow:
        global _single_mode, _radio, _break
        _single_mode = single_mode
        _radio = Radio(radio_name, single_mode, _portal)

        signal.signal(signal.SIGINT, _signal_handler)
        signal.signal(signal.SIGTERM, _signal_handler)
        if system() == 'Windows':
            signal.signal(signal.SIGBREAK, _signal_handler)
        else:
            signal.signal(signal.SIGPIPE, _sigpipe_handler)

        _radio.start()
        # from time import time
        # x = time()
        # print('Start')
        while _radio.is_alive() and (not _break):
            # print(f'{" "* 50} {time() - x} {_radio.is_alive()}')
            _radio.join(2)
            # print(f'{" "* 50} {time() - x} {_radio.is_alive()}')
            if _radio.is_alive():
                sleep(2)

        # print(f'{" " * 50} {time() - x} {_radio.is_alive()}')

        _radio.join(1)
        # print(f'{" " * 50} {time() - x} {_radio.is_alive()}')
        controller.unlock()
        # print(f'{" " * 50} {time() - x} {_radio.is_alive()}')
    else:
        print(f'Another Radio Module for radio {radio_name} is Running!')
