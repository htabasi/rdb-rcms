from datetime import datetime


class StatGenerator:
    def __init__(self, health):
        self.health = health
        self.key_list = {
            'GRDS': self.access,
            'SCSL': self.session,
            'GRCS': self.cbit_level,
            'RCMV': self.voltage,
            'RCTP': self.temperature,
            'GRTI': self.time_date,
            'GRSV': self.software,
            'GRLO': self.display_name
        }
        self.mip = self.health.radio.socket.getsockname()[0]
        TX = self.health.radio.radio.type == 'TX'
        self.bat = 'TXBatteryVoltage' if TX else 'RXBatteryVoltage'
        self.dcs = 'TXDCSectionVoltage' if TX else 'RXDCSectionVoltage'
        self.pat = 'TXPowerAmplifierTemperatures' if TX else 'RXPowerAmplifierTemperatures'
        self.pst = 'TXPowerSupplyTemperatures' if TX else 'RXPowerSupplyTemperatures'
        self.rmt = 'TXRadioModuleTemperatures' if TX else 'RXRadioModuleTemperatures'

    def get_stat(self, key, value):
        return self.key_list[key](value)

    def access(self, value: str):
        """GRDS"""
        acs = int(value[2:].split(',')[-1])
        return [self.health.parameters['Access'].update(acs)]

    def session(self, value: str):
        """SCSL"""
        sessions = int(value[0]) - 1
        sl = [part.replace('::', '').replace('"', '').split(',') for part in value.split(',3,"')[2:]]
        ips = {ip: int(stp) for ip, cl, stp in sl}
        if self.mip in ips:
            my_session_type = ips.pop(self.mip)
        else:
            self.health.log.warning(f'My Session Not Found: ips={ips}')
            my_session_type = 0
        other_session_type = max(ips.values())

        return [self.health.parameters['Session'].update(sessions),
                self.health.parameters['MySessionType'].update(my_session_type),
                self.health.parameters['OtherSessionType'].update(other_session_type)]

    def cbit_level(self, value: str):
        """GRCS"""
        if value == '0':
            level = 0
        else:
            level = max([int(line.split(',')[-1]) for line in value.split(',3,')[1:]])
        return [self.health.parameters['CBITLevel'].update(level)]

    def voltage(self, value: str):
        bat, dcs = map(float, value[2:].split(','))
        return [self.health.parameters[self.bat].update(bat),
                self.health.parameters[self.dcs].update(dcs)]

    def temperature(self, value: str):
        rmt, pst, pat = map(int, value[2:].split(','))
        return [self.health.parameters[self.rmt].update(rmt),
                self.health.parameters[self.pst].update(pst),
                self.health.parameters[self.pat].update(pat)]

    def time_date(self, value: str):
        now = datetime.now().timestamp()
        radio_time = datetime.strptime(value.replace('"', ''), '%Y/%m/%d %H:%M:%S').timestamp()
        return [self.health.parameters['RTCTimeAndDate'].update(now - radio_time)]

    def software(self, value: str):
        booted, v1, p1, v2, p2 = value.replace('"', '').split(',')[1:]
        return [self.health.parameters['PartitionVersions1'].update(v1),
                self.health.parameters['PartitionVersions2'].update(v2)]

    def display_name(self, value: str):
        dsn = value.replace('"', '').split(',')[2]
        return [self.health.parameters['DisplayedName'].update(dsn)]
