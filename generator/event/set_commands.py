import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class ESetCommandInserter(InserterGenerator):
    """
        CREATE TABLE Event.SetCommands
        (
            id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Date       DATETIME NOT NULL DEFAULT GETDATE(),
            Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            CKey       CHAR(4)  NOT NULL FOREIGN KEY REFERENCES Command.KeyInformation (CKey),
            UserID     BIGINT   NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
            Action     TINYINT NOT NULL FOREIGN KEY REFERENCES Common.SetCode (id),
            Comment    VARCHAR(50) NULL
        );

    """

    def __init__(self, radio, log):
        acceptable_keys = ['EVCL', 'GRAT', 'MSGO', 'RCPF', 'RCPT', 'RCRR']
        path = os.path.join(SQL_INSERT_EVENT, 'set_command.sql')
        super(ESetCommandInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                  acceptable_keys=acceptable_keys)
        '''
        EVCL: 0,Event List Cleared
        GRAT: 1,All Trap OFF
        MSGO: 2,Skip To GO
        RCPF: 3,TX Pressed
        RCPF: 4,TX Released
        RCPT: 5,TX + Mod Pressed
        RCPT: 6,TX + Mod Released
        RCRR: 7,Radio Restarted
        '''

    def generate(self, time_tag, key, value) -> list:
        # Date, Radio_Name, CKey, UserID, Action, Comment
        uid, action, comment = value
        return [self.insert.format(str(time_tag)[:23], self.radio.name, key, uid, action, comment)]
    #
    # def generate_special(self, time_tag, key, value):
    #     # self.log.debug(f"{self.__class__.__name__}: key={key}")
    #     if key == 'FFTR':
    #         return ([self.insert.format(key, str(time_tag)[:23], self.radio.name, value)] +
    #                 [self.update_frequency.format(int(value) / 1000000, self.radio.name)])
    #     elif key in ['GRHN', 'GRTI']:
    #         value = value.replace('"', '')
    #     elif key == 'GRME':
    #         value = str(datetime.fromtimestamp(int(value)))[:23]
    #     elif key == 'EVCL':
    #         value = 0
    #     elif key == 'GRAT':
    #         value = 1
    #     elif key == 'MSGO':
    #         value = 2
    #     elif key == 'RCPF':
    #         if value == 1:
    #             value = 3
    #         else:
    #             value = 4
    #     elif key == 'RCPT':
    #         if value == 1:
    #             value = 5
    #         else:
    #             value = 6
    #     elif key == 'RCRR':
    #         value = 7
    #
    #     return [self.insert.format(key, str(time_tag)[:23], self.radio.name, f"'{value}'")]
