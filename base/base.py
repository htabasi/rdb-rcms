from threading import Thread
from socket import socket
from time import sleep
from datetime import datetime

from base.aggregator import Aggregator
from .keeper import BaseKeeper
from .reception import BaseReception


class Base(Thread):
    socket: socket
    keeper: BaseKeeper
    reception: BaseReception
    connector: Thread

    def __init__(self, ip: str, port: int, name: str, logs):
        super().__init__(name=f'{name}_Radio_Connection_Thread')
        self.ip, self.port, self.radio_name = ip, port, name

        self.is_connect = False
        self.keep_alive = True
        self.need_to_check = False
        self.logs = logs
        self.log = logs['Core']

        self.try_to_connect_interval = 60  # Second
        self._check_period = 1.0
        self._counter_max, self.keeper_max = 60, 8
        self._counter_max_on_disconnect = self._counter_max // 5
        self._ping_timeout = 20
        self._first_com_id = 10
        self._last_com_id = 999
        self._com_id = self._first_com_id
        self.ref_time = self.log_start = datetime.utcnow().timestamp()
        self.connect_time = Aggregator('ConnectTimeSec', float)
        self.disconnect_time = Aggregator('DisconnectTimeSec', float)
        self.log.debug('init: Start')
        self.check_period = 1
        self.ping_timeout = 20

        self.connect_logged = self.disconnect_logged = False
        self.ping_counter, self.ping_counter_disconnection_threshold = 0, 3
        self.connect_counter = Aggregator('CntConnect')
        self.disconnect_counter = Aggregator('CntDisconnect')
        self.snd_packet = Aggregator('CntSentPacket')
        self.err_send = Aggregator('CntErrorPacketSending')
        self.err_connect = Aggregator('CntErrorConnection')
        self.alive_counter, self.alive_counter_prev = 0, -1

    @property
    def command_id(self):
        self._com_id += 1
        if self._com_id >= self._last_com_id:
            self._com_id = self._first_com_id
        return self._com_id

    @property
    def check_period(self):
        return self._check_period

    @check_period.setter
    def check_period(self, p):
        self._check_period = p
        self._counter_max = int(self.try_to_connect_interval / p)
        self._counter_max_on_disconnect = self._counter_max // 5
        self.keeper_max = int(0.4 * self.ping_timeout / p)

    @property
    def ping_timeout(self):
        return self._ping_timeout

    @ping_timeout.setter
    def ping_timeout(self, t):
        self._ping_timeout = t
        self.keeper_max = int(0.4 * t / self.check_period)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        # self.log.info(f'Status: Status Update: {self.alive_counter} != {self.alive_counter_prev} => {stat}')

        self.alive_counter_prev = self.alive_counter
        return stat

    def send(self, msg):
        self.snd_packet.add()
        try:
            self.socket.send(f"\n{msg}\r".encode())
        except Exception as e:
            self.err_send.add()
            self.log.warning(f'Send: Sending Error: {e.__class__.__name__} {e.args}')

    def set_counters(self, aggregate, resettable):
        self.connect_counter.set(aggregate, resettable)
        self.disconnect_counter.set(aggregate, resettable)
        self.snd_packet.set(aggregate, resettable)
        self.err_send.set(aggregate, resettable)
        self.err_connect.set(aggregate, resettable)

    def set_timers(self, aggregate, resettable):
        self.connect_time.set(aggregate, resettable)
        self.disconnect_time.set(aggregate, resettable)

    def event_on_connect(self, time_tag):
        self.update_timers(connect=False)
        if not self.connect_logged:
            self.log.info('On Connect: Connected')
            self.connect_logged, self.disconnect_logged = True, False
        self.is_connect = True
        self.ping_counter = 0
        self.keeper = BaseKeeper(self, self.radio_name, self.logs['BaseKeeper'])
        self.reception = BaseReception(self, self.radio_name, self.logs['BaseReception'])
        self.keeper.start()
        self.reception.start()
        self.connect_counter.add()

    def event_on_disconnect(self, time_tag, update_connect_time=True):
        self.update_timers(update_connect_time)
        if not self.disconnect_logged:
            self.log.warning('On Disconnect: Disconnected')
            self.connect_logged, self.disconnect_logged = False, True
        self.is_connect = False
        if hasattr(self, 'keeper'):
            self.keeper.event_on_disconnect()
        if hasattr(self, 'reception'):
            self.reception.event_on_disconnect()
        self.socket.close()
        self.log.info('Socket closed.')
        self.disconnect_counter.add()

    def update_timers(self, connect: bool):
        now = datetime.utcnow().timestamp()
        if connect:
            self.connect_time.add(now - self.ref_time)
        else:
            self.disconnect_time.add(now - self.ref_time)
        self.ref_time = now
        self.log.debug('Timer: Connect: {self.connect_time:.3f} | Disconnect: {self.disconnect_time:.3f}')

    def update_status_when_disconnect(self):
        pass

    def connect(self, log):
        log.debug('Start')
        self.socket = socket()
        try:
            self.socket.connect((self.ip, self.port))
            log.debug('Radio Connected')
        except (TimeoutError, OSError) as e:
            self.err_connect.add()
            self.event_on_disconnect(datetime.utcnow(), update_connect_time=False)
            log.debug(f'Radio Not Connected E: {e.__class__.__name__} {e.args}')
        else:
            self.event_on_connect(datetime.utcnow())
            log.debug('Other Threads Started')

    def sleep(self):
        if self.is_connect:
            counter = self._counter_max
        else:
            counter = self._counter_max_on_disconnect
        while self.keep_alive and counter > 0 and not self.need_to_check:
            sleep(self.check_period)
            if not self.keep_alive:
                break
            counter -= 1
            self.alive_counter += 1
        # self.logger('Sleep', f' self.keep_alive:{self.keep_alive} counter > 0:{counter > 0}'\
        #          f' self.need_to_check:{self.need_to_check}')

    def run(self):
        self.log.debug('Start')
        connect_logged = disconnect_logged = False
        while self.keep_alive:
            self.need_to_check = False
            if not self.is_connect:
                self.log.debug('Connecting...')
                self.connector = Thread(target=self.connect, args=(self.logs['Connector'], ), daemon=True)
                self.connector.start()

            while self.keep_alive and self.connector.is_alive():
                sleep(self.check_period)

            if self.is_connect:
                if not connect_logged:
                    self.log.debug('Connected to Radio')
                    connect_logged, disconnect_logged = True, False
                self.main()
            else:
                if not disconnect_logged:
                    self.log.debug('Radio is Unavailable')
                    connect_logged, disconnect_logged = False, True
                self.periodic_operation_on_disconnection()

            self.update_status_when_disconnect()
            self.sleep()
            self.alive_counter += 1
            # self.update_timers(self.is_connect, 'Run')
            self.log.debug(f'End Loop .... self.keep_alive = {self.keep_alive}')

        self.close()
        # if hasattr(self, 'keeper'):
        #     self.keeper.close()
        #     self.reception.close()
        #     self.keeper.join()
        #     self.reception.join()
        self.log.info('Run Finished')

    def close(self):
        self.keep_alive = self.is_connect = False

    def main(self):
        while self.is_connect:
            self.update_timers(self.is_connect)
            self.log.debug(f'Main: self.keep_alive:{self.keep_alive} self.need_to_check:{self.need_to_check}')
            self.sleep()
            self.alive_counter += 1
            if not self.keep_alive:
                break

    def periodic_operation_on_disconnection(self):
        pass


if __name__ == '__main__':
    from sys import argv
    from log.logger import get_base_logger

    radio = 'MSD_TX_V1M' if 'm' in argv[1:] else 'MSD_TX_V1S'
    _ip = {'MSD_TX_V1M': '192.168.16.11', 'MSD_TX_V1S': '192.168.16.21'}.get(radio)
    _port = 8002
    _logs = get_base_logger(radio)
    _base = Base(_ip, _port, radio, _logs)
    _base.start()
    ex = {'q', 'Q'}
    key = None

    while key not in ex:
        key = input()
    print('Closing .........................')
    _base.close()
    _base.join()
