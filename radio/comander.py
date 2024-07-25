import os
from datetime import datetime
from threading import Thread
from time import sleep, time

from base.aggregator import Aggregator
from execute import get_connection, get_multiple_row, get_simple_row, execute_no_answer_query
from generator import get_file
from settings import SQL_SELECT, SQL_UPDATE, SQL_ANALYZE_SELECT, SQL_ANALYZE_UPDATE


class Commander(Thread):
    connection = None

    def __init__(self, parent, log):
        self.parent = parent
        self.radio = parent.radio
        super().__init__(name=f"{self.radio.name}_Commander", daemon=True)
        self.log = log
        self.core = parent
        self.select = get_file(os.path.join(SQL_SELECT, 'command_history.sql')).format(self.radio.name)
        self.update = get_file(os.path.join(SQL_UPDATE, 'command_history.sql'))
        self.permission = get_file(os.path.join(SQL_SELECT, 'command_history_permission.sql'))
        self.analyzer_reset = get_file(os.path.join(SQL_ANALYZE_SELECT, 'reset.sql')).format(self.radio.name)
        self.analyzer_set_counter = get_file(os.path.join(SQL_ANALYZE_UPDATE,
                                                          'reset_command_counter.sql')).format(self.radio.name)
        self.analyzer_set_timer = get_file(os.path.join(SQL_ANALYZE_UPDATE,
                                                        'reset_command_timer.sql')).format(self.radio.name)
        self.send_command = self.core.sender.send
        self.user_command_succeed = self.core.sender.coordinator.user_command_succeed

        self.alive_counter = self.alive_counter_prev = 0
        # self.cmd_executed = self.cmd_rejected = self.err_command = 0
        self.cmd_executed = Aggregator('CntCommandExecuted')
        self.cmd_rejected = Aggregator('CntCommandRejected')
        self.err_command = Aggregator('CnrErrorCommandExecution')

        self.calm = 3
        self.log.debug('Initiated')
        self.request = {'G': 'Get', 'S': 'Set', 'T': 'Trap'}
        self.code_name = {'Send': 'send_command', 'G': 'get_command', 'S': 'set_command', 'T': 'trap_command'}
        self.task = {'Send': 'Send command', 'G': 'Get command', 'S': 'Set command', 'T': 'Trap command'}
        self.time_period_commands = {'FFSQ': (0, 1), 'RCPF': (1, 0), 'RCPT': (1, 0)}

    def set_counters(self, aggregate, resettable):
        self.cmd_executed.set(aggregate, resettable)
        self.cmd_rejected.set(aggregate, resettable)
        self.err_command.set(aggregate, resettable)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def run(self) -> None:
        self.connection = get_connection(self.log)
        self.log.info('Started')
        while self.core.is_connect:
            answer = get_multiple_row(self.connection, self.select, log=self.log)
            self.log.debug(f'Commands pulled: {answer}')
            if answer is not None:
                for command_args in answer:
                    try:
                        self.execute_command(*command_args)
                    except Exception as e:
                        self.err_command.add()
                        self.log.warning(f'Error executing command {command_args}: {e.__class__.__name__}: {e.args}')

            self.check_analyzer_command()

            sleep(self.calm)
            self.alive_counter += 1

        self.log.info('Finished')

    def execute_command(self, _id, user_id, key_id, key, request, value):
        self.log.debug(f"Command Received: id:{_id}, user_id:{user_id}, key:{key}, request:{request}, value:{value}")
        if not (self.is_permitted(user_id, key_id, request, value, 'Send', _id) and
                self.is_permitted(user_id, key_id, request, value, request, _id)):
            self.cmd_rejected.add()
            self.log.debug(f"PermissionError: Command {key} {request} is not permitted!")
            return
        self.log.debug(f"PermissionAccepted: Command {key} {request} permit")

        if key in {'RCPF', 'RCPT'} and self.core.on_air:
            self.update_database(_id, stat=8)
            self.cmd_rejected.add()
            self.log.debug(f'Command Failed (TX On AIR): {self.request[request]} {key} {value}')
            return

        if key in self.time_period_commands:
            self.run_time_period_command(_id, key, request, value, user_id)
        else:
            self.run_command(_id, key, request, value, user_id)

        self.cmd_executed.add()

    def run_time_period_command(self, _id, key, request, value, uid):
        start, end = self.time_period_commands[key]
        running_length = int(value)

        send_moment = time()
        if not self.run_command(_id, key, request, start, uid, requested=3, done=6, failed=5, length=running_length):
            return

        wait_time = running_length - time() + send_moment
        if wait_time > 0:
            sleep(wait_time)

        self.run_command(_id, key, request, end, uid, requested=7, done=4, failed=5, length=running_length)

    def run_command(self, _id, key, request, value, uid, requested=3, done=4, failed=5, length=0):
        """
        action
            0: Event List Cleared
            1: All Trap OFF
            2: Skip To GO
            3: TX Pressed
            4: TX Released
            5: TX + Mod Pressed
            6: TX + Mod Released
            7: Radio Restarted
        """
        if request == 'S' and key in {'EVCL', 'GRAT', 'MSGO', 'RCPF', 'RCPT', 'RCRR'}:
            action = {'EVCL': 0, 'GRAT': 1, 'MSGO': 2, 'RCPF': 4 - value, 'RCPT': 6 - value, 'RCRR': 7}.get(key)
            comment = f'{length} Second(s)' if key in {'RCPF', 'RCPT'} else ''
        else:
            action, comment = None, None

        self.log.debug(f'Command Received: {self.request[request]} {key} {value}')

        com_num = self.send_command(key, request, value, user_command=True, uac=(uid, action, comment))
        self.update_database(_id, stat=requested)
        self.log.debug(f'Command Requested: {self.request[request]} {key} {value}')

        if self.command_succeed(com_num):
            self.update_database(_id, stat=done)
            self.log.debug(f'Command Result: {self.request[request]} {key} {value} Executed SUCCESSFULLY!')
            return True
        else:
            self.update_database(_id, stat=failed)
            self.log.debug(f'Command Result: {self.request[request]} {key} {value} FAILED')
            return False

    def command_succeed(self, com_num):
        answer, result = self.user_command_succeed(com_num)
        while answer != 'Answered':
            sleep(0.2)
            answer, result = self.user_command_succeed(com_num)

        return result

    def is_permitted(self, user_id, key, request, value, code, _id):
        code_name = self.code_name.get(code)
        task = self.task.get(code)
        self.log.debug(f"Checking {user_id}, {key}, {code_name}")
        answer = get_simple_row(self.connection, self.permission.format(user_id, key, code_name), log=self.log)
        self.log.debug(f"Permission Check: '{answer}'")

        if answer is None:
            self.log.warning(f'{task} to the radio is not permitted: {self.request[request]} {key} {value}')
            self.update_database(_id, stat=9)
            return False
        else:
            return True

    def update_database(self, _id, stat):
        now = str(datetime.utcnow())[:23]
        execute_no_answer_query(self.connection, self.update.format(now, stat, _id), self.log)

    def check_analyzer_command(self):
        try:
            counter, timer = get_simple_row(self.connection, self.analyzer_reset, log=self.log)
        except Exception as e:
            self.log.debug(f'Error on Reading Analyzer Command: {e}')
        else:
            self.log.debug(f'Analyzer Command: counter={counter} timer={timer}')
            if counter:
                try:
                    self.parent.analyzer.counter.reset()
                    self.log.debug(f'Analyzer Command: Counter Reset Done')
                except Exception as e:
                    self.log.debug(f'Error on Reset Analyzer Counter: {e}')
                finally:
                    execute_no_answer_query(self.connection, self.analyzer_set_counter, log=self.log)

            if timer:
                try:
                    self.parent.analyzer.timer.reset()
                    self.log.debug(f'Analyzer Command: Timer Reset Done')
                except Exception as e:
                    self.log.debug(f'Error on Reset Analyzer Timer: {e}')
                finally:
                    execute_no_answer_query(self.connection, self.analyzer_set_timer, log=self.log)
