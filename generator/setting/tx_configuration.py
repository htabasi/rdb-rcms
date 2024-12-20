from generator.setting import SettingInserter, Settings


class TXConfiguration(Settings):
    def get_keys(self):
        keys = ['AICA', 'AIML', 'GRAS', 'GRCO', 'GREX', 'RCDP', 'RIPC', 'RIVL', 'RIVP']
        int_keys = ['AICA', 'AIML', 'GRAS', 'GRCO', 'GREX', 'RCDP', 'RIPC', 'RIVP']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key == 'RIVL':
            from decimal import Decimal
            self.collection[key] = Decimal(value)
        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys:
                self.collection[key] = value

            elif key == 'RIVL':
                self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        return str(value) + ', '

    def single_db_insert(self, dt, name, key):
        value = str(self.collection[key])
        return self.statement.format(key, dt, name, 0, value)


class STXConfigurationInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, query_code='ISTXConfiguration')

    def create_setting(self):
        return TXConfiguration(self.radio.radio_code, self.insert)
