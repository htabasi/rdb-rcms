import os

import pandas as pd

from execute import execute_no_answer_query
from generator import get_file
from settings import SQL_INSERT_HEALTH
from status.radio import RadioStatus


class Frequency:
    def __init__(self, log, station, freq_no, sector, query):
        self.log = log
        self.station = station
        self.freq_no = freq_no
        self.sector = sector
        self.name = str(self)
        self.parameters = {}
        self.status = {}
        self.rx = {}
        self.tx = {}
        self.insert = query.format(station, freq_no, sector)
        self.log.debug(f"{self.name} created")

    def add_radio(self, radio):
        if 'TX' in radio:
            if radio.endswith('M'):
                self.tx['M'] = RadioStatus(radio)
            else:
                self.tx['S'] = RadioStatus(radio)
        else:
            if radio.endswith('M'):
                self.rx['M'] = RadioStatus(radio)
            else:
                self.rx['S'] = RadioStatus(radio)

    def update_parameters(self, df: pd.DataFrame):
        for _, row in df.iterrows():
            self.parameters.setdefault(row['pid'], {}
                                       ).setdefault(row['TXM'], {}
                                                    ).setdefault(row['TXS'], {}
                                                                 ).setdefault(row['RXM'], {}
                                                                              )[row['RXS']] = (row['Level'],
                                                                                               row['message'])
        self.log.debug(f"{self.name} Parameters Reloaded ({len(self.parameters)} parameters)")

        # with open('fp.py', 'w') as fp:
        #     fp.write('frequency_parameters = {\n')
        #     for code in self.parameters:
        #         fp.write(f"    '{code}': {self.parameters[code]},\n")
        #     fp.write('}\n')

    def get_level(self, pid, txm, txs, rxm, rxs):
        if pid not in self.parameters:
            return 0
        txm = txm if txm in self.parameters[pid] else 1
        txs = txs if txs in self.parameters[pid][txm] else 1
        rxm = rxm if rxm in self.parameters[pid][txm][txs] else 1
        rxs = rxs if rxs in self.parameters[pid][txm][txs][rxm] else 1
        return self.parameters[pid][txm][txs][rxm][rxs]

    def update_status(self, connection, df):
        # df.to_csv('output.csv', index=True)
        # with open('fs.csv', 'w', newline='') as f:
        #     f.write()

        self.tx['M'].update_status(df)
        self.tx['S'].update_status(df)
        self.rx['M'].update_status(df)
        self.rx['S'].update_status(df)
        for pid in self.parameters:
            self.status[pid] = self.get_level(pid, self.tx['M'].get(pid), self.tx['S'].get(pid),
                                              self.rx['M'].get(pid), self.rx['S'].get(pid))

        self.log.debug(f"{self.name} Radio Statuses Updated ({len(self.status)} parameters)")
        # print(f'Status of {self}')
        for pid in self.status:
            execute_no_answer_query(connection, self.insert.format(pid, *self.status[pid]))
            # print(f'    {code}: {self.status[code]}')

    def __repr__(self):
        # return f'TXM: {self.tx["M"]} TXS: {self.tx["S"]} RXM: {self.rx["M"]} RXS: {self.rx["S"]}'
        return f'{self.station}_F{self.freq_no}@S{self.sector}'
