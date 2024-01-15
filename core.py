from time import time, sleep
from threading import Thread
from socket import socket, timeout
from datetime import datetime
from constructor import Constructor

ON = CONNECT = 1
OFF = DISCONNECT = 0


class Memory:
    def __init__(self):
        self.trap_requested = {}  # 100: ('FFTR' , 1)
        self.get_request = {}  # 100: 'FFTR'
        self.active_trap = {}  # 100: 'FFTR'
        self.set_request = {}  # 100: ('FFTR', 119300000)
        self.user_command = {}
        self.sending_number = 1
        self.keep_connection, self.ready = True, False
        self.connection_is_active, self.disconnection_detected = False, True
        self.try_to_connect_interval = 60

        self._con, self._dis, self._on_age, self._off_age = 0.0, 0.0, 0.0, 0.0
        self._con_flag, self._age_flag = time(), None
        self._prev_con_stat, self._prev_ind_stat = DISCONNECT, None
        self._on_air = None

    def set_connection(self, stat=CONNECT):
        if stat == CONNECT:
            self.disconnection_detected = False
            self.connection_is_active = True
            self._age_flag = time()
        else:
            self.disconnection_detected = True
            self.connection_is_active, self.ready = False, False
            self._age_flag = None

        self.update_connection_timer()
        self._prev_con_stat = stat

    def update_connection_timer(self):
        if self._prev_con_stat == CONNECT:
            self.connection = time()
        else:
            self.disconnection = time()

    def set_indicator(self, tm, stat=ON):
        self.on_air = stat
        if self._prev_ind_stat is not None:
            self.update_indicator(tm)
        self._prev_ind_stat = stat
        self._age_flag = tm

    def set_indicator_after_disconnection(self, tm):
        if self._prev_ind_stat is not None:
            self.update_indicator(tm)
            self._age_flag = self._prev_ind_stat = None

    def update_indicator(self, tm):
        if self._prev_ind_stat == ON:
            self.on = tm
        else:
            self.off = tm

    def set_ready(self):
        self.ready = True

    def add_previous(self, indicator_on, indicator_off, connection, disconnection):
        """
        :param indicator_on: Previous Indicator_on Time that should be added to current value
        :param indicator_off: Previous Indicator_of Time that should be added to current value
        :param connection: Previous Connection Time that should be added to current value
        :param disconnection: Previous Disconnection Time that should be added to current value
        :return: None
        """
        if indicator_on is not None:
            self._on_age += indicator_on
        if indicator_off is not None:
            self._off_age += indicator_off
        if connection is not None:
            self._con += connection
        if disconnection is not None:
            self._dis += disconnection

    @property
    def connection(self):
        return self._con

    @connection.setter
    def connection(self, tm):
        # if self._flag is not None:
        self._con += tm - self._con_flag
        self._con_flag = tm

    @property
    def disconnection(self):
        return self._dis

    @disconnection.setter
    def disconnection(self, tm):
        # if self._flag is not None:
        self._dis += tm - self._con_flag
        self._con_flag = tm

    @property
    def on(self):
        return self._on_age

    @on.setter
    def on(self, tm):
        self._on_age += tm - self._age_flag

    @property
    def off(self):
        return self._off_age

    @off.setter
    def off(self, tm):
        self._off_age += tm - self._age_flag

    @property
    def on_air(self):
        return self._on_air

    @on_air.setter
    def on_air(self, stat):
        self._on_air = stat


