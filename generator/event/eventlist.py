import os

from generator.inserter import InserterGenerator
from settings import SQL_INSERT_EVENT


class EventListInserter(InserterGenerator):
    """
        CREATE TABLE Event.EventList
        (
            id          INT         NOT NULL IDENTITY PRIMARY KEY,
            Date        DATETIME    NOT NULL,
            Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
            Event_No    SMALLINT    NOT NULL,
            Module      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
            EventDate   DATETIME    NOT NULL,
            Code        SMALLINT    NOT NULL,
            Event_Text  VARCHAR(30) NOT NULL,
            Event_Level TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
        );

    """

    def __init__(self, radio, log):
        path = os.path.join(SQL_INSERT_EVENT, 'eventlist.sql')
        super(EventListInserter, self).__init__(radio, log=log, insert_query_file=path,
                                                acceptable_keys=['EVEE', 'EVEL'])

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: key={key}")
        if key == 'EVEL':
            return self.whole_event_list_query_generator(str(time_tag)[:23], value)
        else:
            return self.simple_record_generator(str(time_tag)[:23], value)

    def whole_event_list_query_generator(self, event_s_datetime, value):
        self.log.debug(f"{self.__class__.__name__}: Event List uploading")
        return [self.insert.format(event_s_datetime, self.radio.name, *simple_record.replace('"', '').split(',')[1:])
                for simple_record in value.split(',7,')[1:]] + \
            [f"Update Application.RadioStatus SET EventListCollect='{event_s_datetime}' WHERE "
             f"Radio_Name='{self.radio.name}'; "]

    def simple_record_generator(self, event_s_datetime, value):
        return [self.insert.format(event_s_datetime, self.radio.name, *value.replace('"', '').split(',')[2:])]
