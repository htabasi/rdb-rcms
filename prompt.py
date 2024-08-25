from sys import argv
from core.identity import RadioIdentity, RX, TX
from log.logger import get_core_loggers
from core.core import Core
from time import sleep

radio_name = 'MSD_TX_V1M' if 'm' in argv[1:] else 'MSD_TX_V1S'
_ip = {'MSD_TX_V1M': '192.168.16.11', 'MSD_TX_V1S': '192.168.16.21'}.get(radio_name)
# radio_name, ip = 'AWZ_TX_V3M', '192.168.1.13'

station, fn = radio_name[:3], int(radio_name[8])
rt = {'RX': RX, 'TX': TX}.get(radio_name[4:6])
ms = {'M': 0, 'S': 1}.get(radio_name[-1])
identity = RadioIdentity(0, radio_name, station, fn, 0, rt, ms, _ip)
_logs = get_core_loggers(identity.name)

_radio = Core(identity, _logs)
_radio.start()
sleep(2)

while True:
    items = input(f'{identity.name}: ({ {True: "Connected", False: "Not Connected"}.get(_radio.is_connect)}) > ')
    if items in {'q', 'Q'}:
        print('Closing .........................')
        _radio.close()
        break
    elif items.upper() == 'IP':
        ip, port = _radio.socket.getsockname()
        print(ip, type(ip))
        print(port, type(port))
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