class RadioEvents:
    def __init__(self, memory: Memory, call: dict):
        """
        :param memory: 
        :param call:
            self.custom_events = {
                'connect': self.after_connect,
                'initiate': self.after_initiated,
                'disconnect': self.when_disconnected,
                'sending_error': self.after_sending_error,
                'sent_command': self.after_command_sent,
                'reception': self.after_message_received,
                'trap_answer': self.after_parameter_updated,
                'get_answer': self.after_parameter_updated,
                'set_accept': self.after_parameter_updated,
                'trap_accept': self.after_trap_accepted,
                'command_error': self.after_command_error_detected,
                'invalid_command': self.after_invalid_command_detected
            }
 
        """
        self.memory = memory
        self.call = call

    def connect(self):
        self.memory.set_connection(CONNECT)
        self.call['connect']()

    def initiate(self):
        self.call['initiate']()

    def disconnect(self):
        self.memory.set_connection(DISCONNECT)
        self.call['disconnect']()

    def sending_error(self, message: str):
        self.call['sending_error'](message)

    def sent_command(self, command: str):
        self.call['sent_command'](command)

    def reception(self, message):
        self.call['reception'](message)

    def trap_answer(self, key, value):
        self.call['trap_answer'](key, value)

    def get_answer(self, key, value):
        self.call['get_answer'](key, value)

    def set_accept(self, key, value):
        self.call['set_accept'](key, value)

    def trap_accept(self, key, stat):
        self.call['trap_accept'](key, stat)

    def command_error(self, key, command_char, request, message, value):
        self.call['command_error'](key, command_char, request, message, value)

    def invalid_command(self, key, command_char, request, message, value):
        self.call['invalid_command'](key, command_char, request, message, value)


class RadioIdentity:
    def __init__(self, ip, station, frequency, radio_code, position, _id=None):
        self.ip = ip
        self.radio_code = radio_code
        if self.radio_code == 1:
            self.port = 8001
            self.type = 'RX'
        else:
            self.port = 8002
            self.type = 'TX'

        self.station = station
        self.frequency = frequency
        self.position = position
        self.id = _id
        self.name = f"{self.station}_{self.type}_V{self.frequency}{self.position}"

    def __repr__(self):
        return self.name


