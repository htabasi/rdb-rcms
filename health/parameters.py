import re


class Parameter:
    def __init__(self, health, log, **kwargs):
        self.health = health
        self.log = log
        self.id = kwargs['id']
        self.name = kwargs['name']
        self.code = kwargs['code']
        self.ok = kwargs['normal_msg']
        self.prev = None

    def update(self, value):
        pass


class FixedValue(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.correct = int(kwargs['correct'])
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        self.log.debug(f'{self.__class__.__name__} update by value: {value} type: {type(value)},'
                       f' code: {self.code}, correct: {self.correct}, severity: {self.severity}')
        severity, message = {
            True: (0, self.ok),
            False: (self.severity, self.message.format(value))
        }.get(int(value) == self.correct)
        query = {True: '', False: self.health.query(self.id, severity, message)}.get(self.prev == value)
        self.prev = value
        self.log.debug(f'{self.__class__.__name__} result: {severity}, {message}')
        return query


class MultiLevel(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.correct = int(kwargs['correct'])
        self.stats = ({self.correct: self.health.query(self.id, 0, self.ok)} |
                      {int(stat['value']): self.health.query(self.id, int(stat['severity']), stat['message'])
                       for stat in kwargs['stats']})
        self.log.debug(f'{self.__class__.__name__} stats: {self.stats}')

    def update(self, value):
        self.log.debug(f'{self.__class__.__name__} update by value: {value} type: {type(value)}, '
                       f'code: {self.code}, correct: {self.correct}')
        value = int(value)
        if self.prev != value:
            self.prev = value
            query = self.stats.get(value, self.health.query(self.id, 1, f'Unknown state {value}'))
            self.log.debug(f'{self.__class__.__name__} result: {value}')
            return query
        else:
            self.log.debug(f'{self.__class__.__name__} no query generated')
            return ''


class Range(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.start, self.end = float(kwargs['start']), float(kwargs['end'])
        self.ranges = {index: (float(range['r_start']), float(range['r_end']))
                       for index, range in enumerate(kwargs['stats'])}
        self.action = {index: (int(range['severity']), range['message'])
                       for index, range in enumerate(kwargs['stats'])}

    def update(self, value):
        self.log.debug(f'{self.__class__.__name__} update by value: {value} type: {type(value)}, code: {self.code}, correct: {(self.start, self.end)}')
        value = float(value)
        if (self.start <= value < self.end) or (self.end == -1 and self.start <= value) or (
                self.start == self.end == -1):
            self.log.debug(f'{self.__class__.__name__} result: 0, {self.ok}')
            return self.get_query(0, self.ok)
        else:
            for index, (start, end) in self.ranges.items():
                if (end == -1 and start <= value) or (start <= value < end):
                    severity, message = self.action[index]
                    self.log.debug(f'{self.__class__.__name__} result: {severity}, {message.format(value)}')
                    return self.get_query(severity, message.format(value))
            else:
                if value == 0.0:
                    self.log.debug(f'{self.__class__.__name__} no query generated')
                    return ''
                else:
                    self.log.debug(f'{self.__class__.__name__} result: Unknown state {value}')
                    return self.get_query(1, f'Unknown state {value}')

    def get_query(self, severity, message):
        if self.prev != severity:
            self.prev = severity
            self.log.debug(f'{self.__class__.__name__} query generate for {severity}, {message}')
            return self.health.query(self.id, severity, message)
        else:
            self.log.debug(f'{self.__class__.__name__} no query generated')
            return ''


class EqualString(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.correct = kwargs['correct']
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        self.log.debug(f'{self.__class__.__name__} update by value: {value} type: {type(value)}, '
                       f'code: {self.code}, correct: {self.correct}, severity: {self.severity}')
        severity, message = {
            True: (0, self.ok),
            False: (self.severity, self.message.format(value))
        }.get(value == self.correct)
        query = {True: '', False: self.health.query(self.id, severity, message)}.get(self.prev == value)
        self.prev = value
        if query:
            self.log.debug(f'{self.__class__.__name__} result: {severity}, {message}')
        else:
            self.log.debug(f'{self.__class__.__name__} no query generated')
        return query


class PatternString(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.pattern = kwargs['pattern']
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        self.log.debug(f'{self.__class__.__name__} update by value: {value} type: {type(value)}, '
                       f'code: {self.code}, correct: {self.pattern}, severity: {self.severity}')
        value = value.replace('"', '')
        matched = True if re.match(self.pattern, value) else False
        severity = {True: 0, False: self.severity}.get(matched)
        query = {
            True: '',
            False: self.health.query(self.id, severity, self.message.format(value))
        }.get(self.prev == value)
        self.prev = value
        if query:
            self.log.debug(f'{self.__class__.__name__} result: {severity}, {self.message}')
        else:
            self.log.debug(f'{self.__class__.__name__} no query generated')
        return query
