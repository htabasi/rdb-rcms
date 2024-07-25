from sys import argv
from threading import Thread
from time import sleep

from radio.radio import run


def commander():
    sleep(3)
    from radio.radio import _radio
    while _radio.is_alive():
        connection = {True: "Connected", False: "Not Connected"}.get(_radio.is_connect)
        try:
            items = input(f'{_radio.radio.name}: ({connection}) > ')
        except Exception as e:
            print(f'Error: {e}')
        else:
            if items in {'q', 'Q'}:
                print('Closing .........................')
                _radio.close()
                break
            try:
                items = items.upper().split()
                if len(items) == 2:
                    key, request = items
                    value = None
                else:
                    key, request, value = items
            except ValueError:
                pass
            else:
                _radio.sender.send(key, request, value, user_command=True)
        if _radio.is_alive():
            sleep(3)

    _radio.join()

radio_name = 'MSD_TX_V1M' if len(argv) == 1 else argv[1].upper()
cmd = Thread(target=commander, daemon=True)
cmd.start()

run(radio_name)
# cmd.join()
