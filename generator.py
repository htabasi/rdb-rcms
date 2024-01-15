from threading import Thread
from time import sleep
from datetime import datetime, date


def get_statement(file):
    with open(file, 'r') as f:
        sql = f.read()
    return sql


def get_datetime(s_dt: str):
    p = s_dt.split(' ')
    sd, st = p[0].split('/'), p[1].split(':')
    d = {'year': int(sd[0]),
         'month': int(sd[1]),
         'day': int(sd[2]),
         'hour': int(st[0]),
         'minute': int(st[1]),
         'second': int(st[2])
         }

    return datetime(**d)


def get_date(s_date):
    sd = s_date.replace('"', '').split('/')
    d = {'year': int(sd[0]),
         'month': int(sd[1]),
         'day': int(sd[2]),
         }
    return date(**d)


def get_timestamp(s_dt: str):
    return get_datetime(s_dt).timestamp()


class IP:
    def __init__(self, radio_answer=None, db_answer=None, ip=None, subnet=None, gateway=None):
        if radio_answer is not None:
            self.ip, self.subnet, self.gateway = radio_answer.replace('"', '').replace('::', '').split(',')[1:]
        elif db_answer is not None:
            self.ip, self.subnet, self.gateway = db_answer
        else:
            self.ip, self.subnet, self.gateway = ip, subnet, gateway

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return (self.ip == other.ip) and (self.subnet == other.subnet) and (self.gateway == other.gateway)
        else:
            return False

    def __repr__(self):
        return f"{self.ip}, {self.subnet}, {self.gateway}"


class Access:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            self.access = {i + 1: ip for i, ip in
                           enumerate(radio_answer.replace('"', '').replace('::', '').split(',')[1:])}
        else:
            self.access = {pair[0]: pair[1] for pair in db_answer}

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.access == other.access


class Partition:
    def __init__(self, version=None, part_number=None, db_answer=None):
        """
        Partition Status:
            0: Booted
            1: Ready
            2: Update
        """
        if db_answer is None:
            self.version = version
            self.part_number = part_number
            if self.version == '00.00' and self.part_number == '0000.0000.00':
                self.status = 2
            else:
                self.status = 1
        else:
            self.version, self.part_number, self.status = db_answer

        self.convert_status = {0: 'Booted', 1: 'Ready', 2: 'Update'}

    def set_booted(self):
        self.status = 0

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.version == other.version and \
                self.part_number == other.part_number and \
                self.status == other.status

    def __repr__(self):
        return f"Part_Number = {self.part_number}, Version = {self.version}, " \
               f"Status = {self.convert_status.get(self.status)}"

    def db_insert(self):
        return f"'{self.part_number}', '{self.version}', {self.status}"


class Software:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            booted, v1, p1, v2, p2 = radio_answer.replace('"', '').split(',')[1:]
            self.partitions = [Partition(v1, p1), Partition(v2, p2)]
            self.booted = int(booted)
            self.partitions[self.booted - 1].set_booted()
        else:
            # [(1, '11.05', '6164.6921.05', 0), (2, '00.00', '0000.0000.00', 2)]
            self.partitions = [Partition(db_answer=p[1:]) for p in db_answer]
            if self.partitions[0].status == 0:
                self.booted = 1
            elif self.partitions[1].status == 0:
                self.booted = 2

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.partitions[0] == other.partitions[0] and \
                self.partitions[1] == other.partitions[1] and \
                self.booted == other.booted

    def __repr__(self):
        return f"Partition {1}: {self.partitions[0]}\nPartition {2}: {self.partitions[1]}"

    def db_insert(self, partition):
        return f"{partition}, {self.partitions[partition - 1].db_insert()}"


class InventoryItem:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            nd = radio_answer.replace('"', '').split(',')
            self.radio_index, self.type, self.variant = int(nd[0]), int(nd[1]), int(nd[5])
            self.component_name, self.ident_number = nd[3:5]
            self.production_index, self.serial_number = nd[7:9]
            self.production_date = nd[9].replace('/', '-')
        else:
            self.radio_index, self.type, self.component_name, self.ident_number, self.variant = db_answer[:5]
            self.production_index, self.serial_number = db_answer[5:7]
            self.production_date = str(db_answer[7])

        self.type_conversion = {0: 'FW', 2: 'SW', 3: 'HWMOD', 4: 'SWMOD', 5: 'DEV'}

    def __eq__(self, other):
        return self.radio_index == other.radio_index and \
            self.type == other.type and \
            self.component_name == other.component_name and \
            self.ident_number == other.ident_number and \
            self.variant == other.variant and \
            self.production_index == other.production_index and \
            self.serial_number == other.serial_number and \
            self.production_date == other.production_date

    def __repr__(self):
        #   0       5       EU4200C RADIO   6144.7800   12      17.00               103897  2015-03-16
        return f"{self.radio_index:^10} {self.type_conversion.get(self.type):^10} {self.component_name:^20} " \
               f"{self.ident_number:^10} {self.variant:^10} {self.production_index:^16} {self.serial_number:^10} " \
               f"{self.production_date:^15}"

    def db_insert(self, dt, name):
        return f"('{dt}', '{name}', {self.radio_index}, {self.type}, '{self.component_name}', '{self.ident_number}', " \
               f"{self.variant}, '{self.production_index}', '{self.serial_number}', '{self.production_date}')"


class Inventory:
    def __init__(self, statement=None):
        self.collection = {}
        self.is_complete = False
        self.statement = statement

    def add_item(self, item: InventoryItem):
        self.collection[item.radio_index] = item
        self.is_complete = len(self.collection) == 10
        # print(f"self.is_complete = {self.is_complete}, len(self.collection) = {len(self.collection)}")

    def clear(self):
        self.collection.clear()
        self.is_complete = False

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.collection == other.collection
        else:
            return False

    def __repr__(self):
        s = f"{'Index':^10} {'Type':^10} {'Component':^20} {'Ident':^10} {'Variant':^10} {'Production Index':^16} " \
            f"{'Serial':^10} {'Production Date':^15}"
        for item in sorted(self.collection):
            s += f"\n{self.collection[item]}"
        return s

    def db_insert(self, dt, name):
        if not self.is_complete:
            return
        sql = self.statement
        for item in sorted(self.collection):
            sql += f"{self.collection[item].db_insert(dt, name)}, "
        return sql[:-2] + ';'


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


