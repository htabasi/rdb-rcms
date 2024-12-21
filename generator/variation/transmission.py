from generator.inserter import InserterGenerator


class VTransmissionInserter(InserterGenerator):
    """
        CREATE TABLE Variation.Transmission
        (
            id         INT IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME       NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            PTT        TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            PTT_AGE    DECIMAL(13, 3) null,
            PTT_ON     DECIMAL(13, 3) null,
            PTT_OFF    DECIMAL(13, 3) null,
            RCTO       TINYINT        null,
            RCMO       TINYINT        null,
            RCTV       DECIMAL(3, 1)  null,
            RCTW       TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            RCVV       DECIMAL(3, 1)  null
        );
    """

    def __init__(self, radio, log):
        acceptable_keys = ['RCMO', 'RCTC', 'RCTO', 'RCTV', 'RCTW', 'RCVV']
        super(VTransmissionInserter, self).__init__(radio, log=log, query_code='IVTransmission',
                                                    special_key=['RCTC', 'RCTW'], acceptable_keys=acceptable_keys)
        self.cum_ptt = self.cum_swr = 0
        self.prev_ptt_stat, self.prev_ptt_time = None, None
        self.prev_swr_stat, self.prev_swr_time = None, None

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'RCTC':
            return self.generate_indicator_statement(time_tag, value)
        else:
            return self.generate_swr_statement(time_tag, value)

    def generate_indicator_statement(self, time_tag, ptt_stat):
        ts = time_tag.timestamp()
        if self.prev_ptt_stat is None:
            self.prev_ptt_stat, self.prev_ptt_time = ptt_stat, ts
            return []

        if ptt_stat == self.prev_ptt_stat:
            self.log.warning(f"{self.__class__.__name__}: UnexpectedEvent: Previous PTT = New PTT: "
                             f"Current_PTT={ptt_stat}, Prev_PTT={self.prev_ptt_stat}, May a package loss be occurs!")
            return []
        else:
            if ptt_stat == '1':
                on_duration, off_duration = 'NULL', ts - self.prev_ptt_time
            else:
                on_duration, off_duration = ts - self.prev_ptt_time, 'NULL'
                self.cum_ptt += on_duration

            self.prev_ptt_stat, self.prev_ptt_time = ptt_stat, ts
            return [self.insert.format('PTT, PTT_ON, PTT_OFF, CUM_PTT', time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3],
                                       self.radio.name, f'{ptt_stat}, {on_duration}, {off_duration}, {self.cum_ptt}')]

    def generate_swr_statement(self, time_tag, swr_stat):
        ts = time_tag.timestamp()
        if self.prev_swr_stat is None:
            self.prev_swr_stat, self.prev_ptt_time = swr_stat, ts
            return []

        if swr_stat == self.prev_swr_stat:
            self.log.warning(f"{self.__class__.__name__}: UnexpectedEvent: Previous SWR = New SWR: "
                             f"Current_SWR={swr_stat}, Prev_SWR={self.prev_swr_stat}, May a package loss be occurs!")
            return []
        else:
            if swr_stat == '0':
                self.cum_swr += ts - self.prev_swr_time

            self.prev_swr_stat, self.prev_swr_time = swr_stat, ts
            return [self.insert.format('RCTW, CUM_SWR', time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name,
                                       f'{swr_stat}, {self.cum_swr}')]
