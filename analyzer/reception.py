from datetime import datetime
from random import randint
from time import time

import pandas as pd
import numpy as np


class Reception:
    def __init__(self, health, radio, log):
        self.health = health
        self.radio = radio
        self.log = log
        self.interval = 5  # Minute
        self.execution = time() + randint(0, self.interval * 60)
        self.execute_now = False
        self.start, self.length = time(), 0.0
        self.sq = 0
        self.time_tag = datetime.utcnow()
        self.category = {'FFRS', 'RCRI'}
        self.buffer, self.stack = [[], []], [[], []]

        self.result = open(f'export/{self.radio.name}_reception.txt', 'w')

    def add(self, key, items):
        time_tag, value = items
        if key == 'FFRS':
            self.buffer[self.sq].append(int(value) - 120)
        elif key == 'RCRI':
            self.sq = int(value)
            self.stack[1 - self.sq].append(self.buffer[1 - self.sq].copy())
            self.buffer[1 - self.sq].clear()
            self.execute_now = True

    def execute(self):
        self.log.debug('Executing reception')
        if time() >= self.execution or self.execute_now:
            self.log.debug('Running reception action')
            return self.run()

    def run(self):
        self.result.write(f"SQ OFF: {self.stack[0]}")
        self.result.write(f"SQ ON: {self.stack[1]}")
        self.stack[0].clear()
        self.stack[1].clear()
