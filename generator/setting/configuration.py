import os

from generator.setting import Settings, SettingInserter, IntGroup, TupleGroup
from settings import SQL_INSERT_SETTING


class Configuration(Settings):
    """
        CREATE TABLE Setting.Configuration
        (
            id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL,
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            Record     TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
            AISE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
            AISF       SMALLINT      NULL,
            EVSR       VARCHAR(50)   NULL,
            FFBL       VARCHAR(150)  NULL,
            FFEA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
            FFFC       VARCHAR(50)   NULL,
            FFLM       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
            FFLT       SMALLINT      NULL
        )

    """

    def get_keys(self):
        keys = ['AISE', 'AISF', 'EVSR', 'FFBL', 'FFEA', 'FFFC', 'FFLM', 'FFLT']
        int_keys = ['AISE', 'AISF', 'FFEA', 'FFLM', 'FFLT']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key in {'EVSR', 'FFFC'}:
            self.collection[key] = IntGroup(radio_answer=value)

        elif key == 'FFBL':
            self.collection[key] = TupleGroup(radio_answer=value)

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            if key in self.int_keys:
                self.collection[key] = value

            elif key in ['EVSR', 'FFFC']:
                self.collection[key] = IntGroup(db_answer=value)

            elif key == 'FFBL':
                self.collection[key] = TupleGroup(db_answer=value)

    def add_values(self, *args):
        key, value = args
        if key in self.int_keys:
            return str(value) + ', '
        else:
            return f"'{value.db_insert()}', "

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys:
            value = str(self.collection[key])
        else:
            value = f"'{self.collection[key].db_insert()}'"
        return self.statement.format(key, dt, name, 0, value)


class SConfigurationInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, os.path.join(SQL_INSERT_SETTING, 'configuration.sql'))

    def create_setting(self):
        return Configuration(self.radio.radio_code, self.insert)
