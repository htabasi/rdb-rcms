import importlib
from datetime import datetime, UTC
from multiprocessing import Process, Queue, set_start_method
from queue import Empty
from threading import Thread
from time import time, sleep


set_start_method('spawn', force=True)

Defined = 1
Created = 2
Running = 3
Failed = 4
Stopping = 5
Stopped = 6


class RadioModule(Thread):
    process: Process
    portal: Queue
    pid = None

    def __init__(self, name, status, message, log):
        super(RadioModule, self).__init__(name=name)
        self.keep_alive = True
        self.status = status
        self.message = message
        self.log = log
        self.station = self.name[:3]
        self.status.module_status(self.name, self.station, datetime.now(UTC), Defined)
        self.calm, self.restart_waiting = 1, 5
        self.hard_reset = False
        self.alive_message = {'radio': self.name,
                              'station': self.name[:3],
                              'date': datetime.now(UTC),
                              'category': 'Status',
                              'alive': False,
                              'connection': None,
                              'database': None}
        self.log.info(f'{self.name}: Initiated')
        # self.create_radio_module()

    def create_radio_module(self):
        self.log.info(f'{self.name}: Creating Radio Module Process')
        radio_module = importlib.import_module('radio.radio')
        importlib.reload(radio_module)
        self.log.debug(f'{self.name}: Creating Radio Module Process')
        self.portal = Queue()
        self.log.debug(f'{self.name}: Attempt to create Process')
        self.process = Process(target=radio_module.run, args=(self.name, False, self.portal))
        self.status.module_status(self.name, self.station, datetime.now(UTC), Created)
        self.log.info(f'{self.name}: Creating Radio Module Process: Done')

    def run(self):
        self.log.info(f'{self.name}: RM Thread Started')
        while self.keep_alive:
            self.create_radio_module()
            self.process.start()
            self.log.info(f'{self.name}: RM Process Started')
            self.status.module_status(self.name, self.station, datetime.now(UTC), Running)

            self.log.info(f'{self.name}: RM Process Evaluating')
            self.evaluate()

            self.log.info(f'{self.name}: RM Process closing')
            self.status.module_status(self.name, self.station, datetime.now(UTC), Stopping)
            self.close()
            self.log.info(f'{self.name}: RM Process closed')
            if self.keep_alive:
                sleep(self.restart_waiting)

        self.status.module_status(self.name, self.station, datetime.now(UTC), Stopped)
        self.log.info(f'{self.name}: RM Thread finished')

    def evaluate(self):
        while self.keep_alive:
            alive = True
            try:
                message = self.portal.get(block=True, timeout=0.5)
            except Empty as e:
                pass
            else:
                if message['category'] == 'Status':
                    self.status.radio_status(**message)
                    if message['alive'] is not None:
                        alive = message['alive']
                else:
                    self.message.register(**message)

            if not self.process.is_alive():
                self.alive_message['date'] = datetime.now(UTC)
                self.status.radio_status(**self.alive_message)
                self.status.module_status(self.name, self.station, datetime.now(UTC), Failed)
                break

            if self.hard_reset or not alive:
                self.status.module_status(self.name, self.station, datetime.now(UTC), Stopping)
                self.portal.put('exit')
                self.close()
                self.status.module_status(self.name, self.station, datetime.now(UTC), Stopped)
                self.create_radio_module()
                self.status.module_status(self.name, self.station, datetime.now(UTC), Created)
                self.process.start()
                self.status.module_status(self.name, self.station, datetime.now(UTC), Running)
                sleep(self.restart_waiting)
                self.hard_reset = False

            sleep(self.calm)

    def stop(self):
        self.portal.put('exit')
        self.keep_alive = False

    def soft_restart(self):
        self.portal.put('restart')

    def hard_restart(self):
        self.hard_reset = True

    def close(self, waiting=120):
        t = time()

        while self.process.is_alive() and time() - t < waiting:
            self.process.join(2)

        if self.process.is_alive():
            self.process.kill()

        del self.process
