USE RCMS;
GO

CREATE SCHEMA Analyze;
GO

CREATE TABLE Analyze.RecordType
(
    id   TINYINT PRIMARY KEY CLUSTERED,
    Type VARCHAR(20) NOT NULL DEFAULT 'Aggregate'
);
GO

INSERT INTO Analyze.RecordType
VALUES (0, 'Aggregate'),
       (1, 'Resettable');
GO

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
GO

INSERT INTO Analyze.Counter
    (Radio_Name, RecordType)
SELECT Name, 0
FROM Radio.Radio
ORDER BY id;

INSERT INTO Analyze.Counter
    (Radio_Name, RecordType)
SELECT Name, 1
FROM Radio.Radio
ORDER BY id;
GO

CREATE TABLE Analyze.Timer
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetDate         DATETIME       NOT NULL DEFAULT GETUTCDATE(),
    RecordType        TINYINT        NOT NULL DEFAULT 0 FOREIGN KEY REFERENCES Analyze.RecordType (id),
    IndicatorONSec    DECIMAL(13, 3) Not NULL DEFAULT 0.0,
    IndicatorOFFSec   DECIMAL(13, 3) Not NULL DEFAULT 0.0,
    ConnectTimeSec    DECIMAL(13, 3) Not NULL DEFAULT 0.0,
    DisconnectTimeSec DECIMAL(13, 3) Not NULL DEFAULT 0.0,
    OperatingHour     INT            Not NULL DEFAULT 0
);
GO

INSERT INTO Analyze.Timer
    (Radio_Name, RecordType)
SELECT Name, 0
FROM Radio.Radio
ORDER BY id;

INSERT INTO Analyze.Timer
    (Radio_Name, RecordType)
SELECT Name, 1
FROM Radio.Radio
ORDER BY id;
GO

CREATE TABLE Analyze.ResetCommand
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name   CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetCounter BIT             NOT NULL DEFAULT 0,
    ResetTimer   BIT             NOT NULL DEFAULT 0
);
GO

INSERT INTO Analyze.ResetCommand
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO

CREATE TABLE Analyze.ResetHistory
(
    id         BIGINT IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL DEFAULT GETUTCDATE(),
    user_id    BIGINT      NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
    radio_name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Action     VARCHAR(50) NOT NULL
)
