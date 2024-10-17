import os
import pickle
import signal
from datetime import datetime
from platform import system
from time import sleep, time

import pandas as pd

from execute import get_connection, get_logger_format, get_multiple_row
from generator import get_file
from log.logger import get_db_loggers
from settings import SQL_SELECT, LOG_DIR
from status.frequency import Frequency
from status.group import Station, Sector


class StatusUpdater:
    def __init__(self):
        self.connection = get_connection()
        log_config = get_multiple_row(self.connection,
                                      get_file(os.path.join(SQL_SELECT, 'status_log_config.sql')),
                                      as_dict=True)
        self.logs = get_db_loggers('StatusUpdater', log_config, get_logger_format())
        self.log = self.logs['Core']
        self.stations, self.sectors = {}, {}

        self._continue = True
        self.frequency_reload_interval = 60
        self.parameters_reload_interval = 30
        self.reload_status_interval = 10
        self.prev_run_freq_reload = time() - self.frequency_reload_interval
        self.prev_run_para_reload = time() - self.parameters_reload_interval
        self.log.info('Initiated')

    def run(self):
        global _break
        self.log.info('Starting')
        # timing = {'Date': [], 'FrequencyReloading': [], 'ParameterReloading': [],
        #           'StatusFetching': [], 'StatusUpdating': []}
        while self._continue:
            # ft = pt = None
            if time() - self.prev_run_freq_reload > self.frequency_reload_interval:
                self.prev_run_freq_reload = time()
                self.reload_frequencies()

            if time() - self.prev_run_para_reload > self.parameters_reload_interval:
                self.prev_run_para_reload = time()
                self.reload_parameters()

            self.update_statuses()
            # timing['Date'].append(datetime.utcnow())
            # timing['FrequencyReloading'].append(ft)
            # timing['ParameterReloading'].append(pt)
            # timing['StatusFetching'].append(t1)
            # timing['StatusUpdating'].append(t2)

            sleep(self.reload_status_interval)
            self._continue = not _break

        # with open(os.path.join(LOG_DIR, 'status_reloading_time.pkl'), 'wb') as f:
        #     pickle.dump(pd.DataFrame(timing), f)
        self.log.info('Finished')

    def close(self):
        self._continue = False

    def reload_frequencies(self):
        # st = time()
        self.log.info('Reloading frequencies')
        radios = get_multiple_row(self.connection,
                                  "SELECT Name, Station, Frequency_No, Sector FROM Radio.Radio", as_dict=True)
        frequencies = {}

        for radio in radios:
            if radio['Station'] in frequencies:
                if radio['Frequency_No'] not in frequencies[radio['Station']]:
                    frequencies[radio['Station']][radio['Frequency_No']] = Frequency(self.log, radio['Station'],
                                                                                     radio['Frequency_No'],
                                                                                     radio['Sector'])
            else:
                frequencies[radio['Station']] = {
                    radio['Frequency_No']: Frequency(self.log, radio['Station'], radio['Frequency_No'],
                                                     radio['Sector'])}

            frequencies[radio['Station']][radio['Frequency_No']].add_radio(radio['Name'])

        self.stations.clear()
        self.sectors.clear()
        for station in frequencies:
            self.stations[station] = Station(station)
            for freq_no, freq_obj in frequencies[station].items():
                self.stations[station].add_frequency(freq_obj)

                if freq_obj.sector not in self.sectors:
                    self.sectors[freq_obj.sector] = Sector(freq_obj.sector)
                self.sectors[freq_obj.sector].add_frequency(freq_obj)

        self.log.info('Reloading frequencies completed')
        # return time() - st

    def reload_parameters(self):
        # st = time()
        self.log.info('Reloading parameters')
        query = get_file(os.path.join(SQL_SELECT, 'frequency_parameters.sql'))
        fp = get_multiple_row(self.connection, query, as_dict=True)

        df = pd.DataFrame(fp)
        columns_to_convert = ['Frequency_No', 'TXM', 'TXS', 'RXM', 'RXS', 'Level']
        df[columns_to_convert] = df[columns_to_convert].astype('int8')

        for station, station_obj in self.stations.items():
            for freq_obj in station_obj.frequencies:
                freq_obj.update_parameters(df[(df['Station'] == station) & (df['Frequency_No'] == freq_obj.freq_no)])
        self.log.info('Reloading parameters completed')
        # return time() - st

    def update_statuses(self):
        # st = time()
        self.log.info('Updating statuses')
        query = get_file(os.path.join(SQL_SELECT, 'radio_status.sql'))
        updated_stats = get_multiple_row(self.connection, query, as_dict=True)
        self.log.info('All Status Fetched')
        # t1, st = time() - st, time()

        status_df = pd.DataFrame(updated_stats)
        if not status_df.empty:
            status_df['severity'] = status_df['severity'].astype('int8')
            for station in self.stations:
                self.stations[station].update_status(self.connection, status_df)

            self.log.info('Updating statuses completed')
        # return t1, time() - st


_break = False
_updater: StatusUpdater


def _signal_handler(*args):
    global _break, _updater

    _break = True
    _updater.close()
    # _updater.log.info(f'SIGINT or SIGTERM Detected by {_updater.name} Module!')
    # while _updater.is_alive():
    #     sleep(0.15)

    _updater.log.info(f'Closed')


def run():
    from controller.controller import Controller

    controller = Controller('temp/.StatusUpdater.controller')
    if controller.allow:
        print('Starting')
        global _break, _updater

        _updater = StatusUpdater()

        signal.signal(signal.SIGINT, _signal_handler)
        signal.signal(signal.SIGTERM, _signal_handler)
        if system() == 'Windows':
            signal.signal(signal.SIGBREAK, _signal_handler)

        _updater.run()

        # while _updater.is_alive() and (not _break):
        #     _updater.join(2)
        #     if _updater.is_alive():
        #         print(f'Updater is working updater.is_alive()={_updater.is_alive()} and _break={_break}')
        #         sleep(2)

        # _updater.join(1)
        controller.unlock()
        print('Exiting')

    else:
        print(f'Another StatusUpdater Module is Running!')
