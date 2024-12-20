from generator.setting import Settings, StrGroup, SettingInserter


class Network(Settings):
    def get_keys(self):
        keys = ['GRDH', 'GRDN', 'GRIE', 'GRIV', 'GRNS', 'GRVE']
        int_keys = ['GRDH', 'GRIE', 'GRIV']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key == 'GRVE':
            from decimal import Decimal
            self.collection[key] = Decimal(value)

        elif key == 'GRDN':
            self.collection[key] = StrGroup(radio_answer=value)

        elif key == 'GRNS':
            self.collection[key] = value.replace('"', '')

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys + ['GRVE']:
                self.collection[key] = value

            elif key == 'GRDN':
                self.collection[key] = StrGroup(db_answer=value)

            elif key == 'GRNS':
                self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        if key in self.int_keys + ['GRVE']:
            return str(value) + ', '
        elif key == 'GRNS':
            return f"'{value}', "
        else:
            return f"'{value.db_insert()}', "

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys + ['GRVE']:
            value = str(self.collection[key])

        elif key == 'GRNS':
            value = f"'{self.collection[key]}'"

        else:
            value = f"'{self.collection[key].db_insert()}'"
        return self.statement.format(key, dt, name, 0, value)


class SNetworkInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, query_code='ISNetwork')

    def create_setting(self):
        return Network(self.radio.radio_code, self.insert)
