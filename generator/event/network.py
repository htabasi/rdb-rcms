import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class ENetworkInserter(InserterGenerator):
    """
        CREATE TABLE Event.Network
            (
                id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
                Date       DATETIME NOT NULL DEFAULT GETDATE(),
                Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
                GRHN       VARCHAR(24)   NULL,
                GRNA       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
                GRTI       DATETIME      NULL,
                SCPG       SMALLINT      NULL,
                SCSS       TINYINT       NULL FOREIGN KEY REFERENCES Common.SessionType (id)
            )

    """

    def __init__(self, radio, log):
        acceptable_keys = ['GRHN', 'GRNA', 'SCPG', 'SCSS']
        path = os.path.join(SQL_INSERT_EVENT, 'network.sql')
        super(ENetworkInserter, self).__init__(radio, log=log, insert_query_file=path,
                                               acceptable_keys=acceptable_keys, special_key=['GRHN'])

    def generate_special(self, time_tag, key, value):
        value = value.replace('"', '')
        return [self.insert.format(key, str(time_tag)[:23], self.radio.name, f"'{value}'")]
