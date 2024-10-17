from itertools import cycle
from multiprocessing import Process
from time import sleep
import os
import signal

from status.status import run

if __name__ == '__main__':
    prg = cycle(['=----', '-=---', '--=--', '---=-', '----=', '---=-', '--=--', '-=---'])

    p = Process(target=run, args=())
    p.start()
    while p.is_alive():
        # try:
        p.join(1.5)
        if p.is_alive():
            print(f'\rUpdater is working {next(prg)}', end='')
            sleep(0.5)
        # except KeyboardInterrupt:
        #     print(f'\rUpdater is closing {next(prg)}', end='')
        #     os.kill(p.pid, signal.SIGINT)

    p.join()
    print(f'\rUpdater is closed.')
