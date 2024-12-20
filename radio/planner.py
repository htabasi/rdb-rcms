from datetime import datetime, timedelta
from threading import Timer

from base.aggregator import Aggregator

RX, TX = 0, 1


class BasePlanner:
    timer: Timer
    pln_counter: Aggregator
    err_counter: Aggregator

    def __init__(self, parent, log, interval, max_delay=None):
        self.radio = parent
        self.sender = parent.sender
        self.log = log
        self.interval = interval
        self.max_delay = max_delay if max_delay is not None else interval
        self.is_scheduled, self.first_plan, self.executing = False, True, False
        # self.pln_counter = self.err_counter = 0
        self.log.info(f'Initialized')

    def make_plan(self):
        if not self.is_scheduled:
            if self.first_plan:
                from random import randint
                delay = randint(1, self.max_delay * 60)
                self.timer = Timer(delay, self.run)
                self.first_plan = False
                self.log.info(f'First Time Planned to run after {delay} seconds')
            else:
                self.timer = Timer(self.interval * 60, self.run)
                self.log.debug(f'Planned to run after {self.interval} minutes')

            self.timer.daemon = True
            self.timer.start()
            self.is_scheduled = True

    def set_counters(self, aggregate, resettable):
        self.pln_counter.set(aggregate, resettable)
        self.err_counter.set(aggregate, resettable)

    def cancel(self):
        try:
            self.timer.cancel()
        except AttributeError:
            pass
        self.log.info(f'Timer Cancelled')

    def run(self):
        if self.radio.radio.name.startswith('BRG_'):
            self.log.debug(f'Adding timer planner counter: self.pln_counter.agg={self.pln_counter.agg}')
        #self.pln_counter.add()
        self.log.info(f'Run Executed')
        self.is_scheduled = False


class TimerUpdatePlanner(BasePlanner):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.pln_counter = Aggregator('CntUpdateTimer')
        self.err_counter = Aggregator('CntErrorUpdateTimer')

    def run(self):
        self.executing = True
        try:
            if self.radio.is_connect:
                self.sender.send('RCOC', 'G')
            else:
                self.radio.optimum_generator.update_counter_timer()
            super().run()
        except Exception as e:
            self.log.exception(f'Executing Error: {e} {e.args}')
            self.err_counter.add()
        self.executing = False


class SpecialSettingUpdatePlanner(BasePlanner):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.pln_counter = Aggregator('CntUpdateSpecial')
        self.err_counter = Aggregator('CntErrorUpdateSpecial')
        self.generator = self.radio.generator
        self.commands = [(key, 'G') for key in ['AITP', 'FFTO', 'RCIT', 'RCLP', 'RCNP', 'RCTS']]

    def run(self):
        self.executing = True
        try:
            self.generator.event_special.set_config_request_started()
            self.sender.group_send(self.commands)
            super().run()
        except Exception as e:
            self.log.exception(f'Executing Error: {e} {e.args}')
            self.err_counter.add()
        self.executing = False


class SettingsUpdatePlanner(BasePlanner):
    def __init__(self, *args, **kwargs):
        BasePlanner.__init__(self,  *args, **kwargs)
        self.pln_counter = Aggregator('CntUpdateSettings')
        self.err_counter = Aggregator('CntErrorUpdateSettings')
        self.first_plan, self.event_list = True, False
        self.generator = self.radio.generator
        self.executor = self.radio.executor
        self.status = self.radio.status
        self.name = self.radio.radio.name

        # 'GRIL0' Remove From Key List
        self.keys = ['AIAI', 'AIEL', 'AISE', 'AISF', 'ERBE', 'EVSR', 'FFBL', 'FFEA', 'FFFC', 'FFFE', 'FFLM',
                     'FFLT', 'FFSC', 'GRAC', 'GRDH', 'GRDN', 'GRIE', 'GRII', 'GRIN', 'GRIP', 'GRIV', 'GRLO',
                     'GRNC', 'GRND0', 'GRND1', 'GRND2', 'GRND3', 'GRND4', 'GRND5', 'GRND6', 'GRND7', 'GRND8',
                     'GRND9', 'GRNS', 'GRSE', 'GRSN', 'GRSV', 'GRVE', 'GRTI', 'MSTY', 'RUFL', 'RUFP']

        if self.radio.radio.radio_code == RX:  # for rx radio_code == 0
            self.keys += ['AIGA', 'AITS', 'FFCO', 'FFSL', 'GRBS', 'GRIS', 'GRLR', 'RIRO', 'RCLR']
        else:
            self.keys += ['AICA', 'AIML', 'AITP', 'FFTO', 'GRAS', 'GRCO', 'GREX', 'GRLT', 'RCDP', 'RCIT', 'RCLP',
                          'RCLV', 'RCNP', 'RCTS', 'RIPC', 'RIVL', 'RIVP']

        self.keys.sort()
        self.commands = []
        for key in self.keys:
            if len(key) == 4:
                self.commands.append((key, 'G'))
            elif len(key) == 5:
                self.commands.append((key[:4], 'G', key[-1]))

    def collect_event_list(self):
        self.log.info('EventList will be collected.')
        self.event_list = True

    def make_plan(self):
        if not self.is_scheduled:
            if self.first_plan:
                from random import randint
                delay = randint(1, self.max_delay * 60)
                self.timer = Timer(delay, self.run)
                self.first_plan = False
                target_time = datetime.utcnow() + timedelta(seconds=delay)
                self.log.info(f'First Time Planned to run at {target_time}')
            else:
                self.timer = Timer(self.interval * 60, self.run)
                target_time = datetime.utcnow() + timedelta(minutes=self.interval)
                self.log.info(f'Planned to run at {target_time}')

            self.timer.daemon = True
            self.timer.start()
            self.executor.add(f"Update Application.RadioStatus SET NextConfigFetch='{str(target_time)[:23]}'"
                              f" WHERE Radio_Name='{self.name}';")
            self.is_scheduled = True

    def run(self):
        self.executing = True
        try:
            self.generator.setting_configuration.set_config_request_started()
            self.generator.setting_installation.set_config_request_started()
            self.generator.setting_network.set_config_request_started()
            self.generator.setting_snmp.set_config_request_started()
            self.generator.setting_status.set_config_request_started()
            self.generator.setting_trx_configuration.set_config_request_started()
            self.generator.setting_inventory.clear()
            self.sender.group_send(self.commands, event_request=self.event_list)
            self.event_list = False

            super().run()
        except Exception as e:
            self.log.exception(f'Executing Error: {e} {e.args}')
            self.err_counter.add()
        self.executing = False
