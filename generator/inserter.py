

class InserterGenerator:
    """
    Base class For Generate SQL Statements
    """

    def __init__(self, radio, query_code, acceptable_keys, log, special_key=None):
        self.radio = radio.radio
        self.queries = radio.queries
        self.insert = self.queries.get(query_code)
        self.acceptable_keys = acceptable_keys
        if special_key is None:
            self.special_key = []
        else:
            self.special_key = special_key
        self.log = log

    def generate(self, time_tag, key, value) -> list:
        # self.log.debug(f"{self.__class__.__name__}: value={value}")
        if key in self.special_key:
            return self.generate_special(time_tag, key, value)
        else:
            return [self.insert.format(key, time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name, value)]

    def generate_special(self, time_tagg, key, value) -> list:
        return []
