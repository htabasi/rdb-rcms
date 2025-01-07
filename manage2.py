
import signal
from platform import system
from sys import argv
from time import sleep

from controller.controller import Controller
from director.message import MessageDirector, get_log
from director.radio import RadioModule
from director.status import StatusDirector
from execute import load_stations, load_radios
from director.display import PanelController

termination_command = [False]


class Manage:
    def __init__(self, pc, stations, log):
        self.status = StatusDirector(pc.panel, stations)
        self.message = MessageDirector()
        self.log = log

        # self.radio_names = load_radios(tuple(d['name'] for n, d in stations.items()))
        self.radio_names = ['MSD_TX_V1M', 'MSD_TX_V1S', 'MSD_RX_V1M', 'MSD_RX_V1S']
        self.rm = {}

    def create_radio_modules(self):
        for radio in self.radio_names:
            self.rm[radio] = RadioModule(radio, self.status, self.message, self.log)

    def start_radio_modules(self):
        for radio in self.radio_names:
            self.rm[radio].start()

    def stop_radio_modules(self):
        for radio in self.radio_names:
            self.rm[radio].stop()

    def wait_to_join(self):
        for radio in self.radio_names:
            self.rm[radio].join()

def main():
    if len(argv) == 1:
        print('Please specified Station list.')
        exit()
        # argv.append('BUZ')

    controller = Controller('temp/.Manager.controller')
    if controller.allow:
        log = get_log()
        # stations = {i + 1: d for i, d in enumerate(load_stations())}
        stations = {2: {'name': 'ANK', 'fc': 3}, 20: {'name': 'MSD', 'fc': 1}}
        pc = PanelController(stations)
        pc.start()
        log.info('Panel Controller Started')
        sleep(2)

        manager = Manage(pc, stations, log)
        log.info('Attempt to create Radio Modules')
        manager.create_radio_modules()
        sleep(2)
        log.info('Radio Modules Created')
        manager.start_radio_modules()
        pc.exit_function = manager.stop_radio_modules

        pc.join()

        controller.unlock()
    else:
        print(f'Another Manager App is Running!')

if __name__ == '__main__':
    main()