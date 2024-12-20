import os
from datetime import datetime

from generator import get_file
from settings import SQL_INSERT, SQL_UPDATE


class Status:
    def __init__(self, parent, log, status):
        self.radio = parent
        self.log = log
        self.name = self.radio.radio.name
        self.status = {
            'id': None,
            'Name': self.name,
            'StartTime': None,
            'PID': -1,
            'UpdateTime': None,
            'ModuleAlive': 0,
            'ReceptionAlive': 0,
            'KeeperAlive': 0,
            'GeneratorAlive': 0,
            'ExecutorAlive': 0,
            'CommanderAlive': 0,
            'AnalyzerAlive': 0,
            'RadioConnected': 0,
            'DatabaseConnected': 0,
            'UpdateSpecialScheduled': 0,
            'UpdateTimerScheduled': 0,
            'UpdateSettingsExecuting': 0,
            'UpdateSpecialExecuting': 0,
            'UpdateTimerExecuting': 0
        } if status is None else status

        self.status['UpdateSpecialScheduled'] = 0
        self.status['UpdateSpecialExecuting'] = 0

    def set_start(self, pid):
        self.log.info(f'Setting start with pid={pid}')
        connection = self.radio.db_connection
        now = str(datetime.utcnow())[:23]
        if self.status['id'] is None:
            query = self.radio.queries.get('IAModuleStatus').format(self.name, now, pid, now)
            connection.execute_non_query(query)
            self.status['id'] = connection.identity
        else:
            query = self.radio.queries.get('USAModuleStatus').format(now, now, pid, self.status['id'])
            connection.execute_non_query(query)

        self.status['StartTime'] = now
        self.status['PID'] = pid
        self.status['UpdateTime'] = now

    def update_status(self):
        self.log.debug(f'On Connect Status Update')
        self.status['ModuleAlive'] = int(self.radio.status())
        self.status['ReceptionAlive'] = int(self.radio.reception.status())
        self.status['KeeperAlive'] = int(self.radio.keeper.status())
        self.status['GeneratorAlive'] = int(self.radio.generator.status())
        self.status['ExecutorAlive'] = int(self.radio.executor.status())
        self.status['CommanderAlive'] = int(self.radio.commander.status())
        self.status['AnalyzerAlive'] = int(self.radio.analyzer.status())
        self.status['HealthAlive'] = int(self.radio.health.status())
        self.status['RadioConnected'] = int(self.radio.is_connect)
        self.status['DatabaseConnected'] = int(self.radio.executor.connection.connected)
        self.status['UpdateSettingsScheduled'] = int(self.radio.setting_planner.is_scheduled)
        self.status['UpdateTimerScheduled'] = int(self.radio.timer_planner.is_scheduled)
        self.status['UpdateSettingsExecuting'] = int(self.radio.setting_planner.executing)
        self.status['UpdateTimerExecuting'] = int(self.radio.timer_planner.executing)
        if self.radio.radio.type == 'TX':
            self.status['UpdateSpecialScheduled'] = int(self.radio.special_planner.is_scheduled)
            self.status['UpdateSpecialExecuting'] = int(self.radio.special_planner.executing)
        time_tag = datetime.utcnow()
        self.radio.event_on_parameter_updated(time_tag, 'ModuleStatus', self.status)

    def update_status_when_disconnect(self):
        self.log.debug(f'On Disconnect Status Update')
        self.status['ModuleAlive'] = int(self.radio.status())
        self.status['ExecutorAlive'] = int(self.radio.executor.status())
        # self.status['HealthAlive'] = int(self.radio.health.status())
        self.status['RadioConnected'] = int(self.radio.is_connect)
        self.status['DatabaseConnected'] = int(self.radio.executor.connection.connected)
        self.radio.optimum_generator.update_module_stat(datetime.utcnow(), self.status)
        self.radio.optimum_generator.update_counter_timer()
