Create DATABASE RCMS;
go

Use RCMS;
go

Create SCHEMA Common;
go

Create SCHEMA Event;
go

Create SCHEMA Setting;
go

Create Schema Command;
go

Create SCHEMA Station;
go

Create SCHEMA Application;
go

-- IF OBJECT_ID('Common.RadioType', 'T') IS NOT NULL
--     DROP Table Common.RadioType;
--
-- IF OBJECT_ID('Common.OnOff', 'T') IS NOT NULL
--     DROP Table Common.OnOff;
go

/**************************************   Common SCHEMA    ****************************************************/

    CREATE TABLE Common.Activation
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(8)
);
go

CREATE TABLE Common.ATRMode
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Mode CHAR(10)
);
go

Create TABLE Common.AudioInterface
(
    id        TINYINT     NOT NULL PRIMARY KEY,
    Interface VARCHAR(12) NOT NULL
);
go

CREATE TABLE Common.CBITConfiguration
(
    id            TINYINT  NOT NULL PRIMARY KEY,
    Configuration CHAR(15) NOT NULL
);
go

CREATE TABLE Common.CBITResult
(
    id     TINYINT     NOT NULL PRIMARY KEY,
    Result VARCHAR(10) NOT NULL
);
go

CREATE TABLE Common.ChannelSpacing
(
    id  TINYINT NOT NULL PRIMARY KEY,
    CSP VARCHAR(8)
);
go

CREATE TABLE Common.CommandStatus
(
    id   TINYINT     NOT NULL PRIMARY KEY,
    Stat VARCHAR(10) NOT NULL
);
go

CREATE TABLE Common.Conn
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(10)
);
go

CREATE TABLE Common.ControlAccess
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(6)
);
go

CREATE TABLE Common.Controller
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(14)
);
go

CREATE TABLE Common.EnableDisable
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(8) NOT NULL
);
go

CREATE TABLE Common.EventLevel
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Level CHAR(11)
);
go

CREATE TABLE Common.EVSWRPolarity
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type CHAR(8)
);
go

CREATE TABLE Common.IPType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Name CHAR(9) NOT NULL
);
go

CREATE TABLE Common.MainStandby
(
    id  TINYINT NOT NULL PRIMARY KEY,
    MST VARCHAR(7)
);
go

CREATE TABLE Common.ModulationMode
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Mode VARCHAR(5)
);
go

CREATE TABLE Common.NewCommandDescription
(
    id          TINYINT NOT NULL PRIMARY KEY,
    Description VARCHAR(22)
)
go

Create TABLE Common.OnOff
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat Char(3) NOT NULL
);
go

CREATE TABLE Common.Operation
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(5)
);
go

Create TABLE Common.Partition
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(6) NOT NULL
);
go

CREATE TABLE Common.PowerLevel
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Level VARCHAR(6)
);
go

CREATE TABLE Common.PTTConfiguration
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(11)
);
go

CREATE TABLE Common.RadioModule
(
    id          TINYINT    NOT NULL PRIMARY KEY,
    Module      VARCHAR(5) NOT NULL,
    Description VARCHAR(15)
);
go

Create TABLE Common.RadioType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type Char(4) NOT NULL
);
go

CREATE TABLE Common.RecordStatus
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat VARCHAR(20)
)
go

CREATE TABLE Common.RSSIOutput
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type CHAR(12)
);
go

CREATE TABLE Common.RXSensitivity
(
    id  TINYINT NOT NULL PRIMARY KEY,
    RIS VARCHAR(14)
);
go

CREATE TABLE Common.Selectable
(
    id    TINYINT     NOT NULL PRIMARY KEY,
    Items VARCHAR(21) NOT NULL
);
go

CREATE TABLE Common.SessionType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(14)
);
go

CREATE TABLE Common.SetCode
(
    id  TINYINT NOT NULL PRIMARY KEY,
    Txt VARCHAR(20)
);
go

CREATE TABLE Common.SettingRecordType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(15)
);
go

CREATE TABLE Common.SQLogic
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Logic CHAR(3) NOT NULL
);
go

