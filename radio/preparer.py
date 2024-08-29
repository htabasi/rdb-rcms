import os

from execute import get_simple_row, get_multiple_row, get_simple_column, execute_no_answer_query
from generator import get_file
from settings import SQL_PREPARE, SQL_PREPARE_APPLICATION, SQL_PREPARE_EVENT, SQL_PREPARE_SETTING, SQL_PREPARE_ANALYZE, \
    SQL_PREPARE_HEALTH


class RadioPreparer:
    def __init__(self, parent, log):
        self.log = log
        self.connection = parent.db_connection
        self.name = parent.radio.name
        self.id = parent.radio.id
        self.code = parent.radio.radio_code

        self.log.info('Radio Preparer initialized')

        self.application = self.simple_row(SQL_PREPARE_APPLICATION, 'configuration.sql', (), as_dict=True)
        self.radio_status = self.simple_row(SQL_PREPARE_APPLICATION, 'radio_status.sql', (self.name,))
        self.module_status = self.simple_row(SQL_PREPARE_APPLICATION, 'module_status.sql', (self.name,),
                                             as_dict=True)

        self.counter = self.get_timer_counter('counter.sql')
        self.timer = self.get_timer_counter('timer.sql')

        self.access = self.simple_row(SQL_PREPARE_SETTING, 'access.sql', (self.name,))
        self.cbit = self.simple_row(SQL_PREPARE_SETTING, 'cbit.sql', (self.name,))
        self.configuration = self.simple_row(SQL_PREPARE_SETTING, 'configuration.sql', (self.name,), as_dict=True)
        self.installation = self.simple_row(SQL_PREPARE_SETTING, 'installation.sql', (self.name,), as_dict=True)
        self.inventory = self.multiple_row(SQL_PREPARE_SETTING, 'inventory.sql', (self.name,))
        self.first_ip = self.simple_row(SQL_PREPARE_SETTING, 'ip.sql', (self.name, 0))
        self.second_ip = self.simple_row(SQL_PREPARE_SETTING, 'ip.sql', (self.name, 1))
        self.network = self.simple_row(SQL_PREPARE_SETTING, 'network.sql', (self.name,), as_dict=True)
        self.snmp = self.simple_row(SQL_PREPARE_SETTING, 'snmp.sql', (self.name,), as_dict=True)
        self.software = self.multiple_row(SQL_PREPARE_SETTING, 'software.sql', (self.name,))
        self.status = self.simple_row(SQL_PREPARE_SETTING, 'status.sql', (self.name,), as_dict=True)

        query = get_file(os.path.join(SQL_PREPARE_HEALTH, 'clear_radio_status.sql')).format(self.name)
        execute_no_answer_query(self.connection, query, self.log)
        self.health_parameters = (
            self.multiple_row(SQL_PREPARE_HEALTH, 'fixed_value.sql', (self.name,), as_dict = True),
            self.multiple_row(SQL_PREPARE_HEALTH, 'multi_level.sql', (self.name,), as_dict=True),
            self.multiple_row(SQL_PREPARE_HEALTH, 'range.sql', (self.name,), as_dict=True),
            self.multiple_row(SQL_PREPARE_HEALTH, 'equal_string.sql', (self.name,), as_dict=True),
            self.multiple_row(SQL_PREPARE_HEALTH, 'pattern_string.sql', (self.name,), as_dict=True)
        )
        self.cbit_list = self.simple_column(SQL_PREPARE, 'cbit_list.sql', ())
        parent.initial_commands = self.multiple_row(SQL_PREPARE, 'initial.sql', (self.code,))
        if parent.radio.type == 'RX':
            self.trx_configuration = self.simple_row(SQL_PREPARE_SETTING, 'rx_configuration.sql',
                                                     (self.name,), as_dict=True)
        else:
            self.special = self.simple_row(SQL_PREPARE_EVENT, 'special.sql', (self.name,), as_dict=True)
            self.trx_configuration = self.simple_row(SQL_PREPARE_SETTING, 'tx_configuration.sql',
                                                     (self.name,), as_dict=True)

        self.log.debug(f'Radio Preparer initialized: Status={self.module_status}')

    def get_timer_counter(self, filename):
        answer = self.multiple_row(SQL_PREPARE_ANALYZE, filename, (self.name,), as_dict=True)
        if answer is None:
            self.prepare_timer_counter(self.name, filename)
            answer = self.multiple_row(SQL_PREPARE_ANALYZE, filename, (self.name,), as_dict=True)
        return {row['RecordType']: row for row in answer}

    def prepare_timer_counter(self, name, filename):
        from settings import SQL_INSERT_ANALYZE
        query = get_file(os.path.join(SQL_INSERT_ANALYZE, filename)).format(name)
        execute_no_answer_query(self.connection, query, self.log)

    def simple_row(self, folder, file, args, as_dict=False):
        query = get_file(os.path.join(folder, file)).format(*args)
        return get_simple_row(self.connection, query, self.log, as_dict=as_dict)

    def multiple_row(self, folder, file, args, as_dict=False):
        query = get_file(os.path.join(folder, file)).format(*args)
        return get_multiple_row(self.connection, query, self.log, as_dict=as_dict)

    def simple_column(self, folder, file, args):
        query = get_file(os.path.join(folder, file)).format(*args)
        return get_simple_column(self.connection, query, self.log)

    # def scalar(self, file, args):
    #     query = get_file(f'./dbfiles/prepare/{file}').format(*args)
    #     return get_scalar_answer(self.connection, query, self.log)
