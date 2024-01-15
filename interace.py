from colorama import init, Fore, Style, Back
from threading import Thread
from platform import system
from itertools import cycle
from time import sleep


class StatusMonitor(Thread):
    def __init__(self, status_array, error_array, continue_command):
        super(StatusMonitor, self).__init__(name='Status_Monitor', daemon=True)
        if system() == 'Windows':
            init(convert=True)

        self.status_array, self.error_array = status_array, error_array
        self.continue_command = continue_command
        self.daemon = True

        # self.progressbar_bg = chr(9617)
        # self.progressbar_fg = chr(9608)
        self.on = f"{chr(9608) * 2}"
        self.off = f"{chr(9617) * 2}"

        self.on_char = f"{Fore.LIGHTGREEN_EX}{self.on}"
        self.off_char = f"{Fore.LIGHTRED_EX}{self.on}"
        self.stat = {False: self.off_char, True: self.on_char}
        fly = Fore.LIGHTYELLOW_EX
        flr = Fore.LIGHTRED_EX

        self.multi_stat = {
            0: f"{Fore.LIGHTRED_EX}{self.on}",
            1: f"{Fore.LIGHTRED_EX}{self.on}",
            2: f"{Fore.LIGHTYELLOW_EX}{self.on}",
            3: f"{Fore.LIGHTGREEN_EX}{self.on}"
        }
        r = Style.RESET_ALL

        self.counter = {'RX': 0, 'TX': 0, 'LOG': 0}
        self.die_detect = {'RX': False, 'TX': False, 'LOG': False}
        self.die_time = {'RX': 0, 'TX': 0, 'LOG': 0}
        self.rotator = cycle([f"{Fore.LIGHTYELLOW_EX}{chr(9600)} {r}", f"{Fore.LIGHTGREEN_EX} {chr(9600)}{r}",
                              f"{Fore.LIGHTYELLOW_EX} {chr(9604)}{r}", f"{Fore.LIGHTGREEN_EX}{chr(9604)} {r}"])

        self.max_rotator_stop = 2
        self.rotator_stop = self.max_rotator_stop
        self.rotate = next(self.rotator)

        # self.status = f"RX {{}}{{:^7.3f}}{r} CON: {{:2}}{r} ACS: {{:2}}{r} SQ: {{:2}}{r} RSSI: {{}}{{:^4}}{r} {{}}{r} | Log {{}} {{:>5}}{r}\r"
        self.status = f"{fly}RAD{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}TXC{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}RXD{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}GEN{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}DBC{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}INT{r} {{}}{r} {flr}{{{{:<5}}}}{r} " \
                      f"{fly}ANL{r} {{}}{r} {flr}{{{{:<5}}}}{r}"

    def run(self) -> None:
        while self.continue_command[0]:
            sleep(sleep_time)
            line = self.status.format(*[self.stat.get(stat) for stat in self.status_array]).format(*self.error_array)
            print("\r" + line + f"{next(self.rotator)}", end="")


def simulate(stat, err, cc):
    from random import randint

    while cc[0]:
        for i in range(8):
            stat[i] = randint(0, 1)
            err[i] = randint(0, 65535)

        sleep(sleep_time)


if __name__ == '__main__':
    import numpy as np

    continue_command = [True]
    sleep_time = 1

    status = np.array([0] * 8, dtype='?')  # ? == numpy.bool8
    errors = np.array([0] * 8, dtype='H')  # H == numpy.uint16
    sim = Thread(target=simulate, args=(status, errors, continue_command), daemon=True)
    stm = StatusMonitor(status, errors, continue_command)

    sim.start()
    stm.start()

    while continue_command[0]:
        ui = input('\nEnter Q for exit.\n')

        if ui.lower() == 'q':
            continue_command[0] = False

    sim.join()
    stm.join()
