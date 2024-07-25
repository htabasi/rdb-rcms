USE RCMS;
GO

--CREATE SCHEMA Final;
--GO

CREATE TABLE Final.FEAdjustment
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AIAD       TINYINT       NULL,
    AILA       SMALLINT      NULL,
    AISL       SMALLINT      NULL,
    GRME       DATETIME      NULL,
    GRUI       VARCHAR(10)   NULL,
    GRUO       VARCHAR(10)   NULL
);
GO

CREATE TABLE Final.FEConnection
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id)
);
GO

CREATE TABLE Final.FENetwork
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    GRHN       VARCHAR(24)   NULL,
    GRNA       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    SCPG       SMALLINT      NULL,
    SCSS       TINYINT       NULL FOREIGN KEY REFERENCES Common.SessionType (id)
);
GO

CREATE TABLE Final.FEOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    ERGN       TINYINT       NULL FOREIGN KEY REFERENCES Common.Operation (id),
    FFMD       TINYINT       NULL FOREIGN KEY REFERENCES Common.ModulationMode (id),
    FFSP       TINYINT       NULL FOREIGN KEY REFERENCES Common.ChannelSpacing (id),
    FFTR       INT           NULL,
    MSAC       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    RCPP       TINYINT       NULL
);
GO

CREATE TABLE Final.FEStatus
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
    Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
    Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id)
);
GO

CREATE TABLE Final.FERXOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    FFSN       TINYINT       NULL,
    FFSQ       TINYINT       NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    FFSR       TINYINT       NULL,
    RIRC       VARCHAR(30)   NULL,
);
GO

CREATE TABLE Final.FESpecialSetting
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AITP       TINYINT  NULL,
    FFTO       TINYINT  NULL FOREIGN KEY REFERENCES Common.TXOffset (id),
    RCIT       TINYINT  NULL FOREIGN KEY REFERENCES Common.Inhibit (id),
    RCLP       TINYINT  NULL,
    RCNP       TINYINT  NULL,
    RCTS       TINYINT  NULL FOREIGN KEY REFERENCES Common.PowerLevel (id),
);
GO

CREATE TABLE Final.FETXOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    RCMG       TINYINT       NULL
);
GO

CREATE TABLE Final.FSConfiguration
(
    id         INT          NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)     NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AISE       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISF       SMALLINT     NULL,
    EVSR       VARCHAR(50)  NULL,
    FFBL       VARCHAR(150) NULL,
    FFEA       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFFC       VARCHAR(50)  NULL,
    FFLM       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFLT       SMALLINT     NULL
);
GO

CREATE TABLE Final.FSInstallation
(
    id         INT          NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)     NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AIAI       TINYINT      NULL FOREIGN KEY REFERENCES Common.AudioInterface (id),
    AIEL       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFFE       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFSC       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIN       VARCHAR(20)  NULL,
    GRLO       VARCHAR(212) NULL,
    MSTY       TINYINT      NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
);
GO

CREATE TABLE Final.FSNetwork
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)      NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    GRDH       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRDN       VARCHAR(50)   NULL,
    GRIE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIV       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRNS       VARCHAR(15)   NULL,
    GRVE       DECIMAL(5, 2) NULL
);
GO

CREATE TABLE Final.FSRXConfiguration
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10) NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AIGA       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AITS       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFCO       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFSL       TINYINT  NULL FOREIGN KEY REFERENCES Common.SQLogic (id),
    GRBS       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIS       TINYINT  NULL FOREIGN KEY REFERENCES Common.RXSensitivity (id),
    RIRO       TINYINT  NULL FOREIGN KEY REFERENCES Common.RSSIOutput (id)
);
GO

CREATE TABLE Final.FSSNMP
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)    NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    GRSE       TINYINT     NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRSN       VARCHAR(30) NULL,
    RUFL       VARCHAR(30) NULL,
    RUFP       VARCHAR(30) NULL
);
GO

CREATE TABLE Final.FSStatus
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)      NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    ERBE       VARCHAR(2000) NULL,
    GRLR       SMALLINT      NULL,
    GRLT       SMALLINT      NULL,
    GRTI       DATETIME      NULL,
    RCLR       TINYINT       NULL,
    RCLV       DECIMAL(3, 1) NULL
);
GO

CREATE TABLE Final.FSTXConfiguration
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name CHAR(10)      NOT NULL UNIQUE FOREIGN KEY REFERENCES Radio.Radio (Name),
    AICA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIML       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRAS       TINYINT       NULL FOREIGN KEY REFERENCES Common.ATRMode (id),
    GRCO       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GREX       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    RCDP       SMALLINT      NULL,
    RIPC       TINYINT       NULL FOREIGN KEY REFERENCES Common.PTTConfiguration (id),
    RIVL       DECIMAL(3, 1) NULL,
    RIVP       TINYINT       NULL FOREIGN KEY REFERENCES Common.EVSWRPolarity (id)
);
GO
