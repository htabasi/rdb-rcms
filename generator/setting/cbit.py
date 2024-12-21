from generator.inserter import InserterGenerator


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
        try:
            self.setting = {code: config for code, config in db_setting}
        except TypeError:
            pass

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


class SCBITInserter(InserterGenerator):
    """
    The radio answer contains two categories of CBIT parameters: Configurable parameters and Non-Configurable
     parameters.
    The parameter name is a string surrounded by '"' characters. you can remove it by this code:
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
        super(SCBITInserter, self).__init__(radio, log=log, query_code='ISSCBIT', acceptable_keys=acceptable_keys)
        self.cbit_list_insert = self.queries.get('ICCBITList')
        self.db_cbit_codes = []
        self.cbit_settings = CBITSettings(log)

    def save_cbit_codes(self, cbit_codes: list):
        self.db_cbit_codes = cbit_codes.copy()
        self.db_cbit_codes.sort()
        # self.log.debug(f"{self.__class__.__name__}: CBIT codes saved")

    def save_cbit_settings(self, cbit_settings: list):
        if cbit_settings is not None:
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

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: valeu={value}")
        cbit_list, cbit_setting = self.extract(value)
        # query = ''.join([self.insert.format(event_s_datetime, self.radio.name, *r) for r in cbit_setting])

        # for code in cbit_list:
        #     query += self.cbit_list_insert.format(*cbit_list[code])

        return [self.insert.format(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name,
                                   *r) for r in cbit_setting] + \
            [self.cbit_list_insert.format(*cbit_list[code]) for code in cbit_list]
