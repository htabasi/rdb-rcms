

class StatusDirector:
    '''
    Radio Module Status:
        Status = 0  ==> Radio Module is not defined         ==>     no color (background)
        Status = 1  ==> Radio Module is defined             ==>     white
        Status = 2  ==> Radio Module status is created      ==>     cyan
        Status = 3  ==> Radio Module status is running      ==>     green
        Status = 4  ==> Radio Module status is failed       ==>     light red
        Status = 5  ==> Radio Module status is stopping     ==>     dark red
        Status = 6  ==> Radio Module status is stopped      ==>     dark gray
    '''

    def __init__(self, panel, stations, log):
        """
            stations: {2: {'name': 'ANK', 'fc': 3},
                       6: {'name': 'BUZ', 'fc': 3},
                       7: {'name': 'BJD', 'fc': 3},
                       20: {'name': 'MSD', 'fc': 2}}
        """
        self.panel = panel
        self.log = log
        radio_status = {'connection': False, 'database': False, 'alive': False, 'status': 0}
        self.status = {}
        for code, d in stations.items():
            self.status[d['name']] = {
                f: {
                    'TXM': radio_status.copy(),
                    'TXS': radio_status.copy(),
                    'RXM': radio_status.copy(),
                    'RXS': radio_status.copy()
                } for f in range(1, d['fc'] + 1)
            }

        for station, station_frequencies in self.status.items():
            for frequency, frequency_radios in station_frequencies.items():
                for radio, status in frequency_radios.items():
                    self.panel.update_status(station, frequency, radio, 0, 0)

    def update_panel(self, station, frequency, radio):
        stat = self.status[station][frequency][radio]
        left = self.get_module_status(stat['alive'], stat['status'])
        right = self.get_radio_status(stat['connection'], stat['database'])
        self.log.debug(f'{self.__class__.__name__}: update_panel: {station},{frequency}{radio} => {left}, {right}')
        self.panel.update_status(station, frequency, radio, left, right)

    def radio_status(self, radio, station, date, category, alive, connection, database):
        '''
            connection & database == True            ==>     green
            connection == False & database == True   ==>     yellow
            database == False                        ==>     red
        '''
        frequency, radio = int(radio[8]), radio[4:6] + radio[-1]
        stat = self.status[station][frequency][radio]
        if alive is not None:
            stat['alive'] = alive

        if connection is not None:
            stat['connection'] = connection

        if database is not None:
            stat['database'] = database

        self.log.debug(f'{self.__class__.__name__}: radio_status: self.status[{station}][{frequency}][{radio}]={stat}')
        self.update_panel(station, frequency, radio)

    def module_status(self, radio, station, date, status):
        frequency, radio = int(radio[8]), radio[4:6] + radio[-1]
        self.status[station][frequency][radio]['status'] = status

        self.update_panel(station, frequency, radio)

    @staticmethod
    def get_radio_status(connection, database):
        if connection and database:
            return 1
        elif database:
            return 2
        else:
            return 3

    @staticmethod
    def get_module_status(alive, status):
        if status == 3 and not alive:
            return 4
        else:
            return status


