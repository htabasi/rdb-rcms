from datetime import datetime

from generator.setting import Settings, SettingInserter, RX


class Status(Settings):
    def get_keys(self):
        if self.radio_type == RX:
            keys = ['ERBE', 'GRLR', 'GRTI', 'RCLR']
            int_keys = ['GRLR', 'RCLR']
        else:
            keys = ['ERBE', 'GRLT', 'GRTI', 'RCLV']
            int_keys = ['GRLT']
        return keys, int_keys

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key == 'RCLV':
            from decimal import Decimal
            self.collection[key] = Decimal(value)

        elif key == 'ERBE':
            self.collection[key] = value.replace('"', '')
        else:
            self.collection[key] = datetime.strptime(value.replace('"', ''), '%Y/%m/%d %H:%M:%S')

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if value is not None:
            self.collection[key] = value

    def add_values(self, *args):
        key, value = args
        if key in self.int_keys + ['RCLV']:
            return str(value) + ', '
        elif key == 'ERBE':
            return f"'{value}', "
        else:
            return f"'{str(value)}', "

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys + ['RCLV']:
            value = str(self.collection[key])
        elif key == 'ERBE':
            value = f"'{self.collection[key]}'"
        else:
            value = f"'{self.collection[key]}'"
        return self.statement.format(key, dt, name, 0, value)


class SStatusInserter(SettingInserter):
    def __init__(self, radio, log):
        super().__init__(radio, log, query_code='ISStatus')
        self.ignore_equality = True

    def create_setting(self):
        return Status(self.radio.radio_code, self.insert)

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key=[{key}] value=[{value}]")
        self.setting.add_item(key, value)
        if self.wait_for_collection:
            if self.setting.is_complete:
                if self.ignore_equality or self.setting != self.db_setting:
                    # self.log.debug(f"{self.__class__.__name__}: setting collection: {self.setting.collection}")
                    # self.log.debug(f"{self.__class__.__name__}: generated query: {s}")
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
