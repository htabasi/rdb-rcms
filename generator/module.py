class ModuleStatusUpdater:
    """
        CREATE TABLE Application.ModuleStatus
        (
            id                         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
            Name                       CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
            StartTime                  DATETIME NOT NULL DEFAULT GETDATE(),
            PID                        INT      NOT NULL DEFAULT -1,
            UpdateTime                 DATETIME NULL,
            ModuleAlive                BIT      NULL,
            ReceptionAlive             BIT      NULL,
            KeeperAlive                BIT      NULL,
            GeneratorAlive             BIT      NULL,
            ExecutorAlive              BIT      NULL,
            CommanderAlive             BIT      NULL,
            AnalyzerAlive              BIT      NULL,
            RadioConnected             BIT      NULL,
            DatabaseConnected          BIT      NULL,
            UpdateSettingsScheduled    BIT      NULL,
            UpdateSpecialScheduled     BIT      NULL,
            UpdateTimerScheduled       BIT      NULL,
            UpdateSettingsExecuting    BIT      NULL,
            UpdateSpecialExecuting     BIT      NULL,
            UpdateTimerExecuting       BIT      NULL,
            CntConnect                 BIGINT   NULL,
            CntDisconnect              BIGINT   NULL,
            CntSentPacket              BIGINT   NULL,
            CntKeepConnectionPacket    BIGINT   NULL,
            CntReceivedPacket          BIGINT   NULL,
            CntReceivedMessage         BIGINT   NULL,
            CntReceivedCommandError    BIGINT   NULL,
            CntReceivedAccessError     BIGINT   NULL,
            CntReceivedTrapAnswer      BIGINT   NULL,
            CntReceivedGetAnswer       BIGINT   NULL,
            CntReceivedTrapAcknowledge BIGINT   NULL,
            CntReceivedSetAcknowledge  BIGINT   NULL,
            CntQueryGenerated          BIGINT   NULL,
            CntQueryExecuted           BIGINT   NULL,
            CntCommandExecuted         BIGINT   NULL,
            CntCommandRejected         BIGINT   NULL,
            CntUpdateSettings          BIGINT   NULL,
            CntUpdateSpecial           BIGINT   NULL,
            CntUpdateTimer             BIGINT   NULL,
            CntErrorPacketReceive      BIGINT   NULL,
            CntErrorPacketEvaluation   BIGINT   NULL,
            CntErrorPacketSending      BIGINT   NULL,
            CntErrorConnection         BIGINT   NULL,
            CntErrorQueryGeneration    BIGINT   NULL,
            CntErrorQueryExecution     BIGINT   NULL,
            CnrErrorCommandExecution   BIGINT   NULL,
            CntErrorUpdateSettings     BIGINT   NULL,
            CntErrorUpdateSpecial      BIGINT   NULL,
            CntErrorUpdateTimer        BIGINT   NULL
        )
    """

    def __init__(self, radio, log):
        self.acceptable_keys = ['ModuleStatus']
        self.update = radio.queries.get('UAModuleStatus')
        self.log = log

    def generate(self, *args):
        """args are: time_tag, key, value"""
        self.log.debug(f"{self.__class__.__name__}: Status Update generating")
        kv, value = f"{'UpdateTime'}='{args[0].strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]}', ", args[2]
        for item in value:
            if item in ['id', 'Name', 'StartTime', 'UpdateTime', 'PID']:
                continue
            kv += f"{item}={value[item]}, "

        return [self.update.format(kv[:-2].replace('None', 'NULL'), value['id'])]
