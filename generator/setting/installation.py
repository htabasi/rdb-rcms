import os

from generator.setting import Settings, SettingInserter, StrGroup
from settings import SQL_INSERT_SETTING


class Installation(Settings):
    def get_keys(self):
        keys = ['AIAI', 'AIEL', 'FFFE', 'FFSC', 'GRIN', 'GRLO', 'MSTY']
        int_keys = ['AIAI', 'AIEL', 'FFFE', 'FFSC', 'MSTY']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key == 'GRLO':
            self.collection[key] = StrGroup(radio_answer=value)

        elif key == 'GRIN':
            self.collection[key] = value.replace('"', '')

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys:
                self.collection[key] = value

            elif key == 'GRLO':
                self.collection[key] = StrGroup(db_answer=value)

            elif key == 'GRIN':
                self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        if key in self.int_keys:
            return str(value) + ', '
        elif key == 'GRIN':
            return f"'{value}', "
        else:
            return f"'{value.db_insert()}', "

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys:
            value = str(self.collection[key])

        elif key == 'GRIN':
            value = f"'{self.collection[key]}'"

        else:
            value = f"'{self.collection[key].db_insert()}'"
        return self.statement.format(key, dt, name, 0, value)


class SInstallationInserter(SettingInserter):
    def __init__(self, radio, log):

        super().__init__(radio, log, os.path.join(SQL_INSERT_SETTING, 'installation.sql'))

    def create_setting(self):
        return Installation(self.radio.radio_code, self.insert)
