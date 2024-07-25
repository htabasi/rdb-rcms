USE RCMS;
GO

CREATE SCHEMA Analyze;
GO

CREATE TABLE Analyze.Counter
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetDate         DATETIME        NOT NULL DEFAULT GETUTCDATE(),
    CntConnect                 BIGINT   NOT NULL DEFAULT 0,
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


CREATE TABLE Analyze.AggregateTimer
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    IndicatorONSec    DECIMAL(13, 3)           DEFAULT 0.0,
    IndicatorOFFSec   DECIMAL(13, 3)           DEFAULT 0.0,
    ConnectTimeSec    DECIMAL(13, 3)           DEFAULT 0.0,
    DisconnectTimeSec DECIMAL(13, 3)           DEFAULT 0.0,
    OperatingHour     INT             Not NULL DEFAULT 0
);
GO

CREATE TABLE Analyze.ResettableTimer
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetDate         DATETIME        NOT NULL DEFAULT GETUTCDATE(),
    IndicatorONSec    DECIMAL(13, 3)           DEFAULT 0.0,
    IndicatorOFFSec   DECIMAL(13, 3)           DEFAULT 0.0,
    ConnectTimeSec    DECIMAL(13, 3)           DEFAULT 0.0,
    DisconnectTimeSec DECIMAL(13, 3)           DEFAULT 0.0,
    OperatingHour     INT             NOT NULL DEFAULT 0
);
GO

CREATE TABLE Analyze.AggregateCounter
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name   CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    CntConnect   BIGINT DEFAULT 0,
    CntIndicator BIGINT DEFAULT 0,
    CntWarning   BIGINT DEFAULT 0,
    CntError     BIGINT DEFAULT 0,
);
GO

CREATE TABLE Analyze.ResettableCounter
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name   CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetDate    DATETIME        NOT NULL DEFAULT GETUTCDATE(),
    CntConnect   BIGINT                   DEFAULT 0,
    CntIndicator BIGINT                   DEFAULT 0,
    CntWarning   BIGINT                   DEFAULT 0,
    CntError     BIGINT                   DEFAULT 0,
);
GO

CREATE TABLE Analyze.ResetCommand
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name   CHAR(10) UNIQUE NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ResetCounter BIT             NOT NULL DEFAULT 0,
    ResetTimer   BIT             NOT NULL DEFAULT 0
)


INSERT INTO Analyze.AggregateTimer
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO

INSERT INTO Analyze.ResettableTimer
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO

INSERT INTO Analyze.AggregateCounter
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO

INSERT INTO Analyze.ResettableCounter
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO

INSERT INTO Analyze.ResetCommand
    (Radio_Name)
SELECT Name
FROM Radio.Radio
ORDER BY id;
GO
