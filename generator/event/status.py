import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class EStatusInserter(InserterGenerator):
    """
    CREATE TABLE Event.EStatus
    (
        id         INT      NOT NULL IDENTITY PRIMARY KEY,
        Date       DATETIME NOT NULL DEFAULT GETDATE(),
        Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
        Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
        Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
        Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id)
    )
    """
    def __init__(self, radio, log):
        acceptable_keys = ['GRDS']
        path = os.path.join(SQL_INSERT_EVENT, 'status.sql')
        super().__init__(radio, path, special_key=['GRDS'], acceptable_keys=acceptable_keys, log=log)

    def generate_special(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        return [self.insert.format('Activation, Operation, Access', str(time_tag)[:23], self.radio.name, value[2:])]
