import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_VARIATION


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
        path = os.path.join(SQL_INSERT_VARIATION, 'temperature.sql')
        super(VTemperatureInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                   special_key=['RCTP'], acceptable_keys=acceptable_keys)

    def generate(self, time_tag, key, value) -> list:
        return [self.insert.format(str(time_tag)[:23], self.radio.name, value[2:])]
