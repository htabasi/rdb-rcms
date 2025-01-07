import importlib
from datetime import datetime, UTC
from multiprocessing import Process, set_start_method, Pipe
from time import time, sleep

set_start_method('spawn', force=True)

Defined = 1
Created = 2
Running = 3
Failed = 4
Stopping = 5
Stopped = 6


class RadioModuleOverseer:
    def __init__(self, status, message, log):
        self.status = status
        self.message = message
        self.log = log
        self.modules = {}
        self.restart_waiting = 5
        self.close_waiting = 60
        self.hard_reset = False
        self.log.info(f'{self.__class__.__name__}: Initiated')
        # self.create_radio_module()

    def get_alive_message(self, name):
        return {'radio': name,
                'station': name[:3],
                'date': datetime.now(UTC),
                'category': 'Status',
                'alive': False,
                'connection': None,
                'database': None}

    def radio_module_add(self, name):
        station = name[:3]
        self.status.module_status(name, station, datetime.now(UTC), Defined)
        self.log.info(f'{name}: Creating Radio Module Process')
        radio_module = importlib.import_module('radio.radio')
        importlib.reload(radio_module)
        self.log.debug(f'{name}: Creating Radio Module Process')
        downward_portal_receiver, downward_portal_sender = Pipe()
        upward_portal_receiver, upward_portal_sender = Pipe()

        self.log.debug(f'{name}: Attempt to create Process')
        if name in self.modules and 'process' in self.modules[name]:
            self.modules[name]['process'].close()
            del self.modules[name]['process']

        process = Process(target=radio_module.run, args=(name, False, downward_portal_receiver, upward_portal_sender))
        self.status.module_status(name, station, datetime.now(UTC), Created)
        self.log.info(f'{name}: Creating Radio Module Process: Done')
        process.start()
        self.log.info(f'{name}: Starting Radio Module Process: Done')
        self.modules[name] = {'process': process, 'dws': downward_portal_sender, 'uwr': upward_portal_receiver,
                              'station': name[:3], 'close_command': None}

    def update(self, name):
        self.log.info(f'{name}: Evaluating')
        process, uwp_receiver = self.modules[name]['process'], self.modules[name]['uwr']
        station = self.modules[name]['station']
        alive = process.is_alive()
        self.log.info(f'{name}: Evaluating -> process.is_alive() = {alive}')
        self.status.module_status(name, station, datetime.now(UTC), Running)
        while uwp_receiver.poll():
            message = uwp_receiver.recv()
            self.log.info(f'{name}: Evaluating -> Message Received: {message}')

            if message['category'] == 'Status':
                self.status.radio_status(**message)
                if message['alive'] is not None:
                    alive = message['alive']
            else:
                self.message.register(**message)

        self.log.info(f'{name}: Evaluating -> Portal Check Finished')
        if not (process.is_alive() and alive):
            self.log.info(f'{name}: Evaluating -> Failed (process.is_alive()={process.is_alive()} alive={alive})')
            self.status.radio_status(**self.get_alive_message(name))
            self.status.module_status(name, station, datetime.now(UTC), Failed)
            return 'Restart'

    def is_alive(self, name):
        return self.modules[name]['process'].is_alive()

    def soft_restart(self, name):
        self.modules[name]['dws'].send('restart')

    def hard_restart(self, name, stat):
        stat['turning_off'] = True
        station = self.modules[name]['station']
        self.status.module_status(name, station, datetime.now(UTC), Stopping)
        self.stop(name)
        while self.modules[name]['process'].is_alive():
            self.wait_to_join(name)
            self.modules[name]['process'].join(timeout=1)

        self.status.module_status(name, station, datetime.now(UTC), Stopped)
        sleep(self.restart_waiting)
        stat['turning_off'] = False
        stat['start'] = True

    def stop(self, name):
        station = self.modules[name]['station']
        self.status.module_status(name, station, datetime.now(UTC), Stopping)
        self.modules[name]['close_command'] = time()
        self.modules[name]['dws'].send('exit')

    def wait_to_join(self, name):
        command, process = self.modules[name]['close_command'], self.modules[name]['process']
        station = self.modules[name]['station']

        self.log.debug(f'{self.__class__.__name__}: {name} wait_to_join: Time elapsed={time() - command:.3f}, Alive={process.is_alive()}')
        if process.is_alive():
            if time() - command >= self.close_waiting:
                process.kill()

            self.modules[name]['process'].join(timeout=0.5)
        else:
            self.status.module_status(name, station, datetime.now(UTC), Stopped)
