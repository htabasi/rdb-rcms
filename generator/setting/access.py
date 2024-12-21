import os

from generator import get_file
from settings import SQL_INSERT_SETTING


class Access:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            self.access = {i + 1: ip for i, ip in
                           enumerate(radio_answer.replace('"', '').replace('::', '').split(',')[1:])}
        else:
            self.access = {pair[0]: pair[1] for pair in db_answer}

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.access == other.access


class SAccessInserter:
    def __init__(self, radio, log):
        self.radio = radio.radio
        self.insert = radio.queries.get('ISAccess')
        self.acceptable_keys = ['GRAC']
        self.db_access = None
        p = self.insert.index('VALUES') + 7
        self.statement, self.values = self.insert[:p], self.insert[p:-1]
        self.log = log

    def save_access(self, db_access):
        # self.log.debug(f"{self.__class__.__name__}: Access list received")
        if db_access is not None:
            self.db_access = Access(db_answer=db_access)

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        access = Access(radio_answer=value)
        if access != self.db_access:
            vs = ''
            for i in access.access:
                if access.access[i] != '':
                    vs += self.values.format(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name,
                                             i, access.access[i]) + ', '
            if vs != '':
                return [self.statement + vs[:-2] + ';']
            else:
                return []
        else:
            return []
