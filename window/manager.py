from threading import Thread
from time import sleep
from window.color import Colors
import unicurses as uc
from window.hotkey_controller import HotKeyController
from window.sub_window import TableWindow, StatusWindow, HotKeyWindow
from itertools import cycle


class RadioModuleStatus:
    def __init__(self, window: StatusWindow, end_pos):
        self.latest_status = {}
        self.window = window
        self.rotator = None
        self.led = chr(9608) + chr(9608)
        self.start_pos = end_pos - 78
        self.green, self.yellow, self.red = 15, 22, 8
        self.progress_rotator = cycle([f"{chr(9600)} ", f" {chr(9600)}", f" {chr(9604)}", f"{chr(9604)} "])
        self.rotator_color = cycle([15, 22, 36])
        self.all_modules = 0

    def set_radio_modules(self, radio_modules: list):
        for radio_module in radio_modules:
            self.latest_status[radio_module] = {
                'Alive': False,
                'RadioConnection': False,
                'DBStatus': False
            }
        self.rotator = cycle(radio_modules)
        self.all_modules = len(radio_modules)

    def update(self, radio, stat):
        self.latest_status[radio]['Alive'] = stat['Alive']
        self.latest_status[radio]['RadioConnection'] = stat['RadioConnection']
        self.latest_status[radio]['DBStatus'] = stat['DBStatus']

    def get_overall(self):
        alive, connect = 0, 0
        for stat in self.latest_status.values():
            alive += int(stat['Alive'] and stat['DBStatus'])
            connect += int(stat['RadioConnection'])
        return alive, connect

    def load_next(self):
        radio_name = next(self.rotator)

        if self.latest_status[radio_name]['Alive']:
            alive_color = self.green if self.latest_status[radio_name]['DBStatus'] else self.yellow
        else:
            alive_color = self.red
        connect_color = self.green if self.latest_status[radio_name]['RadioConnection'] else self.red
        alive, connect = self.get_overall()
        self.window.print_at(1, self.start_pos, 'Overall: ', 43)
        self.window.print_at(1, self.start_pos + 9, 'Alive ', 22)
        self.window.print_at(1, self.start_pos + 15, f'{alive:>3}', 36)
        self.window.print_at(1, self.start_pos + 18, f'/', 22)
        self.window.print_at(1, self.start_pos + 19, f'{self.all_modules:<3}', 36)
        self.window.print_at(1, self.start_pos + 23, 'Connect', 22)
        self.window.print_at(1, self.start_pos + 31, f'{connect:>3}', 36)
        self.window.print_at(1, self.start_pos + 34, f'/', 22)
        self.window.print_at(1, self.start_pos + 35, f'{self.all_modules:<3}', 36)
        self.window.print_at(1, self.start_pos + 39, 'Special: ', 43)
        self.window.print_at(1, self.start_pos + 48, radio_name, 15)
        self.window.print_at(1, self.start_pos + 59, 'Alive', 43)
        self.window.print_at(1, self.start_pos + 65, self.led, alive_color)
        self.window.print_at(1, self.start_pos + 68, 'Connect', 43)
        self.window.print_at(1, self.start_pos + 76, self.led, connect_color)
        self.window.print_at(1, self.start_pos + 79, next(self.progress_rotator), next(self.rotator_color))
        self.window.refresh()

    def get_connection_status(self):
        pass


class ManagerWindow(Thread):
    def __init__(self, termination_command, border=True):
        super().__init__(name='Manager Window Thread', daemon=False)
        self.running = [True]
        self.hotkey_controller = HotKeyController(self, self.running, termination_command)
        self.window = uc.initscr()
        uc.cbreak()
        uc.noecho()
        uc.curs_set(0)
        uc.keypad(self.window, True)
        if border:
            uc.wborder(self.window)
        if not uc.has_colors():
            print("This terminal does not support color!")

        uc.start_color()
        self.color = Colors()
        uc.bkgd(self.color.bg)

        self.lines, self.cols = uc.getmaxyx(self.window)
        y, x = uc.getmaxyx(self.window)
        if border:
            self.hotkey = HotKeyWindow(3, self.cols - 2, self.lines - 4, 1, 'HotKey', self.color)
            self.status = StatusWindow(3, self.cols - 2, self.lines - 7, 1, 'Status', self.color)
            self.table = TableWindow(y - 5, self.cols - 2, 1, 1, 'Table Box', self.color, self)
        else:
            self.hotkey = HotKeyWindow(3, self.cols, self.lines - 3, 0, 'HotKey', self.color)
            self.status = StatusWindow(3, self.cols, self.lines - 6, 0, 'Status', self.color)
            self.table = TableWindow(y - 7, self.cols, 1, 0, 'Table Box', self.color, self)

        self.hotkey.set_bg()
        self.status.set_bg()
        self.table.set_bg()

        self.hotkey.refresh()
        self.status.refresh()
        self.table.refresh()
        self.status_buffer = []
        self.modules = RadioModuleStatus(self.status, self.cols - 4)
        self.evaluation = False

        self.hotkey.draw()
        # self.status.print_in_middle('Status Window')
        # self.table.print_in_middle('Message Box Window')

    def set_title(self, text, center=False):
        x = (uc.getmaxx(self.window) - len(text)) // 2 if center else 2
        uc.wattron(self.window, self.color.title)
        uc.mvwaddstr(self.window, 0, x, text)
        uc.wattroff(self.window, self.color.title)

    def refresh(self):
        uc.wrefresh(self.window)
        uc.refresh()

    def set_modules(self, radio_modules):
        self.modules.set_radio_modules(radio_modules)

    def add_message(self, row):
        self.table.add(row)

    def add_next_stat(self, *args):
        self.status_buffer.append(args)

    def update_module(self, radio_name, stat):
        self.modules.update(radio_name, stat)

    def set_status_roll(self, task, count=None, deterministic=True):
        if deterministic:
            self.status.config_status_progress(task, count)
        else:
            self.status.config_evaluating_status(task)

    # def write_on_status(self, msg):
    #     self.status.print_at(1, 60, msg, 36)

    # def write_temp(self, msg):
    #     self.status.print_at(1, 100, msg, 29)

    def finish(self):
        self.running[0] = False

    def run(self):
        self.hotkey_controller.start()
        x = 20
        while self.running[0]:
            self.table.load_buffer()
            try:
                args = self.status_buffer.pop(0)
                self.status.set_progress(*args)
            except IndexError:
                pass
            if self.evaluation:
                if x == 0:
                    self.modules.load_next()
                    x = 20
                x -= 1
            # self.status.print_in_middle(self.status_message, 46)
            # self.set_evaluating_status()
            # print(f"\r{self.status_message}", end="")
            self.refresh()
            sleep(0.05)
        self.hotkey_controller.join()

        self.refresh()
        print('Finish')
        uc.endwin()

    def on_error_exit(self):
        self.running[0] = False
        uc.endwin()
