USE RCMS;
GO

CREATE TABLE Setting.Configuration
(
    id         INT          NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME     NOT NULL,
    Radio_Name CHAR(10)     NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT      NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AISE       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISF       SMALLINT     NULL,
    EVSR       VARCHAR(50)  NULL,
    FFBL       VARCHAR(150) NULL,
    FFEA       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFFC       VARCHAR(50)  NULL,
    FFLM       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFLT       SMALLINT     NULL
)
GO

CREATE TABLE Setting.Installation
(
    id         INT          NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME     NOT NULL,
    Radio_Name CHAR(10)     NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT      NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AIAI       TINYINT      NULL FOREIGN KEY REFERENCES Common.AudioInterface (id),
    AIEL       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFFE       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFSC       TINYINT      NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIN       VARCHAR(20)  NULL,
    GRLO       VARCHAR(212) NULL,
    MSTY       TINYINT      NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
)
GO

CREATE TABLE Setting.Network
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    GRDH       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRDN       VARCHAR(50)   NULL,
    GRIE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIV       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRNS       VARCHAR(15)   NULL,
    GRVE       DECIMAL(5, 2) NULL
)
GO

CREATE TABLE Setting.RXConfiguration
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL,
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AIGA       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AITS       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFCO       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    FFSL       TINYINT  NULL FOREIGN KEY REFERENCES Common.SQLogic (id),
    GRBS       TINYINT  NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRIS       TINYINT  NULL FOREIGN KEY REFERENCES Common.RXSensitivity (id),
    RIRO       TINYINT  NULL FOREIGN KEY REFERENCES Common.RSSIOutput (id)
)
GO

CREATE TABLE Setting.SNMP
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    GRSE       TINYINT     NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRSN       VARCHAR(30) NULL,
    RUFL       VARCHAR(30) NULL,
    RUFP       VARCHAR(30) NULL
)
GO

CREATE TABLE Setting.Status
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    ERBE       VARCHAR(2000) NULL,
    GRLR       SMALLINT      NULL,
    GRLT       SMALLINT      NULL,
    GRTI       DATETIME      NULL,
    RCLR       TINYINT       NULL,
    RCLV       DECIMAL(3, 1) NULL
)
GO

CREATE TABLE Setting.TXConfiguration
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AICA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIML       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GRAS       TINYINT       NULL FOREIGN KEY REFERENCES Common.ATRMode (id),
    GRCO       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    GREX       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    RCDP       SMALLINT      NULL,
    RIPC       TINYINT       NULL FOREIGN KEY REFERENCES Common.PTTConfiguration (id),
    RIVL       DECIMAL(3, 1) NULL,
    RIVP       TINYINT       NULL FOREIGN KEY REFERENCES Common.EVSWRPolarity (id)
)
GO
