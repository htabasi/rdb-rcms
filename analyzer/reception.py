import pandas as pd
import numpy as np


class Reception:
    def __init__(self, radio, log):
        self.radio = radio
        self.log = log
        self.category = {'FFRS', 'RCRI'}
        self.id, self.bid = 0, 0
        self.buffer = [{}, {}]
        self.category = {'Reception'}

    def add(self, key, items):
        time_tag, value = items
        self.buffer[self.bid][self.id] = {'Time': time_tag, 'RSSI': rssi, 'SQ': sq, 'SQ_ON': sq_on, 'SQ_OFF': sq_off}
        self.id += 1

    def calculate(self, bid):
        df = pd.DataFrame.from_dict(self.buffer[bid])
        # در این قسمت باید دیکشنری بافر به دیتافریم پانداس تبدیل شود
        self.buffer[bid].clear()

    def generate(self, key):
        self.bid = 1 - self.bid
        self.calculate(1 - self.bid)

