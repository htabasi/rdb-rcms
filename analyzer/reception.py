from datetime import datetime, UTC

import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import MinMaxScaler


class KMeansClusterManager:
    def __init__(self, radio_name, log):
        self.radio_name = radio_name
        self.log = log
        self.file_name = f'export/reception/{self.radio_name}-data.txt'
        self.centers = np.array([[-118, 0], [-107, 0], [-85, 1], [0, 1]])
        self.cluster_names = {'N': 'Noise', 'F': 'FarAway', 'D': 'Detected', 'T': 'Transmitter'}
        self.cluster_thresholds = {'N': -107, 'T': -50}

    def generate(self, data: list):
        if len(data) == 0:
            return None
        result = None
        try:
            answer = self.calculate(data)
            if answer is None:
                return None
            all_fields, all_values = answer
        except Exception as e:
            self.log.error(f'RX Statistics :: {e.__class__.__name__}, args: {e.args} len(data): {len(data)}')
            self.save_data(data)
        else:
            result = all_fields, all_values
        finally:
            data.clear()
            return result

    def calculate(self, data: list):
        df = pd.DataFrame(data)
        self.log.debug(f'KMC :: Converted to DataFrame')
        sq_on_exists, sq_off_exists = False, False
        if 'SQ_ON' in df and 'SQ_OFF' in df:
            self.log.debug(f'KMC :: SQ_ON & SQ_OFF Detected')
            sq_data_df = df[(~df['SQ_ON'].isna()) | (~df['SQ_OFF'].isna())][['SQ_ON', 'SQ_OFF']].copy()
            sq_on_exists, sq_off_exists = True, True
        elif 'SQ_ON' in df:
            self.log.debug(f'KMC :: Only SQ_ON Detected')
            sq_data_df = df[~df['SQ_ON'].isna()][['SQ_ON']].copy()
            sq_on_exists, sq_off_exists = True, False
        elif 'SQ_OFF' in df:
            self.log.debug(f'KMC :: Only SQ_OFF Detected')
            sq_data_df = df[~df['SQ_OFF'].isna()][['SQ_OFF']].copy()
            sq_on_exists, sq_off_exists = False, True
        else:
            sq_data_df = None

        df = self.correct_sq(self.sq_fill(self.rssi_fill(df)))
        self.log.debug(f'KMC :: Filling & Correcting Done')

        scaler = MinMaxScaler(feature_range=(0, 1))
        df['r'] = scaler.fit_transform(df[['RSSI']])
        df = self.get_interpolated(df, 0.5)
        self.log.debug(f'KMC :: Scaling & Interpolating Done')

        km_n, km_score = self.find_best_n_clusters_km(df)

        if km_score == -1:
            self.log.warning(f'KMC :: Clustering Aborted (km_score = -1) and (len(df) = {len(df)})')
            return None

        km = KMeans(n_clusters=km_n, random_state=10).fit(df[['r', 'SQ']])
        df['KMC'] = km.labels_
        self.log.debug(f'KMC :: Clustering Done')

        dpc = self.calculate_cluster_duration(df, 'KMC')
        km_result = self.stat_group(scaler, df, 'KMC')
        km_result.reset_index(inplace=True)
        km_result = km_result.merge(dpc, on='KMC', how='left')

        self.log.debug(f'KMC :: Ready to query construction')
        return self.construction(km_result, sq_data_df, sq_on_exists, sq_off_exists)

    def construction(self, df: pd.DataFrame, sq_data_df: pd.DataFrame, sq_on_exists, sq_off_exists):
        #      count        mean  median       std    q15         q85   sq   type
        # KMC
        # 0      606 -117.827112  -118.0  2.202960 -119.0 -118.000000  0.0  Noise
        # 2       46  -96.076033   -96.0  6.042445  -98.0  -92.874381  1.0  Pilot
        # 1       67    0.396010     0.0  0.488915    0.0    1.000000  1.0     Tx
        # result = {
        #     'Noise': {'count': 606, 'mean': -117.827112, 'median': -118.0, ...},
        #     'Pilot': {'count': 46, 'mean': -96.076033, 'median': -96.0, ...},
        #     'Tx': {'count': 67, 'mean': 0.396010, 'median': -0.0, ...}
        # }

        result = df.groupby('type').apply(lambda x: x.to_dict(orient='records')[0], include_groups=False).to_dict()

        parts = {}
        for key, data in result.items():
            parts[key] = self.get_data(key, data)

        fields_part, values_part = '', ''
        if sq_on_exists:
            parts['SQ_ON'] = self.get_statistics('SQ_ON', sq_data_df['SQ_ON'].astype(float))
            fields_part += 'SQ_ON_Length, '
            values_part += f"{sq_data_df['SQ_ON'].sum()}, "
        if sq_off_exists:
            parts['SQ_OFF'] = self.get_statistics('SQ_OFF', sq_data_df['SQ_OFF'].astype(float))
            fields_part += 'SQ_OFF_Length, '
            values_part += f"{sq_data_df['SQ_OFF'].sum()}, "

        for part, items in parts.items():
            fields_part += ', '.join(items.keys()) + ', '
            values_part += ', '.join([str(v) for v in items.values()]) + ', '

        return fields_part[:-2], values_part[:-2]

    @staticmethod
    def calculate_cluster_duration(df, cluster_col):
        df['change_cluster_date'] = np.where(df[cluster_col].diff() != 0, df['Date'], np.nan)
        df['change_cluster_date'] = df['change_cluster_date'].ffill()
        df['duration'] = df['change_cluster_date'].diff().shift(-1)
        df = df.dropna(subset=['duration'])
        cluster_duration = df.groupby(cluster_col)['duration'].sum().apply(lambda x: x.total_seconds()).reset_index()
        return cluster_duration

    def stat_group(self, scaler: MinMaxScaler, df: pd.DataFrame, cluster_col):
        stats = df.groupby(cluster_col).agg(count=('r', 'size'),
                                            mean=('r', 'mean'),
                                            median=('r', 'median'),
                                            std=('r', 'std'),
                                            q15=('r', lambda x: x.quantile(0.15)),
                                            q85=('r', lambda x: x.quantile(0.85)),
                                            sq=('SQ', 'mean'))
        sorted_stats = stats.sort_values(by='mean', ascending=True)
        sorted_stats[['mean', 'median', 'q15', 'q85']] = scaler.inverse_transform(
            sorted_stats[['mean', 'median', 'q15', 'q85']])
        sorted_stats['std'] = sorted_stats['std'] * (scaler.data_max_[0] - scaler.data_min_[0])

        sorted_stats['type'] = '*'
        sorted_stats['type'] = sorted_stats.apply(lambda row: self.evaluate(row.name, row['sq'], row['mean']), axis=1)

        return sorted_stats

    def evaluate(self, index, sq, mean):
        sq = int(sq >= 0.5)
        if mean >= self.cluster_thresholds['T']:
            return self.cluster_names['T']
        if mean < self.cluster_thresholds['N']:
            return self.cluster_names['N']
        elif sq == 1:
            return self.cluster_names['D']
        elif index == 0:
            return self.cluster_names['N']
        else:
            return self.cluster_names['F']

    @staticmethod
    def find_best_n_clusters_km(df, max_clusters=4):
        best_n = 1
        best_score = -1
        scores = []

        unique_points = df[['r', 'SQ']].drop_duplicates()
        max_clusters = min(max_clusters, len(unique_points))
        for n in range(2, max_clusters + 1):
            km = KMeans(n_clusters=n, random_state=0).fit(df[['r', 'SQ']])
            labels = km.labels_
            score = silhouette_score(df[['r', 'SQ']], labels)
            scores.append(score)

            if score > best_score:
                best_score = score
                best_n = n

        return best_n, best_score

    @staticmethod
    def get_interpolated(df: pd.DataFrame, window=0.5):
        tdf = df.copy()
        time_bins = np.arange(int(tdf['Date'].min().value // (window * 1e9)),
                              int(tdf['Date'].max().value // (window * 1e9)) + 1)
        time_bin_dates = pd.to_datetime(time_bins * (window * 1e9)).tz_localize('UTC')
        result = pd.DataFrame({'Date': time_bin_dates})
        rdf = pd.concat([tdf, result]).sort_values(by='Date').reset_index()
        rdf.ffill().bfill()
        rdf[['SQ', 'RSSI', 'r']] = rdf[['SQ', 'RSSI', 'r']].ffill().bfill()
        return rdf

    @staticmethod
    def rssi_fill(df):
        # Fill RSSI NaN
        df['Date'] = pd.to_datetime(df['Date'], format='ISO8601')
        df.set_index('Date', inplace=True)
        df['RSSI'] = df['RSSI'].interpolate(method='time')
        df.reset_index(inplace=True)
        df['RSSI'] = df['RSSI'].bfill().ffill()
        return df

    @staticmethod
    def sq_fill(df: pd.DataFrame):
        # Fill SQ NaN
        first_valid_index = df['SQ'].first_valid_index()
        if pd.isna(df.loc[0, 'SQ']):
            df.loc[0, 'SQ'] = df.loc[first_valid_index, 'SQ']
        df['SQ'] = df['SQ'].ffill()
        return df

    def correct_sq(self, df: pd.DataFrame):
        df['RSSI-Diff'] = df['RSSI'].diff()
        std = df['RSSI-Diff'].std()
        df['SQ-3'] = df['SQ'].shift(3)
        df['SQ-2'] = df['SQ'].shift(2)
        df['SQ-1'] = df['SQ'].shift()
        df['SQ+1'] = df['SQ'].shift(-1)
        df['SQ+2'] = df['SQ'].shift(-2)
        df['SQ+3'] = df['SQ'].shift(-3)

        df['DF-2'] = df['RSSI-Diff'].shift(2)
        df['DF-1'] = df['RSSI-Diff'].shift()
        df['DF+1'] = df['RSSI-Diff'].shift()

        df['NSQ'] = df.apply(lambda row: self.get_nsq(row, std, 'RSSI-Diff'), axis=1)
        df['SQ'] = df['NSQ'].fillna(df['SQ']).astype(int)
        df.drop(['SQ-3', 'SQ-2', 'SQ-1', 'SQ+1', 'SQ+2', 'SQ+3', 'DF-1', 'DF-2', 'DF+1', 'NSQ', 'RSSI-Diff'],
                axis=1, inplace=True)
        return df

    @staticmethod
    def get_nsq(row, std, mark='RSSI-Diff'):
        if (row['SQ'] == 0) & (row['SQ+1'] == 1) & (row[mark] > std):
            return 1
        elif (row['SQ'] == 0) & (row['SQ+1'] == 1) & (row['DF-1'] > std):
            return 1
        elif (row['SQ'] == 0) & (row['SQ+1'] == 0) & (row['SQ+2'] == 1) & (row[mark] > std):
            return 1
        elif (row['SQ'] == 0) & (row['SQ+1'] == 1) & (row['DF-2'] > std):
            return 1
        elif (row['SQ'] == 0) & (row['SQ+1'] == 0) & (row['SQ+2'] == 1) & (row['DF-1'] > std):
            return 1
        elif (row['SQ'] == 0) & (row['SQ+1'] == 0) & (row['SQ+2'] == 0) & (row['SQ+3'] == 1) & (row[mark] > std):
            return 1

        elif (row['SQ'] == 1) & (row['SQ+1'] == 0) & (row[mark] < -std):
            return 0
        elif (row['SQ'] == 1) & (row['SQ+1'] == 0) & (row['DF-1'] < -std):
            return 0
        elif (row['SQ'] == 1) & (row['SQ+1'] == 1) & (row['SQ+2'] == 0) & (row[mark] < -std):
            return 0
        elif (row['SQ'] == 1) & (row['SQ+1'] == 0) & (row['DF-2'] < -std):
            return 0
        elif (row['SQ'] == 1) & (row['SQ+1'] == 1) & (row['SQ+2'] == 0) & (row['DF-1'] < -std):
            return 0
        elif (row['SQ'] == 1) & (row['SQ+1'] == 1) & (row['SQ+2'] == 1) & (row['SQ+3'] == 0) & (row[mark] < -std):
            return 0
        else:
            return np.nan

    def save_data(self, data: list):
        with open(self.file_name, 'a') as f:
            str_data = '['
            for d in data:
                correct_d = {}
                for key, value in d.items():
                    if key != 'Date':
                        correct_d[key] = value
                    else:
                        correct_d[key] = str(value)
                str_data += str(correct_d) + ',\n '

            f.write(str_data[:-3] + ']\n')

    @staticmethod
    def get_data(name, rd: dict):
        return {
            f'{name}_Count': int(rd['count']) if rd['count'] is not None else 0,
            f'{name}_Duration': float(rd['duration']) if rd['duration'] is not None else 0.0,
            f'{name}_Mean': float(rd['mean']) if not pd.isna(rd['mean']) else 0.0,
            f'{name}_Median': float(rd['median']) if not pd.isna(rd['median']) else 0.0,
            f'{name}_Deviation': float(rd['std']) if not pd.isna(rd['std']) else 0.0,
            f'{name}_Quantiles15': float(rd['q15']) if not pd.isna(rd['q15']) else 0.0,
            f'{name}_Quantiles85': float(rd['q85']) if not pd.isna(rd['q85']) else 0.0
        }

    @staticmethod
    def get_statistics(name, series: pd.Series):
        cnt = len(series)
        mean, median = series.mean(), series.median()
        std = series.std()
        qn = series.quantile([0.15, 0.85])
        return {
            f'{name}_Count': int(cnt) if not pd.isna(cnt) else 0,
            f'{name}_Mean': mean if not pd.isna(mean) else 0,
            f'{name}_Median': median if not pd.isna(median) else 0,
            f'{name}_Deviation': std if not pd.isna(std) else 0,
            f'{name}_Quantiles15': qn[0.15] if not pd.isna(qn[0.15]) else 0,
            f'{name}_Quantiles85': qn[0.85] if not pd.isna(qn[0.85]) else 0
        }


class Reception:
    def __init__(self, health, radio, queries, log):
        self.health = health
        self.radio = radio
        self.log = log
        self.category = {'RCRI', 'FFRS'}
        self.buffer = [[], []]
        self.write_buffer = 0
        self.insert = queries.get('IAReception')
        self.centers_insert = queries.get('IARSSIClusters')
        self.latest_sq, self.sq_start = None, None
        self.file_name = f'export/reception/{self.radio.name}-data.txt'
        self.latest_sq = None
        self.kmeans = KMeansClusterManager(self.radio.name, log)

    def add(self, key, items):
        time_tag, value = items
        if key == 'RCRI':
            sq = int(value)

            sq_len = 0 if self.sq_start is None else time_tag.timestamp() - self.sq_start
            sq_key = {0: 'SQ_ON', 1: 'SQ_OFF'}.get(sq)
            self.buffer[self.write_buffer].append({'Date': time_tag, 'SQ': sq, sq_key: sq_len})
            self.sq_start = time_tag.timestamp()
            self.latest_sq = sq
        else:
            if len(self.buffer[self.write_buffer]) == 0 and self.latest_sq is not None:
                self.buffer[self.write_buffer].append({'Date': time_tag, 'SQ': self.latest_sq})

            self.buffer[self.write_buffer].append({'Date': time_tag, 'RSSI': int(value) - 120})

    def generate(self):
        read_buffer, self.write_buffer = self.write_buffer, 1 - self.write_buffer

        result = self.kmeans.generate(self.buffer[read_buffer])
        if result is None:
            return []
        all_fields, all_values = result
        query_list = [self.insert.format(all_fields, self.radio.name,
                                         datetime.now(UTC).strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], all_values)]
        return query_list

