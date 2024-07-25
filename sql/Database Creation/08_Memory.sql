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

DECLARE @RX_Count INT;
DECLARE @TX_Count INT;
DECLARE @RX_Minute INT;
DECLARE @TX_Minute INT;
DECLARE @DC_Minute INT;
DECLARE @TEMP_Minute INT;
DECLARE @RX_PPS INT;
DECLARE @TX_PPS INT;
DECLARE @DC_PPS INT;
DECLARE @TEMP_PPS INT;
DECLARE @RX_BC INT;
DECLARE @TX_BC INT;
DECLARE @DC_BC INT;
DECLARE @TEMP_BC INT;

-- SET @RX_Count = (SELECT Count(RR.id) From Radio.Radio RR WHERE RadioType=0);
SET @RX_Count = 100;
-- SET @TX_Count = (SELECT Count(RR.id) From Radio.Radio RR WHERE RadioType=1);
SET @TX_Count = 100;

SET @RX_Minute = 10;
SET @TX_Minute = 10;
SET @DC_Minute = 15;
SET @TEMP_Minute = 15;

SET @RX_PPS = 4;
SET @TX_PPS = 2;
SET @DC_PPS = 1;
SET @TEMP_PPS = 1;

SET @RX_BC = @RX_Count * @RX_PPS * @RX_Minute * 60;
SET @TX_BC = @TX_Count * @TX_PPS * @TX_Minute * 60;
SET @DC_BC = (@RX_Count + @TX_Count) * @DC_PPS * @DC_Minute * 60;
SET @TEMP_BC = (@RX_Count + @TX_Count) * @TEMP_PPS * @TEMP_Minute * 60;

INSERT INTO Application.DBParameters
    (RX_Count, TX_Count,
     RX_Minute, TX_Minute, DC_Minute, TEMP_Minute,
     RX_PPS, TX_PPS, DC_PPS, TEMP_PPS,
     Reception_BUCKET_COUNT, Transmission_BUCKET_COUNT, Voltage_BUCKET_COUNT, Temperature_BUCKET_COUNT)
VALUES
    (@RX_Count, @TX_Count,
     @RX_Minute, @TX_Minute, @DC_Minute, @TEMP_Minute,
     @RX_PPS, @TX_PPS, @DC_PPS, @TEMP_PPS,
     @RX_BC, @TX_BC, @DC_BC, @TEMP_BC
    );
GO

USE RCMS
GO

CREATE SCHEMA Memory
GO

CREATE TABLE Memory.LatestReception
(
    id           INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 240000),
    Date         DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)       NOT NULL,
    FFRS         SMALLINT       NULL,
    SQ           TINYINT        NULL,
    SQ_ON        DECIMAL(13, 3) NULL,
    SQ_OFF       DECIMAL(13, 3) NULL,
	CUM_SQ       DECIMAL(13, 3) NULL,
    INDEX IDX_LatestReception_Date NONCLUSTERED (Date),
    INDEX IDX_LatestReception_Radio_Name NONCLUSTERED (Radio_Name)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

CREATE TRIGGER InsertLatestReception
ON Variation.Reception
AFTER INSERT
AS
BEGIN
    INSERT INTO Memory.LatestReception (Date, Radio_Name, FFRS, SQ, SQ_ON, SQ_OFF, CUM_SQ)
    SELECT Date, Radio_Name, FFRS, SQ, SQ_ON, SQ_OFF, CUM_SQ FROM inserted
END;
GO

CREATE PROCEDURE Application.CleanupLatestReception
AS
BEGIN
    DELETE FROM Memory.LatestReception
    WHERE Date < DATEADD(MINUTE, -(Select [RX_Minute] from [Application].[DBParameters]), GETUTCDATE());
END;
GO
----------------------------------------------

CREATE TABLE Memory.LatestTemperature
(
    id         INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH ( BUCKET_COUNT = 180000 ),
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL,
    RM_Temp    TINYINT  NULL,
    PS_Temp    TINYINT  NULL,
    PA_Temp    TINYINT  NULL,
    INDEX IDX_LatestTemperature_Date NONCLUSTERED (Date),
    INDEX IDX_LatestTemperature_Radio_Name NONCLUSTERED (Radio_Name)
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

CREATE TRIGGER InsertLatestTemperature
ON Variation.Temperature
AFTER INSERT
AS
BEGIN
    INSERT INTO Memory.LatestTemperature (Date, Radio_Name, RM_Temp, PS_Temp, PA_Temp)
    SELECT Date, Radio_Name, RM_Temp, PS_Temp, PA_Temp FROM inserted
END;
GO

CREATE PROCEDURE Application.CleanupLatestTemperature
AS
BEGIN
    DELETE FROM Memory.LatestTemperature
    WHERE Date < DATEADD(MINUTE, -(Select [TEMP_Minute] from [Application].[DBParameters]), GETUTCDATE());
END;
GO
----------------------------------------------

CREATE TABLE Memory.LatestTransmission
(
    id           INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 120000),
    Date       DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10)       NOT NULL,
    PTT        TINYINT        NULL,
    PTT_AGE    DECIMAL(13, 3) null,
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
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

CREATE TRIGGER InsertLatestTransmission
ON Variation.Transmission
AFTER INSERT
AS
BEGIN
    INSERT INTO Memory.LatestTransmission
        (Date, Radio_Name, PTT, PTT_AGE, PTT_ON, PTT_OFF, CUM_PTT, CUM_SWR, RCTO, RCMO, RCTV, RCTW, RCVV)
    SELECT Date, Radio_Name, PTT, PTT_AGE, PTT_ON, PTT_OFF, CUM_PTT, CUM_SWR, RCTO, RCMO, RCTV, RCTW, RCVV
        FROM inserted
END;
GO

CREATE PROCEDURE Application.CleanupLatestTransmission
AS
BEGIN
    DELETE FROM Memory.LatestTransmission
    WHERE Date < DATEADD(MINUTE, -(Select [TX_Minute] from [Application].[DBParameters]), GETUTCDATE());
END;
GO
----------------------------------------------

CREATE TABLE Memory.LatestVoltage
(
    id      INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH ( BUCKET_COUNT = 180000 ),
    Date         DATETIME      NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)      NOT NULL,
    Battery_Volt DECIMAL(3, 1) NULL,
    DC_Section   DECIMAL(3, 1) NULL,
    INDEX IDX_LatestVoltage_Date NONCLUSTERED (Date),
    INDEX IDX_LatestVoltage_Radio_Name NONCLUSTERED (Radio_Name)
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA );
GO

CREATE TRIGGER InsertLatestVoltage
ON Variation.Voltage
AFTER INSERT
AS
BEGIN
    INSERT INTO Memory.LatestVoltage (Date, Radio_Name, Battery_Volt, DC_Section)
    SELECT Date, Radio_Name, Battery_Volt, DC_Section FROM inserted
END;
GO

CREATE PROCEDURE Application.CleanupLatestVoltage
AS
BEGIN
    DELETE FROM Memory.LatestVoltage
    WHERE Date < DATEADD(MINUTE, -(Select [DC_Minute] from [Application].[DBParameters]), GETUTCDATE());
END;
GO

