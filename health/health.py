import os
from threading import Thread
from time import sleep

from base.aggregator import Aggregator
from generator import get_file
from health.generator import StatGenerator
from health.parameters import FixedValue, PatternString, EqualString, MultiLevel, Range
from settings import SQL_INSERT_HEALTH


class HealthMonitor(Thread):
    def __init__(self, parent, executor, log):
        super(HealthMonitor, self).__init__(name='Health_Monitor')
        self.radio = parent
        self.executor = executor
        self.log = log
        # self.status = {}
        self.buffer = [[], []]
        self.writer = 0

        self.parameters = {}
        self.calm = 1.0
        self.alive_counter = self.alive_counter_prev = 0
        self.stat_update = Aggregator('CntStatusUpdated')
        self.err_update = Aggregator('CntErrorStatusUpdating')
        self.key_code_convert = {
            'AIAD': 'AudioDelay',
            'AIAI': 'AudioInterface',
            'AICA': 'TxAudioALC',
            'AIEL': 'LineInterfaceInLocalMode',
            'AIGA': 'RxAudioAGC',
            'AILA': 'AudioLevel',
            'AITP': 'TxPreEmphasis',
            'Connection': 'Connection',
            'ERBE': 'BootErrorList',
            'ERGN': 'GONOGOStatus',
            'FFCO': 'CarrierOverride',
            'FFEA': 'ACARSDataMode',
            'FFLM': 'LocalMode',
            'FFLT': 'LocalModeTimeout',
            'FFMD': 'ModulationMode',
            'FFSC': 'SingleChannel',
            'FFSL': 'SQLogicOperation',
            'FFSN': 'SNRSquelchThreshold',
            'FFSP': 'ChannelSpacing',
            'FFSQ': 'SQCircuit',
            'FFSR': 'RSSISquelchThreshold',
            'FFTO': 'CarrierOffset',
            'FFTR': 'Frequency',
            'GRAS': 'ATRSwitchMode',
            'GRDH': 'DHCPEnabled',
            'GRHN': 'Hostname',
            'GRIE': 'SecondIPAddressEnabled',
            'GRII': 'SecondIPAddress',
            'GRIN': 'InstallationInfo',
            'GRIP': 'IPAddress',
            'GRIS': 'RxInputSensitivity',
            'GRIV': 'IPv6Enabled',
            'GRLR': 'MeasureRXAudioLevel',
            'GRLT': 'MeasureTXAudioLevel',
            'GRNA': 'NTPSyncActive',
            'GRND': 'SerialNumber',
            'GRNS': 'NTPServer',
            'GRSE': 'SNMPEnable',
            'GRSN': 'SNMPCommunityString',
            'GRVE': 'GB2PPVersion',
            'IRO': 'RSSIOutputType',
            'MSAC': 'ActivationStatus',
            'MSTY': 'MainStandbyType',
            'RCDP': 'PTTTimeout',
            'RCIT': 'TXInhibition',
            'RCLP': 'TxLowPowerLevel',
            'RCMG': 'ModulationDepthSetting',
            'RCMO': 'ModulationDepthValue',
            'RCPP': 'PresetPageNumber',
            'RCTO': 'TXPowerValue',
            'RCTV': 'VSWRValue',
            'RCTW': 'VSWRLED',
            'RCVV': 'ExternalVSWRVoltage',
            'RIPC': 'PTTInputConfiguration',
            'RIVL': 'EXTVSWRlimit',
            'RIVP': 'EXTVSWRPolarity',
            'RUFL': 'FTPLogin',
            'RUFP': 'FTPPassword'
        }

        # self.key_code_convert = {
        #     'FFEA': 'ACARSDataMode',
        #     'MSAC': 'ActivationStatus',
        #     'AIAI': 'AudioInterface',
        #     'FFSP': 'ChannelSpacing',
        #     'Connection': 'Connection',
        #     'GRDH': 'DHCPEnabled',
        #     'FFTR': 'Frequency',
        #     'ERGN': 'GONOGOStatus',
        #     'GRIV': 'IPv6Enabled',
        #     'AIEL': 'LineInterfaceInLocalMode',
        #     'FFLM': 'LocalMode',
        #     'MSTY': 'MainStandbyType',
        #     'FFMD': 'ModulationMode',
        #     # '': 'MySessionType',
        #     'GRNA': 'NTPSyncActive',
        #     # '': 'OtherSessionType',
        #     'RCPP': 'PresetPageNumber',
        #     'GRIS': 'RxInputSensitivity',
        #     'GRIE': 'SecondIPAddressEnabled',
        #     'FFSC': 'SingleChannel',
        #     'GRSE': 'SNMPEnable',
        #     'FFCO': 'CarrierOverride',
        #     'IRO': 'RSSIOutputType',
        #     'AIGA': 'RxAudioAGC',
        #     'FFSQ': 'SQCircuit',
        #     'FFSL': 'SQLogicOperation',
        #     'GRAS': 'ATRSwitchMode',
        #     'FFTO': 'CarrierOffset',
        #     'RIVP': 'EXTVSWRPolarity',
        #     'RIPC': 'PTTInputConfiguration',
        #     'AICA': 'TxAudioALC',
        #     'RCIT': 'TXInhibition',
        #     'RCTW': 'VSWRLED',
        #     'AIAD': 'AudioDelay',
        #     'AILA': 'AudioLevel',
        #     'FFLT': 'LocalModeTimeout',
        #     'GRLR': 'MeasureRXAudioLevel',
        #     'FFSR': 'RSSISquelchThreshold',
        #     'FFSN': 'SNRSquelchThreshold',
        #     'RCVV': 'ExternalVSWRVoltage',
        #     'RIVL': 'EXTVSWRlimit',
        #     'GRLT': 'MeasureTXAudioLevel',
        #     'RCMG': 'ModulationDepthSetting',
        #     'RCMO': 'ModulationDepthValue',
        #     'RCDP': 'PTTTimeout',
        #     'RCLP': 'TxLowPowerLevel',
        #     'RCTO': 'TXPowerValue',
        #     'AITP': 'TxPreEmphasis',
        #     'RCTV': 'VSWRValue',
        #     'ERBE': 'BootErrorList',
        #     'GRIP': 'IPAddress',
        #     'GRII': 'SecondIPAddress',
        #     'GRND': 'SerialNumber',
        #     'GRSN': 'SNMPCommunityString',
        #     'GRVE': 'GB2PPVersion',
        #     'RUFL': 'FTPLogin',
        #     'RUFP': 'FTPPassword',
        #     'GRHN': 'Hostname',
        #     'GRIN': 'InstallationInfo',
        #     'GRNS': 'NTPServer',
        #
        # }

        self.stat_gen = StatGenerator(self)
        self.insert = get_file(os.path.join(SQL_INSERT_HEALTH, 'radio_status.sql')).format(self.radio.radio.name)

    def create_parameters(self, fixed_values, multi_levels, ranges, equal_strings, pattern_strings):
        ml_codes = {}
        rn_codes = {}
        for data in multi_levels:
            if data['code'] in ml_codes:
                ml_codes[data['code']]['stats'].append({'value': data['value'],
                                                        'severity': data['severity'],
                                                        'message': data['message']})
            else:
                ml_codes[data['code']] = {'id': data['id'],
                                          'code': data['code'],
                                          'name': data['name'],
                                          'correct': data['correct'],
                                          'normal_msg': data['normal_msg'],
                                          'stats': [{'value': data['value'],
                                                     'severity': data['severity'],
                                                     'message': data['message']}]}
        for data in ranges:
            if data['code'] in rn_codes:
                rn_codes[data['code']]['stats'].append({'r_start': data['r_start'],
                                                        'r_end': data['r_end'],
                                                        'severity': data['severity'],
                                                        'message': data['message']})
            else:
                rn_codes[data['code']] = {'id': data['id'],
                                          'code': data['code'],
                                          'name': data['name'],
                                          'start': data['start'],
                                          'end': data['end'],
                                          'normal_msg': data['normal_msg'],
                                          'stats': [{'r_start': data['r_start'],
                                                     'r_end': data['r_end'],
                                                     'severity': data['severity'],
                                                     'message': data['message']}]}

        for data in fixed_values:
            self.parameters[data['code']] = FixedValue(health=self, **data)
        for data in equal_strings:
            self.parameters[data['code']] = EqualString(health=self, **data)
        for data in pattern_strings:
            self.parameters[data['code']] = PatternString(health=self, **data)
        for code, data in ml_codes.items():
            self.parameters[code] = MultiLevel(health=self, **data)
        for code, data in rn_codes.items():
            self.parameters[code] = Range(health=self, **data)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def query(self, id, level, message):
        return self.insert.format(id, level, message)

    def add(self, key, value):
        self.buffer[self.writer].append((key, value))

    def run(self) -> None:
        self.log.info('Started')
        while self.radio.keep_alive:
            reader = 1 - self.writer

            try:
                self.generate(self.buffer[reader])
            except Exception as e:
                self.err_update.add()
                self.log.exception(f'Error on Query Generation! {e}')

            if not self.radio.keep_alive:
                # self.log.debug(f"Reading {len(self.buffer[self.writer])} new data from latest buffer.")
                sleep(self.calm / 2)
                self.generate(self.buffer[self.writer])

            self.alive_counter += 1
            sleep(self.calm)
            self.writer = reader

        self.log.info('Finished')

    def generate(self, buffer):
        while buffer:
            key, value = buffer.pop(0)
            query_list = []
            try:
                parameter = self.key_code_convert[key]
            except KeyError:
                if key in self.stat_gen.key_list:
                    query_list.extend(self.stat_gen.get_stat(key, value))
                else:
                    continue
            except Exception as e:
                self.err_update.add()
                self.log.exception(f'Error occurred during query generation: {e}, {e.args}')
            else:
                query_list.append(self.parameters[parameter].update(value))
            finally:
                for query in query_list:
                    if query:
                        self.stat_update.add()
                        self.executor.add(query)
    #
    # def __repr__(self):
    #     levels = {0: 'Normal', 1: 'Notice', 2: 'Warning', 3: 'Error', 4: 'Critical', 5: 'Emergency'}
    #     stat = {level: {} for level in levels}
    #     for pr, (lvl, msg) in self.status.items():
    #         stat[lvl][pr] = msg
    #
    #     s = ''
    #     for lvl in stat:
    #         if stat[lvl]:
    #             s += f'{levels[lvl]}:\n'
    #             s += "".join([f'    {param}: {message}\n' for param, message in self.status[lvl].items()])
    #     return s