CREATE TABLE Common.StationAvailability
(
    id     TINYINT     NOT NULL PRIMARY KEY,
    Status VARCHAR(13) NOT NULL
);
go

CREATE TABLE Common.TXOffset
(
    id     TINYINT NOT NULL PRIMARY KEY,
    Offset CHAR(4) NOT NULL
);
go

CREATE TABLE Common.CBITList
(
    id            INT             NOT NULL IDENTITY PRIMARY KEY,
    CBIT_Code     SMALLINT UNIQUE NOT NULL,
    Level         TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
    Description   VARCHAR(30)     NOT NULL,
    Configuration TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.CBITConfiguration (id),
    Selectable    TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.Selectable (id)
);
go

CREATE TABLE Common.Radio
(
    id                INT            NOT NULL IDENTITY PRIMARY KEY,
    Radio_Name        CHAR(10)       NOT NULL UNIQUE,
    Station_Code      CHAR(3)        NOT NULL,
    Frequency_No      TINYINT        NOT NULL,
    Type              TINYINT        NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    MainStandBy       TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
    IP                VARCHAR(15)    NOT NULL,
    IndicatorONSec    DECIMAL(13, 3) NULL,
    IndicatorOFFSec   DECIMAL(13, 3) NULL,
    ConnectTimeSec    DECIMAL(13, 3) NULL,
    DisconnectTimeSec DECIMAL(13, 3) NULL,
    OperatingHour     INT            NULL
);
go

/**************************************    Event SCHEMA    ****************************************************/

CREATE TABLE Event.ECBIT
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    Code       SMALLINT    NOT NULL,
    Name       VARCHAR(30) NOT NULL,
    Level      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id)
);
go

CREATE TABLE Event.ERadio
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    AIAD       TINYINT       NULL,
    AILA       SMALLINT      NULL,
    AISL       SMALLINT      NULL,
    ERGN       TINYINT       NULL FOREIGN KEY REFERENCES Common.Operation (id),
    FFMD       TINYINT       NULL FOREIGN KEY REFERENCES Common.ModulationMode (id),
    FFSP       TINYINT       NULL FOREIGN KEY REFERENCES Common.ChannelSpacing (id),
    FFTR       INT           NULL,
    GRHN       VARCHAR(24)   NULL,
    GRME       DATETIME      NULL,
    GRNA       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    GRTI       DATETIME      NULL,
    GRUI       VARCHAR(10)   NULL,
    GRUO       VARCHAR(10)   NULL,
    MSAC       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    RCPP       TINYINT       NULL,
    SCPG       SMALLINT      NULL,
    SCSS       TINYINT       NULL FOREIGN KEY REFERENCES Common.SessionType (id),
    -- Only for RX
    FFSN       TINYINT       NULL,
    FFSQ       TINYINT       NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    FFSR       TINYINT       NULL,
    RCLR       TINYINT       NULL,
    RIRC       VARCHAR(30)   NULL,
    -- Only for TX
    RCLV       DECIMAL(3, 1) NULL,
    RCMG       TINYINT       NULL,
    -- Set Only Commands
    EVCL       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    GRAT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    MSGO       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    RCPF       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    RCPT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    RCRR       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id)
);
go

CREATE TABLE Event.EventList
(
    id          INT         NOT NULL IDENTITY PRIMARY KEY,
    Date        DATETIME    NOT NULL,
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    Event_No    INT         NOT NULL,
    Module      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    EventDate   DATETIME    NOT NULL,
    Code        SMALLINT    NOT NULL,
    Event_Text  VARCHAR(30) NOT NULL,
    Event_Level TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
);
go

CREATE TABLE Event.Reception
(
    id           INT IDENTITY PRIMARY KEY NOT NULL,
    Date         DATETIME                 NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)                 NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    FFRS         SMALLINT                 NULL,
    SQ           TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    SQ_AGE       DECIMAL(13, 3)           NULL,
    SQ_ON        DECIMAL(13, 3)           NULL,
    SQ_OFF       DECIMAL(13, 3)           NULL,
    Battery_Volt DECIMAL(3, 1)            NULL,
    DC_Section   DECIMAL(3, 1)            NULL,
    RX_Temp      TINYINT                  NULL,
    PS_Temp      TINYINT                  NULL,
    PA_Temp      TINYINT                  NULL
);
go

