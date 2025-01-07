from threading import Thread
from time import sleep

from base.aggregator import Aggregator
from health.generator import StatGenerator
from health.parameters import FixedValue, PatternString, EqualString, MultiLevel, Range


class HealthMonitor(Thread):
    def __init__(self, parent, executor, log):
        super(HealthMonitor, self).__init__(name='Health_Monitor')
        self.radio = parent
        self.executor = executor
        self.log = log
        self.dispatcher = self.radio.dispatcher
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
            'GRIN': 'InstallationInfo',
            'GRIS': 'RxInputSensitivity',
            'GRIV': 'IPv6Enabled',
            'GRLR': 'MeasureRXAudioLevel',
            'GRLT': 'MeasureTXAudioLevel',
            'GRNA': 'NTPSyncActive',
            'GRNS': 'NTPServer',
            'GRSE': 'SNMPEnable',
            'GRSN': 'SNMPCommunityString',
            'GRVE': 'GB2PPVersion',
            'RIRO': 'RSSIOutputType',
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
        self.codes = {
            'AnalyzedTXPowerValue', 'AnalyzedModulationDepthValue', 'AnalyzedVSWRValue', 'AnalyzedExternalVSWRVoltage',
        }

        self.stat_gen = StatGenerator(self)
        self.insert = self.radio.queries.get('MHRadioStatus').format(self.radio.radio.name)
        self.acceptable_keys = set(list(self.key_code_convert.keys()) +
                                   list(self.stat_gen.key_list.keys())).union(self.codes)
        self.disabled_codes, self.disabled_keys = set(), set()
        self.log.debug(f'acceptable_keys: {self.acceptable_keys}')

    def create_parameters(self, fixed_values, multi_levels, ranges, equal_strings, pattern_strings):
        ml_codes = {}
        rn_codes = {}
        self.log.debug(f'FV Parameters {fixed_values}')
        self.log.debug(f'ML Parameters {multi_levels}')
        self.log.debug(f'RN Parameters {ranges}')
        self.log.debug(f'ES Parameters {equal_strings}')
        self.log.debug(f'PS Parameters {pattern_strings}')
        for data in multi_levels:
            self.log.debug(f'Range Parameter: {data}')
            if data['enable'] == 0:
                self.log.debug(f'Parameter with code {data["code"]} and key {data["key"]} is disabled')
                self.disabled_codes.add(data['code'])
                if data['key']:
                    self.disabled_keys.add(data['key'])
                continue
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
            self.log.debug(f'Range Parameter: {data}')
            if data['enable'] == 0:
                self.log.debug(f'Parameter with code {data["code"]} and key {data["key"]} is disabled')
                self.disabled_codes.add(data['code'])
                if data['key']:
                    self.disabled_keys.add(data['key'])
                continue
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
            self.log.debug(f'Range Parameter: {data}')
            self.add_parameter(data, FixedValue)
        for data in equal_strings:
            self.log.debug(f'Range Parameter: {data}')
            self.add_parameter(data, EqualString)
        for data in pattern_strings:
            self.log.debug(f'Range Parameter: {data}')
            self.add_parameter(data, PatternString)
        #
        # for data in fixed_values:
        #     if data['enable'] == 0:
        #         self.disabled_codes.add(data['code'])
        #         if data['key']:
        #             self.disabled_keys.add(data['key'])
        #         continue
        #     self.parameters[data['code']] = FixedValue(health=self, log=self.log, **data)
        # for data in equal_strings:
        #     if data['enable'] == 0:
        #         self.disabled_codes.add(data['code'])
        #         if data['key']:
        #             self.disabled_keys.add(data['key'])
        #         continue
        #     self.parameters[data['code']] = EqualString(health=self, log=self.log, **data)
        # for data in pattern_strings:
        #     if data['enable'] == 0:
        #         self.disabled_codes.add(data['code'])
        #         if data['key']:
        #             self.disabled_keys.add(data['key'])
        #         continue
        #     self.parameters[data['code']] = PatternString(health=self, log=self.log, **data)
        for code, data in ml_codes.items():
            self.parameters[code] = MultiLevel(health=self, log=self.log, **data)
        for code, data in rn_codes.items():
            self.parameters[code] = Range(health=self, log=self.log, **data)

        self.log.debug(f'Parameters: {list(self.parameters.keys())}')
        self.log.debug(f'Disabled parameters by codes: {self.disabled_codes}')
        self.log.debug(f'Disabled parameters by keys: {self.disabled_keys}')

    def add_parameter(self, data, parameter_class):
        if data['enable'] == 0:
            self.log.debug(f'Parameter with code {data["code"]} and key {data["key"]} is disabled')
            self.disabled_codes.add(data['code'])
            if data['key']:
                self.disabled_keys.add(data['key'])
            return
        self.parameters[data['code']] = parameter_class(health=self, log=self.log, **data)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def query(self, id, level, message):
        return self.insert.format(id, level, message)

    def add(self, key, value):
        if key in self.acceptable_keys and key not in self.disabled_keys and key not in self.disabled_codes:
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
                self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)

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
                if key in self.codes and key not in self.disabled_codes:
                    query_list.append(self.parameters[key].update(value))

                elif key in self.key_code_convert and key not in self.disabled_keys:
                    parameter = self.key_code_convert[key]
                    query_list.append(self.parameters[parameter].update(value))

                elif key in self.stat_gen.key_list:
                    query_list.extend(self.stat_gen.get_stat(key, value))

                else:
                    self.log.debug(f'Unspecified parameter for key {key} with value {value}')

            except Exception as e:
                self.err_update.add()
                self.log.exception(
                    f'Error occurred during query generation for key:{key}, value:{value}: {e}, {e.args}')
                self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)
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
