from threading import Thread
from datetime import datetime

from base.aggregator import Aggregator


class BaseReception(Thread):
    def __init__(self, parent, name, log):
        super().__init__(name=f'{name}_Reception_Thread', daemon=True)
        self.base = parent
        self.log = log
        self.keep_alive = True
        self.close = self.event_on_disconnect
        self.rec_packet = Aggregator('CntReceivedPacket')
        self.rec_message = Aggregator('CntReceivedMessage')
        self.rec_c_error = Aggregator('CntReceivedCommandError')
        self.rec_a_error = Aggregator('CntReceivedAccessError')
        self.rec_trap_answer = Aggregator('CntReceivedTrapAnswer')
        self.rec_get_answer = Aggregator('CntReceivedGetAnswer')
        self.rec_trap_ack = Aggregator('CntReceivedTrapAcknowledge')
        self.rec_set_ack = Aggregator('CntReceivedSetAcknowledge')
        self.err_receive = Aggregator('CntErrorPacketReceive')
        self.err_eval = Aggregator('CntErrorPacketEvaluation')

        # self.rec_packet, self.rec_message, self.rec_c_error, self.rec_a_error = 0, 0, 0, 0
        # self.rec_trap_answer, self.rec_get_answer, self.rec_trap_ack, self.rec_set_ack = 0, 0, 0, 0
        # self.err_eval, self.err_receive = 0, 0
        self.alive_counter, self.alive_counter_prev = 0, 0

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def set_counters(self, aggregate, resettable):
        self.rec_packet.set(aggregate, resettable)
        self.rec_message.set(aggregate, resettable)
        self.rec_c_error.set(aggregate, resettable)
        self.rec_a_error.set(aggregate, resettable)
        self.rec_trap_answer.set(aggregate, resettable)
        self.rec_get_answer.set(aggregate, resettable)
        self.rec_trap_ack.set(aggregate, resettable)
        self.rec_set_ack.set(aggregate, resettable)
        self.err_receive.set(aggregate, resettable)
        self.err_eval.set(aggregate, resettable)

    def run(self):
        while self.keep_alive:
            self.log.debug('Run Receive')
            try:
                self.receive()
            except Exception as e:
                self.err_receive.add()
                self.log.warning(f'Error {e.__class__.__name__} {e.args}')
            self.alive_counter += 1

    def event_on_disconnect(self):
        self.keep_alive = False

    def receive(self):
        self.log.debug('Start')
        try:
            self.log.debug('Receive from socket.')
            data = self.base.socket.recv(1460).decode()
            time_tag = datetime.utcnow()
            self.rec_packet.add()
            self.alive_counter += 1
            self.log.debug(f'Packet Received. packet_len = {len(data)}')
            if not data:
                self.log.debug('Free Data Received')
                raise ConnectionResetError("Empty Data Received!")

            try:
                need_to_continue_receive = data[-1] != chr(13)
            except IndexError:
                need_to_continue_receive = False
            while need_to_continue_receive:
                data += self.base.socket.recv(1460).decode()
                self.rec_packet.add()
                need_to_continue_receive = data[-1] != chr(13)
                self.alive_counter += 1
        except (TimeoutError, ConnectionResetError, ConnectionAbortedError, OSError, ConnectionError) as e:
            self.log.debug(f'Radio Disconnected E: {e}')
            self.base.event_on_disconnect(datetime.utcnow())

        else:
            self.log.debug('New Packet Received')
            for received in data.split('\r\n'):
                self.alive_counter += 1
                self.rec_message.add()
                if received.startswith('\n'):
                    received = received[1:]
                if received.endswith('\r'):
                    received = received[:-1]

                if received == "":
                    continue
                self.log.debug('Packet Evaluation')
                try:
                    self.eval_answer(time_tag, received)
                except Exception as e:
                    self.err_eval.add()
                    self.log.error(f'Evaluation: Error {e.__class__.__name__} {e.args} Received:{received}')

    def eval_answer(self, time_tag, received):
        try:
            i = received.index(' ')
        except ValueError:
            return
        else:
            if received.startswith('E'):
                self.command_error(time_tag, int(received[i + 1:]), int(received[2:i]), received)

            else:
                command_number = int(received[0:i])
                request_char = received[i + 1: i + 2]
                try:
                    error_code = int(received[i + 2: i + 3])
                except ValueError:
                    secondary_command = received[i + 2:i + 4]
                    if request_char == 'd':  # Trap Answer
                        self.trap_answer(time_tag, command_number, secondary_command, received[i + 4:])

                    elif request_char == 'g':  # Get Answer
                        self.get_answer(time_tag, command_number, secondary_command, received[i + 4:])

                    elif request_char == 's':  # Set Acknowledge
                        self.set_acknowledge(time_tag, command_number, secondary_command)

                    elif request_char == 't':  # Trap Acknowledge
                        self.trap_acknowledge(time_tag, command_number, secondary_command)
                    else:
                        return

                else:
                    secondary_command = received[i + 3:i + 5]
                    self.access_error(time_tag, command_number, secondary_command, request_char, error_code, received)

    def command_error(self, time_tag, com_num, error_code, message):
        self.rec_c_error.add()
        self.log.debug(f'Command_error: {com_num} {message}')

    def access_error(self, time_tag, com_num, secondary_command, request, error_code, message):
        self.rec_a_error.add()
        self.log.debug(f'Access_error: {com_num} {request} {secondary_command}: {message}')

    def trap_answer(self, time_tag, com_num, secondary_command, value):
        self.rec_trap_answer.add()
        self.log.debug(f'trap_answer {com_num} {secondary_command}: {value}')

    def get_answer(self, time_tag, com_num, secondary_command, value):
        self.rec_get_answer.add()
        self.log.debug(f'get_answer: {com_num} {secondary_command}: {value}')

    def set_acknowledge(self, time_tag, com_num, secondary_command):
        self.rec_set_ack.add()
        self.log.debug(f'set_acknowledge: {com_num} {secondary_command}')
        if secondary_command == 'PG':
            self.base.ping_counter -= 1
            self.log.debug(f'set_acknowledge: Ping Timeout was set. alive_counter = {self.base.ping_counter}')

    def trap_acknowledge(self, time_tag, com_num, secondary_command):
        self.rec_trap_ack.add()
        self.log.debug(f'trap_acknowledge: {com_num} {secondary_command}')
