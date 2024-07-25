from pymssql import _mssql as db
import os


def get_connection(to_liara=False):
    username = 'sa'

    if to_liara:
        server = 'olympus.liara.cloud'
        password = '8Xc2dbUeK4H0jFwiQQxher7U'
        port = 31430
    else:
        server = 'PROBOOK\PRO'
        password = 'ht8923@$!&HT'
        port = 1433

    try:
        connection = db.connect(server=server, user=username, password=password, port=port)
    except db.MSSQLDatabaseException as e:
        print(f'Error on Connection:\n    Number:{e.number}\n    Level:{e.severity}\n    State:{e.state}\n'
              f'    Message:{e.message}')
    else:
        return connection


def execute_no_answer_query(connection, query):
    try:
        connection.execute_non_query(query)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        print(msg)
        return None
    else:
        return connection.rows_affected


def get_query_answer(connection, query):
    try:
        connection.execute_query(query)
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Query Execution: Query:{query} Number:{e.number}, Level:{e.severity}, State:{e.state}, ' \
              f'Message:{e.message}'
        print(msg)
    else:
        return list(connection)[0]


def get_multiple_row(connection, query, as_dict=False):
    execute_no_answer_query(connection, query)
    if as_dict:
        return [{item: row[item] for item in row if type(item) is str} for row in connection]
    else:
        result = [[row[i] for i in range(len(row) // 2)] for row in connection]
        if len(result) == 0:
            return None
        return result


def get_sql_files(folder):
    folder_content = os.listdir(folder)
    return sorted(
        [filename for filename in folder_content if filename.endswith('.sql') and not filename.startswith('2')])


def check_files(folder):
    sql_files = get_sql_files(folder)
    for filename in sql_files:
        with open(filename, 'r') as f:
            file_content = f.read()
        file_content = file_content.replace('go\n', 'GO\n')
        with open(filename, 'w') as f:
            f.write(file_content)


def get_file(file):
    with open(file, 'r') as f:
        wq = f.read()
    wql = wq.split('\nGO')
    return [statement for statement in wql if statement]


def load_and_run(folder):
    connection = get_connection()
    sql_files = get_sql_files(folder)
    for filename in sql_files:
        statements = get_file(filename)
        for statement in statements:
            print(statement)
            answer = execute_no_answer_query(connection, statement)
            if answer is None:
                return
            else:
                print(f'--> {answer} rows affected.')


if __name__ == '__main__':
    load_and_run('.')
    # print(get_sql_files('.'))
    # con = get_connection()
    # execute_no_answer_query(con, "SELECT DATABASEPROPERTYEX('RCMS', 'UserAccess');")
