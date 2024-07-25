import os
from datetime import datetime

from generator import get_file
from settings import SQL_ANALYZE_UPDATE


def get_updates(gauges):
    return ''.join([gauge.update() for gauge in gauges])[:-2], ''.join([gauge.update_res() for gauge in gauges])[:-2]


class Updater:
    gauges: list
    category: set
    update: str
    reset_query: str

    def __init__(self, root, log):
        self.root = root
        self.log = log
        self.radio = self.root.radio
        self.reset_date = self.get_date()
        self.reset_done = False
        self.define()

    def define(self):
        pass

    def add(self, *args):
        pass

    @staticmethod
    def get_date():
        return str(datetime.utcnow())[:23]

    def reset(self):
        self.reset_date = self.get_date()
        self.log.debug(f'{self.__class__.__name__} Resetting All Gauges')
        for gauge in self.gauges:
            gauge.reset()
        self.reset_done = True

    def generate(self):
        agg_update, res_update = get_updates(self.gauges)

        self.log.debug(f"{self.__class__.__name__} Write on DB:\n"
                       f"   aggregate : {agg_update}\n"
                       f"   resettable: {res_update}")
        ql = [self.update.format(agg_update, self.radio.name, 0),
              self.update.format(res_update, self.radio.name, 1)]
        if self.reset_done:
            ql.append(self.reset_query.format(self.reset_date, self.radio.name))
            self.reset_done = False
        return ql


class CounterUpdater(Updater):
    """
        CREATE TABLE Analyze.Counter
        (
            id                         INT IDENTITY PRIMARY KEY CLUSTERED,
            Radio_Name                 CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            ResetDate                  DATETIME NOT NULL DEFAULT GETUTCDATE(),
            RecordType                 TINYINT  NOT NULL DEFAULT 0 FOREIGN KEY REFERENCES Analyze.RecordType (id),
            CntConnect                 BIGINT   NOT NULL DEFAULT 0,
            CntDisconnect              BIGINT   NOT NULL DEFAULT 0,
            CntIndicatorOn             BIGINT   NOT NULL DEFAULT 0,
            CntCBITWarning             BIGINT   NOT NULL DEFAULT 0,
            CntCBITError               BIGINT   NOT NULL DEFAULT 0,
            CntSentPacket              BIGINT   NOT NULL DEFAULT 0,
            CntKeepConnectionPacket    BIGINT   NOT NULL DEFAULT 0,
            CntReceivedPacket          BIGINT   NOT NULL DEFAULT 0,
            CntReceivedMessage         BIGINT   NOT NULL DEFAULT 0,
            CntReceivedCommandError    BIGINT   NOT NULL DEFAULT 0,
            CntReceivedAccessError     BIGINT   NOT NULL DEFAULT 0,
            CntReceivedTrapAnswer      BIGINT   NOT NULL DEFAULT 0,
            CntReceivedGetAnswer       BIGINT   NOT NULL DEFAULT 0,
            CntReceivedTrapAcknowledge BIGINT   NOT NULL DEFAULT 0,
            CntReceivedSetAcknowledge  BIGINT   NOT NULL DEFAULT 0,
            CntQueryGenerated          BIGINT   NOT NULL DEFAULT 0,
            CntQueryExecuted           BIGINT   NOT NULL DEFAULT 0,
            CntCommandExecuted         BIGINT   NOT NULL DEFAULT 0,
            CntCommandRejected         BIGINT   NOT NULL DEFAULT 0,
            CntUpdateSettings          BIGINT   NOT NULL DEFAULT 0,
            CntUpdateSpecial           BIGINT   NOT NULL DEFAULT 0,
            CntUpdateTimer             BIGINT   NOT NULL DEFAULT 0,
            CntErrorPacketReceive      BIGINT   NOT NULL DEFAULT 0,
            CntErrorPacketEvaluation   BIGINT   NOT NULL DEFAULT 0,
            CntErrorPacketSending      BIGINT   NOT NULL DEFAULT 0,
            CntErrorConnection         BIGINT   NOT NULL DEFAULT 0,
            CntErrorQueryGeneration    BIGINT   NOT NULL DEFAULT 0,
            CntErrorQueryExecution     BIGINT   NOT NULL DEFAULT 0,
            CnrErrorCommandExecution   BIGINT   NOT NULL DEFAULT 0,
            CntErrorUpdateSettings     BIGINT   NOT NULL DEFAULT 0,
            CntErrorUpdateSpecial      BIGINT   NOT NULL DEFAULT 0,
            CntErrorUpdateTimer        BIGINT   NOT NULL DEFAULT 0
        );
    """

    def define(self):
        self.gauges = [
            self.root.connect_counter,
            self.root.disconnect_counter,
            self.root.indicator_on_ctr,
            self.root.generator.event_cbit.warning_count,
            self.root.generator.event_cbit.error_count,
            self.root.snd_packet,
            self.root.keeper.kep_packet,
            self.root.reception.rec_packet,
            self.root.reception.rec_message,
            self.root.reception.rec_c_error,
            self.root.reception.rec_a_error,
            self.root.reception.rec_trap_answer,
            self.root.reception.rec_get_answer,
            self.root.reception.rec_trap_ack,
            self.root.reception.rec_set_ack,
            self.root.generator.gen_query,
            self.root.executor.exe_query,
            self.root.commander.cmd_executed,
            self.root.commander.cmd_rejected,
            self.root.setting_planner.pln_counter,
            self.root.timer_planner.pln_counter,
            self.root.reception.err_receive,
            self.root.reception.err_eval,
            self.root.err_send,
            self.root.err_connect,
            self.root.generator.err_generate,
            self.root.executor.err_execute,
            self.root.commander.err_command,
            self.root.setting_planner.err_counter,
            self.root.timer_planner.err_counter
        ]
        if self.radio.type == 'TX':
            self.gauges.extend([self.root.special_planner.pln_counter, self.root.special_planner.err_counter])

        self.category = {'Counter'}
        self.update = get_file(os.path.join(SQL_ANALYZE_UPDATE, 'counter.sql'))
        self.reset_query = get_file(os.path.join(SQL_ANALYZE_UPDATE, 'reset_counter.sql'))


