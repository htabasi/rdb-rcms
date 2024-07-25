USE RCMS;
GO

Create SCHEMA Variation;
GO

CREATE TABLE Variation.Reception
(
    id         INT IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    FFRS       SMALLINT       NULL,
    SQ         TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    SQ_ON      DECIMAL(13, 3) NULL,
    SQ_OFF     DECIMAL(13, 3) NULL,
    CUM_SQ     DECIMAL(13, 3) NULL
);
GO

CREATE NONCLUSTERED INDEX IDX_Reception_Date ON Variation.Reception (Date);
CREATE NONCLUSTERED INDEX IDX_Reception_Radio_Name ON Variation.Reception (Radio_Name);
GO

CREATE TABLE Variation.Temperature
(
    id         INT IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    RM_Temp    TINYINT  NULL,
    PS_Temp    TINYINT  NULL,
    PA_Temp    TINYINT  NULL
);
GO
CREATE NONCLUSTERED INDEX IDX_Temperature_Date ON Variation.Temperature (Date);
CREATE NONCLUSTERED INDEX IDX_Temperature_Radio_Name ON Variation.Temperature (Radio_Name);
GO

CREATE TABLE Variation.Transmission
(
    id         INT IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    PTT        TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    PTT_AGE    DECIMAL(13, 3) null,
    PTT_ON     DECIMAL(13, 3) null,
    PTT_OFF    DECIMAL(13, 3) null,
    CUM_PTT    DECIMAL(13, 3) null,
    CUM_SWR    DECIMAL(13, 3) null,
    RCTO       TINYINT        null,
    RCMO       TINYINT        null,
    RCTV       DECIMAL(3, 1)  null,
    RCTW       TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    RCVV       DECIMAL(3, 1)  null
);
CREATE NONCLUSTERED INDEX IDX_Transmission_Date ON Variation.Transmission (Date);
CREATE NONCLUSTERED INDEX IDX_Transmission_Radio_Name ON Variation.Transmission (Radio_Name);
GO

CREATE TABLE Variation.Voltage
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Date         DATETIME      NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Battery_Volt DECIMAL(3, 1) NULL,
    DC_Section   DECIMAL(3, 1) NULL,
);
GO
CREATE NONCLUSTERED INDEX IDX_Voltage_Date ON Variation.Voltage (Date);
CREATE NONCLUSTERED INDEX IDX_Voltage_Radio_Name ON Variation.Voltage (Radio_Name);
GO