class RadioSettings:
    """
        sql = "SELECT CKI.CKey, CKI.TX_Support, CKI.RX_Support FROM INFORMATION_SCHEMA.COLUMNS ISC INNER JOIN
               Command.KeyInformation CKI on ISC.COLUMN_NAME = CKI.CKey WHERE ISC.TABLE_SCHEMA='Setting' AND
               ISC.TABLE_NAME='SRadio';"
        ans = get_answer(connection, sql)
        rx_keys = [tu[0] for tu in ans if tu[2]]
        tx_keys = [tu[0] for tu in ans if tu[1]]

        sql = "Select ISC.COLUMN_NAME From INFORMATION_SCHEMA.COLUMNS ISC WHERE ISC.TABLE_SCHEMA='Setting' AND
               ISC.TABLE_NAME='SRadio';"
        ans = get_answer(connection, sql)
        print(tuple(zip(*ans))[0])
    """

    def __init__(self, radio_type, statement):
        self.collection = {}
        self.radio_type = radio_type
        if self.radio_type == 1:  # RX
            self.keys = ['AIAI', 'AIEL', 'AIGA', 'AISE', 'AISF', 'AITS', 'ERBE', 'EVSR', 'FFBL', 'FFCO', 'FFEA', 'FFFC',
                         'FFFE', 'FFLM', 'FFLT', 'FFSC', 'FFSL', 'GRBS', 'GRDH', 'GRDN', 'GRIE', 'GRIN', 'GRIS', 'GRIV',
                         'GRLO', 'GRLR', 'GRNS', 'GRSE', 'GRSN', 'GRVE', 'MSTY', 'RIRO', 'RUFL', 'RUFP']
            self.int_keys = ['AIAI', 'AIEL', 'AIGA', 'AISE', 'AISF', 'AITS', 'FFCO', 'FFEA', 'FFFE', 'FFLM', 'FFLT',
                             'FFSC', 'FFSL', 'GRBS', 'GRDH', 'GRIE', 'GRIS', 'GRIV', 'GRLR', 'GRSE', 'MSTY', 'RIRO']

        else:
            self.keys = ['AIAI', 'AICA', 'AIEL', 'AIML', 'AISE', 'AISF', 'AITP', 'ERBE', 'EVSR', 'FFBL', 'FFEA', 'FFFC',
                         'FFFE', 'FFLM', 'FFLT', 'FFSC', 'FFTO', 'GRAS', 'GRCO', 'GRDH', 'GRDN', 'GREX', 'GRIE', 'GRIN',
                         'GRIV', 'GRLO', 'GRLT', 'GRNS', 'GRSE', 'GRSN', 'GRVE', 'MSTY', 'RCDP', 'RCIT', 'RCLP', 'RCNP',
                         'RCTS', 'RIPC', 'RIVL', 'RIVP', 'RUFL', 'RUFP']
            self.int_keys = ['AIAI', 'AICA', 'AIEL', 'AIML', 'AISE', 'AISF', 'AITP', 'FFEA', 'FFFE', 'FFLM', 'FFLT',
                             'FFSC', 'FFTO', 'GRAS', 'GRCO', 'GRDH', 'GREX', 'GRIE', 'GRIV', 'GRLT', 'GRSE', 'MSTY',
                             'RCDP', 'RCIT', 'RCLP', 'RCNP', 'RCTS', 'RIPC', 'RIVP']

        self.is_complete, self.all = False, len(self.keys)
        self.statement = statement

    def add_item(self, key, value):
        if key in self.int_keys:
            self.collection[key] = int(value)

        elif key in ['GRVE', 'RIVL']:
            from decimal import Decimal
            self.collection[key] = Decimal(value)

        elif key in ['EVSR', 'FFFC']:
            self.collection[key] = IntGroup(radio_answer=value)

        elif key == 'FFBL':
            self.collection[key] = TupleGroup(radio_answer=value)

        elif key in ['GRDN', 'GRLO']:
            self.collection[key] = StrGroup(radio_answer=value)

        elif key in ['ERBE', 'GRIN', 'GRNS', 'GRSN', 'RUFL', 'RUFP']:
            self.collection[key] = value.replace('"', '')

        self.is_complete = len(self.collection) == self.all

    def save_db(self, key, value):
        if key in self.int_keys:
            self.collection[key] = value

        elif key in ['GRVE', 'RIVL']:
            self.collection[key] = value

        elif key in ['EVSR', 'FFFC']:
            self.collection[key] = IntGroup(db_answer=value)

        elif key == 'FFBL':
            self.collection[key] = TupleGroup(db_answer=value)

        elif key in ['GRDN', 'GRLO']:
            self.collection[key] = StrGroup(db_answer=value)

        elif key in ['ERBE', 'GRIN', 'GRNS', 'GRSN', 'RUFL', 'RUFP']:
            self.collection[key] = value

    def clear(self):
        self.collection.clear()
        self.is_complete = False

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            result = True
            for key in self.collection:
                if key in ['GRLR', 'GRLT']:
                    continue
                result = result and self.collection[key] == other.collection[key]
                if not result:
                    break
            return result
        else:
            return False

    def db_insert(self, dt, name):
        if not self.is_complete:
            return
        keys, values = '', ''
        for key in self.collection:
            value = self.collection[key]
            keys += key + ', '
            if key in self.int_keys + ['GRVE', 'RIVL']:
                values += str(value) + ', '

            elif key in ['ERBE', 'GRIN', 'GRNS', 'GRSN', 'RUFL', 'RUFP']:
                values += f"'{value}', "

            else:
                values += f"'{value.db_insert()}', "

        return self.statement.format(keys[:-2], dt, name, 1, values[:-2])

    def single_db_insert(self, dt, name, key):
        if key in self.int_keys + ['GRVE', 'RIVL']:
            value = str(self.collection[key])

        elif key in ['GRIN', 'GRNS', 'GRSN', 'RUFL', 'RUFP']:
            value = f"'{self.collection[key]}'"

        else:
            value = f"'{self.collection[key].db_insert()}'"
        return self.statement.format(key, dt, name, 0, value)

    def __repr__(self):
        return ''.join([f"{key} : {self.collection[key]}\n" for key in self.collection])


