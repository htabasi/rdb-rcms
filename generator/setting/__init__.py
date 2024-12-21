RX, TX = 0, 1


class Group:
    def __init__(self, answer=None):
        self.group = tuple(answer)

    def __repr__(self):
        return str(self.group)

    def db_insert(self):
        return ''.join([str(n) + ',' for n in self.group])[:-1]

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.group == other.group


class IntGroup(Group):
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            super(IntGroup, self).__init__([int(item) for item in radio_answer.split(',')[1:]])
        else:
            super(IntGroup, self).__init__([int(item) for item in db_answer.split(',')])


class StrGroup(Group):
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            super(StrGroup, self).__init__(
                [str(item) for item in radio_answer.replace('"', '').replace('::', '').split(',')[1:]])
        else:
            super(StrGroup, self).__init__([str(item) for item in db_answer.split(',')])


class TupleGroup(Group):
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            n, c = int(radio_answer[:radio_answer.index(',')]), radio_answer.count(',')
            r, m = radio_answer[radio_answer.index(',') + 1:], n // c
            super(TupleGroup, self).__init__([IntGroup(radio_answer=r[m * i: m * i + 5]) for i in range(n)])
        else:
            super(TupleGroup, self).__init__([IntGroup(db_answer=group) for group in db_answer.split(';')])

    def db_insert(self):
        return ''.join([str(t.db_insert()) + ';' for t in self.group])[:-1]


class Settings:
    def __init__(self, radio_type, statement):
        self.collection = {}
        self.radio_type = radio_type
        self.keys, self.int_keys = self.get_keys()
        self.is_complete, self.all = False, len(self.keys)
        self.statement = statement

    def get_keys(self):
        if self.radio_type == RX:
            keys = []
        else:
            keys = ['AITP', 'FFTO', 'RCIT', 'RCLP', 'RCNP', 'RCTS']
        return keys, keys

    def add_item(self, key, value):
        self.collection[key] = int(value)
        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        self.collection[key] = value

    def clear(self):
        self.collection.clear()
        self.is_complete = False

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            result = True
            try:
                for key in self.collection:
                    result = result and self.collection[key] == other.collection[key]
                    if not result:
                        break
                return result
            except KeyError:
                return False
        else:
            return False

    def add_values(self, *args):
        return str(args[1]) + ', '

    def db_insert(self, dt, name):
        if not self.is_complete:
            return
        keys, values = '', ''
        for key in self.collection:
            value = self.collection[key]
            keys += key + ', '
            values += self.add_values(key, value)

        return self.statement.format(keys[:-2], dt, name, 1, values[:-2])

    def single_db_insert(self, dt, name, key):
        value = str(self.collection[key])
        return self.statement.format(key, dt, name, 0, value)

    def __repr__(self):
        return ''.join([f"{key} : {self.collection[key]}\n" for key in self.collection])


class SettingInserter:
    def __init__(self, radio, log, query_code):
        self.radio = radio.radio
        self.queries = radio.queries
        self.insert = self.queries.get(query_code)
        self.db_setting = None
        self.setting = self.create_setting()
        self.acceptable_keys = self.setting.keys
        self.wait_for_collection = False
        self.log = log

    def create_setting(self):
        return Settings(self.radio.radio_code, self.insert)

    def save_setting(self, db_setting: dict):
        # self.log.debug(f"{self.__class__.__name__}: Setting Received From Database: {db_setting}")
        # print(db_setting)
        if db_setting is not None:
            self.db_setting = self.create_setting()
            for key, value in db_setting.items():
                if key in self.db_setting.keys:
                    self.db_setting.save_db(key, value)

            # self.log.debug(f"{self.__class__.__name__}: Database Setting saved.")
        else:
            self.log.info(f"{self.__class__.__name__}: Database Setting is empty")
            # self.log.debug(f"{self.__class__.__name__}: Database Setting is empty")

    def set_config_request_started(self):
        # self.log.debug(f"{self.__class__.__name__}: Start for Setting collection")
        self.setting.clear()
        self.wait_for_collection = True

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key=[{key}] value=[{value}]")
        self.setting.add_item(key, value)
        if self.wait_for_collection:
            if self.setting.is_complete:
                if self.setting != self.db_setting:
                    query = [self.setting.db_insert(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name)]
                    self.db_setting = self.setting
                    self.setting = self.create_setting()
                    self.log.info(f"{self.__class__.__name__}: Settings Updated")
                    # self.log.debug(f"{self.__class__.__name__}: Setting collection finished")
                    return query
                else:
                    self.log.debug(f"{self.__class__.__name__}: Settings Checked")
                    # self.log.debug(f"{self.__class__.__name__}: Collected Setting is same as database setting")
                    self.wait_for_collection = False
                    self.setting.clear()
                    return []
            else:
                return []
        else:
            # self.log.debug(f"{self.__class__.__name__}: Singular Setting updated.")
            return [self.setting.single_db_insert(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name, key)]


class SSpecialSettingInserter(SettingInserter):
    """
        CREATE TABLE Event.SpecialSetting
            (
                id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
                Date       DATETIME NOT NULL DEFAULT GETDATE(),
                Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
                AITP       TINYINT  NULL,
                FFTO       TINYINT  NULL FOREIGN KEY REFERENCES Common.TXOffset (id),
                RCIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.Inhibit (id),
                RCLP       TINYINT  NULL,
                RCNP       TINYINT  NULL,
                RCTS       TINYINT  NULL FOREIGN KEY REFERENCES Common.PowerLevel (id),
            );

    """

    def __init__(self, radio, log):
        super().__init__(radio, log, query_code='IESpecialSetting')

    def create_setting(self):
        return Settings(self.radio.radio_code, self.insert)
