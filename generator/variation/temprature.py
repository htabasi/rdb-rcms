from generator.inserter import InserterGenerator


class VTemperatureInserter(InserterGenerator):
    """
        CREATE TABLE Variation.Temperature
        (
            id         INT IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            RM_Temp    TINYINT  NULL,
            PS_Temp    TINYINT  NULL,
            PA_Temp    TINYINT  NULL
        );
    """

    def __init__(self, radio, log):
        acceptable_keys = ['RCTP']
        super(VTemperatureInserter, self).__init__(radio, log=log, query_code='IVTemperature',
                                                   special_key=['RCTP'], acceptable_keys=acceptable_keys)

    def generate(self, time_tag, key, value) -> list:
        return [self.insert.format(str(time_tag)[:23], self.radio.name, value[2:])]