class CBITSettings:
    def __init__(self, log):
        self.setting = {}
        self.difference = []
        self.log = log

    def add_radio_config(self, s_code: str, s_config: str):
        code, config = int(s_code), int(s_config)
        if code not in self.setting or self.setting[code] != config:
            self.log.debug(f"{self.__class__.__name__}: CBIT Setting Difference Detected on CBIT_Code:{code} = "
                           f"{config}")
            self.difference.append((code, config))

    def add_db_config(self, db_setting: list):
        # [[348, 2], [347, 2], [346, 1], [345, 1], [342, 1], [338, 1], [336, 1], [335, 1], [331, 4], [323, 4],
        #  [302, 1], [301, 2], [201, 4], [103, 4], [101, 2]]
        # self.log.debug(f"{self.__class__.__name__}: CBIT Setting Received from Database")
        self.setting = {code: config for code, config in db_setting}

    def get_difference(self):
        # if self.difference:
        #     self.log.debug(f"{self.__class__.__name__}: Differences: {self.difference}")
        # else:
        #     self.log.debug(f"{self.__class__.__name__}: No Differences")
        return self.difference

    def clear_difference(self):
        for code, config in self.difference:
            self.setting[code] = config
        self.difference.clear()
        # self.log.debug(f"{self.__class__.__name__}: Setting Updated. Differences are cleared!")


class InserterGenerator:
    """
    Base class For Generate SQL Statements
    """

    def __init__(self, radio, insert_query_file, acceptable_keys, log, special_key=None):
        self.radio = radio
        self.insert = get_statement(insert_query_file)
        self.acceptable_keys = acceptable_keys
        if special_key is None:
            self.special_key = []
        else:
            self.special_key = special_key
        self.log = log

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: value={value}")
        if key in self.special_key:
            return self.generate_special(event_timestamp, event_s_datetime, key, value)
        else:
            return [self.insert.format(key, event_s_datetime, self.radio.name, value)]

    def generate_special(self, event_timestamp, event_s_datetime, key, value):
        pass


class ECBITInserter(InserterGenerator):
    """
    This class  Event.ECBIT Table:

    Table Definition:
        CREATE TABLE Event.ECBIT
        (
            id         INT         NOT NULL IDENTITY PRIMARY KEY,
            Date       DATETIME    NOT NULL,
            Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            Code       SMALLINT    NOT NULL,
            Name       VARCHAR(30) NOT NULL,
            Level      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id)
        );

        Sample Answer: '2,3,101,"INACTIVE WARNING",1,3,101,"INACTIVE WARNING",1'
    """

    def __init__(self, radio, log, status_insert):
        super(ECBITInserter, self).__init__(radio, insert_query_file='dbfiles/insert/ecbit.sql', log=log,
                                            acceptable_keys=['GRCS'])
        self.no_cbit = (0, 'CBIT LIST IS CLEAR', 0)
        self.cbit_stat = 0
        self.status_insert = status_insert

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"ECBITInserter: value={value}")
        if value == '0':
            self.cbit_stat = 0
            query_list = [self.insert.format(event_s_datetime, self.radio.name, *self.no_cbit)]
            # query_list.extend(self.status_insert.generate(event_timestamp, event_s_datetime, 'CBIT', self.cbit_stat))
            # self.log.debug(f"ECBITInserter: Query={q}")
            # return query_list
        else:
            cbit_lines = [line.split(',') for line in value.replace('"', '').split(',3,')[1:]]
            self.cbit_stat = max([int(level) for level in list(zip(*cbit_lines))[2]])
            query_list = [self.insert.format(event_s_datetime, self.radio.name, *line) for line in cbit_lines]

        query_list.extend(self.status_insert.generate(event_timestamp, event_s_datetime, 'CBIT', self.cbit_stat))

        # self.log.debug(f"ECBITInserter: Query={query}")
        return query_list


