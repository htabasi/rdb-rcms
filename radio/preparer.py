from execute import get_simple_row, get_multiple_row, get_simple_column, execute_no_answer_query


class RadioPreparer:
    def __init__(self, parent, log):
        self.log = log
        self.connection = parent.db_connection
        self.name = parent.radio.name
        self.id = parent.radio.id
        self.code = parent.radio.radio_code
        self.queries = parent.queries

        self.log.info('Radio Preparer initialized')

        self.application = self.simple_row('SAConfiguration', (), as_dict=True)
        self.radio_status = self.simple_row('SARadioStatus', (self.name,))
        self.module_status = self.simple_row('SAModuleStatus', (self.name,), as_dict=True)

        self.counter = self.get_timer_counter('SACounter', 'IACounter')
        self.timer = self.get_timer_counter('SATimer', 'IATimer')
        self.log.debug(f'Timer: {self.timer}')

        self.access = self.simple_row('SSAccess', (self.name,))
        self.cbit = self.simple_row('SSSCBIT', (self.name,))
        self.configuration = self.simple_row('SSConfiguration', (self.name,), as_dict=True)
        self.installation = self.simple_row('SSInstallation', (self.name,), as_dict=True)
        self.inventory = self.multiple_row('SSInventory', (self.name,))
        self.first_ip = self.simple_row('SSIP', (self.name, 0))
        self.second_ip = self.simple_row('SSIP', (self.name, 1))
        self.network = self.simple_row('SSNetwork', (self.name,), as_dict=True)
        self.snmp = self.simple_row('SSSNMP', (self.name,), as_dict=True)
        self.software = self.multiple_row('SSSoftware', (self.name,))
        self.status = self.simple_row('SSStatus', (self.name,), as_dict=True)

        query = self.queries.get('DHRadioStatus').format(self.name)
        execute_no_answer_query(self.connection, query, self.log)
        self.health_parameters = (
            self.multiple_row('SHFixedValue', (self.name,), as_dict=True),
            self.multiple_row('SHMultiLevel', (self.name,), as_dict=True),
            self.multiple_row('SHRange', (self.name,), as_dict=True),
            self.multiple_row('SHEqualString', (self.name,), as_dict = True),
            self.multiple_row('SHPatternString', (self.name,), as_dict=True),
        )
        self.cbit_list = self.simple_column('SCCBITList', ())
        parent.initial_commands = self.multiple_row('SCRadioInitial', (self.code,))
        if parent.radio.type == 'RX':
            self.trx_configuration = self.simple_row('SSRXConfiguration', (self.name,), as_dict=True)
            self.rssi_clusters = self.simple_row('SARSSIClusters', (self.name,))
        else:
            self.special = self.simple_row('SESpecialSetting', (self.name,), as_dict=True)
            self.trx_configuration = self.simple_row('SSTXConfiguration', (self.name,), as_dict=True)

        self.log.debug(f'Radio Preparer initialized: Status={self.module_status}')

    def get_timer_counter(self, select_code, insert_code):
        answer = self.multiple_row(select_code, (self.name,), as_dict=True)
        if answer is None or len(answer) == 0:
            self.prepare_timer_counter(insert_code, self.name)
            answer = self.multiple_row(select_code, (self.name,), as_dict=True)
        return {row['RecordType']: row for row in answer}

    def prepare_timer_counter(self, query_code, name):
        query = self.queries.get(query_code).format(name)
        execute_no_answer_query(self.connection, query, self.log)

    def simple_row(self, query_code, args, as_dict=False):
        query = self.queries.get(query_code).format(*args)
        return get_simple_row(self.connection, query, self.log, as_dict=as_dict)

    def multiple_row(self, query_code, args, as_dict=False):
        query = self.queries.get(query_code).format(*args)
        return get_multiple_row(self.connection, query, self.log, as_dict=as_dict)

    def simple_column(self, query_code, args):
        query = self.queries.get(query_code).format(*args)
        return get_simple_column(self.connection, query, self.log)

    # def scalar(self, file, args):
    #     query = get_file(f'./dbfiles/prepare/{file}').format(*args)
    #     return get_scalar_answer(self.connection, query, self.log)
