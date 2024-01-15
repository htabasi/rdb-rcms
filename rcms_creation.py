import os


def remove_start_end(s:str):
    while s.startswith('\n'):
        s = s[1:]
    while s.endswith('\n'):
        s = s[:-1]
    return s


def eval_statement(s: str):
    rs = ''
    for l in s.split('\n'):
        if len(l) and not l.startswith('/*') and not l.startswith('--') and 'Create DATABASE RCMS' not in l:
            rs += l + '\n'
    if rs:
        return rs
    else:
        return


def get_creation():
    with open('dbfiles/M_Creation/Create_Tables.sql', 'r') as cf:
        creation_lines = cf.read()

    # print(creation_lines)
    creation_statements = [remove_start_end(line) for line in creation_lines.split('go')]

    # print(creation_statements)
    creation = []
    for statement in creation_statements:
        rs = eval_statement(statement)
        if rs:
            creation.append(rs)

    return creation


def get_filling():
    filling = []
    os.chdir('dbfiles/A_Creation')
    for file in sorted(os.listdir('.')):
        with open(file, 'r') as ff:
            for line in ff.readlines():
                filling.append(line)
    return filling


def create_database(server):
    from pymssql import _mssql as db
    try:
        connection = db.connect(server=server, user='sa', password='ht8923@$!&HT')
    except db.MSSQLDatabaseException as e:
        msg = f'Error on Connection: Number:{e.number}, Level:{e.severity}, State:{e.state}, Message:{e.message}'
        print(msg)
        return

    try:
        connection.execute_non_query('Drop Database IF EXISTS RCMS;')
        connection.execute_non_query('Create Database RCMS;')
    except db.MSSQLDatabaseException as e:
        msg = f'Creation Error!: Number:{e.number}, Level:{e.severity}, State:{e.state}, Message:{e.message}'
        print(msg)
    else:
        print('Database Created successfully!')

    connection.close()


def create_tables(server):
    from dbdriver import get_connection, execute_no_answer_query
    connection = get_connection(server=server)
    query_list = get_creation()

    while query_list:
        query = query_list.pop(0)
        execute_no_answer_query(connection, query)

    connection.close()
    print('All Database Objects created successfully!')


def fill_tables(server):
    from dbdriver import get_connection, execute_no_answer_query
    connection = get_connection(server=server)
    query_list = get_filling()

    while query_list:
        query = query_list.pop(0)
        execute_no_answer_query(connection, query)

    connection.close()
    print('All base tables filled successfully!')


def clear_database(server):
    clear_statements = []
    with open('dbfiles/M_Creation/clear_database.sql') as cdf:
        for line in cdf.readlines():
            if len(line) > 1:
                clear_statements.append(remove_start_end(line))

    from dbdriver import get_connection, execute_no_answer_query
    connection = get_connection(server=server)
    while clear_statements:
        query = clear_statements.pop(0)
        execute_no_answer_query(connection, query)

    connection.close()


if __name__ == '__main__':
    from sys import argv

    server_ip = '192.168.16.200'
    db_create = create = False
    for arg in argv:
        if '-s' in arg or 'server' in arg:
            server_ip = arg[arg.index('=') + 1:]

        if '-d' in arg:
            db_create = True

        if '-c' in arg or 'create' in arg:
            create = True

    if db_create:
        create_database(server_ip)

    if create:
        create_tables(server_ip)

    fill_tables(server_ip)
    # clear_database()
