class Coordinator:
    def __init__(self, parent, log):
        self.parent = parent
        self.log = log
        self.com = {}
        self.user_command = {}
        self.active_trap = []

    def get_key(self, com_num):
        key = self.com.get(com_num, None).get('key', None)
        self.log.debug(f"get_key: Read command {com_num} Key -> {key}")
        return key

    def send(self, com_num, key, request, value, user_command=False, uac=None):
        self.com[com_num] = {'request': request, 'key': key, 'value': value, 'answer': None,
                             'accepted': False, 'error': False, 'error_code': 0, 'error_type': None}
        self.log.debug(f"send: Register command {com_num}: {key} {request} {value}")
        if user_command:
            user_id, action, comment = uac
            self.user_command[com_num] = {'request': request, 'key': key, 'answer': None, 'error': False,
                                          'user': user_id, 'action': action, 'comment': comment}
            self.log.debug(f"send: Register User command {com_num}: {key} {request} {value} {user_id}")

        return com_num

    def receive(self, time_tag, com_num, sign='d', error_code=0, answer='', message=''):
        """
        :param time_tag: Datetime of receive packet
        :param com_num: Command Number
        :param sign:
            'E': Unknown Error
            'd': Trap Answer
            'g': Get Answer
            's': Set Acknowledgement
            't': Trap Acknowledgement
            'e': Command Error

        :param error_code: Error Code
        :param answer: Answer
        :param message: Received Message
        :return: None
        """
        com = self.com[com_num] if self.com[com_num]['request'] == 'T' else self.com.pop(com_num)

        self.log.debug(f"receive: Evaluating command {com_num}")

        if sign in {'d', 'g'}:
            self.log.debug(f"receive: Update {com['key']} -> {answer}")
            self.parent.event_on_parameter_updated(time_tag, com['key'], answer)
        elif sign == 's':
            if com['key'] in {'EVCL', 'GRAT', 'MSGO', 'RCPF', 'RCPT', 'RCRR'}:
                self.parent.event_on_parameter_updated(time_tag, com['key'],
                                                       (com['user'], com['action'], com['comment']))
            else:
                self.parent.event_on_parameter_updated(time_tag, com['key'], com['value'])
            self.parent.event_on_set_accepted(time_tag, com['key'], com['value'])
        elif sign == 't':
            self.active_trap.append({'com_num': com_num, 'key': com['key']})
            self.parent.event_on_trap_accepted(time_tag, com['key'], com['value'])
        elif sign == 'e':
            self.parent.event_on_access_error(time_tag, com['key'], error_code, message)
        else:  # sign == 'E'
            self.parent.event_on_command_error(time_tag, com['key'], error_code, message)

        if com_num in self.user_command:
            com = self.user_command[com_num]
            if sign in {'g', 's', 't'}:
                self.parent.event_on_user_command_answered(time_tag, com['key'], answer)
            else:
                self.parent.event_on_user_command_answered(time_tag, com['key'], None, error=True)

    def user_command_succeed(self, com_num):
        if self.user_command[com_num]['answer'] is not None:
            com = self.user_command.pop(com_num)
            return 'Answered', com['error']
        else:
            return 'Not Answered', None
