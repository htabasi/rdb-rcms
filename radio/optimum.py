import os

from analyzer.updater import get_updates
from generator import get_file
from settings import SQL_OPTIMUM


class OptimumGenerator:
    def __init__(self, parent, log):
        self.root = parent
        self.log = log
        self.executor = parent.executor
        self.counters = [
            self.root.connect_counter,
            self.root.disconnect_counter,
            self.root.executor.exe_query,
            self.root.timer_planner.pln_counter,
            self.root.err_connect,
            self.root.executor.err_execute,
            self.root.timer_planner.err_counter
        ]
        self.timers = [
            self.root.connect_time,
            self.root.disconnect_time
        ]

        self.name = self.root.radio.name
        self.module = get_file(os.path.join(SQL_OPTIMUM, 'module.sql'))
        self.counter_update = get_file(os.path.join(SQL_OPTIMUM, 'counter.sql'))
        self.timer_update = get_file(os.path.join(SQL_OPTIMUM, 'timer.sql'))
        self.connection = get_file(os.path.join(SQL_OPTIMUM, 'connection.sql'))
        self.connection_stat = get_file(os.path.join(SQL_OPTIMUM, 'connection_stat.sql'))
        self.disconnection_updated = False

    def update_module_stat(self, *args):
        self.log.debug(f"Status Updating")
        kv, value = f"{'UpdateTime'}='{str(args[0])[:23]}', ", args[1]
        for item in value:
            if item in ['id', 'Name', 'StartTime', 'UpdateTime', 'PID']:
                continue
            kv += f"{item}={value[item]}, "

        self.executor.add(self.module.format(kv[:-2].replace('None', 'NULL'), value['id']))

    def update_counter_timer(self):
        self.update_gauges('Counter', self.counters, self.counter_update)
        self.update_gauges('Timer', self.timers, self.timer_update)

    def update_gauges(self, category, gauges, update_query):
        self.log.debug(f"{category} Updating")
        agg_update, res_update = get_updates(gauges)
        self.log.debug(f"Write on DB:\n   aggregate : {agg_update}\n   resettable: {res_update}")
        self.executor.add(update_query.format(agg_update, self.name, 0))
        self.executor.add(update_query.format(res_update, self.name, 1))

    def update_disconnection(self, time_tag):
        if not self.disconnection_updated:
            self.executor.add(self.connection.format(str(time_tag)[:23], self.name))
            self.executor.add(self.connection_stat.format(self.name))
            self.disconnection_updated = True
