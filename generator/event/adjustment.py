import os
from datetime import datetime

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class EAdjustmentInserter(InserterGenerator):
    """
        CREATE TABLE Event.Adjustment
            (
                id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
                Date       DATETIME NOT NULL DEFAULT GETDATE(),
                Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
                AIAD       TINYINT       NULL,
                AILA       SMALLINT      NULL,
                AISL       SMALLINT      NULL,
                GRME       DATETIME      NULL,
                GRUI       VARCHAR(10)   NULL,
                GRUO       VARCHAR(10)   NULL
            )
        GO
    """

    def __init__(self, radio, log):
        acceptable_keys = ['AIAD', 'AILA', 'AISL', 'GRME', 'GRUI', 'GRUO']
        path = os.path.join(SQL_INSERT_EVENT, 'adjustment.sql')
        super(EAdjustmentInserter, self).__init__(radio, log=log,
                                                  insert_query_file=path,
                                                  acceptable_keys=acceptable_keys,
                                                  special_key=['GRME', 'GRUO'])

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'GRME':
            value = str(datetime.fromtimestamp(int(value)))[:23]

        return [self.insert.format(key, str(time_tag)[:23], self.radio.name, f"'{value}'")]
