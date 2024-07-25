import os
import queue
import signal
from datetime import datetime
from multiprocessing import Process, Queue
from platform import system
from sys import argv
from time import sleep, time

from controller.controller import Controller
from execute import get_connection, get_file, get_simple_column, get_available_stations
from radio.radio import run
from settings import SQL_SELECT
from window import CRIT, ERROR, WARN, INFO, SUCCESS
from window.manager import ManagerWindow
from window.presenter import Row

termination_command = [False]


class RadioModule:
    process: Process
    queue: Queue
    pid = None
    alive = False

    def __init__(self, name, interface: ManagerWindow, exit_command: list):
        self.interface = interface
        self.name = name
        self.exit_command = exit_command
        self.first_announce = True
        self.prev_alive_counter = None
        self.status = {
            'UpdateTime': datetime.utcnow(),
            'Alive': False,
            'RadioConnection': False,
            'DBStatus': False
        }
        self.alive_easy_going, self.connect_easy_going = 120, 120
        self.alive_timer_start, self.connect_timer_start = None, None
        self.connection_reported, self.disconnection_reported = False, False
        self.queue_counter, self.queue_counter_prev = 0, 0
        # self.file = open(f'export/test_{name}.log', 'w')

    def send_message(self, level, category, sender, message):
        dt = datetime.utcnow()
        self.interface.add_message(Row(level, category, sender, message, dt))

    def create_process(self):
        self.queue = Queue()
        self.process = Process(target=run, args=(self.name, False, self.queue))

    def start(self):
        self.process.start()
        self.pid = self.process.pid
        self.alive = self.process.is_alive()

    def evaluate(self):
        self.status['Alive'] = self.process.is_alive()
        if not self.process.is_alive():
            if self.alive:
                self.send_message(ERROR, 'Alive', 'Radio Module', f"{self.name} with PID {self.pid} is NOT Alive.")
                self.alive = False

            if not self.exit_command[0]:
                self.create_process()
                self.start()
                self.first_announce = True
        else:
            if self.first_announce:
                self.send_message(INFO, 'Alive', 'Radio Module', f"{self.name} with PID {self.pid} is Alive.")
                self.first_announce = False
            self.alive_timer_start = time()
            self.alive_action()

    def alive_action(self):
        try:
            module_stat = self.queue.get(block=True, timeout=0.3)
        except queue.Empty:
            pass
            # self.send_message(WARN, 'Alive', 'Radio Module', f"{self.name} Empty Status Received")
        else:
            # self.file.write(f"{module_stat.values()}\n")
            # dt = module_stat['UpdateTime']
            # av = module_stat['Alive']
            # rc = module_stat['RadioConnection']
            # dc = module_stat['DBStatus']
            # self.send_message(WARN, 'Alive', 'Radio Module', f"Alive={av}")

            alive_message = {True: 'Is Alive', False: 'Is Not Alive'}
            connection_message = {True: 'Connected Successfully', False: 'Disconnected'}
            db_message = {True: 'Database OK', False: 'Database Is Not OK'}

            if self.status['Alive'] != module_stat['Alive']:
                msg = alive_message.get(module_stat['Alive'])
                severity = {True: INFO, False: ERROR}.get(module_stat['Alive'])
                self.send_message(severity, 'Alive', 'Radio Module', f'{self.name} {msg}')
                self.status['Alive'] = module_stat['Alive']

            if self.status['RadioConnection'] != module_stat['RadioConnection']:
                msg = connection_message.get(module_stat['RadioConnection'])
                severity = {True: SUCCESS, False: WARN}.get(module_stat['RadioConnection'])
                self.send_message(severity, 'Connection', 'Radio Module', f'{self.name} {msg}')
                self.status['RadioConnection'] = module_stat['RadioConnection']

            if self.status['DBStatus'] != module_stat['DBStatus']:
                msg = db_message.get(module_stat['DBStatus'])
                severity = {True: INFO, False: ERROR}.get(module_stat['DBStatus'])
                self.send_message(severity, 'Alive', 'Radio Module', f'{self.name} {msg}')
                self.status['DBStatus'] = module_stat['DBStatus']

            # dt, av, rc, dc = tuple(module_stat.values())
            # if (datetime.utcnow() - dt).seconds < 60:
                # self.status['Alive'] = self.process.is_alive()
            # self.status['Alive'] = av
            # self.status['Connected'] = rc
            # self.status['DBStatus'] = dc

            # self.send_message(WARN, 'Alive', 'Radio Module', f"{self.name}{(av, rc, dc)}")

    #
    # def connection_action(self):
    #     self.status['IsConnect'] = self.is_connect.value
    #     if self.is_connect.value:
    #         if not self.connection_reported:
    #             self.send_message(SUCCESS, 'Connection', 'Radio Module', f"{self.name} Successfully Connect")
    #             self.connection_reported = True
    #             self.disconnection_reported = False
    #     else:
    #         if not self.disconnection_reported:
    #             self.send_message(WARN, 'Connection', 'Radio Module', f"{self.name} Connection Failed")
    #             self.disconnection_reported = True
    #             self.connection_reported = False

    def close(self):
        # self.file.close()
        self.send_message(INFO, 'Alive', 'Radio Module', f"{self.name} Sending Close Signal")
        if system() == 'Windows':
            os.kill(self.pid, signal.CTRL_BREAK_EVENT)
        else:
            os.kill(self.pid, signal.SIGINT)

    def wait_to_close(self):
        if self.process.is_alive():
            self.process.join(0.15)
        self.alive = self.process.is_alive()

    def force_close(self):
        self.send_message(ERROR, 'Alive', 'Radio Module', f"{self.name} Killing")
        if self.process.is_alive():
            self.process.kill()
        self.alive = self.process.is_alive()


