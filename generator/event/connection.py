from generator.inserter import InserterGenerator


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
        super().__init__(radio, query_code='IEEConnection', acceptable_keys=['Connection'], log=log)
