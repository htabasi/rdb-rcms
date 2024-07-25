from constructor.constructor import Constructor
from time import sleep


class Sender:
    def __init__(self, parent, coordinator, log):
        self.parent = parent
        self.coordinator = coordinator
        self.constructor = Constructor(self.parent.logs['Constructor'], self.parent.identity.radio_code)
        self._calm = 0.3
        self.request_convert = {'G': 'Get', 'S': 'Set', 'T': 'Trap'}
        self.log = log

    @property
    def calm(self):
        return self._calm

    @calm.setter
    def calm(self, value):
        self._calm = value

    def send(self, key, request, value=None, user_command=False, uac=None):
        self.log.debug(f'Sending Command: {key} {request} {value} (User-command: {user_command})')
        com_num = self.parent.command_id
        self.coordinator.send(com_num, key, request, value, user_command, uac)
        self.parent.send(self.constructor.convert(com_num, key, request, value))
        v = value if value is not None else ''
        self.parent.event_on_command_sent(f"{com_num}: {key} {self.request_convert.get(request, 'Get')} {v}")
        return com_num

    def group_send(self, command_list: list, event_request=False):
        self.log.debug(f'Sending {len(command_list)} Command(s)')
        for com in command_list:
            self.send(*com)
            sleep(self.calm)
        if event_request:
            self.log.debug(f'EventList will be received')
            self.send('EVEL', 'G')