class RadioReception(Thread):
    """
    timing property:
        define waiting after close command detection for clearing socket object
    """
    def __init__(self, connection_socket: socket, memory: Memory, events: RadioEvents, radio: RadioIdentity, logs):
        super().__init__(name=f'{radio}_Reception_Thread', daemon=True)

        self.socket = connection_socket
        self.radio = radio
        self.memory = memory
        self.events = events
        self.log = logs['Reception']
        self._wait_time = 0.1
        self._alive_counter = self._err_counter = self._packet_counter = 0
        self.log.debug("Initiated!")

    @property
    def timing(self):
        return self._wait_time

    @timing.setter
    def timing(self, t):
        self._wait_time = t

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
    def packet_add(self):
        return self._packet_counter

    @packet_add.setter
    def packet_add(self, value=1):
        self._packet_counter += value
        if self._packet_counter > 65535:
            self._packet_counter -= 65535

    def run(self) -> None:
        self.log.debug(f"Started - connection_is_active={self.memory.connection_is_active}")
        while self.memory.connection_is_active:
            try:
                self.log.info(f"Started")
                self.main()
            except Exception as e:
                self.err_add = 1
                self.log.exception(f'Failed by an error: {e}')
            self.alive_add = 1
        self.log.info(f"Finished")

    def main(self):
        while self.memory.connection_is_active:
            self.log.debug("Running!")
            sleep(0.05)
            if not self.memory.keep_connection:
                Thread(target=self.wait, name='Wait_To_Finish_Thread', daemon=True).start()
            try:
                data = self.receive_socket()
            except (TimeoutError, ConnectionResetError, ConnectionAbortedError, OSError) as e:
                self.log.error(f"Disconnected - {e}")
                self.memory.connection_is_active = False
                break
            else:
                # self.log.debug(f"Data Received - {len(data)} Chars: {data}")
                for received in data.split('\r\n'):
                    if received.startswith('\n'):
                        received = received[1:]
                    if received.endswith('\r'):
                        received = received[:-1]
                    # self.report_reception_message(f"RECEIVED : {received}")
                    # self.events.call('reception', (f"RECEIVED : {received}",))
                    if received == "":
                        continue
                    self.events.reception(f"RECEIVED : {received}")

                    #   Evaluating Answer
                    try:
                        i = received.index(' ')
                    except ValueError:
                        continue
                    else:
                        if received[0] == 'E':
                            '''
                                UnknownCommandError Detected
                                request_number = int(received[i + 1:])
                                unknown error code = int(received[2:i])
                                sample: 'E:7 10'
                            '''
                            self.unknown_command_error(int(received[i + 1:]), received)
                        else:
                            """
                                received sample: '100 gTR119300000'
                            """
                            request_number = int(received[0:i])
                            command_char = received[i + 1: i + 2]
                            try:
                                int(received[i + 2: i + 3])
                            except ValueError:
                                '''
                                    known Answer Detected (Get/Trap Answer or Set/Trap Acknowledge)
                                    request_number = int(received[i + 1:])
                                    command = received[i + 1: i + 2]
                                    secondary_command = received[i + 2:i + 4]
                                    answer_value = received[i + 4:]
                                    sample: '100 gTR119300000'
                                '''
                                secondary_command = received[i + 2:i + 4]
                                if command_char == 'd':
                                    """
                                        Trap Answer Detected
                                        sample: '100 dTR119300000'
                                    """
                                    answer_value = received[i + 4:]
                                    try:
                                        command_key = self.memory.active_trap[request_number]
                                    except KeyError:
                                        command_key = self.memory.trap_requested[request_number][0]

                                    if secondary_command == command_key[2:]:
                                        self.log.debug(f'TrapAnswer {command_key}={answer_value}')
                                        self.events.trap_answer(command_key, answer_value)
                                        self.fill_command_result(request_number, True)

                                elif command_char == 'g':
                                    """
                                        Get Answer Detected
                                        sample: '100 gTR119300000'
                                        self.get_request = {}                   # 100: 'FFTR'
                                    """
                                    answer_value = received[i + 4:]
                                    command_key = self.memory.get_request.pop(request_number)
                                    if secondary_command == command_key[2:]:
                                        self.log.debug(f'GetAnswer {command_key}={answer_value}')
                                        self.events.get_answer(command_key, answer_value)
                                        self.fill_command_result(request_number, True)

                                elif command_char == 's':
                                    """
                                        Set Acknowledge Detected
                                        sample: '100 sTR'
                                        self.set_request = {}                   # 100: ('FFTR', 119300000)
                                    """
                                    command_key, answer_value = self.memory.set_request.pop(request_number)
                                    if secondary_command == command_key[2:]:
                                        self.log.debug(f'SetAccept {command_key}={answer_value}')
                                        self.events.set_accept(command_key, answer_value)
                                        self.fill_command_result(request_number, True)
                                elif command_char == 't':
                                    """
                                        Trap Acknowledge Detected
                                        sample: '100 tTR'
                                        self.trap_requested = {}                # 100: ('FFTR', 1)
                                    """
                                    command_key, trap_command = self.memory.trap_requested[request_number]
                                    if secondary_command == command_key[2:]:
                                        self.trap_acknowledge(command_key, request_number, trap_command)
                                else:
                                    continue
                            else:
                                '''
                                    CommandError Detected
                                    error code = int(received[i + 2: i + 3])
                                    secondary_command = received[i + 3: i + 5]
                                    sample: '100 g3TR'
                                '''
                                # print(f'Command Error: {data}')
                                self.command_error(command_char, request_number, received)

            self.alive_add = 1

    def wait(self):
        self.log.info('Waiting For last Socket Reading')
        sleep(self._wait_time)
        self.memory.connection_is_active = False

    def receive_socket(self):
        data = self.socket.recv(1460).decode()
        self.packet_add = 1
        self.alive_add = 1
        try:
            need_to_continue_receive = data[-1] != chr(13)
        except IndexError:
            need_to_continue_receive = False
        while need_to_continue_receive:
            data += self.socket.recv(1460).decode()
            self.packet_add = 1
            self.alive_add = 1
            need_to_continue_receive = data[-1] != chr(13)

        return data

    def unknown_command_error(self, request, message):
        self.err_add = 1
        value = None
        if request in self.memory.trap_requested.keys():
            command_char = 'T'
            key, value = self.memory.trap_requested.pop(request)
        elif request in self.memory.get_request.keys():
            command_char, key = 'G', self.memory.get_request.pop(request)
        elif request in self.memory.set_request.keys():
            command_char = 'S'
            key, value = self.memory.set_request.pop(request)
        else:
            return
        self.log.debug(f'InvalidCommand {key} {command_char} {value}')
        self.events.invalid_command(key, command_char, request, message, value)
        self.fill_command_result(request, False)

    def command_error(self, command_char, request, message):
        self.err_add = 1
        value = None
        if command_char == 't':
            key, value = self.memory.trap_requested.pop(request)
        elif command_char == 'g':
            key = self.memory.get_request.pop(request)
        elif command_char == 's':
            key, value = self.memory.set_request.pop(request)
        else:
            return

        self.log.debug(f'InvalidCommand {key} {command_char} {value}')
        self.events.command_error(key, command_char.upper(), request, message, value)
        self.fill_command_result(request, False)

    def trap_acknowledge(self, key, request, stat):
        self.memory.trap_requested.pop(request)
        if stat:
            self.memory.active_trap[request] = key
        self.log.debug(f'TrapAccept {key}={stat}')
        self.events.trap_accept(key, stat)
        self.fill_command_result(request, True)

    def fill_command_result(self, request, result):
        if request in self.memory.user_command:
            self.memory.user_command[request] = result


