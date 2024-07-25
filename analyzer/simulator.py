import numpy as np


class Simulator:
    def __init__(self):
        self.noise_level_dbm = -110
        self.time_length = 5 * 60
        self.pps = 5


    def rssi_generator(self):
        moment = np.linspace(0, self.time_length, self.time_length * self.pps)

    @staticmethod
    def uv(dbm):
        return np.sqrt(5 * 10 ** (dbm / 10 + 10))

    @staticmethod
    def dbm(uv):
        return 20 * np.log10(np.abs(uv))
