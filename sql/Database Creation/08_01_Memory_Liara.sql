USE RCMS;

CREATE TABLE Application.DBParameters
(
    id                        INT IDENTITY PRIMARY KEY CLUSTERED,
    RX_Count                  INT DEFAULT 100,
    TX_Count                  INT DEFAULT 100,
    RX_Minute                 INT DEFAULT 10,
    TX_Minute                 INT DEFAULT 10,
    DC_Minute                 INT DEFAULT 10,
    TEMP_Minute               INT DEFAULT 10,
    RX_PPS                    INT DEFAULT 5,
    TX_PPS                    INT DEFAULT 2,
    DC_PPS                    INT DEFAULT 2,
    TEMP_PPS                  INT DEFAULT 2,
    Reception_BUCKET_COUNT    INT DEFAULT 300000,
    Transmission_BUCKET_COUNT INT DEFAULT 120000,
    Voltage_BUCKET_COUNT      INT DEFAULT 240000,
    Temperature_BUCKET_COUNT  INT DEFAULT 240000,
)
GO

CREATE SCHEMA Memory
GO

CREATE TABLE Memory.LatestReception
(
    id           INT IDENTITY PRIMARY KEY,
    Date         DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)       NOT NULL,
    FFRS         SMALLINT       NULL,
    SQ           TINYINT        NULL,
    SQ_ON        DECIMAL(13, 3) NULL,
    SQ_OFF       DECIMAL(13, 3) NULL,
	CUM_SQ       DECIMAL(13, 3) NULL,
    INDEX IDX_LatestReception_Date NONCLUSTERED (Date),
    INDEX IDX_LatestReception_Radio_Name NONCLUSTERED (Radio_Name)
);
GO

CREATE TABLE Memory.LatestTemperature
(
    id         INT IDENTITY PRIMARY KEY,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL,
    RM_Temp    TINYINT  NULL,
    PS_Temp    TINYINT  NULL,
    PA_Temp    TINYINT  NULL,
    INDEX IDX_LatestTemperature_Date NONCLUSTERED (Date),
    INDEX IDX_LatestTemperature_Radio_Name NONCLUSTERED (Radio_Name)
);
GO

CREATE TABLE Memory.LatestTransmission
(
    id           INT IDENTITY PRIMARY KEY,
    Date       DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10)       NOT NULL,
    PTT        TINYINT        NULL,
    PTT_ON     DECIMAL(13, 3) null,
    PTT_OFF    DECIMAL(13, 3) null,
    CUM_PTT    DECIMAL(13, 3) null,
    CUM_SWR    DECIMAL(13, 3) null,
    RCTO       TINYINT        null,
    RCMO       TINYINT        null,
    RCTV       DECIMAL(3, 1)  null,
    RCTW       TINYINT        NULL,
    RCVV       DECIMAL(3, 1)  null,
    INDEX IDX_LatestTransmission_Date NONCLUSTERED (Date),
    INDEX IDX_LatestTransmission_Radio_Name NONCLUSTERED (Radio_Name)
);
GO

CREATE TABLE Memory.LatestVoltage
(
    id      INT IDENTITY PRIMARY KEY,
    Date         DATETIME      NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)      NOT NULL,
    Battery_Volt DECIMAL(3, 1) NULL,
    DC_Section   DECIMAL(3, 1) NULL,
    INDEX IDX_LatestVoltage_Date NONCLUSTERED (Date),
    INDEX IDX_LatestVoltage_Radio_Name NONCLUSTERED (Radio_Name)
);
GO