class RadioTransmission:
    """
    timing property
        define waiting between commands when run a group of commands
    """
    def __init__(self, connection_socket: socket, memory: Memory, events: RadioEvents, radio: RadioIdentity, logs):
        self.socket = connection_socket
        self.memory = memory
        self.events = events
        self.radio = radio
        self.log = logs['Transmission']
        self.log.debug('Initiated')
        self._wait_time = 0.3
        self._err_counter = self._packet_counter = 0
        self.constructor = Constructor(self.radio.radio_code)

    @property
    def timing(self):
        return self._wait_time

    @timing.setter
    def timing(self, t):
        self._wait_time = t

    @property
    def err_add(self):
        return self._err_counter

    @err_add.setter
    def err_add(self, value=1):
        self._err_counter += value
        if self._err_counter > 65535:
            self._err_counter -= 65535

    @property
    def packet_add(self):
        return self._packet_counter

    @packet_add.setter
    def packet_add(self, value=1):
        self._packet_counter += value
        if self._packet_counter > 65535:
            self._packet_counter -= 65535

    def request_group_commands(self, command_list, event_request=False):
        self.log.debug(f'Sending {len(command_list)} Command(s) ')
        for com in command_list:
            self.request_command(*com)
            sleep(self._wait_time)
        if event_request:
            self.request_command('EVEL', 'G')

    def request_command(self, key, command, value=None):
        self.memory.sending_number += 1
        if command == 'T':
            self.memory.trap_requested[self.memory.sending_number] = (key, int(value))
            # self.active_trap[self.sending_number] = command_key
        elif command == 'G':
            self.memory.get_request[self.memory.sending_number] = key
        elif command == 'S':
            self.memory.set_request[self.memory.sending_number] = (key, value)

        txt = self.constructor.convert(key, value, command, self.memory.sending_number)
        self.send(f"\n{txt}\r".encode())
        self.convert_sending_command(key, command, value)
        return self.memory.sending_number

    def send(self, data):
        try:
            self.socket.send(data)
            self.packet_add = 1
        except Exception as e:
            # from datetime import datetime
            # err_msg = f' Sending Error Detected:\n' + \
            #           f' IP: {self.radio.ip}, Port: {self.radio.port}, Name: {self.radio}\n' + \
            #           f' Sending Message: {data[1:-1]}' + \
            #           f' Following Exception raised at date a time:{datetime.now()}:\n' + \
            #           f' {e.__class__.__name__} - {e.__class__.__doc__} - {e} - {e.args}\n' + 20 * '!' + '\n'
            self.err_add = 1
            self.log.warning(f'SendingError {data[1:-1]} {e}')
            if 'Broken pipe' in str(e):
                self.memory.connection_is_active = False
                self.log.error(f'Disconnected - {e}')

            else:
                self.events.sending_error(f'SendingError {data[1:-1]} {e}')

    def convert_sending_command(self, *args):
        sent = f'{self.memory.sending_number}:{args[0]}'
        for x in args[1:]:
            sent += f"-{x}"
        self.log.debug(f'SentCommand {sent}')
        self.events.sent_command(sent)