class Manager:
    window: ManagerWindow
    alive_modules: list

    def __init__(self, window, stations: list):
        global termination_command
        self.exit_command = termination_command

        self.window = window
        self.window.set_title(" Iran RCMS Radio Modules Manager ", True)

        self.send_message(INFO, 'Manager', 'Manager', f"Manager PID is {os.getpid()}")
        self.send_message(INFO, 'Manager', 'Manager', 'Loading radio names')

        self.connection = get_connection()
        if self.connection is None:
            self.send_message(CRIT, 'Manager', 'Manager', "Database Connection Error! Manager will exit!")
            self.exit_command[0] = True
            return

        self.radio_names = self.get_radio_names(stations)
        self.send_message(SUCCESS, 'Manager', 'Manager', "All radio names Loaded successfully")
        self.window.set_modules(self.radio_names)
        self.radio_modules = {}
        self.send_message(INFO, 'Manager', 'Manager', 'Creating radio modules')
        self.create_radio_modules()

        self.send_message(INFO, 'Manager', 'Manager', 'Running radio modules')
        self.run_radio_modules()
        # self.start_group_commander()

    def send_message(self, level, category, sender, message):
        dt = datetime.utcnow()
        self.window.add_message(Row(level, category, sender, message, dt))

    def get_radio_names(self, stations):
        simple_station_query = get_file(os.path.join(SQL_SELECT, 'radio_simple_station.sql'))
        multiple_station_query = get_file(os.path.join(SQL_SELECT, 'radio_multiple_station.sql'))

        if len(stations) == 1 and stations[0] != 'ALL':
            _radio_names = get_simple_column(self.connection, simple_station_query.format(stations[0]))
        else:
            if stations[0] == 'ALL':
                stations = get_available_stations()
            _radio_names = get_simple_column(self.connection, multiple_station_query.format(tuple(stations)))
        return _radio_names

    def create_radio_modules(self):
        self.window.set_status_roll(f'Create Radio Modules', len(self.radio_names) - 1)
        for i, radio_name in enumerate(self.radio_names):
            self.radio_modules[radio_name] = RadioModule(radio_name, self.window, self.exit_command)
            self.radio_modules[radio_name].create_process()
            self.window.add_next_stat(radio_name, i)

    def run_radio_modules(self):
        self.window.set_status_roll(f'Running Radio Modules', len(self.radio_names) - 1)
        for i, [radio_name, radio_module] in enumerate(self.radio_modules.items()):
            radio_module.start()
            self.send_message(INFO, 'Alive', 'Manager', f'{radio_name} Radio Module Started')
            self.window.add_next_stat(radio_name, i)
            sleep(0.5)

    def evaluate_radio_modules(self):
        self.window.evaluation = True
        self.send_message(INFO, 'Manager', 'Manager', 'Evaluating Radio Modules')
        self.window.set_status_roll('Evaluating Radio Modules', deterministic=False)
        while not self.exit_command[0]:
            for radio_name, radio_module in self.radio_modules.items():
                radio_module.evaluate()
                self.window.update_module(radio_name, radio_module.status)
                sleep(0.1)

            sleep(1)

        self.window.evaluation = False
        # self.group_commander.join()

    def close_all_radio_modules(self):
        self.close_radio_modules()
        self.waiting_to_close()
        self.kill_alive_radio_modules()
        self.send_message(SUCCESS, 'Manager', 'Manager', 'All radio Closed')

    def close_radio_modules(self):
        self.send_message(WARN, 'Manager', 'Manager', 'Closing All Radio Modules')
        self.window.set_status_roll(f'Closing Radio Modules', len(self.radio_names) - 1)
        for i, [radio_name, radio_module] in enumerate(self.radio_modules.items()):
            radio_module.close()
            self.window.add_next_stat(radio_name, i)
            try:
                sleep(0.1)
            except KeyboardInterrupt:
                sleep(0.1)

    def waiting_to_close(self):
        self.send_message(INFO, 'Manager', 'Manager', 'Wait to join Radio Modules')
        self.window.set_status_roll(f'Please wait for Exiting', deterministic=False)
        # from itertools import cycle
        # waiting_progress = cycle(('[=      ]', '[==     ]', '[===    ]', '[ ===   ]', '[  ===  ]',
        #                           '[   === ]', '[    ===]', '[     ==]', '[      =]', '[       ]'))

        from time import time
        st = time()
        self.alive_modules = self.radio_names.copy()
        while self.alive_modules and time() - st < 120:
            for radio_name in self.alive_modules:
                # self.window.add_next_stat()
                # self.window.set_status(f'Please wait for Exiting... {next(waiting_progress)}')
                # print(f'Please wait for Exiting... {next(waiting_progress)}')
                self.radio_modules[radio_name].wait_to_close()
                if not self.radio_modules[radio_name].alive:
                    self.alive_modules.remove(radio_name)
        self.send_message(SUCCESS, 'Manager', 'Manager', 'All Radio Modules are closed successfully')

    def kill_alive_radio_modules(self):
        if self.alive_modules:
            self.send_message(WARN, 'Manager', 'Manager', 'Try To Force kill remained radio modules')
            self.window.set_status_roll('Try To Force kill remained radio modules', len(self.alive_modules) - 1)

        while self.alive_modules:
            for i, [radio_name, radio_module] in enumerate(self.radio_modules.items()):
                self.window.add_next_stat(radio_name, i)
                if radio_name in self.alive_modules:
                    radio_module.force_close()
                    if not radio_module.alive:
                        self.alive_modules.remove(radio_name)


