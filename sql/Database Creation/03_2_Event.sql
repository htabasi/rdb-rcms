USE RCMS;
GO

CREATE TABLE Event.EAdjustment
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    AIAD       TINYINT       NULL,
    AILA       SMALLINT      NULL,
    AISL       SMALLINT      NULL,
    GRME       DATETIME      NULL,
    GRUI       VARCHAR(10)   NULL,
    GRUO       VARCHAR(10)   NULL
)
GO

CREATE TABLE Event.EConnection
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Connection TINYINT  NULL FOREIGN KEY REFERENCES Common.Conn (id)
);
GO

CREATE TABLE Event.EStatus
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Activation TINYINT  NULL FOREIGN KEY REFERENCES Common.Activation (id),
    Operation  TINYINT  NULL FOREIGN KEY REFERENCES Common.Operation (id),
    Access     TINYINT  NULL FOREIGN KEY REFERENCES Common.ControlAccess (id)
);
GO

CREATE TABLE Event.ENetwork
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    GRHN       VARCHAR(24)   NULL,
    GRNA       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    SCPG       SMALLINT      NULL,
    SCSS       TINYINT       NULL FOREIGN KEY REFERENCES Common.SessionType (id)
)
GO

CREATE TABLE Event.EOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    ERGN       TINYINT       NULL FOREIGN KEY REFERENCES Common.Operation (id),
    FFMD       TINYINT       NULL FOREIGN KEY REFERENCES Common.ModulationMode (id),
    FFSP       TINYINT       NULL FOREIGN KEY REFERENCES Common.ChannelSpacing (id),
    FFTR       INT           NULL,
    MSAC       TINYINT       NULL FOREIGN KEY REFERENCES Common.Activation (id),
    RCPP       TINYINT       NULL
)
GO


CREATE TABLE Event.RXOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    FFSN       TINYINT       NULL,
    FFSQ       TINYINT       NULL FOREIGN KEY REFERENCES Common.OnOff (id),
    FFSR       TINYINT       NULL,
    RIRC       VARCHAR(30)   NULL,
)
GO

CREATE TABLE Event.SetCommands
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    CKey       CHAR(4)  NOT NULL FOREIGN KEY REFERENCES Command.KeyInformation (CKey),
    UserID     BIGINT   NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
    Action     TINYINT NOT NULL FOREIGN KEY REFERENCES Common.SetCode (id),
    Comment    VARCHAR(50) NULL
);
GO

CREATE TABLE Event.TXOperation
(
    id         INT      NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Date       DATETIME NOT NULL DEFAULT GETDATE(),
    Radio_Name CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    RCMG       TINYINT       NULL
)
GO
--     -- Only for RX
--     -- Only for TX
--     -- Set Only Commands
--     EVCL       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
--     GRAT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
--     MSGO       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
--     RCPF       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
--     RCPT       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id),
--     RCRR       TINYINT       NULL FOREIGN KEY REFERENCES Common.SetCode (id)

