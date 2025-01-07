import os
from pymssql import _mssql as db
from pymssql._mssql import MSSQLDatabaseException

from settings import SQL_SELECT


def get_file(filename):
    with open(filename, 'r') as f:
        query = f.read()
    return query

def get_connection(log=None, server=None):
    if server is None:
        # server = 'olympus.liara.cloud,31430'
        server = 'ProBook\\Pro'
        # server = '192.168.1.201'
    database = 'RCMS'
    # username = 'sa'
    username = 'rdbu'
    password = 'HadiTabasiAslAvval'
    # password = '8Xc2dbUeK4H0jFwiQQxher7U'
    # Driver = 'ODBC Driver 18 for SQL Server';
    # Server = your_server;
    # Encrypt = yes;
    # Trusted_Connection = 'yes'

    try:
        connection = db.connect(server=server, user=username, password=password, database=database)
    except MSSQLDatabaseException as e:
        msg = f'Error on Connection: Number:{e.number}, Level:{e.severity}, State:{e.state}, Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)
    else:
        return connection


def get_radio_ip(radio_name):
    query = get_file(os.path.join(SQL_SELECT, 'radio_specification_by_name.sql')).format(radio_name)
    with get_connection() as con:
        answer = get_simple_row(con, query, as_dict=True)

    return answer


def get_available_stations(queries):
    with get_connection() as connection:
        result = get_simple_column(connection, queries.get('SRStation'))

    return result


def get_available_radios(queries):
    with get_connection() as connection:
        result = get_simple_column(connection, queries.get('SRStation'))

    return result

def load_stations():
    connection = get_connection()
    query = """
    SELECT Station AS 'name', Max(Frequency_No) AS 'fc' FROM Radio.Radio RR
         INNER JOIN Radio.Station RS ON RR.Station = RS.Code
         INNER JOIN Common.StationAvailability as SA ON RS.Availability = SA.id
    WHERE SA.Status = 'Available'
    GROUP BY Station;
    """

    return get_multiple_row(connection, query, as_dict=True)

def load_radios(stations):
    connection = get_connection()
    query = f"SELECT Name FROM Radio.Radio WHERE Station IN {stations} ORDER BY Name;"

    return get_simple_column(connection, query)


def get_scalar_answer(connection, query, log=None):
    try:
        return connection.execute_scalar(query)
    except MSSQLDatabaseException as e:
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
    except MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)


def execute_no_answer_query(connection, query, log=None):
    try:
        return connection.execute_non_query(query)
    except MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        if log is not None:
            log.exception(msg)
        else:
            print(msg)


if __name__ == '__main__':
    co = get_connection()
    a = get_multiple_row(co, """
    Select Station, Count(severity) As 'Warning'
    From HealthMonitor.FrequencyStatus
    Where severity=1
    GROUP BY Station""")
    # a = get_scalar_answer(co, 'select GRTI from Setting.Status')
    print(a)
    print(type(a))
    # s = "2024/06/12 16:33:33"
    # from datetime import datetime
    # d = datetime.strptime(s.replace('"', ''), '%Y/%m/%d %H:%M:%S')
    # print(d == a)