CREATE TABLE Event.Session
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    IP         VARCHAR(15) NOT NULL,
    Client     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Controller (id),
    Type       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.SessionType (id),
);
go

CREATE TABLE Event.Status
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id),
    Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
    Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
    Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id),
    CBIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
);
go

create table Event.Transmission
(
    id           INT IDENTITY PRIMARY KEY NOT NULL,
    Date         DATETIME                 NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)                 NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    PTT          TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    PTT_AGE      DECIMAL(13, 3)           null,
    PTT_ON       DECIMAL(13, 3)           null,
    PTT_OFF      DECIMAL(13, 3)           null,
    RCTO         TINYINT                  null,
    RCMO         TINYINT                  null,
    RCTV         DECIMAL(3, 1)            null,
    RCTW         TINYINT                  NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    RCVV         DECIMAL(3, 1)            null,
    Battery_Volt DECIMAL(3, 1)            null,
    DC_Section   DECIMAL(3, 1)            null,
    TX_Temp      TINYINT                  null,
    PS_Temp      TINYINT                  NULL,
    PA_Temp      TINYINT                  NULL
);
go

/**************************************   Setting SCHEMA   ****************************************************/

CREATE TABLE Setting.Access
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    ACL_Index  TINYINT     NOT NULL,
    Allowed_IP VARCHAR(15) NOT NULL
);
go

CREATE TABLE Setting.IP
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    IP_Type    TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.IPType (id),
    IP         VARCHAR(15) NOT NULL,
    Subnet     VARCHAR(15) NOT NULL,
    Gateway    VARCHAR(15) NULL
);
go

CREATE TABLE Setting.Software
(
    id          INT         NOT NULL IDENTITY PRIMARY KEY,
    Date        DATETIME    NOT NULL,
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    Partition   TINYINT     NOT NULL,
    Part_Number VARCHAR(12) NOT NULL,
    Version     VARCHAR(5)  NOT NULL,
    Status      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Partition (id),
);
go

CREATE TABLE Setting.SRadio
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    Record     TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AIAI       TINYINT       NULL FOREIGN KEY REFERENCES Common.AudioInterface (id),
    AICA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIEL       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIGA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIML       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISF       SMALLINT      NULL,
    AITP       TINYINT       NULL,
    AITS       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    ERBE       VARCHAR(2000) NULL,
    EVSR       VARCHAR(50)   NULL,
    FFBL       VARCHAR(150)  NULL,
    FFCO       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFEA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFFC       VARCHAR(50)   NULL,
    FFFE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFLM       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFLT       SMALLINT      NULL,
    FFSC       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFSL       TINYINT       NULL FOREIGN KEY REFERENCES Common.SQLogic (id),
    FFTO       TINYINT       NULL FOREIGN KEY REFERENCES Common.TXOffset (id),
    GRAS       TINYINT       NULL FOREIGN KEY REFERENCES Common.ATRMode (id),
    GRBS       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRCO       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRDH       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRDN       VARCHAR(50)   NULL,
    GREX       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIN       VARCHAR(20)   NULL,
    GRIS       TINYINT       NULL FOREIGN KEY REFERENCES Common.RXSensitivity (id),
    GRIV       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRLO       VARCHAR(212)  NULL,
    GRLR       SMALLINT      NULL,
    GRLT       SMALLINT      NULL,
    GRNS       VARCHAR(15)   NULL,
    GRSE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRSN       VARCHAR(30)   NULL,
    GRVE       DECIMAL(5, 2) NULL,
    MSTY       TINYINT       NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
    RCDP       SMALLINT      NULL,
    RCIT       TINYINT       NULL,
    RCLP       TINYINT       NULL,
    RCNP       TINYINT       NULL,
    RCTS       TINYINT       NULL FOREIGN KEY REFERENCES Common.PowerLevel (id),
    RIPC       TINYINT       NULL FOREIGN KEY REFERENCES Common.PTTConfiguration (id),
    RIRO       TINYINT       NULL FOREIGN KEY REFERENCES Common.RSSIOutput (id),
    RIVL       DECIMAL(3, 1) NULL,
    RIVP       TINYINT       NULL FOREIGN KEY REFERENCES Common.EVSWRPolarity (id),
    RUFL       VARCHAR(30)   NULL,
    RUFP       VARCHAR(30)   NULL
);
go

