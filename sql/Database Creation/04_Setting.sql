USE RCMS;
GO

CREATE TABLE Setting.Access
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ACL_Index  TINYINT     NOT NULL,
    Allowed_IP VARCHAR(15) NOT NULL
);
GO

CREATE TABLE Setting.IP
(
    id         INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME    NOT NULL,
    Radio_Name CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    IP_Type    TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.IPType (id),
    IP         VARCHAR(15) NOT NULL,
    Subnet     VARCHAR(15) NOT NULL,
    Gateway    VARCHAR(15) NULL
);
GO

CREATE TABLE Setting.Software
(
    id          INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date        DATETIME    NOT NULL,
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Partition   TINYINT     NOT NULL,
    Part_Number VARCHAR(12) NOT NULL,
    Version     VARCHAR(5)  NOT NULL,
    Status      TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.Partition (id),
);
GO

CREATE TABLE Setting.SRadio
(
    id         INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME      NOT NULL,
    Radio_Name CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Record     TINYINT       NOT NULL FOREIGN KEY REFERENCES Common.SettingRecordType (id),
    AIAI       TINYINT       NULL FOREIGN KEY REFERENCES Common.AudioInterface (id),
    AICA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIEL       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIGA       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AIML       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISE       TINYINT       NULL FOREIGN KEY REFERENCES Common.EnableDisable (id),
    AISF       SMALLINT      NULL,
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
    RIPC       TINYINT       NULL FOREIGN KEY REFERENCES Common.PTTConfiguration (id),
    RIRO       TINYINT       NULL FOREIGN KEY REFERENCES Common.RSSIOutput (id),
    RIVL       DECIMAL(3, 1) NULL,
    RIVP       TINYINT       NULL FOREIGN KEY REFERENCES Common.EVSWRPolarity (id),
    RUFL       VARCHAR(30)   NULL,
    RUFP       VARCHAR(30)   NULL
);
GO

CREATE TABLE Setting.Inventory
(
    id               INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date             DATETIME    NOT NULL,
    Radio_Name       CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    R_Index          TINYINT     NOT NULL,
    Type             TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioModule (id),
    Component_Name   VARCHAR(20) NOT NULL,
    Ident_Number     CHAR(9)     NOT NULL,
    Variant          TINYINT     NOT NULL,
    Production_Index CHAR(5)     NOT NULL,
    Serial_Number    CHAR(6)     NOT NULL,
    Production_Date  DATE        NOT NULL
);
GO

CREATE TABLE Setting.SCBIT
(
    id            INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date          DATETIME NOT NULL,
    Radio_Name    CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    CBIT_Code     SMALLINT NOT NULL,
    Configuration TINYINT  NOT NULL FOREIGN KEY REFERENCES Common.CBITResult
);
GO

--Network
-- GRDH,    DHCP Enabled,                       DHCP Enabled
-- GRDN,    Primary and Secondary DNS,          Primary and Secondary DNS
-- GRIE,    Second IP Address Enabled,          Second IP Address Enabled
-- GRIV,    IPv6 Enabled,                       IPv6 Enabled
-- GRNS,    NTP Server,                         NTP Server
-- GRVE,    GB2PP Version,                      GB2PP Version

--SNMP
-- GRSE,    SNMP Enable,                        SNMP Enable
-- GRSN,    SNMP Community String,              SNMP Community String
-- RUFL,    FTP Login,                          FTP Login
-- RUFP,    FTP Password,                       FTP Password

--Installation
-- AIAI,    Select Audio Interface,             Select Audio Interface
-- AIEL,    Line Interface in local mode,       Line Interface in local mode
-- FFFE,    Motor Tuned Telsa Filter,           Motor Tuned Telsa Filter
-- FFSC,    Single Channel,                     Single Channel
-- GRIN,    Installation Info,                  Installation Info
-- GRLO,    Location Info,                      Location Info
-- MSTY,    Main-Standby Type,                  Main-Standby Type

--Configuration
-- AISE,    PTT Signaling,                      SQ-RSSI Signaling
-- AISF,    PTT Signaling Frequency,            SQ Signaling Frequency
-- EVSR,    Read Sequence Number Page,          Read Sequence Number Page
-- FFBL,    Frequency Blocking Ranges,          Frequency Blocking Ranges
-- FFEA,    ACARS Data Mode,                    ACARS Data Mode
-- FFFC,    Filter Configuration,               Filter Configuration
-- FFLM,    Local Mode,                         Local Mode
-- FFLT,    Local Mode Timeout,                 Local Mode Timeout

--TXConfiguration
-- AICA,    Tx Audio ALC,
-- AIML,    Mute Loudspeaker,
-- GRAS,    ATR Switch Mode,
-- GRCO,    5 Carrier Offset,
-- GREX,    External Amplifier,
-- RCDP,    PTT Timeout,
-- RIPC,    PTT Input Configuration,
-- RIVL,    EXT VSWR limit,
-- RIVP,    EXT VSWR Polarity,

--RXConfiguration
-- AIGA,    ,Rx Audio AGC
-- AITS,    ,True Side-tone Transceiver
-- FFCO,    ,Carrier Override
-- FFSL,    ,SNR-RSSI SQ Logic Operation
-- GRBS,    ,Best Signal Selection
-- GRIS,    ,Rx Input Sensitivity
-- RIRO,    ,RSSI Output Type

--Status
-- ERBE,    Boot Error List,                    Boot Error List
-- GRLR,    ,Measure RX Audio Level
-- GRLT,    Measure TX Audio Level,
-- RCLR     ,Last RSSI Value
-- RCLV     Last VSWR Value
