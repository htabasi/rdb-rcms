Use RCMS;
GO

UPDATE Application.Names SET App='Core', JobInformation='' WHERE id=1;
UPDATE Application.Names SET App='Reception', JobInformation='' WHERE id=2;
UPDATE Application.Names SET App='Keeper', JobInformation='' WHERE id=3;
UPDATE Application.Names SET App='Connector', JobInformation='' WHERE id=4;
UPDATE Application.Names SET App='Coordinator', JobInformation='' WHERE id=5;
UPDATE Application.Names SET App='Sender', JobInformation='' WHERE id=6;
UPDATE Application.Names SET App='Constructor', JobInformation='' WHERE id=7;
UPDATE Application.Names SET App='Executor', JobInformation='' WHERE id=8;
UPDATE Application.Names SET App='Generator', JobInformation='' WHERE id=9;
UPDATE Application.Names SET App='Commander', JobInformation='' WHERE id=10;
UPDATE Application.Names SET App='Preparer', JobInformation='' WHERE id=11;
UPDATE Application.Names SET App='Status', JobInformation='' WHERE id=12;
UPDATE Application.Names SET App='TimerUpdate', JobInformation='' WHERE id=13;
UPDATE Application.Names SET App='SettingsUpdate', JobInformation='' WHERE id=14;
UPDATE Application.Names SET App='SpecialUpdate', JobInformation='' WHERE id=15;
UPDATE Application.Names SET App='Optimum', JobInformation='' WHERE id=16;
UPDATE Application.Names SET App='Manager', JobInformation='' WHERE id=17;
GO

DROP TABLE Application.Configuration;
GO

CREATE TABLE Application.Configuration
(
    id                      INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date                    DATETIME      NOT NULL DEFAULT GETDATE(),
    Status                  TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.RecordStatus (id),
    ConnectionTryInterval   TINYINT       NOT NULL DEFAULT 60,   -- Second
    PeriodicSettingCheck    SMALLINT      NOT NULL DEFAULT 1440, -- Minute
    MaxDelaySettingCheck    SMALLINT      NOT NULL DEFAULT 60,   -- Minute
    PeriodicTimerUpdate     SMALLINT      NOT NULL DEFAULT 5,    -- Minute
    MaxDelayTimerUpdate     SMALLINT      NOT NULL DEFAULT 2,    -- Minute
    PeriodicSpecialUpdate   SMALLINT      NOT NULL DEFAULT 5,    -- Minute
    MaxDelaySpecialUpdate   SMALLINT      NOT NULL DEFAULT 2,    -- Minute
    CoreCheckInterval       DECIMAL(4, 2) NOT NULL DEFAULT 0.5,  -- Second
    PingTimeout             SMALLINT      NOT NULL DEFAULT 20,   -- Second
    SenderCalm              DECIMAL(4, 2) NOT NULL DEFAULT 0.3,  -- Second
    GeneratorCalm           DECIMAL(4, 2) NOT NULL DEFAULT 2.0,  -- Second
    ExecutorCalm            DECIMAL(4, 2) NOT NULL DEFAULT 3.0,  -- Second
    CommanderCalm           DECIMAL(4, 2) NOT NULL DEFAULT 5.0,  -- Second
    SessionWarningThreshold TINYINT       NOT NULL DEFAULT 3,    -- Session
    FistCommandID           SMALLINT      NOT NULL DEFAULT 1000,
    LastCommandID           SMALLINT      NOT NULL DEFAULT 9999
);
GO

INSERT INTO Application.Configuration
(Date, Status, ConnectionTryInterval, PeriodicSettingCheck, MaxDelaySettingCheck, PeriodicTimerUpdate,
 MaxDelayTimerUpdate, PeriodicSpecialUpdate, MaxDelaySpecialUpdate, CoreCheckInterval, PingTimeout, SenderCalm,
 GenerationCalm, ExecutorCalm, CommanderCalm, SessionWarningThreshold, FistCommandID, LastCommandID)
VALUES (GETDATE(), 1, 60, 1440, 60, 5, 2, 5, 2, 1, 20, 0.3, 2.0, 3.0, 5.0, 3, 1000, 9999);
GO

Update RCMS.Application.LogConfig Set RunMode=0, App=1, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=1;
Update RCMS.Application.LogConfig Set RunMode=0, App=2, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=2;
Update RCMS.Application.LogConfig Set RunMode=0, App=3, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=3;
Update RCMS.Application.LogConfig Set RunMode=0, App=4, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=4;
Update RCMS.Application.LogConfig Set RunMode=0, App=5, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=5;
Update RCMS.Application.LogConfig Set RunMode=0, App=6, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=6;
Update RCMS.Application.LogConfig Set RunMode=0, App=7, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=7;
Update RCMS.Application.LogConfig Set RunMode=0, App=8, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=8;
Update RCMS.Application.LogConfig Set RunMode=0, App=9, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=9;
Update RCMS.Application.LogConfig Set RunMode=0, App=10, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=10;
Update RCMS.Application.LogConfig Set RunMode=0, App=11, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=11;
Update RCMS.Application.LogConfig Set RunMode=0, App=12, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=12;
Update RCMS.Application.LogConfig Set RunMode=0, App=13, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=13;
Update RCMS.Application.LogConfig Set RunMode=0, App=14, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=14;
Update RCMS.Application.LogConfig Set RunMode=0, App=15, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=15;
Update RCMS.Application.LogConfig Set RunMode=0, App=16, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=16;
Update RCMS.Application.LogConfig Set RunMode=0, App=17, FileLevel=20, StreamLevel=30, FileFormat=1, StreamFormat=1  Where id=17;
Update RCMS.Application.LogConfig Set RunMode=1, App=1, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=18;
Update RCMS.Application.LogConfig Set RunMode=1, App=2, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=19;
Update RCMS.Application.LogConfig Set RunMode=1, App=3, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=20;
Update RCMS.Application.LogConfig Set RunMode=1, App=4, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=21;
Update RCMS.Application.LogConfig Set RunMode=1, App=5, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=22;
Update RCMS.Application.LogConfig Set RunMode=1, App=6, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=23;
Update RCMS.Application.LogConfig Set RunMode=1, App=7, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=24;
Update RCMS.Application.LogConfig Set RunMode=1, App=8, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=25;
Update RCMS.Application.LogConfig Set RunMode=1, App=9, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=26;
Update RCMS.Application.LogConfig Set RunMode=1, App=10, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=27;
Update RCMS.Application.LogConfig Set RunMode=1, App=11, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=28;
Update RCMS.Application.LogConfig Set RunMode=1, App=12, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=29;
Update RCMS.Application.LogConfig Set RunMode=1, App=13, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=30;
Update RCMS.Application.LogConfig Set RunMode=1, App=14, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=31;
Update RCMS.Application.LogConfig Set RunMode=1, App=15, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=32;
Update RCMS.Application.LogConfig Set RunMode=1, App=16, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=33;
Update RCMS.Application.LogConfig Set RunMode=1, App=17, FileLevel=20, StreamLevel=50, FileFormat=1, StreamFormat=1  Where id=34;
GO


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
GO