CREATE TABLE Setting.Inventory
(
    id               INT         NOT NULL IDENTITY PRIMARY KEY,
    Date             DATETIME    NOT NULL,
    Radio_Name       CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    R_Index          TINYINT     NOT NULL,
    Type             TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioModule (id),
    Component_Name   VARCHAR(20) NOT NULL,
    Ident_Number     CHAR(9)     NOT NULL,
    Variant          TINYINT     NOT NULL,
    Production_Index CHAR(5)     NOT NULL,
    Serial_Number    CHAR(6)     NOT NULL,
    Production_Date  DATE        NOT NULL
);
go

CREATE TABLE Setting.SCBIT
(
    id            INT      NOT NULL IDENTITY PRIMARY KEY,
    Date          DATETIME NOT NULL,
    Radio_Name    CHAR(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    CBIT_Code     SMALLINT NOT NULL,
    Configuration TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.CBITResult
);
go

/**************************************   Command SCHEMA   ****************************************************/

CREATE TABLE Command.History
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY,
    RegisterTime DATETIME    NOT NULL DEFAULT GETDATE(),
    TargetRadio  char(10)    NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    CKey         char(4)     NOT NULL,
    Request      char(1)     NOT NULL,
    Value        varchar(50) NULL,
    SentTime     DATETIME    NULL,
    Status       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.CommandStatus (id),

    CONSTRAINT Request_Check CHECK (Request in ('G', 'S', 'T'))
);
go

CREATE TABLE Command.ManagerHistory
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY,
    RegisterTime DATETIME    NOT NULL DEFAULT GETDATE(),
    Station      CHAR(3)     NOT NULL FOREIGN KEY REFERENCES Station.StationList (Code),
    Frequency    TINYINT     NOT NULL,
    RadioType     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    MainStandby  TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
    CKey         char(4)     NOT NULL,
    Request      char(1)     NOT NULL,
    Value        varchar(50) NULL,
    SentTime     DATETIME    NULL,
    Status       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.CommandStatus (id),

    CONSTRAINT Manager_Request_Check CHECK (Request in ('G', 'S', 'T'))
);
go

CREATE TABLE Command.RadioInitial
(
    id      INT         NOT NULL IDENTITY PRIMARY KEY,
    rtype   TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    CKey    CHAR(4)     NOT NULL,
    Request CHAR(1)     NOT NULL,
    Value   VARCHAR(10) NOT NULL,
    Active  BIT         NOT NULL DEFAULT 1,

    CONSTRAINT InitialRequest_Check CHECK (Request in ('G', 'S', 'T'))
);
go

CREATE TABLE Command.KeyInformation
(
    id                   INT IDENTITY   NOT NULL PRIMARY KEY,
    CKey                 CHAR(4) UNIQUE NOT NULL,
    TX_Name              VARCHAR(50)    NULL,
    RX_Name              VARCHAR(50)    NULL,
    Parameter_Type       VARCHAR(30)    NOT NULL,
    Parameter_Unit       VARCHAR(6)     NULL,
    INT_Parameter_Min    INT            NULL,
    INT_Parameter_Max    INT            NULL,
    INT_Parameter_Step   INT            NULL,
    FLOAT_Parameter_Min  DECIMAL(2, 1)  NULL,
    FLOAT_Parameter_Max  DECIMAL(2, 1)  NULL,
    FLOAT_Parameter_Step DECIMAL(2, 1)  NULL,
    STRING_Max_Length    TINYINT        NULL,
    Convertor_Table      VARCHAR(50)    NULL,
    RegisterTable        VARCHAR(50)    NULL,
    TX_Support           BIT            NOT NULL,
    RX_Support           BIT            NOT NULL,
    GET_Support          BIT            NOT NULL,
    SET_Support          BIT            NOT NULL,
    TRAP_Support         BIT            NOT NULL,
    GET_Need_Value       BIT            NULL,
    Update_Need_Restart  BIT            NULL,
    Work_As_Expected     BIT            NULL,
    Fully_Identified     BIT            NULL
);
go

