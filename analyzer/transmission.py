import os
from datetime import datetime
from random import randint
from time import time
import pandas as pd

from generator import get_file
from settings import SQL_INSERT_ANALYZE


class Transmission:
    def __init__(self, health, radio, log):
        self.health = health
        self.radio = radio
        self.log = log
        self.interval = 5  # Minute
        self.execution = time() + randint(0, self.interval * 60)
        self.buffer = []
        self.power = []
        self.modulation = []
        self.swr = []
        self.ex_swr = []
        self.execute_now = False
        self.category = {'RCTO', 'RCMO', 'RCTV', 'RCVV', 'RCTC'}
        self.start, self.length = time(), 0.0
        self.time_tag = datetime.utcnow()
        self.insert = get_file(os.path.join(SQL_INSERT_ANALYZE, 'transmission.sql'))

    def add(self, key, items):
        time_tag, value = items
        if key == 'RCTO':
            power = int(value)
            if power != 0:
                self.power.append(power)
        elif key == 'RCMO':
            # self.add_test_data('RCMO : ' + str(value))
            mod = int(value)
            if mod != '0':
                self.modulation.append(mod)
        elif key == 'RCTV':
            swr = float(value)
            if swr != 0.0:
                self.swr.append(swr)
        elif key == 'RCVV':
            ex_swr = float(value)
            if ex_swr != 0.0:
                self.ex_swr.append(ex_swr)
        elif key == 'RCTC':
            ptt = int(value)
            self.execute_now = ptt == 0
            if ptt:
                self.start = time()
                self.length = 0.0
            else:
                self.length = time() - self.start
                self.time_tag = time_tag

    def execute(self):
        self.log.debug('Executing transmission')
        if time() >= self.execution or self.execute_now:
            self.log.debug('Running transmission action')
            return self.run()

    def run(self):
        query_list = []
        if self.modulation:
            # self.add_test_data('MOD : ' + str(self.modulation))
            self.log.debug(f'Transmission Action: modulation: {self.modulation}')
            # self.add_test_data(f'Adding : {max(self.modulation)}')
            if not (len(self.modulation) == 1 and self.modulation[0] == 0):
                self.health.add('AnalyzedModulationDepthValue', max(self.modulation))
            query_list.append(self.generate_insert(self.modulation, 'MOD'))
            self.modulation.clear()

        if self.power:
            self.log.debug(f'Transmission Action: power: {self.power}')
            self.health.add('AnalyzedTXPowerValue', max(self.power))
            query_list.append(self.generate_insert(self.power, 'PWR'))
            self.power.clear()

        if self.swr:
            self.log.debug(f'Transmission Action: swr: {self.swr}')
            self.health.add('AnalyzedVSWRValue', max(self.swr))
            query_list.append(self.generate_insert(self.swr, 'SWR'))
            self.modulation.clear()

        if self.ex_swr:
            self.log.debug(f'Transmission Action: ex_swr: {self.ex_swr}')
            self.health.add('AnalyzedExternalVSWRVoltage', max(self.ex_swr))
            query_list.append(self.generate_insert(self.ex_swr, 'EXSWR'))
            self.modulation.clear()

        self.execution += self.interval * 60
        self.execute_now = False
        return query_list

    def add_test_data(self, message: str):
        if self.radio.name.startswith('TBZ_'):
            with open(f"export/{self.radio.name} Mod Data.txt", 'a') as f:
                f.write(str(datetime.now())[:23] + ' | ' + message + '\n')

    def generate_insert(self, data, category):
        if len(data) <= 1:
            return ''
        fields, values = self.calculate_statistics(data, category)
        return self.insert.format(fields, self.radio.name, str(self.time_tag)[:23], len(data), self.length, values)

    @staticmethod
    def calculate_statistics(data: list, category: str):
        series = pd.Series(data).astype(float)
        mx, mn = series.max(), series.min()
        diff = mx - mn
        mean, median = series.mean(), series.median()
        var, std = series.var(), series.std()
        qn = series.quantile([0.25, 0.50, 0.75])
        skew, kurt = series.skew(), series.kurt()
        fields = {
            'Max': mx if not pd.isna(mx) else 0,
            'Min': mn if not pd.isna(mn) else 0,
            'Difference': diff if not pd.isna(diff) else 0,
            'Mean': mean if not pd.isna(mean) else 0,
            'Median': median if not pd.isna(median) else 0,
            'Variance': var if not pd.isna(var) else 0,
            'Deviation': std if not pd.isna(std) else 0,
            'Quantiles25': qn[0.25] if not pd.isna(qn[0.25]) else 0,
            'Quantiles50': qn[0.50] if not pd.isna(qn[0.50]) else 0,
            'Quantiles75': qn[0.75] if not pd.isna(qn[0.75]) else 0,
            'Skewness': skew if not pd.isna(skew) else 0,
            'Kurtosis': kurt if not pd.isna(kurt) else 0,
        }
        fields_part = f'{category}_' + f', {category}_'.join(fields.keys())
        values_part = ', '.join([str(v) for v in fields.values()])
        return fields_part, values_part
