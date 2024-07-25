RX, TX = 0, 1


class RadioIdentity:
    def __init__(self, _id, name, station, frequency_no, sector_id, radio_type, main_standby, ip):
        # id, Name, Station, Frequency_No, Sector, RadioType, MainStandBy, IP
        self.ip = ip
        self.radio_code = radio_type
        if self.radio_code == RX:
            self.port = 8001
            self.type = 'RX'
        else:
            self.port = 8002
            self.type = 'TX'

        self.station = station
        self.frequency = frequency_no
        self.sector = sector_id
        self.position = {0: 'M', 1: 'S'}.get(main_standby)
        self.id = _id
        self.name = name
