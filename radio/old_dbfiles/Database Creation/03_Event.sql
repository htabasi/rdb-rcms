USE RCMS;
GO

CREATE TABLE Event.ECBIT
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Code       SMALLINT    NOT NULL,
    Name       VARCHAR(30) NOT NULL,
    Level      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id)
);
GO

CREATE TABLE Event.ERadio
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
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
GO

CREATE TABLE Event.EventList
(
    id          INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date        DATETIME    NOT NULL,
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Event_No    INT         NOT NULL,
    Module      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    EventDate   DATETIME    NOT NULL,
    Code        SMALLINT    NOT NULL,
    Event_Text  VARCHAR(30) NOT NULL,
    Event_Level TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
);
GO

CREATE TABLE Event.Reception
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Date         DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    FFRS         SMALLINT       NULL,
    SQ           TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    SQ_AGE       DECIMAL(13, 3) NULL,
    SQ_ON        DECIMAL(13, 3) NULL,
    SQ_OFF       DECIMAL(13, 3) NULL,
    Battery_Volt DECIMAL(3, 1)  NULL,
    DC_Section   DECIMAL(3, 1)  NULL,
    RX_Temp      TINYINT        NULL,
    PS_Temp      TINYINT        NULL,
    PA_Temp      TINYINT        NULL
);
GO


CREATE TABLE Event.Session
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    IP         VARCHAR(15) NOT NULL,
    Client     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Controller (id),
    Type       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.SessionType (id),
);
GO

CREATE TABLE Event.SpecialSetting
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AITP       TINYINT  NULL,
    FFTO       TINYINT  NULL FOREIGN KEY REFERENCES Common.TXOffset (id),
    RCIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.Inhibit (id),
    RCLP       TINYINT  NULL,
    RCNP       TINYINT  NULL,
    RCTS       TINYINT  NULL FOREIGN KEY REFERENCES Common.PowerLevel (id),
);
GO

CREATE TABLE Event.Status
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id),
    Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
    Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
    Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id),
    CBIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.EventLevel (id),
);
GO

CREATE TABLE Event.Timer
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    IndicatorONSec    DECIMAL(13, 3) NULL,
    IndicatorOFFSec   DECIMAL(13, 3) NULL,
    ConnectTimeSec    DECIMAL(13, 3) NULL,
    DisconnectTimeSec DECIMAL(13, 3) NULL,
    OperatingHour     INT            NULL
);

create table Event.Transmission
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    Date         DATETIME       NOT NULL DEFAULT GETDATE(),
    Radio_Name   CHAR(10)       NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    PTT          TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    PTT_AGE      DECIMAL(13, 3) null,
    PTT_ON       DECIMAL(13, 3) null,
    PTT_OFF      DECIMAL(13, 3) null,
    RCTO         TINYINT        null,
    RCMO         TINYINT        null,
    RCTV         DECIMAL(3, 1)  null,
    RCTW         TINYINT        NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    RCVV         DECIMAL(3, 1)  null,
    Battery_Volt DECIMAL(3, 1)  null,
    DC_Section   DECIMAL(3, 1)  null,
    TX_Temp      TINYINT        null,
    PS_Temp      TINYINT        NULL,
    PA_Temp      TINYINT        NULL
);
GO
