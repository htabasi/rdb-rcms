import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class ETXOperationInserter(InserterGenerator):
    """
        CREATE TABLE Event.TXOperation
        (
            id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            RCMG       TINYINT       NULL
        )

    """

    def __init__(self, radio, log):
        acceptable_keys = ['RCMG']
        path = os.path.join(SQL_INSERT_EVENT, 'tx_operation.sql')
        super(ETXOperationInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                   acceptable_keys=acceptable_keys)