/**************************************   Station SCHEMA   ****************************************************/

CREATE TABLE Station.StationList
(
    id           INT     NOT NULL IDENTITY PRIMARY KEY,
    Code         CHAR(3) NOT NULL UNIQUE,
    Availability TINYINT NOT NULL FOREIGN KEY REFERENCES Common.StationAvailability (id),

);
go

/************************************** Application SCHEMA ****************************************************/

-- Drop Table Application.Sleep;
-- Drop Table Application.Names;

CREATE TABLE Application.Names
(
    id             TINYINT      NOT NULL PRIMARY KEY,
    App            VARCHAR(30)  NOT NULL UNIQUE,
    JobInformation VARCHAR(255) NULL
);
go

CREATE TABLE Application.Timing
(
    id     TINYINT       NOT NULL PRIMARY KEY,
    App    TINYINT       NOT NULL FOREIGN KEY REFERENCES Application.Names (id),
    Timing DECIMAL(2, 1) NOT NULL
);
go

CREATE TABLE Application.Configuration
(
    id                      INT      NOT NULL IDENTITY PRIMARY KEY,
    Date                    DATETIME NOT NULL DEFAULT GETDATE(),
    Status                  TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.RecordStatus (id),
    ConnectionTryInterval   TINYINT  NOT NULL DEFAULT 60,   -- Second
    MaxDelaySettingFetch    SMALLINT NOT NULL DEFAULT 60,   -- Minute
    PeriodicSettingCheck    SMALLINT NOT NULL DEFAULT 1440, -- Minute
    PeriodicAgeUpdate       SMALLINT NOT NULL DEFAULT 5,    -- Minute
    SessionWarningThreshold TINYINT  NOT NULL DEFAULT 3,    -- Session
    NewCommand              TINYINT  NOT NULL DEFAULT 0 FOREIGN KEY REFERENCES Common.NewCommandDescription (id)
);
go

-- Drop TABLE Application.RadioStatus;
CREATE TABLE Application.RadioStatus
(
    id               INT      NOT NULL IDENTITY PRIMARY KEY,
    Radio_Name       char(10) NOT NULL FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    FirstConnection  DATETIME NOT NULL DEFAULT GETDATE(),
    EventListCollect DATETIME NULL,
    NextConfigFetch  DATETIME NULL
);
go

CREATE TABLE Application.LogLevel
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Level CHAR(8) NOT NULL
);
go


CREATE TABLE Application.LogFormat
(
    id              TINYINT    NOT NULL IDENTITY PRIMARY KEY,
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
go


CREATE TABLE Application.LogConfig
(
    id           TINYINT NOT NULL IDENTITY PRIMARY KEY,
    App          TINYINT NOT NULL FOREIGN KEY REFERENCES Application.Names (id),
    FileLevel    TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogLevel (id),
    StreamLevel  TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogLevel (id),
    FileFormat   TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogFormat (id),
    StreamFormat TINYINT NOT NULL FOREIGN KEY REFERENCES Application.LogFormat (id)
);
go


CREATE TABLE Application.RadioModuleStatus
(
    id                          INT      NOT NULL IDENTITY PRIMARY KEY,
    RadioModuleName             CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Common.Radio (Radio_Name),
    StartTime                   DATETIME NOT NULL DEFAULT GETDATE(),
    PID                         INT      NOT NULL DEFAULT -1,
    UpdateTime                  DATETIME NULL,
    ModuleAlive                 INT      NULL,
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
go