class ERadioInserter(InserterGenerator):
    """
        CREATE TABLE Event.ERadio
        (
            id         INT           NOT NULL IDENTITY PRIMARY KEY,
            Date       DATETIME      NOT NULL,
            Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            AIAD       TINYINT       NULL,
            AILA       TINYINT       NULL,
            AISL       SMALLINT      NULL,
            ERGN       TINYINT       NULL FOREIGN KEY REFERENCES Common.Operation (id),
            FFMD       TINYINT       NULL FOREIGN KEY REFERENCES Common.ModulationMode (id),
            FFSP       TINYINT       NULL FOREIGN KEY REFERENCES Common.ChannelSpacing (id),
            FFTR       INT           NULL,
            GRHN       VARCHAR(24)   NULL,
            GRME       DATETIME      NULL,
            GRNA       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
            GRTI       DATETIME      NULL,
            GRUI       VARCHAR(10)   NULL,
            GRUO       VARCHAR(10)   NULL,
            MSAC       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
            RCPP       TINYINT       NULL,
            SCPG       SMALLINT      NULL,
            SCSS       TINYINT       NULL FOREIGN KEY REFERENCES Common.SessionType (id),
            -- Only for RX
            FFSN       TINYINT       NULL,
            FFSQ       TINYINT       NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            FFSR       TINYINT       NULL,
            RCLR       TINYINT       NULL,
            RIRC       VARCHAR(30)   NULL,
            -- Only for TX
            RCLV       DECIMAL(3, 1) NULL,
            RCMG       TINYINT       NULL,
            -- Set Only Commands
            EVCL       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            GRAT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            MSGO       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            RCPF       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            RCPT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            RCRR       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id)
        );

    """

    def __init__(self, radio, log):
        acceptable_keys = ['AIAD', 'AILA', 'AISL', 'ERGN', 'EVCL', 'FFMD', 'FFSN', 'FFSP', 'FFSQ', 'FFSR', 'FFTR',
                           'GRAT', 'GRHN', 'GRME', 'GRNA', 'GRTI', 'GRUI', 'GRUO', 'MSAC', 'MSGO', 'RCLR', 'RCLV',
                           'RCMG', 'RCPF', 'RCPP', 'RCPT', 'RCRR', 'RIRC', 'SCPG', 'SCSS']
        super(ERadioInserter, self).__init__(radio, log=log,
                                             insert_query_file='dbfiles/insert/eradio.sql',
                                             acceptable_keys=acceptable_keys,
                                             special_key=['GRHN', 'GRME', 'GRTI', 'GRUO', 'RIRC', 'EVCL', 'GRAT',
                                                          'MSGO', 'RCPF', 'RCPT', 'RCRR'])
        '''
        EVCL: 0,Event List Cleared
        GRAT: 1,All Trap OFF
        MSGO: 2,Skip To GO
        RCPF: 3,TX Pressed
        RCPF: 4,TX Released
        RCPT: 5,TX + Mod Pressed
        RCPT: 6,TX + Mod Released
        RCRR: 7,Radio Restarted
        '''

    def generate_special(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key in ['GRHN', 'GRTI']:
            value = value.replace('"', '')
        elif key == 'GRME':
            value = str(datetime.fromtimestamp(int(value)))[:23]
        elif key == 'EVCL':
            value = 0
        elif key == 'GRAT':
            value = 1
        elif key == 'MSGO':
            value = 2
        elif key == 'RCPF':
            if value == 1:
                value = 3
            else:
                value = 4
        elif key == 'RCPT':
            if value == 1:
                value = 5
            else:
                value = 6
        elif key == 'RCRR':
            value = 7

        return [self.insert.format(key, event_s_datetime, self.radio.name, f"'{value}'")]


class EventListInserter(InserterGenerator):
    """
        CREATE TABLE Event.EventList
        (
            id          INT         NOT NULL IDENTITY PRIMARY KEY,
            Date        DATETIME    NOT NULL,
            Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            Event_No    SMALLINT    NOT NULL,
            Module      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
            EventDate   DATETIME    NOT NULL,
            Code        SMALLINT    NOT NULL,
            Event_Text  VARCHAR(30) NOT NULL,
            Event_Level TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
        );

    """

    def __init__(self, radio, log):
        super(EventListInserter, self).__init__(radio, log=log,
                                                insert_query_file='dbfiles/insert/eventlist.sql',
                                                acceptable_keys=['EVEE', 'EVEL'])

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'EVEL':
            return self.whole_event_list_query_generator(event_s_datetime, value)
        else:
            return self.simple_record_generator(event_s_datetime, value)

    def whole_event_list_query_generator(self, event_s_datetime, value):
        self.log.debug(f"{self.__class__.__name__}: Event List uploading")
        return [self.insert.format(event_s_datetime, self.radio.name, *simple_record.replace('"', '').split(',')[1:])
                for simple_record in value.split(',7,')[1:]] + \
            [f"Update Application.RadioStatus SET EventListCollect='{event_s_datetime}' WHERE "
             f"Radio_Name='{self.radio.name}'; "]

        # query = ''
        # for simple_record in value.split(',7,')[1:]:
        #     query += self.insert.format(event_s_datetime, self.radio.name,
        #                                 *simple_record.replace('"', '').split(',')[1:])
        # query += f"Update Application.RadioStatus SET EventListCollect='{event_s_datetime}' " \
        #          f"WHERE Radio_Name='{self.radio.name}'; "
        # self.log.debug(f"{self.__class__.__name__} : EventList: {query}")
        # if len(query) > 1000:
        #     query_list = [s + ';' for s in query.split(';')][:-1]
        #     return query_list
        # return query

    def simple_record_generator(self, event_s_datetime, value):
        return [self.insert.format(event_s_datetime, self.radio.name, *value.replace('"', '').split(',')[2:])]


class ReceptionTransmissionInserter(InserterGenerator):
    """
    This class is used to generate the necessary queries to fill the tables related to the transmission
     parameters of the TX and the reception parameters of the receiver.
    Also, in this class, the lifetime of TX transmission and RX reception is maintained by the age property.

        CREATE TABLE Event.Reception
        (
            id           INT IDENTITY PRIMARY KEY NOT NULL,
            Date         DATETIME                 NOT NULL DEFAULT GETDATE(),
            Radio_Name   CHAR(10)                 NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            FFRS         SMALLINT                 NULL,
            SQ           TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            SQ_ON        DECIMAL(13, 3)           NULL,
            SQ_OFF       DECIMAL(13, 3)           NULL,
            Battery_Volt DECIMAL(3, 1)            NULL,
            DC_Section   DECIMAL(3, 1)            NULL,
            RX_Temp      TINYINT                  NULL,
            PS_Temp      TINYINT                  NULL,
            PA_Temp      TINYINT                  NULL
        );

        create table Event.Transmission
        (
            id           INT IDENTITY PRIMARY KEY NOT NULL,
            Date         DATETIME                 NOT NULL DEFAULT GETDATE(),
            Radio_Name   CHAR(10)                 NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            RCTC         TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            PTT_ON       DECIMAL(13, 3)           null,
            PTT_OFF      DECIMAL(13, 3)           null,
            RCTO         TINYINT                  null,
            RCMO         TINYINT                  null,
            RCTV         DECIMAL(3, 1)            null,
            RCTW         TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            RCVV         DECIMAL(3, 1)            null,
            Battery_Volt DECIMAL(3, 1)            null,
            DC_Section   DECIMAL(3, 1)            null,
            TX_Temp      TINYINT                  null,
            PS_Temp      TINYINT                  NULL,
            PA_Temp      TINYINT                  NULL
        );

    """

    def __init__(self, radio, log):
        acceptable_keys = ['FFRS', 'RCMO', 'RCMV', 'RCRI', 'RCTC', 'RCTO', 'RCTP', 'RCTV', 'RCTW', 'RCVV']
        if radio.type == 'TX':
            super(ReceptionTransmissionInserter, self).__init__(radio, log=log,
                                                                insert_query_file='dbfiles/insert/transmission.sql',
                                                                special_key=['RCMV', 'RCTC', 'RCTP'],
                                                                acceptable_keys=acceptable_keys)
            self.indicator_group_fields = 'PTT, PTT_ON, PTT_OFF'
            self.indicator_name = 'RCTC'
            self.temp_fields = 'TX_Temp, PS_Temp, PA_Temp'
            self.indicator = 'PTT'
        else:
            super(ReceptionTransmissionInserter, self).__init__(radio, log=log,
                                                                insert_query_file='dbfiles/insert/reception.sql',
                                                                special_key=['FFRS', 'RCMV', 'RCRI', 'RCTP'],
                                                                acceptable_keys=acceptable_keys)
            self.indicator_group_fields = 'SQ, SQ_ON, SQ_OFF'
            self.indicator_name = 'RCRI'
            self.temp_fields = 'RX_Temp, PS_Temp, PA_Temp'
            self.indicator = 'SQ'

        self.fields_selection = {'RCMV': 'Battery_Volt, DC_Section', 'RCTP': self.temp_fields}
        self._age = 0
        self.prev_indicator_stat, self.prev_time = None, None

    def generate_special(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'FFRS':
            return [self.insert.format(key, event_s_datetime, self.radio.name, int(value) - 120)]
        elif key == self.indicator_name:
            return self.generate_indicator_statement(event_timestamp, event_s_datetime, value)
        else:
            return [self.insert.format(self.fields_selection.get(key), event_s_datetime, self.radio.name, value[2:])]

    def generate_indicator_statement(self, event_timestamp, event_s_datetime, indicator_stat):
        if self.prev_indicator_stat is None:
            self.prev_indicator_stat, self.prev_time = indicator_stat, event_timestamp
            return []

        if indicator_stat == self.prev_indicator_stat:
            self.log.warning(f"{self.__class__.__name__}: UnexpectedEvent: Previous {self.indicator} = New "
                             f"{self.indicator}, May a package loss be occurs!")
            return []
        else:
            if indicator_stat == '1':
                on_duration, off_duration = 'NULL', event_timestamp - self.prev_time
            else:
                on_duration, off_duration = event_timestamp - self.prev_time, 'NULL'

            self.prev_indicator_stat, self.prev_time = indicator_stat, event_timestamp
            return [self.insert.format(self.indicator_group_fields, event_s_datetime, self.radio.name,
                                       f'{indicator_stat}, {on_duration}, {off_duration}')]


class SessionInserter(InserterGenerator):
    """
        CREATE TABLE Event.Session
        (
            id         INT         NOT NULL IDENTITY PRIMARY KEY,
            Date       DATETIME    NOT NULL,
            Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            IP         VARCHAR(15) NOT NULL,
            Client     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Controller (id),
            Type       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.SessionType (id),
        );

        3,3,"::",3,0,3,"::192.168.1.100",0,2,3,"::192.168.1.100",0,0
    """

    def __init__(self, radio, log):
        super(SessionInserter, self).__init__(radio, log=log,
                                              insert_query_file='dbfiles/insert/session.sql',
                                              acceptable_keys=['SCSL'])
        self.session_threshold_warning = 3

    def set_warning_threshold(self, wt):
        self.session_threshold_warning = wt

    def generate(self, event_timestamp, event_s_datetime, key, value):
        sessions = int(value[0]) - 1
        if sessions >= self.session_threshold_warning:
            self.log.warning(f"{self.__class__.__name__}: Active Session={sessions}")
        else:
            self.log.info(f"{self.__class__.__name__}: Active Session={sessions}")

        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        sessions = [part.replace('::', '').replace('"', '').split(',') for part in value.split(',3,"')[2:]]
        # query = ''
        # for session in sessions:
        #     query += self.insert.format(event_s_datetime, self.radio.name, *session)
        # return query
        return [self.insert.format(event_s_datetime, self.radio.name, *session) for session in sessions]


class StatusInserter(InserterGenerator):
    """
    CREATE TABLE Event.Status
    (
        id         INT      NOT NULL IDENTITY PRIMARY KEY,
        Date       DATETIME NOT NULL DEFAULT GETDATE(),
        Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
        Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id),
        Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
        Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
        Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id),
        CBIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
    );

    """

    def __init__(self, radio, log):
        acceptable_keys = ['CBIT', 'Connection', 'GRDS']
        super().__init__(radio, 'dbfiles/insert/estatus.sql', special_key=['GRDS'], acceptable_keys=acceptable_keys,
                         log=log)

    def generate_special(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        return [self.insert.format('Activation, Operation, Access', event_s_datetime, self.radio.name, value[2:])]


class DurationUpdater:
    """
    This class is used to record the duration of the transmitter's transmission and the receiver's reception,
        the duration of connection and disconnection to the radio.
    Since this is the working information of each radio, this information is stored in the Common.Radio table.
    Only these parameters need update:
        IndicatorONSec      :   Shows the length of PTT or SQ active time of the radio in seconds
        IndicatorOFFSec     :   Shows the length of PTT or SQ inactive time of the radio in seconds
        ConnectTimeSec      :   Shows the length of Connected Time of the radio in seconds
        DisconnectTimeSec   :   Shows the length of DisConnected Time of the radio in seconds
        OperatingHour       :   Shows the length of Operating Time of the radio in Hours

    The first three parameters are calculated by the program, but the fourth parameter is asked from the radio
        by RCOC code.

    Table Definition:
        CREATE TABLE Common.Radio
        (
            id                INT            NOT NULL IDENTITY PRIMARY KEY,
            Radio_Name        CHAR(10)       NOT NULL UNIQUE,
            Station_Code      CHAR(3)        NOT NULL,
            Frequency_No      TINYINT        NOT NULL,
            Type              TINYINT        NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
            IP                VARCHAR(15)    NOT NULL,
            IndicatorONSec    DECIMAL(13, 3) NULL,
            IndicatorOFFSec   DECIMAL(13, 3) NULL,
            ConnectTimeSec    DECIMAL(13, 3) NULL,
            DisconnectTimeSec DECIMAL(13, 3) NULL,
            OperatingHour     INT            NULL
        );
    """

    def __init__(self, radio, log):
        self.acceptable_keys = ['RCOC']
        self.radio = radio
        self.update = get_statement('dbfiles/update/radio.sql')
        self.log = log

    def generate(self, *args):
        """args are: event_timestamp, event_s_datetime, key, value"""
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        return [self.update.format(*args[3], self.radio.name)]


class ModuleStatusUpdater:
    """
    The current state of the radio module is converted into an executable query in this class.
    Each part of the radio module is responsible for keeping its parameters updated in the status dictionary.
    And finally periodically this status is updated in the database.
    The status parameter list includes the following:
        RadioModuleName                 Radio Module Name is equal to Radio Name
        StartTime                       Indicate Start Time of Radio Module
        UpdateTime                      Indicate Last Update of record content
        PID
        ModuleAlive                     Indicate that is Radio Module is alive or not (boolean)
        ReceptionAlive
        KeepConnectionAlive
        GeneratorAlive
        ConnectorAlive
        AnalyzerAlive
        SettingUpdaterAlive
        RadioConnected
        DBConnected
        SettingUpdaterInProgress
        RadioDisconnectionCounter
        DBDisconnectionCounter
        ReceivedPacketCounter
        SentPacketCounter
        QueryGeneratedCounter
        QueryExecutedCounter
        PacketEvalErrorCounter
        PacketSendingErrorCounter
        QueryGenerationErrorCounter
        QueryExecutionErrorCounter
        QueryWaitingCounter
        SettingUpdateCounter

    """

    def __init__(self, log):
        self.acceptable_keys = ['ModuleStatus']
        self.update = get_statement('dbfiles/update/radio_module.sql')
        self.log = log

    def generate(self, *args):
        """args are: event_timestamp, event_s_datetime, key, value"""
        self.log.debug(f"{self.__class__.__name__}: Status Update generating")
        kv, value = f"{'UpdateTime'}='{args[1]}', ", args[3]
        for item in value:
            if item in ['id', 'RadioModuleName', 'StartTime', 'UpdateTime', 'PID']:
                continue
            kv += f"{item}={value[item]}, "

        return [self.update.format(kv[:-2].replace('None', 'NULL'), value['id'])]


class SRadioInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.insert = get_statement('dbfiles/insert/sradio.sql')
        self.db_setting = None
        self.setting = RadioSettings(self.radio.radio_code, self.insert)
        self.acceptable_keys = self.setting.keys
        self._type = 0
        self.wait_for_collection = False
        self.log = log

    def save_setting(self, db_setting: dict):
        # self.log.debug(f"{self.__class__.__name__}: Setting Received From Database")
        # print(db_setting)
        if db_setting is not None:
            self.db_setting = RadioSettings(self.radio.radio_code, self.insert)
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
        self._type = 1

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key=[{key}] value=[{value}]")
        self.setting.add_item(key, value)
        if self.wait_for_collection:
            if self.setting.is_complete:
                if self.setting != self.db_setting:
                    query = [self.setting.db_insert(event_s_datetime, self.radio.name)]
                    self.db_setting = self.setting
                    self.setting = RadioSettings(self.radio.radio_code, self.insert)
                    self.log.info(f"{self.__class__.__name__}: Settings Updated")
                    # self.log.debug(f"{self.__class__.__name__}: Setting collection finished")
                    return query
                else:
                    self.log.debug(f"{self.__class__.__name__}: Settings Checked")
                    # self.log.debug(f"{self.__class__.__name__}: Collected Setting is same as database setting")
                    self.wait_for_collection = False
                    self._type = 0
                    self.setting.clear()
                    return []
            else:
                return []
        else:
            self.log.debug(f"{self.__class__.__name__}: Singular Setting updated.")
            return [self.setting.single_db_insert(event_s_datetime, self.radio.name, key)]


class InventoryInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.acceptable_keys = ['GRND']
        self.insert = get_statement('dbfiles/insert/inventory.sql')
        p = self.insert.index('VALUES') + 7
        self.statement, self.values = self.insert[:p], self.insert[p:-1]
        self.db_inventory = None
        self.inventory = Inventory(self.statement)
        self.log = log

    def save_inventory(self, db_inventory):
        self.log.debug(f"{self.__class__.__name__}: Inventory received from database")
        if db_inventory is not None:
            if len(db_inventory) != 10:
                self.log.debug(f"{self.__class__.__name__}: Error in Inventory Read from database!")
                return
            self.db_inventory = Inventory(self.statement)
            for item in db_inventory:
                self.db_inventory.add_item(InventoryItem(db_answer=item[3:]))
            self.log.debug(f"{self.__class__.__name__}: Inventory saved")

    def clear(self):
        self.inventory.clear()
        self.log.debug(f"{self.__class__.__name__}: Inventory cleared")

    def generate(self, event_timestamp, event_s_datetime, key, value):
        self.inventory.add_item(InventoryItem(radio_answer=value))
        self.log.debug(f"{self.__class__.__name__}: Adding Next item: {value}")
        if self.inventory.is_complete:
            # self.log.debug(f"{self.__class__.__name__}: {len(self.inventory.collection)} Items Collected")
            # self.log.debug(f"{self.__class__.__name__}: db_inventory and new inventory are same is {self.inventory
            # == self.db_inventory} ")
            if self.inventory != self.db_inventory:
                query_list = [self.inventory.db_insert(event_s_datetime, self.radio.name)]
                self.db_inventory = self.inventory
                self.inventory = Inventory(self.statement)
                self.log.debug(f"{self.__class__.__name__}: Query Generated")
                # self.log.debug(f"{self.__class__.__name__}: Generation Result: {query_list}")
                return query_list
            else:
                # self.log.debug(f"{self.__class__.__name__}: No Query Generated")
                return []
        else:
            # self.log.debug(f"{self.__class__.__name__}: No Query Generated")
            return []


class SCBITInserter(InserterGenerator):
    """
    The radio answer contains two categories of CBIT parameters: Configurable parameters and Non-Configurable
     parameters.
    The parameter name is a string surrounded by " characters. you can remove it by this code:
    # >>> #'57,5,1,0,"RESTART",0,0,5,2,0,"TIME CHANGED",0,0,5,3,0,"EVENT LIST FULL",0,0,5,101,1,'
    # >>> answer = answer.replace('"', '')

    If you separate the answer with ',' character, the first element of the split answer is a number that represents
     the number of CBIT codes.
    # >>> n = answer.index(',')
    # >>> length, codes_lines = int(answer[:n]), answer[(n + 1):]
    # >>> #print(length) -> 57

    After splitting answer with comma splitter, each split group that contain 6 member is the information related
     to a CBIT code. Of course, the initial member, which is always number 5, is used as a starting sign and there
     is no need to store it.
    # >>> joined_rows = codes_lines.split(',')
    # >>> rows = [joined_rows[6 * l:6 * (l + 1)] for l in range(length)]
    # >>> #['5', '1', '0', 'RESTART', '0', '0']
    # >>> #['5', '2', '0', 'TIME CHANGED', '0', '0']
    # >>> #['5', '3', '0', 'EVENT LIST FULL', '0', '0']
    # >>> #['5', '101', '1', 'INACTIVE WARNING', '2', '3']

    And we can remove redundant 5 by this line:
    # >>> rows = [joined_rows[6 * l + 1:6 * (l + 1)] for l in range(length)]
    # >>> ['1', '0', 'RESTART', '0', '0']
    # >>> ['2', '0', 'TIME CHANGED', '0', '0']
    # >>> ['3', '0', 'EVENT LIST FULL', '0', '0']
    # >>> ['101', '1', 'INACTIVE WARNING', '2', '3']

    Ok. That's it!
    Let's begin to describe each of these 5 sections in each row!
    Section 1 is CBIT Code!
    Section 2 represents the level of the event. The value 0 means that this code is announced as an information.
     A value of 1 means a warning, and level 2 indicates an error.
    Section 3 describe name of that CBIT Code.
    Section 4 describes whether this code is configurable or not, and if it is configurable, what value is currently
     set to it.
                0	Can not Config
                1	Disable
                2	Warning
                4	NoGo Error
    Section 5, which only makes sense for parameters that are configurable, and determines what values this
     parameter can have:
                3   'Disabled|Warning',
                5   'Disabled|NoGo',
                6   'Warning|NoGo',
                7   'Disabled|Warning|NoGo'

    """

    def __init__(self, radio, log):
        acceptable_keys = ['GRNC']
        super(SCBITInserter, self).__init__(radio, log=log,
                                            insert_query_file='dbfiles/insert/scbit.sql',
                                            acceptable_keys=acceptable_keys)
        self.cbit_list_insert = get_statement('dbfiles/insert/cbitlist.sql')
        self.db_cbit_codes = []
        self.cbit_settings = CBITSettings(log)

    def save_cbit_codes(self, cbit_codes: list):
        self.db_cbit_codes = cbit_codes
        self.db_cbit_codes.sort()
        # self.log.debug(f"{self.__class__.__name__}: CBIT codes saved")

    def save_cbit_settings(self, cbit_settings: list):
        self.cbit_settings.add_db_config(cbit_settings)

    def extract(self, nd):
        nd = nd.replace('"', '')
        ci = nd.index(',')
        length, ds = int(nd[:ci]), nd[(ci + 1):]

        ds_rows = ds.split(',')
        cbit_list = {}

        for pos in range(length):
            code = int(ds_rows[6 * pos + 1])
            if code not in self.db_cbit_codes:
                cbit_list[code] = ds_rows[6 * pos + 1: 6 * pos + 6]

            self.db_cbit_codes.extend(cbit_list)
            self.db_cbit_codes.sort()
            if ds_rows[6 * pos + 4] != '0':
                self.cbit_settings.add_radio_config(ds_rows[6 * pos + 1], ds_rows[6 * pos + 4])
                # cbit_setting.append([ds_rows[6 * l + 1], ds_rows[6 * l + 4]])
        cbit_setting = self.cbit_settings.get_difference()
        self.cbit_settings.clear_difference()

        return cbit_list, cbit_setting

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: valeu={value}")
        cbit_list, cbit_setting = self.extract(value)
        # query = ''.join([self.insert.format(event_s_datetime, self.radio.name, *r) for r in cbit_setting])

        # for code in cbit_list:
        #     query += self.cbit_list_insert.format(*cbit_list[code])

        return [self.insert.format(event_s_datetime, self.radio.name, *r) for r in cbit_setting] + \
            [self.cbit_list_insert.format(*cbit_list[code]) for code in cbit_list]

        #
        # if len(query) > 1000:
        #     query_list = [s + ';' for s in query.split(';')][:-1]
        #     return query_list
        #
        # return query


class IPInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.insert = get_statement('dbfiles/insert/sip.sql')
        self.acceptable_keys = ['GRII', 'GRIP']
        self.ip_type = {'GRIP': 0, 'GRII': 1}
        self.first, self.second = None, None
        self.log = log

    def save_ip(self, first, second):
        if first is not None:
            self.first = IP(db_answer=first)
        if second is not None:
            self.second = IP(db_answer=second)
        # self.log.debug(f"{self.__class__.__name__}: IPs Saved")

    def is_different(self, ip: IP, t):
        if t == 0:
            return ip != self.first
        else:
            return ip != self.second

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        t = self.ip_type.get(key)
        ip = IP(radio_answer=value)
        if self.is_different(ip, t):
            if t == 0:
                self.first = ip
            else:
                self.second = ip
            return [self.insert.format(event_s_datetime, self.radio.name, t, ip.ip, ip.subnet, ip.gateway)]
        else:
            return []


class AccessInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.insert = get_statement('dbfiles/insert/saccess.sql')
        self.acceptable_keys = ['GRAC']
        self.db_access = None
        p = self.insert.index('VALUES') + 7
        self.statement, self.values = self.insert[:p], self.insert[p:-1]
        self.log = log

    def save_access(self, db_access):
        # self.log.debug(f"{self.__class__.__name__}: Access list received")
        if db_access is not None:
            self.db_access = Access(db_answer=db_access)

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        access = Access(radio_answer=value)
        if access != self.db_access:
            vs = ''
            for i in access.access:
                if access.access[i] != '':
                    vs += self.values.format(event_s_datetime, self.radio.name, i, access.access[i]) + ', '
            if vs != '':
                return [self.statement + vs[:-2] + ';']
            else:
                return []
        else:
            return []


class SoftwareInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.insert = get_statement('dbfiles/insert/ssoftware.sql')
        self.acceptable_keys = ['GRSV']
        self.db_software = None
        self.log = log

    def save_software(self, db_software):
        # self.log.debug(f"{self.__class__.__name__}: Software version received")
        if db_software is not None:
            self.db_software = Software(db_answer=db_software)

    def generate(self, event_timestamp, event_s_datetime, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        software = Software(radio_answer=value)
        if software != self.db_software:
            self.db_software = software
            return [self.insert.format(event_s_datetime, self.radio.name, software.db_insert(1),
                                       event_s_datetime, self.radio.name, software.db_insert(2))]
        else:
            return []


class QueryGenerator(Thread):
    def __init__(self, memory, radio, connector, logs, status):
        super(QueryGenerator, self).__init__(name='Query_Generator')
        self.memory = memory
        self.radio = radio
        self.connector = connector
        self.buffer = [[], []]
        self.writer = 0
        self.log = logs['Generator']

        self._sleep_time = 1.0
        self._alive_counter = self._err_counter = self._query_counter = 0

        self.reception_transmission_insert = ReceptionTransmissionInserter(self.radio, self.log)
        self.event_radio_insert = ERadioInserter(self.radio, self.log)
        self.status_insert = StatusInserter(self.radio, self.log)
        self.ecbit_insert = ECBITInserter(self.radio, self.log, self.status_insert)
        self.event_list_insert = EventListInserter(self.radio, self.log)
        self.session_insert = SessionInserter(self.radio, self.log)
        self.duration_updater = DurationUpdater(self.radio, self.log)
        self.module_status_updater = ModuleStatusUpdater(self.log)
        self.sradio_insert = SRadioInserter(self.radio, self.log)
        self.inventory_insert = InventoryInserter(self.radio, self.log)
        self.scbit_insert = SCBITInserter(self.radio, self.log)
        self.ip_insert = IPInserter(self.radio, self.log)
        self.access_insert = AccessInserter(self.radio, self.log)
        self.software_insert = SoftwareInserter(self.radio, self.log)

        self.parts = [self.reception_transmission_insert, self.event_radio_insert, self.status_insert,
                      self.ecbit_insert, self.event_list_insert, self.session_insert, self.duration_updater,
                      self.module_status_updater, self.sradio_insert, self.inventory_insert, self.scbit_insert,
                      self.ip_insert, self.access_insert, self.software_insert]

    @property
    def timing(self):
        return self._sleep_time

    @timing.setter
    def timing(self, t):
        self.log.info("Timing Updated")
        self._sleep_time = t

    @property
    def alive_add(self):
        return self._alive_counter

    @alive_add.setter
    def alive_add(self, value=1):
        self._alive_counter += value
        if self._alive_counter > 65535:
            self._alive_counter -= 65535

    @property
    def err_add(self):
        return self._err_counter

    @err_add.setter
    def err_add(self, value=1):
        self._err_counter += value
        if self._err_counter > 65535:
            self._err_counter -= 65535

    @property
    def query_add(self):
        return self._query_counter

    @query_add.setter
    def query_add(self, value=1):
        self._query_counter += value
        if self._query_counter > 65535:
            self._query_counter -= 65535

    def run(self) -> None:
        self.log.info('Started')
        while self.memory.keep_connection:
            # self.log.debug(f"keep_connection = {self.memory.keep_connection}, sleep_time={self.timing}")
            reader = 1 - self.writer
            # self.log.debug(f"Reading {len(self.buffer[reader])} new data.")

            try:
                self.generate(self.buffer[reader])
            except Exception as e:
                self.err_add = 1
                self.log.exception(f'Error on Query Generation! {e}')

            # self.log.debug(f"Buffer {reader}: length = {len(self.buffer[reader])}")

            if not self.memory.keep_connection:
                # self.log.debug(f"Reading {len(self.buffer[self.writer])} new data from latest buffer.")
                sleep(self._sleep_time / 2)
                self.generate(self.buffer[self.writer])

            self.alive_add = 1
            sleep(self._sleep_time)
            self.writer = reader
            # self.log.debug(f"Read Buffer switched to {reader}")

        self.log.info('Finished')

    def add(self, event_timestamp, event_s_datetime, key, value):
        # if 'GRND' in key or 'GRIL' in key:
        #     self.log.debug(f'Saving {key} data: {value}')
        try:
            self.buffer[self.writer].append((event_timestamp, event_s_datetime, key, value))
        except Exception as e:
            self.err_add = 1
            self.log.exception(f'Error on adding key-value! {e}')

    def generate(self, buffer: list):
        while buffer:
            event_timestamp, event_s_datetime, key, value = buffer.pop(0)
            query_list = []

            for part in self.parts:
                if key in part.acceptable_keys:
                    try:
                        query_list.extend(part.generate(event_timestamp, event_s_datetime, key, value))
                    except Exception as e:
                        self.err_add = 1
                        self.log.exception(f'Error on Generate Queries or extending query list! {e}')
                    finally:
                        break

            # self.log.debug(f"Sending {len(sql)} to Connector")
            self.query_add = len(query_list)
            for statement in query_list:
                if statement:
                    self.connector.add(statement)

            self.alive_add = 1
