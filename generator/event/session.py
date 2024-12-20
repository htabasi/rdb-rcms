from generator.inserter import InserterGenerator


class ESessionInserter(InserterGenerator):
    """
        CREATE TABLE Event.Session
        (
            id         INT         NOT NULL IDENTITY PRIMARY KEY,
            Date       DATETIME    NOT NULL,
            Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            IP         VARCHAR(15) NOT NULL,
            Client     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Controller (id),
            Type       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.SessionType (id),
        );

        3,3,"::",3,0,3,"::192.168.1.100",0,2,3,"::192.168.1.100",0,0
    """

    def __init__(self, radio, log):
        super(ESessionInserter, self).__init__(radio, log=log, query_code='IESession', acceptable_keys=['SCSL'])
        self.session_threshold_warning = 3

    def set_warning_threshold(self, wt):
        self.session_threshold_warning = wt

    def generate(self, time_tag, key, value):
        sessions = int(value[0]) - 1
        if sessions >= self.session_threshold_warning:
            self.log.warning(f"{self.__class__.__name__}: Active Session={sessions}")
        else:
            self.log.info(f"{self.__class__.__name__}: Active Session={sessions}")

        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        sessions = [part.replace('::', '').replace('"', '').split(',') for part in value.split(',3,"')[2:]]
        # query = ''
        # for session in sessions:
        #     query += self.insert.format(event_s_datetime, self.radio.name, *session)
        # return query
        return [self.insert.format(str(time_tag)[:23], self.radio.name, *session, number + 1)
                for number, session in enumerate(sessions)]
