from base.reception import BaseReception


class Reception(BaseReception):
    def __init__(self, parent, coordinator, name, log):
        super().__init__(parent, name, log)
        self.coordinator = coordinator

    def eval_answer(self, time_tag, received):
        self.base.event_on_message_received(received)
        super().eval_answer(time_tag, received)

    def command_error(self, time_tag, com_num, error_code, message):
        super().command_error(time_tag, com_num, error_code, message)
        self.coordinator.receive(time_tag, com_num, sign='E', error_code=error_code, message=message)
        self.log.warning(f'Command Error Detected: {message}')

    def access_error(self, time_tag, com_num, secondary_command, request, error_code, message):
        super().access_error(time_tag, com_num, secondary_command, request, error_code, message)
        self.coordinator.receive(time_tag, com_num, sign='e', error_code=error_code, message=message)
        self.log.warning(f'Inaccessible Command Detected: {message}')

    def trap_answer(self, time_tag, com_num, secondary_command, value):
        super().trap_answer(time_tag, com_num, secondary_command, value)
        self.coordinator.receive(time_tag, com_num, sign='d', answer=value)
        self.log.debug(f'Trap Answer: {com_num} {value}')

    def get_answer(self, time_tag, com_num, secondary_command, value):
        super().get_answer(time_tag, com_num, secondary_command, value)
        self.coordinator.receive(time_tag, com_num, sign='g', answer=value)
        self.log.debug(f'Get Answer: {com_num} {value}')

    def set_acknowledge(self, time_tag, com_num, secondary_command):
        self.rec_set_ack.add()
        if secondary_command == 'PG' and self.coordinator.get_key(com_num) == 'SCPG':
            self.base.ping_counter -= 1
            self.log.debug(f'set_acknowledge: Ping Timeout was set. alive_counter = {self.base.ping_counter}')
        self.coordinator.receive(time_tag, com_num, sign='s')
        self.log.debug(f'set_acknowledge: {com_num} {secondary_command}')

    def trap_acknowledge(self, time_tag, com_num, secondary_command):
        super().trap_acknowledge(time_tag, com_num, secondary_command)
        self.coordinator.receive(time_tag, com_num, sign='t')
        self.log.debug(f'Trap Stat Updated: {com_num}')
