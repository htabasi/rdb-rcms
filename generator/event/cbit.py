import os

from base.aggregator import Aggregator
from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


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

    def __init__(self, radio, log):
        path = os.path.join(SQL_INSERT_EVENT, 'cbit.sql')
        super(ECBITInserter, self).__init__(radio, insert_query_file=path, log=log,
                                            acceptable_keys=['GRCS'])
        self.no_cbit = (0, 'CBIT LIST IS CLEAR', 0)
        self.cbit_stat = 0
        self.warning_count = Aggregator('CntCBITWarning')
        self.error_count = Aggregator('CntCBITError')
        # self.warning_count, self.error_count = 0, 0
        # self.warning_count_resettable, self.error_count_resettable = 0, 0

    def set_counters(self, aggregate, resettable):
        self.warning_count.set(aggregate, resettable)
        self.error_count.set(aggregate, resettable)

    def generate(self, time_tag, key, value):
        # self.log.debug(f"ECBITInserter: value={value}")
        if value == '0':
            self.cbit_stat = 0
            query_list = [self.insert.format(str(time_tag)[:23], self.radio.name, *self.no_cbit)]
            # query_list.extend(self.status_insert.generate(event_timestamp, event_s_datetime, 'CBIT', self.cbit_stat))
            # self.log.debug(f"ECBITInserter: Query={q}")
            # return query_list
        else:
            cbit_lines = [line.split(',') for line in value.replace('"', '').split(',3,')[1:]]
            levels = [int(level) for level in list(zip(*cbit_lines))[2]]
            self.warning_count.add(levels.count(1))
            self.error_count.add(levels.count(2))
            # self.warning_count += wc
            # self.warning_count_resettable += wc
            # self.error_count += ec
            # self.error_count_resettable += ec
            self.cbit_stat = max(levels)
            query_list = [self.insert.format(str(time_tag)[:23], self.radio.name, *line) for line in cbit_lines]

        # self.log.debug(f"ECBITInserter: Query={query}")
        return query_list
