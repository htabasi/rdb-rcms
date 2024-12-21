from base.base import Base
from base.aggregator import Aggregator, OperatingHourUpdater
from .identity import RadioIdentity
from .reception import Reception
from .keeper import Keeper
from .coordinator import Coordinator
from .sender import Sender
from socket import error as SocketError
from datetime import datetime, UTC


class Core(Base):
    def __init__(self, identity: RadioIdentity, logs):
        super().__init__(identity.ip, identity.port, identity.name, logs)
        self.identity = identity
        self.logs = logs
        self.log = logs['Core']
        self.coordinator = Coordinator(self, logs['Coordinator'])
        self.sender = Sender(self, self.coordinator, logs['Sender'])
        self.ind_ref = self.ref_time
        self.indicator_on = Aggregator('IndicatorONSec', float)
        self.indicator_off = Aggregator('IndicatorOFFSec', float)
        self.indicator_on_ctr = Aggregator('CntIndicatorOn')
        self.operating_hour = OperatingHourUpdater('OperatingHour')

        self.initial_commands = [('RCTC', 'T', 1)] if self.identity.type == 'TX' else [('RCRI', 'T', 1)]
        self.on_air = 0

    def main(self):
        self.initiate()
        self.log.debug(f'Main Loop: Started')
        while self.is_connect:
            self.update_timers(self.is_connect)
            self.update_ind_timers()
            self.update_status_when_connect()

            self.log.debug(f'Update at {datetime.now(UTC).timestamp():.3f}: Timers: Connect:{self.connect_time} '
                           f'Disconnect:{self.disconnect_time} IndOn:{self.indicator_on} '
                           f'IndOff:{self.indicator_off}')
            # self.log.info(f'Main: self.keep_alive:{self.keep_alive} self.need_to_check:{self.need_to_check}')
            self.alive_counter += 1
            self.sleep()
            if not self.keep_alive:
                break
            self.periodic_operation()

        self.log.info(f'Main Loop: Finished')

    def close(self):
        self.log.debug(f'Closing App...')
        if hasattr(self, 'keeper'):
            self.keeper.close()
            self.reception.close()
            self.socket.close()

            self.keeper.join()
            self.reception.join(3)
        self.keep_alive = self.is_connect = False
        self.log.debug(f'Objects are closed')

    def periodic_operation(self):
        pass

    def update_status_when_connect(self):
        pass

    def update_indicator(self, now: datetime, stat):
        ts = now.timestamp()
        self.log.debug(f'Update Indicator: {stat}')
        if self.on_air is False and stat == 1:
            self.indicator_on_ctr.add()
        self.on_air = stat == 1
        self.update_ind_timers(ts)

    def update_ind_timers(self, ts=None):
        set_off = self.on_air ^ (ts is None)
        ts = datetime.now(UTC).timestamp() if ts is None else ts
        delta = ts - self.ind_ref
        if set_off:
            self.indicator_off.add(delta)
        else:
            self.indicator_on.add(delta)
        self.ind_ref = ts

    def set_counters(self, aggregate, resettable):
        super().set_counters(aggregate, resettable)
        self.indicator_on_ctr.set(aggregate, resettable)

    def set_timers(self, aggregate, resettable):
        self.log.debug(f'Set Timers: {aggregate, resettable}')
        super().set_timers(aggregate, resettable)
        self.indicator_on.set(aggregate, resettable)
        self.indicator_off.set(aggregate, resettable)
        self.operating_hour.set(aggregate, resettable)

    def send(self, msg):
        self.log.debug(f'Send: {msg}')
        self.snd_packet.add()
        try:
            self.socket.send(f"\n{msg}\r".encode())
        except TimeoutError:
            self.err_send.add()
            self.event_on_send_error(msg)
        except (SocketError, BrokenPipeError, ConnectionRefusedError):
            self.err_send.add()
            self.event_on_send_error(msg)
            self.event_on_disconnect(datetime.now(UTC))

    def initiate(self, contain_event_list=False):
        self.sender.group_send(self.initial_commands, contain_event_list)
        self.event_on_initiate()
        self.log.debug(f'Radio initiated')

    def event_on_connect(self, time_tag):
        self.update_timers(connect=False)
        self.log.debug(f'On Connect: Connected')
        self.is_connect = True
        self.ping_counter = 0
        self.reception = Reception(self, self.coordinator, self.radio_name, self.logs['Reception'])
        self.keeper = Keeper(self, self.coordinator, self.radio_name, self.logs['Keeper'])
        self.reception.start()
        self.keeper.start()
        self.connect_counter.add()
        self.ind_ref = time_tag.timestamp()

    def event_on_initiate(self):
        pass

    def event_on_send_error(self, message):
        pass

    def event_on_command_sent(self, command_text):
        pass

    def event_on_message_received(self, message):
        pass

    def event_on_parameter_updated(self, time_tag, key, value):
        self.log.debug(f'Parameter Updated: {key} > {value}')
        if key == 'SCPG':
            self.ping_timeout = int(value)
        elif key in {'RCRI', 'RCTC'}:
            self.update_indicator(time_tag, int(value))

    def event_on_trap_accepted(self, time_tag, key, stat):
        self.log.debug(f"TrapAccepted {time_tag} {key} > { {'0': 'OFF', '1': 'ON'}.get(stat)}")

    def event_on_set_accepted(self, time_tag, key, value):
        self.log.debug(f'SetAccepted {time_tag} {key} > {value}')

    def event_on_access_error(self, time_tag, key, error_code, message):
        self.log.debug(f'AccessError {time_tag} {key} > Rejected by {error_code}: {message}')

    def event_on_command_error(self, time_tag, key, error_code, message):
        self.log.debug(f'CommandError {time_tag} {key} > Rejected by {error_code}: {message}')

    def event_on_user_command_answered(self, time_tag, key, value, error=False):
        if error:
            self.log.debug(f'User Command {time_tag} {key} > {value} is Rejected')
        else:
            self.log.debug(f'User Command {time_tag} {key} > {value} is Accepted')


if __name__ == '__main__':
    pass
