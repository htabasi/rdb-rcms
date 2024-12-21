from generator.inserter import InserterGenerator


class VVoltageInserter(InserterGenerator):
    """
        CREATE TABLE Variation.Voltage
        (
            id           INT IDENTITY PRIMARY KEY CLUSTERED,
            Date         DATETIME      NOT NULL DEFAULT GETDATE(),
            Radio_Name   CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            Battery_Volt DECIMAL(3, 1) NULL,
            DC_Section   DECIMAL(3, 1) NULL,
        );
    """

    def __init__(self, radio, log):
        acceptable_keys = ['RCMV']
        super(VVoltageInserter, self).__init__(radio, log=log, query_code='IVVoltage',
                                               special_key=['RCMV'], acceptable_keys=acceptable_keys)

    def generate(self, time_tag, key, value) -> list:
        return [self.insert.format(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name, value[2:])]
