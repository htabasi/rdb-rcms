from threading import Thread
from time import sleep
from pymssql._mssql import MSSQLDatabaseException

from base.aggregator import Aggregator
from execute import get_connection


class QueryExecutor(Thread):
    def __init__(self, parent, log):
        super(QueryExecutor, self).__init__(name='MSSSConnector')
        self.radio = parent
        self.buffer = [[], []]
        self.writer = 0
        self.calm = 3.0
        self.alive_counter = self.alive_counter_prev = 0
        self.exe_query = Aggregator('CntQueryExecuted')
        self.err_execute = Aggregator('CntErrorQueryExecution')
        # self.err_execute = self.exe_query = 0

        self.wait_to_release_connection = False
        self.log = log
        self.connection = get_connection(self.log)
        self.connection.set_msghandler(self.db_message_handler)

    def set_counters(self, aggregate, resettable):
        self.exe_query.set(aggregate, resettable)
        self.err_execute.set(aggregate, resettable)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def run(self) -> None:
        self.log.info('Started')
        while self.radio.keep_alive:
            # self.log.debug(f"keep_connection = {self.memory.keep_connection}, sleep_time={self.timing}")
            reader = 1 - self.writer

            # self.log.debug(f"Sending {len(self.buffer[reader])} queries from Buffer {reader}")
            try:
                self.send_buffer(self.buffer[reader])
            except Exception as e:
                self.err_execute.add()
                self.log.exception(f'Error on Sending Queries to database! {e}')

            # self.log.debug(f"Buffer {reader}: length = {len(self.buffer[reader])}")

            self.alive_counter += 1
            sleep(self.calm)
            self.writer = reader
            # self.log.debug(f"Read Buffer switched to {reader}")

        self.connection.close()
        self.log.info('Finished')

    def db_message_handler(self, msgstate, severity, srvname, procname, line, msgtext):
        self.log.debug(f'DatabaseDriver: Server:{srvname} Proc:{procname} Level:{severity}, Line:{line}, '
                       f'State:{msgstate}, Message:{msgtext}')

    def add(self, query: str):
        # self.log.debug(f"Saving {len(query)} byte(s) length query.")
        try:
            self.buffer[self.writer].append(query)
        except Exception as e:
            self.err_execute.add()
            self.log.exception(f'Error on adding query! {e}')

    def send_buffer(self, buffer: list):
        self.exe_query.add(len(buffer))
        while buffer:
            sql = buffer.pop(0)
            try:
                self.connection.execute_non_query(sql)
            except MSSQLDatabaseException as e:
                self.err_execute.add()
                self.log.exception(f'Error on Query Execution: Query:{sql}\n Number:{e.number}, Level:{e.severity},'
                                   f' State:{e.state}, Message:{e.message}')

        # self.log.debug(f"Execution of {sl} query is done.")
