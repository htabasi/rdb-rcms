from dbdriver import get_connection, get_simple_column, get_available_stations
from radio import run
from sys import argv
from multiprocessing import Process
from time import sleep, time
from threading import Thread
import signal
import os
from platform import system
from group_command import GroupCommand

radio_process: dict
pids: dict
# =======       Manager PID is << 6588 >>       =======
message = '\n··· --- === <<< {:^40} >>> === --- ···\n'
_termination_command = [False]


def get_radio_names():
    stations = [item.upper() for item in argv[1:]]

    conn = get_connection()
    if len(stations) == 1 and stations[0].lower() != 'all':
        # Multiple row - Simple Column
        _radio_names = get_simple_column(conn, f"SELECT Radio_Name FROM Common.Radio WHERE Station_Code = "
                                               f"'{stations[0]}' ORDER BY Radio_Name;")
    else:
        if stations[0].lower() == 'all':
            stations = get_available_stations()

        # Multiple row - Simple Column
        _radio_names = get_simple_column(conn, f"SELECT Radio_Name FROM Common.Radio WHERE Station_Code IN "
                                               f"{tuple(stations)} ORDER BY Radio_Name;")
    return _radio_names


def create_and_run(radio_names):
    _radio_process = {}
    print(message.format('Creating and running radio modules'))
    for radio_name in radio_names:
        _radio_process[radio_name] = Process(target=run, args=(radio_name,), )

    for radio_name in _radio_process:
        _radio_process[radio_name].start()
        sleep(0.5)
        print(f'{radio_name} Radio Module Started')

    return _radio_process, {radio_name: _radio_process[radio_name].pid for radio_name in _radio_process}


def run_again_radio(radio_name):
    global radio_process, pids

    print(message.format(f'Warning: Create and run again {radio_name} radio module'))
    radio_process[radio_name] = Process(target=run, args=(radio_name,), )
    radio_process[radio_name].start()
    pids[radio_name] = radio_process[radio_name].pid


def evaluating_modules():
    global _termination_command

    alive_radio = []

    print(message.format('Evaluating Radio Modules'))
    while not _termination_command[0]:
        for radio_name in radio_process:
            if not radio_process[radio_name].is_alive():
                if radio_name in alive_radio:
                    print(f"{radio_name} with PID {pids[radio_name]} is NOT Alive.")
                    alive_radio.remove(radio_name)

                if not _termination_command[0]:
                    run_again_radio(radio_name)
                else:
                    break
            else:
                if radio_name not in alive_radio:
                    print(f"{radio_name} with PID {pids[radio_name]} is Alive.")
                    alive_radio.append(radio_name)

            sleep(0.1)

        sleep(0.2)


def close_all_processes():
    global radio_process, pids
    from itertools import cycle

    print(message.format('Closing All Radio Modules'))
    for radio_name in radio_process:
        if system() == 'Windows':
            os.kill(pids[radio_name], signal.CTRL_BREAK_EVENT)
        else:
            os.kill(pids[radio_name], signal.SIGINT)
        try:
            sleep(0.1)
        except KeyboardInterrupt:
            sleep(0.1)

        # radio_process[radio_name].kill()

    print(message.format('Wait to join Radio Modules'))
    waiting_progress = cycle(('[=      ]', '[==     ]', '[===    ]', '[ ===   ]', '[  ===  ]',
                              '[   === ]', '[    ===]', '[     ==]', '[      =]', '[       ]'))

    st = time()
    alive_processes = radio_names.copy()
    while alive_processes and time() - st < 120:
        for radio_name in radio_names:

            if radio_process[radio_name].is_alive():
                print(f'\rPlease wait for Exiting... {next(waiting_progress)}', end='')
                radio_process[radio_name].join(0.15)
            elif radio_name in alive_processes:
                    alive_processes.remove(radio_name)

    print(message.format('Try To Force kill remained radio modules'))

    while alive_processes:
        for radio_name in radio_names:
            if radio_name in alive_processes:
                if radio_process[radio_name].is_alive():
                    radio_process[radio_name].kill()
                elif radio_name in alive_processes:
                    alive_processes.remove(radio_name)



def _signal_handler(*args):
    _termination_command[0] = True


def interface(exit_command):
    while not exit_command[0]:
        try:
            command = input('Please Enter Command:\n')
        except EOFError:
            command = ''

        if command.lower() in ['q', 'quit', 'exit']:
            exit_command[0] = True
            break


if __name__ == '__main__':
    from duplication_controller import Controller
    controller = Controller('temp/.Manager.controller')
    if controller.allow:
        if len(argv) == 1:
            print('Please specified Station list.')
            exit()

        radio_names = get_radio_names()
    
        print(message.format(f"Manager PID is {os.getpid()}"))

        radio_process, pids = create_and_run(radio_names)

        Thread(target=interface, args=(_termination_command,), daemon=True).start()
        group_command_thread = GroupCommand(radio_names, _termination_command)
        group_command_thread.start()

        signal.signal(signal.SIGINT, _signal_handler)
        signal.signal(signal.SIGTERM, _signal_handler)
        if system() == 'Windows':
            signal.signal(signal.SIGBREAK, _signal_handler)

        evaluating_modules()
        group_command_thread.join()

        close_all_processes()

        controller.unlock()
    else:
        print(f'Another Manager App is Running!')

