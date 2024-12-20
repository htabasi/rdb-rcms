d = {
    'DHRadioStatus': 'sql/prepare/health/clear_radio_status.sql',
    'IACounter': 'sql/insert/analyze/counter.sql',
    'IATimer': 'sql/insert/analyze/timer.sql',
    'IATransmission': 'sql/insert/analyze/transmission.sql',
    'IAModuleStatus': 'sql/insert/module_status.sql',
    'IARadioStatus': "Insert Into Application.RadioStatus (Radio_Name, FirstConnection) VALUES ('{}', '{}');",
    'ICCBITList': 'sql/insert/setting/cbit_list.sql',
    'IEEadjustment': 'sql/insert/event/adjustment.sql',
    'IEECBIT': 'sql/insert/event/cbit.sql',
    'IEEConnection': 'sql/insert/event/connection.sql',
    'IEENetwork': 'sql/insert/event/network.sql',
    'IEEOperation': 'sql/insert/event/operation.sql',
    'IEEStatus': 'sql/insert/event/status.sql',
    'IEEventList': 'sql/insert/event/eventlist.sql',
    'IERXOperation': 'sql/insert/event/rx_operation.sql',
    'IESession': 'sql/insert/event/session.sql',
    'IESetCommands': 'sql/insert/event/set_command.sql',
    'IESpecialSetting': 'sql/insert/setting/special_setting.sql',
    'IETXOperation': 'sql/insert/event/tx_operation.sql',
    'ISAccess': 'sql/insert/setting/access.sql',
    'ISConfiguration': 'sql/insert/setting/configuration.sql',
    'ISInstallation': 'sql/insert/setting/installation.sql',
    'ISInventory': 'sql/insert/setting/inventory.sql',
    'ISIP': 'sql/insert/setting/ip.sql',
    'ISNetwork': 'sql/insert/setting/network.sql',
    'ISRXConfiguration': 'sql/insert/setting/rx_configuration.sql',
    'ISSCBIT': 'sql/insert/setting/cbit.sql',
    'ISSNMP': 'sql/insert/setting/snmp.sql',
    'ISSoftware': 'sql/insert/setting/software.sql',
    'ISStatus': 'sql/insert/setting/status.sql',
    'ISTXConfiguration': 'sql/insert/setting/tx_configuration.sql',
    'IVReception': 'sql/insert/variation/reception.sql',
    'IVTemperature': 'sql/insert/variation/temperature.sql',
    'IVTransmission': 'sql/insert/variation/transmission.sql',
    'IVVoltage': 'sql/insert/variation/voltage.sql',
    'IOEEConnection': 'sql/optimum/connection.sql',
    'MHFrequencyStatus': 'sql/insert/health/frequency_status.sql',
    'MHRadioStatus': 'sql/insert/health/radio_status.sql',
    'MOHRadioStatus': 'sql/optimum/connection_stat.sql',
    'SACounter': 'sql/prepare/analyze/counter.sql',
    'SAResetCommand': 'sql/analyze/select/reset.sql',
    'SATimer': 'sql/prepare/analyze/timer.sql',
    'SAConfiguration': 'sql/prepare/application/configuration.sql',
    'SALogConfig': 'sql/select/log_config.sql',
    'SALogFormat': 'sql/select/log_format.sql',
    'SAModuleStatus': 'sql/prepare/application/module_status.sql',
    'SARadioStatus': 'sql/prepare/application/radio_status.sql',
    'SAStatusUpdater': 'sql/select/status_log_config.sql',
    'SCHistory': 'sql/select/command_history.sql',
    'SDUser': 'sql/select/command_history_permission.sql',
    'SCRadioInitial': 'sql/prepare/initial.sql',
    'SCCBITList': 'sql/prepare/cbit_list.sql',
    'SESpecialSetting': 'sql/prepare/event/special.sql',
    'SHEqualString': 'sql/prepare/health/equal_string.sql',
    'SHFixedValue': 'sql/prepare/health/fixed_value.sql',
    'SHFrequencyParameters': 'sql/select/frequency_parameters.sql',
    'SHMultiLevel': 'sql/prepare/health/multi_level.sql',
    'SHPatternString': 'sql/prepare/health/pattern_string.sql',
    'SHRadioStatus': 'sql/select/radio_status.sql',
    'SHRange': 'sql/prepare/health/range.sql',
    'SRStation': 'sql/select/available_stations.sql',
    'SSAccess': 'sql/prepare/setting/access.sql',
    'SSConfiguration': 'sql/prepare/setting/configuration.sql',
    'SSInstallation': 'sql/prepare/setting/installation.sql',
    'SSInventory': 'sql/prepare/setting/inventory.sql',
    'SSIP': 'sql/prepare/setting/ip.sql',
    'SSNetwork': 'sql/prepare/setting/network.sql',
    'SSRXConfiguration': 'sql/prepare/setting/rx_configuration.sql',
    'SSSCBIT': 'sql/prepare/setting/cbit.sql',
    'SSSNMP': 'sql/prepare/setting/snmp.sql',
    'SSSoftware': 'sql/prepare/setting/software.sql',
    'SSStatus': 'sql/prepare/setting/status.sql',
    'SSTXConfiguration': 'sql/prepare/setting/tx_configuration.sql',
    'SARRadio': 'sql/select/available_radios.sql',
    'SIRRadio': "SELECT id, Name, Station, Frequency_No, Sector, RadioType, MainStandBy, IP FROM RCMS.Radio.Radio WHERE Name='{}';",
    'SMRRadio': 'sql/select/radio_multiple_station.sql',
    'SSRRadio': 'sql/select/radio_simple_station.sql',
    'UACounter': 'sql/analyze/update/counter.sql',
    'UATimer': 'sql/analyze/update/timer.sql',
    'UAModuleStatus': 'sql/update/module_status.sql',
    'UCHistory': 'sql/update/command_history.sql',
    'URRadio': 'sql/update/update_frequency.sql',
    'UCAResetCommand': 'sql/analyze/update/reset_command_counter.sql',
    'UOACounter': 'sql/optimum/counter.sql',
    'UOATimer': 'sql/optimum/timer.sql',
    'UOAModuleStatus': 'sql/optimum/module.sql',
    'URACounter': 'sql/analyze/update/reset_counter.sql',
    'URATimer': 'sql/analyze/update/reset_timer.sql',
    'USAModuleStatus': 'sql/update/module_status_start.sql',
    'UTAResetCommand': 'sql/analyze/update/reset_command_timer.sql',
}


def minimize_query(query):
    return ' '.join(query.split())


def read_file(file_name):
    with open(file_name, 'r') as f:
        return minimize_query(f.read())


def create_query(code, query):
    query = query.replace("'", "''")
    return f"""
INSERT INTO Application.Queries 
    (code, query) 
VALUES ('{code}', '{query}');\n"""


with open('sql/Database Creation/15_1_Fill_Application.sql', 'w') as wf:
    for code in sorted(d.keys()):
        file = d[code]
        if file.startswith('S') or file.startswith('I'):
            wf.write(create_query(code, file))
        else:
            wf.write(create_query(code, read_file(file)))
