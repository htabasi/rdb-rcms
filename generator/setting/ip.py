import os

from generator import get_file
from settings import SQL_INSERT_SETTING


class IP:
    def __init__(self, radio_answer=None, db_answer=None, ip=None, subnet=None, gateway=None):
        if radio_answer is not None:
            self.ip, self.subnet, self.gateway = radio_answer.replace('"', '').replace('::', '').split(',')[1:]
        elif db_answer is not None:
            self.ip, self.subnet, self.gateway = db_answer
        else:
            self.ip, self.subnet, self.gateway = ip, subnet, gateway

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return (self.ip == other.ip) and (self.subnet == other.subnet) and (self.gateway == other.gateway)
        else:
            return False

    def __repr__(self):
        return f"{self.ip}, {self.subnet}, {self.gateway}"


class SIPInserter:
    def __init__(self, radio, log):
        self.radio = radio
        self.insert = get_file(os.path.join(SQL_INSERT_SETTING, 'ip.sql'))
        self.acceptable_keys = ['GRII', 'GRIP']
        self.ip_type = {'GRIP': 0, 'GRII': 1}
        self.first, self.second = None, None
        self.log = log

    def save_ip(self, first, second):
        if first is not None:
            self.first = IP(db_answer=first)
        if second is not None:
            self.second = IP(db_answer=second)
        # self.log.debug(f"{self.__class__.__name__}: IPs Saved")

    def is_different(self, ip: IP, t):
        if t == 0:
            return ip != self.first
        else:
            return ip != self.second

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        t = self.ip_type.get(key)
        ip = IP(radio_answer=value)
        if self.is_different(ip, t):
            if t == 0:
                self.first = ip
            else:
                self.second = ip
            return [self.insert.format(str(time_tag)[:23], self.radio.name, t, ip.ip, ip.subnet, ip.gateway)]
        else:
            return []