class TimerUpdater(Updater):
    """
        CREATE TABLE Analyze.AggregateTimer
        (
            id                INT IDENTITY PRIMARY KEY CLUSTERED,
            Radio_Name        CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            IndicatorONSec    DECIMAL(13, 3) DEFAULT 0.0,
            IndicatorOFFSec   DECIMAL(13, 3) DEFAULT 0.0,
            ConnectTimeSec    DECIMAL(13, 3) DEFAULT 0.0,
            DisconnectTimeSec DECIMAL(13, 3) DEFAULT 0.0,
        );

        CREATE TABLE Analyze.ResettableTimer
        (
            id                INT IDENTITY PRIMARY KEY CLUSTERED,
            Radio_Name        CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
            ResetDate         DATETIME        NOT NULL DEFAULT GETUTCDATE(),
            IndicatorONSec    DECIMAL(13, 3)           DEFAULT 0.0,
            IndicatorOFFSec   DECIMAL(13, 3)           DEFAULT 0.0,
            ConnectTimeSec    DECIMAL(13, 3)           DEFAULT 0.0,
            DisconnectTimeSec DECIMAL(13, 3)           DEFAULT 0.0,
        );
    """

    def define(self):
        self.gauges = [
            self.root.indicator_on,
            self.root.indicator_off,
            self.root.connect_time,
            self.root.disconnect_time,
            self.root.operating_hour
        ]
        self.category = {'Timer'}
        self.update = get_file(os.path.join(SQL_ANALYZE_UPDATE, 'timer.sql'))
        self.reset_query = get_file(os.path.join(SQL_ANALYZE_UPDATE, 'reset_timer.sql'))
