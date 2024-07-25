USE RCMS;
GO

CREATE TABLE Common.Activation
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(8)
);
GO

CREATE TABLE Common.ATRMode
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Mode CHAR(10)
);
GO

Create TABLE Common.AudioInterface
(
    id        TINYINT     NOT NULL PRIMARY KEY,
    Interface VARCHAR(12) NOT NULL
);
GO

CREATE TABLE Common.CBITConfiguration
(
    id            TINYINT  NOT NULL PRIMARY KEY,
    Configuration CHAR(15) NOT NULL
);
GO

CREATE TABLE Common.CBITResult
(
    id     TINYINT     NOT NULL PRIMARY KEY,
    Result VARCHAR(10) NOT NULL
);
GO

CREATE TABLE Common.ChannelSpacing
(
    id  TINYINT NOT NULL PRIMARY KEY,
    CSP VARCHAR(8)
);
GO

CREATE TABLE Common.CommandStatus
(
    id   TINYINT     NOT NULL PRIMARY KEY,
    Stat VARCHAR(25) NOT NULL
);
GO

CREATE TABLE Common.Conn
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(10)
);
GO

CREATE TABLE Common.ControlAccess
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(6)
);
GO

CREATE TABLE Common.Controller
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(14)
);
GO

CREATE TABLE Common.EnableDisable
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(8) NOT NULL
);
GO

CREATE TABLE Common.EventLevel
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Level CHAR(11)
);
GO

CREATE TABLE Common.EVSWRPolarity
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type CHAR(8)
);
GO

CREATE TABLE Common.Inhibit
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(7)
)

CREATE TABLE Common.IPType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Name CHAR(9) NOT NULL
);
GO

CREATE TABLE Common.MainStandby
(
    id  TINYINT NOT NULL PRIMARY KEY,
    MST VARCHAR(7)
);
GO

CREATE TABLE Common.ModulationMode
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Mode VARCHAR(5)
);
GO

Create TABLE Common.OnOff
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat Char(3) NOT NULL
);
GO

CREATE TABLE Common.Operation
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(5)
);
GO

Create TABLE Common.Partition
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat CHAR(6) NOT NULL
);
GO

CREATE TABLE Common.PowerLevel
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Level VARCHAR(6)
);
GO

CREATE TABLE Common.PTTConfiguration
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(11)
);
GO

CREATE TABLE Common.RadioModule
(
    id          TINYINT    NOT NULL PRIMARY KEY,
    Module      VARCHAR(5) NOT NULL,
    Description VARCHAR(15)
);
GO

Create TABLE Common.RadioType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(4)
);
GO

CREATE TABLE Common.RecordStatus
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Stat VARCHAR(20)
)
GO

CREATE TABLE Common.RSSIOutput
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type CHAR(12)
);
GO

CREATE TABLE Common.RXSensitivity
(
    id  TINYINT NOT NULL PRIMARY KEY,
    RIS VARCHAR(14)
);
GO

CREATE TABLE Common.Selectable
(
    id    TINYINT     NOT NULL PRIMARY KEY,
    Items VARCHAR(21) NOT NULL
);
GO

CREATE TABLE Common.SessionType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(14)
);
GO

CREATE TABLE Common.SetCode
(
    id  TINYINT NOT NULL PRIMARY KEY,
    Txt VARCHAR(20)
);
GO

CREATE TABLE Common.SettingRecordType
(
    id   TINYINT NOT NULL PRIMARY KEY,
    Type VARCHAR(15)
);
GO

CREATE TABLE Common.SQLogic
(
    id    TINYINT NOT NULL PRIMARY KEY,
    Logic CHAR(3) NOT NULL
);
GO

CREATE TABLE Common.StationAvailability
(
    id     TINYINT     NOT NULL PRIMARY KEY,
    Status VARCHAR(13) NOT NULL
);
GO

CREATE TABLE Common.TXOffset
(
    id     TINYINT NOT NULL PRIMARY KEY,
    Offset CHAR(4) NOT NULL
);
GO

CREATE TABLE Common.CBITList
(
    id            INT             NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    CBIT_Code     SMALLINT UNIQUE NOT NULL,
    Level         TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
    Description   VARCHAR(30)     NOT NULL,
    Configuration TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.CBITConfiguration (id),
    Selectable    TINYINT         NOT NULL FOREIGN KEY REFERENCES Common.Selectable (id)
);
GO
