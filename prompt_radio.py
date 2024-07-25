from sys import argv
from radio.radio import Radio
from time import sleep

radio_name = 'MSD_TX_V1M' if len(argv) == 1 else argv[1].upper()

_radio = Radio(radio_name, single_mode=True)
_radio.start()
sleep(2)

while True:
    items = input(f'{_radio.radio.name}: ({ {True: "Connected", False: "Not Connected"}.get(_radio.is_connect)}) > ')
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

_radio.join()