_manager: Manager


def _signal_handler(*args):
    global _manager
    try:
        _manager.send_message(INFO, 'HotKey', 'Signal Handler', f'Exit: {args}')
    except NameError:
        pass
    termination_command[0] = True


def main():
    if len(argv) == 1:
        print('Please specified Station list.')
        exit()
        # argv.append('BUZ')

    controller = Controller('temp/.Manager.controller')
    if controller.allow:
        # def finish_command():
        #     termination_command[0] = True

        manager_window = ManagerWindow(_signal_handler, border=False)
        manager_window.start()

        _manager = Manager(manager_window, [station.upper() for station in argv[1:]])
        if not termination_command[0]:
            signal.signal(signal.SIGINT, _signal_handler)
            signal.signal(signal.SIGTERM, _signal_handler)
            if system() == 'Windows':
                signal.signal(signal.SIGBREAK, _signal_handler)

            _manager.evaluate_radio_modules()
            _manager.close_all_radio_modules()

            manager_window.finish()
            manager_window.join()
        else:
            manager_window.on_error_exit()
            manager_window.join()

        controller.unlock()
    else:
        print(f'Another Manager App is Running!')


def create_test_items(mw: ManagerWindow):
    sleep(1)

    mw.add_message(Row('Information', 'Connection', 'Radio Module', 'BUZ_RX_V1M Radio connected!'))
    sleep(0.05)
    mw.add_message(Row('Error', 'Connection', 'Radio Module', 'BUZ_RX_V1M Radio connected!'))
    sleep(0.05)
    mw.add_message(Row('Information', 'Connection', 'Radio Module', 'BUZ_RX_V1M Radio connected!'))
    sleep(0.05)
    mw.add_message(Row('Warning', 'Connection', 'Radio Module', 'BUZ_RX_V1M Radio connected!'))
    sleep(0.05)


if __name__ == '__main__':
    # main = ManagerWindow(border=False)
    # main = MainWindow()
    # main.set_title(" Iran RCMS Radio Modules Manager ", True)
    # main.start()
    # create_test_items(main)
    #
    # f.close()
    # main.join()
    # uc.endwin()
    main()
