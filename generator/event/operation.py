import os

from generator import get_file
from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT, SQL_UPDATE


class EOperationInserter(InserterGenerator):
    """
        CREATE TABLE Event.Operation
        (
            id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            ERGN       TINYINT       NULL FOREIGN KEY REFERENCES Common.Operation (id),
            FFMD       TINYINT       NULL FOREIGN KEY REFERENCES Common.ModulationMode (id),
            FFSP       TINYINT       NULL FOREIGN KEY REFERENCES Common.ChannelSpacing (id),
            FFTR       INT           NULL,
            MSAC       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
            RCPP       TINYINT       NULL
        )

    """

    def __init__(self, radio, log):
        acceptable_keys = ['ERGN', 'FFMD', 'FFSP', 'FFTR', 'MSAC', 'RCPP']
        path = os.path.join(SQL_INSERT_EVENT, 'operation.sql')
        super(EOperationInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                 acceptable_keys=acceptable_keys, special_key=['FFTR'])
        self.update_frequency = get_file(os.path.join(SQL_UPDATE, 'update_frequency.sql'))

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        return ([self.insert.format(key, str(time_tag)[:23], self.radio.name, value)] +
                [self.update_frequency.format(int(value) / 1000000, self.radio.name)])
