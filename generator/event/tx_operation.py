from generator.inserter import InserterGenerator


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
        super(ETXOperationInserter, self).__init__(radio, log=log, query_code='IETXOperation', acceptable_keys=['RCMG'])
