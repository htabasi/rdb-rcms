from pymssql import _mssql as db
from threading import Thread
from time import sleep


def get_connection(log=None, server=None):
    if server is None:
        server = 'ProBook\Pro'
    database = 'RCMS'
    username = 'dbu'
    password = 'HadiTabasiAslAvval'

    try:
        connection = db.connect(server=server, user=username, password=password, database=database)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Connection: Number:{e.number}, Level:{e.severity}, State:{e.state}, Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)
    else:
        return connection


def get_file(filename):
    with open(filename, 'r') as f:
        query = f.read()
    return query



def get_radio_ip(radio_name):
    query = get_file('dbfiles/select/radio_specification_by_name.sql').format(radio_name)
    with get_connection() as con:
        answer = get_simple_row(con, query, as_dict=True)

    return answer


def get_available_stations():
    with get_connection() as connection:
        result = get_simple_column(connection, get_file('dbfiles/select/available_stations.sql'))

    return result


def get_available_radios():
    with get_connection() as connection:
        result = get_simple_column(connection, get_file('dbfiles/select/available_radios.sql'))

    return result


def get_logger_config():
    with get_connection() as connection:
        result = get_multiple_row(connection, get_file('dbfiles/select/log_config.sql'), as_dict=True)

    return result


def get_logger_format():
    with get_connection() as connection:
        result = get_multiple_row(connection, get_file('dbfiles/select/log_format.sql'), as_dict=True)

    return result


def get_scalar_answer(connection, query, log=None):
    try:
        return connection.execute_scalar(query)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)


def get_simple_column(connection, query, log=None):
    get_query_answer(connection, query, log)
    return [row[0] for row in connection]


def get_simple_row(connection, query, log=None, as_dict=False):
    get_query_answer(connection, query, log)
    try:
        answer = list(connection)[0]
    except IndexError:
        return None
    if as_dict:
        return {key: value for key, value in answer.items() if type(key) is str}
    else:
        return [answer[i] for i in range(len(answer) // 2)]


def get_multiple_row(connection, query, log=None, as_dict=False):
    get_query_answer(connection, query, log)
    if as_dict:
        return [{item: row[item] for item in row if type(item) is str} for row in connection]
    else:
        result = [[row[i] for i in range(len(row) // 2)] for row in connection]
        if len(result) == 0:
            return None
        return result


def get_query_answer(connection, query, log=None):
    try:
        connection.execute_query(query)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)


def execute_no_answer_query(connection, query, log=None):
    try:
        return connection.execute_non_query(query)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)


class MSSSConnector(Thread):
    def __init__(self, memory, logs):
        super(MSSSConnector, self).__init__(name='MSSSConnector')
        self.memory = memory
        self.buffer = [[], []]
        self.writer = 0
        self._sleep_time = 3.0
        self._alive_counter = self._err_counter = self._query_counter = 0

        self.wait_to_release_connection = False
        self.log = logs['Connector']
        self.connection = get_connection(self.log)
        self.connection.set_msghandler(self.db_message_handler)

    @property
    def timing(self):
        return self._sleep_time

    @timing.setter
    def timing(self, t):
        self._sleep_time = t

    @property
    def alive_add(self):
        return self._alive_counter

    @alive_add.setter
    def alive_add(self, value=1):
        self._alive_counter += value
        if self._alive_counter > 65535:
            self._alive_counter -= 65535

    @property
    def err_add(self):
        return self._err_counter

    @err_add.setter
    def err_add(self, value=1):
        self._err_counter += value
        if self._err_counter > 65535:
            self._err_counter -= 65535

    @property
    def query_add(self):
        return self._query_counter

    @query_add.setter
    def query_add(self, value=1):
        self._query_counter += value
        if self._query_counter > 65535:
            self._query_counter -= 65535

    def run(self) -> None:
        self.log.info('Started')
        while self.memory.keep_connection:
            # self.log.debug(f"keep_connection = {self.memory.keep_connection}, sleep_time={self.timing}")
            reader = 1 - self.writer

            # self.log.debug(f"Sending {len(self.buffer[reader])} queries from Buffer {reader}")
            try:
                self.send_buffer(self.buffer[reader])
            except Exception as e:
                self.err_add = 1
                self.log.exception(f'Error on Sending Queries to database! {e}')

            # self.log.debug(f"Buffer {reader}: length = {len(self.buffer[reader])}")

            self.alive_add = 1
            sleep(self._sleep_time)
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
        except Exception:
            self.query_add = 1
            self.log.exception('Error on adding query!')

    def send_buffer(self, buffer: list):
        self.query_add = len(buffer)
        while buffer:
            sql = buffer.pop(0)
            try:
                self.connection.execute_non_query(sql)
            except db.MSSQLDatabaseException as e:
                self.err_add = 1
                self.log.exception(f'Error on Query Execution: Query:{sql}\n Number:{e.number}, Level:{e.severity},'
                                   f' State:{e.state}, Message:{e.message}')

        # self.log.debug(f"Execution of {sl} query is done.")


if __name__ == '__main__':
    _connection = get_connection()
    if not _connection:
        print('Connection Error: Database is unreachable!')
        exit()

    """
        connection.execute_non_query()
        connection.execute_query()
        connection.execute_scalar()
        connection.execute_row()
        
    """
    # try:
    #     _connection.execute_query("SELECT @@version;")
    # except db.MSSQLDatabaseException as err:
    #     print(err)
    # else:
    #     for _row in _connection:
    #         for _key in _row:
    #             print(_row[_key])

    # print(get_available_stations())
    # print(get_available_radios())
    # print(get_radio_ip('BUZ_RX_v1M'))
    # print(get_multiple_row(_connection, get_file('dbfiles/select/application_timing.sql')))
    # config = get_logger_config()
    # format = get_logger_format()
    # from log import get_all_loggers
    # get_all_loggers('BUZ_RX_V1M', config, format)
    # id = get_simple_row(_connection, f"Select id FROM Application.RadioModuleStatus WHERE RadioModuleName='BUZ_TX_V1M'")[0]
    # print(id)
    d = get_multiple_row(_connection, get_file(r'dbfiles/select/latest_cbit_setting.sql').format('BJD_TX_V2S'))
    print(d)
    _connection.close()
