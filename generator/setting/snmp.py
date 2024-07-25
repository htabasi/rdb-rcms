import os

from generator.setting import Settings, SettingInserter
from settings import SQL_INSERT_SETTING


class SNMP(Settings):
    def get_keys(self):
        keys = ['GRSE', 'GRSN', 'RUFL', 'RUFP']
        int_keys = ['GRSE']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key in {'GRSN', 'RUFL', 'RUFP'}:
            self.collection[key] = value.replace('"', '')

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys:
                self.collection[key] = value

            elif key in {'GRSN', 'RUFL', 'RUFP'}:
                self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        if key in self.int_keys:
            return str(value) + ', '
        else:
            return f"'{value}', "

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys:
            value = str(self.collection[key])

        else:
            value = f"'{self.collection[key]}'"
        return self.statement.format(key, dt, name, 0, value)


class SSNMPInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, os.path.join(SQL_INSERT_SETTING, 'snmp.sql'))

    def create_setting(self):
        return SNMP(self.radio.radio_code, self.insert)
