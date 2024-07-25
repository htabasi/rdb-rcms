import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class ERXOperationInserter(InserterGenerator):
    """
        CREATE TABLE Event.RXOperation
        (
            id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            FFSN       TINYINT       NULL,
            FFSQ       TINYINT       NULL FOREIGN KEY REFERENCES Common.OnOff (id),
            FFSR       TINYINT       NULL,
            RIRC       VARCHAR(30)   NULL,
        )

    """

    def __init__(self, radio, log):
        acceptable_keys = ['FFSN', 'FFSQ', 'FFSR', 'RIRC']
        path = os.path.join(SQL_INSERT_EVENT, 'rx_operation.sql')
        super(ERXOperationInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                   acceptable_keys=acceptable_keys, special_key=['RIRC'])

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        return [self.insert.format(key, str(time_tag)[:23], self.radio.name, f"'{value}'")]
