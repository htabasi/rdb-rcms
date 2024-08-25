import re


class Parameter:
    def __init__(self, health, **kwargs):
        self.health = health
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
        self.correct = kwargs['correct']
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        severity = {True: 0, False: self.severity}.get(int(value) == self.correct)
        query = {True: '', False: self.health.query(self.id, severity, self.message)}.get(self.prev == value)
        self.prev = value
        return query
        #
        # if int(value) == self.correct:
        #     if self.prev_lvl != 0:
        #         return self.health.query(self.id, 0, self.ok)
        #     else:
        #         return ''
        # else:
        #     if self.prev_lvl != self.severity:
        #         return self.health.query(self.id, self.severity, self.message)
        #     else:
        #         return ''
        #


class MultiLevel(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.correct = int(kwargs['correct'])
        self.stats = ({self.correct: self.health.query(self.id, 0, self.ok)} |
                      {int(stat['value']): self.health.query(self.id, int(stat['severity']), stat['message'])
                       for stat in kwargs['stats']})

    def update(self, value):
        value = int(value)
        if self.prev != value:
            self.prev = value
            query = self.stats.get(value, self.health.query(self.id, 1, f'Unknown state {value}'))
            return query
        else:
            return ''
        # if value == self.correct:
        #     return self.health.query(self.id, 0, self.ok)
        # elif value in self.stats:
        #     return self.health.query(self.id, *self.stats[value])
        # else:
        #     return self.health.query(self.id, 1, f'Unknown state {value}')


class Range(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.start, self.end = float(kwargs['start']), float(kwargs['end'])
        self.ranges = {index: (float(range['r_start']), float(range['r_end']))
                       for index, range in enumerate(kwargs['stats'])}
        self.action = {index: (int(range['severity']), range['message'])
                       for index, range in enumerate(kwargs['stats'])}

    def update(self, value):
        value = float(value)
        if (self.start <= value < self.end) or (self.end == -1 and self.start <= value) or (
                self.start == self.end == -1):
            return self.get_query(0, self.ok)
        else:
            for index, (start, end) in self.ranges.items():
                if (end == -1 and start <= value) or (start <= value < end):
                    severity, message = self.action[index]
                    return self.get_query(severity, message.format(value))
            else:
                return self.get_query(1, f'Unknown state {value}')

    def get_query(self, severity, message):
        if self.prev != severity:
            self.prev = severity
            return self.health.query(self.id, severity, message)
        else:
            return ''


class EqualString(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.correct = kwargs['correct']
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        severity = {True: 0, False: self.severity}.get(value == self.correct)
        query = {True: '', False: self.health.query(self.id, severity, self.message)}.get(self.prev == value)
        self.prev = value
        return query
        # if value == self.correct:
        #     return self.health.query(self.id, 0, self.ok)
        # else:
        #     return self.health.query(self.id, self.severity, self.message)


class PatternString(Parameter):
    def __init__(self, health, **kwargs):
        super().__init__(health, **kwargs)
        self.pattern = kwargs['pattern']
        self.severity = int(kwargs['severity'])
        self.message = kwargs['message']

    def update(self, value):
        matched = True if re.match(self.pattern, value) else False
        severity = {True: 0, False: self.severity}.get(matched)
        query = {True: '', False: self.health.query(self.id, severity, self.message)}.get(self.prev == value)
        self.prev = value
        return query
        # if re.match(self.pattern, value):
        #     return self.health.query(self.id, 0, 'OK')
        # else:
        #     return self.health.query(self.id, self.severity, self.message)
