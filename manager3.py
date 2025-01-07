from sys import argv
from threading import Thread
from time import sleep

from controller.controller import Controller
from director.display import PanelController
from director.message import get_log, MessageDirector
from director.overseer import RadioModuleOverseer
from director.status import StatusDirector

keep_alive, manager_closed = [True], [False]


class Manager:
    def __init__(self, panel, stations, log):
        self.log = log
        self.status = StatusDirector(panel.panel, stations, log)
        self.keep_alive = True
        self.message = MessageDirector()
        self.overseer = RadioModuleOverseer(self.status, self.message, self.log)
        # self.radio_names = load_radios(tuple(d['name'] for n, d in stations.items()))
        self.radio_names = ['MSD_TX_V1M', 'MSD_TX_V1S', 'MSD_RX_V1M', 'MSD_RX_V1S']
        self.restart_modules, self.alive_modules = set(), set()
        self.rm = {rn: {'start': True, 'turning_off': False} for rn in self.radio_names}
        self.threads = []

    def stop(self):
        self.keep_alive = False
        self.log.debug(f'Stopping manager: self.keep_alive = {self.keep_alive}')

    def start(self):
        while self.keep_alive:
            self.log.debug(f'{self.__class__.__name__} Loop started. self.keep_alive={self.keep_alive}')
            for radio in self.radio_names:
                if self.rm[radio]['start'] and not self.rm[radio]['turning_off']:
                    self.overseer.radio_module_add(radio)
                    self.rm[radio]['start'] = False
                    sleep(1)

            for radio in self.radio_names:
                stat = self.overseer.update(radio)
                if stat == 'Restart':
                    self.restart(radio)
            sleep(1)

        self.log.debug('While Loop Finished')
        for radio in self.radio_names:
            self.overseer.stop(radio)
            sleep(0.02)

        self.log.debug('Exit Command Sent to all children')

        alive_modules = set(radio for radio in self.radio_names if self.overseer.is_alive(radio))
        need_to_kill = len(alive_modules) > 0
        while alive_modules:
            for radio in alive_modules:
                self.overseer.wait_to_join(radio)
            alive_modules = set(radio for radio in self.radio_names if self.overseer.is_alive(radio))
        else:
            if need_to_kill:
                self.log.debug('Alive children killed')

        self.message.close()
        self.log.debug('Manager Finished (Inside)')


    def restart(self, name):
        th = Thread(target=self.overseer.hard_restart, args=(name, self.rm[name]), name=f'{name}_Reset_Thread')
        self.threads.append(th)
        th.start()


def main():
    if len(argv) == 1:
        print('Please specified Station list.')
        exit()

    controller = Controller('temp/.Manager.controller', verbose=False)
    if not controller.allow:
        print(f'Another Manager App is Running!')
        return

    log = get_log()
    # stations = {i + 1: d for i, d in enumerate(load_stations())}
    stations = {2: {'name': 'ANK', 'fc': 3}, 20: {'name': 'MSD', 'fc': 1}}
    pc = PanelController(stations, log)
    pc.start()
    log.info('Panel Controller Started')

    manager = Manager(pc, stations, log)
    pc.set_stop_command(manager.stop)

    manager.start()

    log.info('Manager Finished (Outside)')
    pc.manager_is_closed()

    controller.unlock()


if __name__ == '__main__':
    main()