class Core(Thread):
    socket: socket                      # Socket Object
    memory: Memory
    events: RadioEvents
    radio: RadioIdentity
    transmission: RadioTransmission
    reception: RadioReception           # Thread Object
    keeper: Thread                      # Thread Object

    def __init__(self, identity: RadioIdentity, logs, timing, config, _termination_command):
        super(Core, self).__init__(name=f'{identity}_Core_Thread', daemon=True)

        self.memory = Memory()
        self.memory.try_to_connect_interval = int(config[0])
        self.radio = identity
        self._termination_command = _termination_command
        self.events = RadioEvents(self.memory, {
                                                  'connect': self.connection_task,
                                                  'initiate': self.after_initiated,
                                                  'disconnect': self.after_disconnected,
                                                  'sending_error': self.after_sending_error,
                                                  'sent_command': self.after_command_sent,
                                                  'reception': self.after_message_received,
                                                  'trap_answer': self.parameter_updated,
                                                  'get_answer': self.parameter_updated,
                                                  'set_accept': self.parameter_updated,
                                                  'trap_accept': self.after_trap_accepted,
                                                  'command_error': self.after_command_error_detected,
                                                  'invalid_command': self.after_invalid_command_detected
                                              })
        self._counter_max = 60
        self._keeper_max = 60
        self._check_period = 1.0
        self._ping_timeout = 20
        self._alive_counter = self._err_counter = self._parameter_counter = 0
        self.disconnect_counter = 0
        self.keeper_alive = 0
        self.disconnection_logged = False

        self.prev_reception_alive = self.prev_keeper_alive = 0
        self.ping_timeout_updated = False
        self.prev_ping_timeout = self._ping_timeout

        self.timing = timing
        self.logs = logs
        self.log = logs['Core']
        self.log.debug('Initiated')
        self.t0 = time()

        for row in self.timing:
            if row[1] == 'Core':
                self._check_period = float(row[3])

    @property
    def check_period(self):
        return self._check_period

    @check_period.setter
    def check_period(self, p):
        self._check_period = p
        self._counter_max = int(self.memory.try_to_connect_interval / p)
        self._keeper_max = int(0.4 * self.ping_timeout / p)

    @property
    def ping_timeout(self):
        return self._ping_timeout

    @ping_timeout.setter
    def ping_timeout(self, t):
        self._ping_timeout = t
        self._keeper_max = int(0.4 * t / self.check_period)

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
    def parameter_add(self):
        return self._parameter_counter

    @parameter_add.setter
    def parameter_add(self, value=1):
        self._parameter_counter += value
        if self._parameter_counter > 65535:
            self._parameter_counter -= 65535

    def run(self) -> None:
        self.log.info('Started')
        self.log.debug("Time    | keep_connection | socket | connection_is_active | disconnection_detected | ready | "
                       "_con    | _dis    | _prev_stat | _flag")
        while self.memory.keep_connection:
            try:
                self.main()
            except Exception as e:
                self.err_add = 1
                self.log.exception(f'Failed by an error: {e}')
            if self._termination_command[0]:
                self.memory.keep_connection = False
            self.alive_add = 1
        self.log.debug('Finished')

    def main(self):
        while self.memory.keep_connection:
            if not self.memory.connection_is_active:
                self.connect()

            if self.memory.connection_is_active:
                try:
                    self.periodic_connection_task()
                except Exception as e:
                    self.err_add = 1
                    self.log.exception(f'Error on Periodic Connection Task: {e}')

            self.periodic_status_update()
            counter = self._counter_max
            while counter > 0:
                sleep(self.check_period)
                if self._termination_command[0]:
                    self.memory.keep_connection = False
                if not self.memory.keep_connection:
                    # self.events.disconnect()
                    self.log.debug('Close Command Detected')
                    break
                if not self.memory.connection_is_active:
                    self.log.info('Closing Objects after disconnection detection')
                    self.events.disconnect()

                self.alive_add = 1
                counter -= 1

            self.alive_add = 1
            self.memory.update_connection_timer()
            self.log.debug('Update Timer Done')

    def connect(self):
        self.socket = socket()

        try:
            self.socket.connect((self.radio.ip, self.radio.port))
        except (timeout, TimeoutError, OSError) as e:
            # self.log.warning(f'Failed to connect! {e}')
            if not self.disconnection_logged:
                self.log.error(f'Failed to connect! Error: {e}')
                self.disconnection_logged = True
            self.socket.close()
            self.events.disconnect()
        else:
            # print(f'Radio {self.radio} is now connected!')
            # self.reception.socket = self.transmission.socket = self.socket
            self.log.info(f'Successfully Connected')
            self.disconnection_logged = False
            self.events.connect()
        finally:
            pass

    def disconnect(self):
        self.events.disconnect()
        self.socket.close()

    def keep_connection_alive(self):
        self.log.info('Keep Connection Started')
        self.memory.keeper_disconnect_command = False
        sleep(2)
        while self.memory.connection_is_active:
            try:
                self.transmission.request_command('SCPG', 'S', str(self.ping_timeout))
            except Exception as e:
                self.log.exception(f'Failed to send keep alive connection command! {e}')

            counter = self._keeper_max
            while counter > 0:
                sleep(self.check_period)
                if not self.memory.keep_connection or not self.memory.connection_is_active:
                    break
                counter -= 1
                self.keeper_alive += 1
                if self.keeper_alive > 65535:
                    self.keeper_alive = 0

        self.log.info('Keep Connection Finished')

    def connection_task(self):
        self.log.info('Object Creation')
        self.keeper = Thread(target=self.keep_connection_alive, name=f"{self.radio}_Keeper", daemon=True)
        self.reception = RadioReception(self.socket, self.memory, self.events, self.radio, self.logs)
        self.transmission = RadioTransmission(self.socket, self.memory, self.events, self.radio, self.logs)

        for row in self.timing:
            if row[1] == 'RadioReception':
                self.reception.timing = float(row[3])
            elif row[1] == 'RadioTransmission':
                self.transmission.timing = float(row[3])

        self.keeper.start()
        self.reception.start()

        self.objects_creation()

        self.after_connect()
        self.initiate_radio()
        self.events.initiate()

    def initiate_radio(self):
        pass

    def periodic_connection_task(self):
        pass

    def periodic_status_update(self):
        pass

    def objects_creation(self):
        pass

    @staticmethod
    def get_time():
        now = datetime.now()
        return now.timestamp(), str(now)[:23]

    def parameter_updated(self, key, value):
        now_ts, now_sdt = self.get_time()
        if key == 'SCPG':
            self.ping_timeout = int(value)
            if self.ping_timeout_updated and self.ping_timeout == self.prev_ping_timeout:
                return
            else:
                self.ping_timeout_updated = True
                self.prev_ping_timeout = self.ping_timeout

        elif key in ('RCRI', 'RCTC'):
            self.memory.set_indicator(now_ts, int(value))
            # print(f'\nCore_Line_840: OnAir: {self.memory.on_air}')

        self.log.debug(f"{key}={value}")
        self.after_parameter_update(key, value, now_ts, now_sdt)

    def after_connect(self):
        """
            Can be overridden
        """

    def after_initiated(self):
        self.log.info('Radio initiated')

    def after_disconnected(self):
        # self.send_debug()
        if hasattr(self, 'keeper'):
            self.keeper.join()
        if hasattr(self, 'reception'):
            self.reception.join()
        self.log.info('All Object are closed')

    def after_sending_error(self, message):
        self.log.warning(f'SendingError: {message}')

    def after_command_sent(self, command):
        self.log.debug(f'CommandSent: {command}')

    def after_message_received(self, message):
        self.log.debug(f"MessageReceived ({len(message)} Byte(s):{message}")

    def after_parameter_update(self, key, value, ts, dt):
        pass

    def after_trap_accepted(self, key, stat):
        self.log.debug(f'TrapAccepted:{key}={stat}')

    def after_command_error_detected(self, key, command_char, request, message, value):
        self.log.warning(f'CommandError:{request}:{key}-{command_char}-{value}-{message}')

    def after_invalid_command_detected(self, key, command_char, request, message, value):
        self.log.warning(f'InvalidCommand:{request}:{key}-{command_char}-{value}-{message}')


if __name__ == '__main__':
    pass
