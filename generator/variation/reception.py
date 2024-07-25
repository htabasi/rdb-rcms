import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_VARIATION


class VReceptionInserter(InserterGenerator):
    """
        CREATE TABLE Variation.Reception
        (
            id         INT IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME       NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            FFRS       SMALLINT       NULL,
            SQ         TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            SQ_ON      DECIMAL(13, 3) NULL,
            SQ_OFF     DECIMAL(13, 3) NULL
        );
    """

    def __init__(self, radio, log):
        acceptable_keys = ['FFRS', 'RCRI']
        path = os.path.join(SQL_INSERT_VARIATION, 'reception.sql')
        super(VReceptionInserter, self).__init__(radio, log=log,
                                         insert_query_file=path,
                                         special_key=['FFRS', 'RCMV', 'RCRI', 'RCTP'],
                                         acceptable_keys=acceptable_keys)
        self.prev_sq_stat, self.prev_time = None, None
        self.cum_sq = 0

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'FFRS':
            return [self.insert.format(key, str(time_tag)[:23], self.radio.name, int(value) - 120)]
        else:
            return self.generate_indicator_statement(time_tag, value)

    def generate_indicator_statement(self, time_tag, sq_stat):
        ts = time_tag.timestamp()
        if self.prev_sq_stat is None:
            self.prev_sq_stat, self.prev_time = sq_stat, ts
            return []

        if sq_stat == self.prev_sq_stat:
            self.log.warning(f"{self.__class__.__name__}: UnexpectedEvent: Previous SQ = New SQ: "
                             f"Current_SQ={sq_stat}, Prev_SQ={self.prev_sq_stat}, May a package loss be occurs!")
            return []
        else:
            if sq_stat == '1':
                on_duration, off_duration = 'NULL', ts - self.prev_time
            else:
                on_duration, off_duration = ts - self.prev_time, 'NULL'
                self.cum_sq += on_duration

            self.prev_sq_stat, self.prev_time = sq_stat, ts
            return [self.insert.format('SQ, SQ_ON, SQ_OFF, CUM_SQ', str(time_tag)[:23], self.radio.name,
                                       f'{sq_stat}, {on_duration}, {off_duration}, {self.cum_sq}')]
