from datetime import datetime
from threading import Thread
from time import sleep
from base.aggregator import Aggregator


class BaseKeeper(Thread):
    def __init__(self, parent, name, log):
        super().__init__(name=f"{name}_Keeper_Thread")
        self.keep_alive = True
        self.base = parent
        self.log = log
        # self.kep_packet = 0
        self.kep_packet = Aggregator('CntKeepConnectionPacket')
        self.close = self.event_on_disconnect
        self.alive_counter, self.alive_counter_prev = 0, 0

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def event_on_disconnect(self):
        self.keep_alive = False

    def set_counters(self, aggregate, resettable):
        self.kep_packet.set(aggregate, resettable)

    def sleep(self):
        counter = self.base.keeper_max
        self.log.debug(f'Counter = {counter}')
        while counter > 0:
            sleep(self.base.check_period)
            if not self.keep_alive:
                break
            counter -= 1

    def run(self):
        while self.keep_alive:
            if self.base.ping_counter > self.base.ping_counter_disconnection_threshold:
                self.log.warning('Radio Disconnected due to failure to respond to ping timout packets three times')
                self.base.need_to_check = True
                self.base.event_on_disconnect(datetime.utcnow())
                break

            self.log.debug('Loop Start')
            try:
                self.send_keep_connection()
                self.log.debug(f'Alive Message Sent alive_counter = {self.base.ping_counter}')
            except (ConnectionError, TimeoutError) as e:
                pass
                self.log.debug(f'Failed to send keep alive connection command! {e.__class__.__name__} {e.args}')
            self.sleep()
            self.alive_counter += 1

    def send_keep_connection(self):
        self.base.ping_counter += 1
        self.kep_packet.add()
        self.base.send(f"M:SC {self.base.command_id} SPG{self.base.ping_timeout}")
