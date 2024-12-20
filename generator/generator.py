from threading import Thread
from time import sleep

from base.aggregator import Aggregator
from generator.event.adjustment import EAdjustmentInserter
from generator.event.cbit import ECBITInserter
from generator.event.connection import EConnectionInserter
from generator.event.eventlist import EventListInserter
from generator.event.network import ENetworkInserter
from generator.event.operation import EOperationInserter
from generator.event.rx_operation import ERXOperationInserter
from generator.event.session import ESessionInserter
from generator.event.set_commands import ESetCommandInserter
from generator.event.status import EStatusInserter
from generator.event.tx_operation import ETXOperationInserter
from generator.module import ModuleStatusUpdater
from generator.setting import SSpecialSettingInserter
from generator.setting.access import SAccessInserter
from generator.setting.cbit import SCBITInserter
from generator.setting.configuration import SConfigurationInserter
from generator.setting.installation import SInstallationInserter
from generator.setting.inventory import SInventoryInserter
from generator.setting.ip import SIPInserter
from generator.setting.network import SNetworkInserter
from generator.setting.rx_configuration import SRXConfigurationInserter
from generator.setting.snmp import SSNMPInserter
from generator.setting.software import SSoftwareInserter
from generator.setting.status import SStatusInserter
from generator.setting.tx_configuration import STXConfigurationInserter
from generator.variation.reception import VReceptionInserter
from generator.variation.temprature import VTemperatureInserter
from generator.variation.transmission import VTransmissionInserter
from generator.variation.voltage import VVoltageInserter


class QueryGenerator(Thread):
    def __init__(self, parent, executor, log):
        super(QueryGenerator, self).__init__(name='Query_Generator')
        self.radio = parent
        self.executor = executor
        self.buffer = [[], []]
        self.writer = 0
        self.log = log

        self.calm = 2.0
        self.alive_counter = self.alive_counter_prev = 0
        self.gen_query = Aggregator('CntQueryGenerated')
        self.err_generate = Aggregator('CntErrorQueryGeneration')
        # self.err_generate = self.gen_query = 0

        self.event_adjustment = EAdjustmentInserter(self.radio, self.log)
        self.event_cbit = ECBITInserter(self.radio, self.log)
        self.event_connection = EConnectionInserter(self.radio, self.log)
        self.event_status = EStatusInserter(self.radio, self.log)
        self.event_list = EventListInserter(self.radio, self.log)
        self.event_network = ENetworkInserter(self.radio, self.log)
        self.event_operation = EOperationInserter(self.radio, self.log)
        self.event_session = ESessionInserter(self.radio, self.log)
        self.event_set_command = ESetCommandInserter(self.radio, self.log)

        self.setting_access = SAccessInserter(self.radio, self.log)
        self.setting_cbit = SCBITInserter(self.radio, self.log)
        self.setting_configuration = SConfigurationInserter(self.radio, self.log)
        self.setting_installation = SInstallationInserter(self.radio, self.log)
        self.setting_inventory = SInventoryInserter(self.radio, self.log)
        self.setting_ip = SIPInserter(self.radio, self.log)
        self.setting_network = SNetworkInserter(self.radio, self.log)
        self.setting_snmp = SSNMPInserter(self.radio, self.log)
        self.setting_software = SSoftwareInserter(self.radio, self.log)
        self.setting_status = SStatusInserter(self.radio, self.log)

        self.variation_temperature = VTemperatureInserter(self.radio, self.log)
        self.variation_voltage = VVoltageInserter(self.radio, self.log)

        if self.radio.radio.type == 'RX':
            self.event_trx_operation = ERXOperationInserter(self.radio, self.log)
            self.setting_trx_configuration = SRXConfigurationInserter(self.radio, self.log)
            self.variation_radio = VReceptionInserter(self.radio, self.log)
        else:
            self.event_special = SSpecialSettingInserter(self.radio, self.log)
            self.event_trx_operation = ETXOperationInserter(self.radio, self.log)
            self.setting_trx_configuration = STXConfigurationInserter(self.radio, self.log)
            self.variation_radio = VTransmissionInserter(self.radio, self.log)
        self.module_status_updater = ModuleStatusUpdater(self.radio, self.log)

        self.parts = [self.event_adjustment, self.event_cbit, self.event_connection,
                      self.event_status, self.event_list, self.event_network, self.event_operation,
                      self.event_session, self.event_set_command, self.event_trx_operation, self.setting_access,
                      self.setting_cbit, self.setting_configuration, self.setting_installation, self.setting_inventory,
                      self.setting_ip, self.setting_network, self.setting_snmp, self.setting_software,
                      self.setting_status, self.setting_trx_configuration, self.module_status_updater,
                      self.variation_radio, self.variation_temperature, self.variation_voltage]

        if self.radio.radio.type == 'TX':
            self.parts.append(self.event_special)

        self.mapper = {key: part for part in self.parts for key in part.acceptable_keys}
        self.log.info('Initialized')

    def set_counters(self, aggregate, resettable):
        self.gen_query.set(aggregate, resettable)
        self.err_generate.set(aggregate, resettable)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def run(self) -> None:
        self.log.info('Started')
        while self.radio.keep_alive:
            # self.log.debug(f"keep_connection = {self.memory.keep_connection}, sleep_time={self.timing}")
            reader = 1 - self.writer
            # self.log.debug(f"Reading {len(self.buffer[reader])} new data.")

            try:
                self.generate(self.buffer[reader])
            except Exception as e:
                self.err_generate.add()
                self.log.exception(f'Error on Query Generation! {e}')

            # self.log.debug(f"Buffer {reader}: length = {len(self.buffer[reader])}")

            if not self.radio.keep_alive:
                # self.log.debug(f"Reading {len(self.buffer[self.writer])} new data from latest buffer.")
                sleep(self.calm / 2)
                self.generate(self.buffer[self.writer])

            self.alive_counter += 1
            sleep(self.calm)
            self.writer = reader
            # self.log.debug(f"Read Buffer switched to {reader}")

        self.log.info('Finished')

    def add(self, time_tag, key, value):
        try:
            self.buffer[self.writer].append((time_tag, key, value))
        except Exception as e:
            self.err_generate.add()
            self.log.exception(f'Error on adding key-value! {e}')

    def generate(self, buffer: list):
        while buffer:
            time_tag, key, value = buffer.pop(0)
            try:
                query_list = self.mapper[key].generate(time_tag, key, value)
            except KeyError as e:
                self.err_generate.add()
                self.log.exception(f'Mapper Error: {e.args} {e.__traceback__}')
            except Exception as e:
                self.err_generate.add()
                self.log.exception(f'Error on Generate Queries or extending query list! {e}')
            else:
                self.log.debug(f'{(time_tag, key, value)}: {query_list}')
                self.gen_query.add(len(query_list))
                for statement in query_list:
                    if statement:
                        self.executor.add(statement)
            finally:
                self.alive_counter += 1
