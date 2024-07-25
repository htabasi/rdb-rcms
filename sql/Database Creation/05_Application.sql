USE RCMS;
GO

CREATE TABLE Application.Names
(
    id             TINYINT      NOT NULL PRIMARY KEY CLUSTERED,
    App            VARCHAR(30)  NOT NULL UNIQUE,
    JobInformation VARCHAR(255) NULL
);
GO

CREATE TABLE Application.RunningMode
(
    id   TINYINT     NOT NULL PRIMARY KEY CLUSTERED,
    Mode VARCHAR(50) NOT NULL
)
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
    LastCommandID           SMALLINT      NOT NULL DEFAULT 9999,
    AnalyzeCalm             DECIMAL(4, 2) NOT NULL DEFAULT 5.0  -- Second
);
GO

-- Drop TABLE Application.RadioStatus;
CREATE TABLE Application.RadioStatus
(
    id               INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name       char(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    FirstConnection  DATETIME NOT NULL DEFAULT GETDATE(),
    EventListCollect DATETIME NULL,
    NextConfigFetch  DATETIME NULL
);
GO

CREATE TABLE Application.LogLevel
(
    id    TINYINT NOT NULL PRIMARY KEY CLUSTERED,
    Level CHAR(8) NOT NULL
);
GO


CREATE TABLE Application.LogFormat
(
    id              TINYINT    NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    separator       VARCHAR(3) NOT NULL,
    radio           TINYINT    NOT NULL, -- Radio Name
    radio_len       TINYINT    NOT NULL,
    asctime         TINYINT    NOT NULL, -- time
    asctime_len     TINYINT    NOT NULL,
    name            TINYINT    NOT NULL, -- log name
    name_len        TINYINT    NOT NULL,
    pathname        TINYINT    NOT NULL, --full path of the filename
    pathname_len    TINYINT    NOT NULL,
    filename        TINYINT    NOT NULL, --log generator filename
    filename_len    TINYINT    NOT NULL,
    module          TINYINT    NOT NULL, --same as filename without .py
    module_len      TINYINT    NOT NULL,
    funcName        TINYINT    NOT NULL, --log generator funcName
    funcName_len    TINYINT    NOT NULL,
    [lineno]        TINYINT    NOT NULL, --line number of file that create log record
    lineno_len      TINYINT    NOT NULL,
    processName     TINYINT    NOT NULL, --Process name same as MainProcess
    processName_len TINYINT    NOT NULL,
    process         TINYINT    NOT NULL, --pid of running process
    process_len     TINYINT    NOT NULL,
    threadName      TINYINT    NOT NULL, --Thread name
    threadName_len  TINYINT    NOT NULL,
    thread          TINYINT    NOT NULL, --thread ID same as MainThread
    thread_len      TINYINT    NOT NULL,
    levelname       TINYINT    NOT NULL, --log level
    levelname_len   TINYINT    NOT NULL,
    levelno         TINYINT    NOT NULL, --log level number
    levelno_len     TINYINT    NOT NULL,
    message         TINYINT    NOT NULL,--log message
    message_len     TINYINT    NOT NULL
);
GO


CREATE TABLE Application.LogConfig
(
    id           TINYINT NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    RunMode      TINYINT NOT NULL FOREIGN KEY REFERENCES Application.RunningMode (id),
    App          TINYINT NOT NULL FOREIGN KEY REFERENCES Application.Names (id),
    FileLevel    TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogLevel (id),
    StreamLevel  TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogLevel (id),
    FileFormat   TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogFormat (id),
    StreamFormat TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogFormat (id)
);
GO


CREATE TABLE Application.RadioModuleStatus
(
    id                          INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    RadioModuleName             CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    StartTime                   DATETIME NOT NULL DEFAULT GETDATE(),
    PID                         INT      NOT NULL DEFAULT -1,
    UpdateTime                  DATETIME NULL,
    ModuleAliveCounter          INT      NULL,
    ModuleAlive                 BIT      NULL,
    ReceptionAlive              BIT      NULL,
    KeepConnectionAlive         BIT      NULL,
    GeneratorAlive              BIT      NULL,
    ConnectorAlive              BIT      NULL,
    AnalyzerAlive               BIT      NULL,
    CommanderAlive              BIT      NULL,
    SettingUpdaterAlive         BIT      NULL,
    RadioConnected              BIT      NULL,
    DBConnected                 BIT      NULL,
    SettingUpdaterInProgress    BIT      NULL,
    RadioDisconnectionCounter   INT      NULL,
    DBDisconnectionCounter      INT      NULL,
    ReceivedPacketCounter       INT      NULL,
    ParameterUpdateCounter      INT      NULL,
    CommandRequestCounter       INT      NULL,
    SentPacketCounter           INT      NULL,
    QueryGeneratedCounter       INT      NULL,
    QueryExecutedCounter        INT      NULL,
    PacketEvalErrorCounter      INT      NULL,
    CommandRequestError         INT      NULL,
    PacketSendingErrorCounter   INT      NULL,
    QueryGenerationErrorCounter INT      NULL,
    QueryExecutionErrorCounter  INT      NULL,
    QueryWaitingCounter         INT      NULL,
    SettingUpdateCounter        INT      NULL
);
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

