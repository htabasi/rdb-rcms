import os

current_file_path = os.path.realpath(__file__)

ROOT_DIR = os.path.dirname(current_file_path)

LOG_DIR = os.path.join(ROOT_DIR, 'export')
SQL_DIR = os.path.join(ROOT_DIR, 'sql')

SQL_INSERT = os.path.join(SQL_DIR, 'insert')
SQL_OPTIMUM = os.path.join(SQL_DIR, 'optimum')
SQL_PREPARE = os.path.join(SQL_DIR, 'prepare')
SQL_SELECT = os.path.join(SQL_DIR, 'select')
SQL_UPDATE = os.path.join(SQL_DIR, 'update')
SQL_ANALYZE = os.path.join(SQL_DIR, 'analyze')

SQL_INSERT_ANALYZE = os.path.join(SQL_INSERT, 'analyze')
SQL_INSERT_EVENT = os.path.join(SQL_INSERT, 'event')
SQL_INSERT_SETTING = os.path.join(SQL_INSERT, 'setting')
SQL_INSERT_VARIATION = os.path.join(SQL_INSERT, 'variation')

SQL_ANALYZE_SELECT = os.path.join(SQL_ANALYZE, 'select')
SQL_ANALYZE_UPDATE = os.path.join(SQL_ANALYZE, 'update')

SQL_PREPARE_ANALYZE = os.path.join(SQL_PREPARE, 'analyze')
SQL_PREPARE_APPLICATION = os.path.join(SQL_PREPARE, 'application')
SQL_PREPARE_EVENT = os.path.join(SQL_PREPARE, 'event')
SQL_PREPARE_SETTING = os.path.join(SQL_PREPARE, 'setting')
