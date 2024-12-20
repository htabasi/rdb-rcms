from generator.setting import Settings, SettingInserter


class RXConfiguration(Settings):
    def get_keys(self):
        keys = ['AIGA', 'AITS', 'FFCO', 'FFSL', 'GRBS', 'GRIS', 'RIRO']
        int_keys = ['AIGA', 'AITS', 'FFCO', 'FFSL', 'GRBS', 'GRIS', 'RIRO']
        return keys, int_keys

    def add_item(self, key, value):
        self.collection[key] = int(value)
        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys:
                self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        return str(value) + ', '

    def single_db_insert(self, dt, name, key):
        value = str(self.collection[key])
        return self.statement.format(key, dt, name, 0, value)


class SRXConfigurationInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, query_code='ISRXConfiguration')

    def create_setting(self):
        return RXConfiguration(self.radio.radio_code, self.insert)
