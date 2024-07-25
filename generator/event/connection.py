import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class EConnectionInserter(InserterGenerator):
    """
    CREATE TABLE Event.EConnection
    (
        id         INT      NOT NULL IDENTITY PRIMARY KEY,
        Date       DATETIME NOT NULL DEFAULT GETDATE(),
        Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
        Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id),
    );

    """

    def __init__(self, radio, log):
        acceptable_keys = ['Connection']
        path = os.path.join(SQL_INSERT_EVENT, 'connection.sql')
        super().__init__(radio, path, acceptable_keys=acceptable_keys, log=log)
