USE RCMS;
GO

-- CREATE SCHEMA HealthMonitor;
-- GO

CREATE TABLE HealthMonitor.StatusTypes
(
    id              TINYINT PRIMARY KEY,
    StatusName      VARCHAR(50)    NOT NULL,
    StatusChar      CHAR(1) UNIQUE NOT NULL,
    BackgroundColor CHAR(7)        NOT NULL,
    ForegroundColor CHAR(7)        NOT NULL
);

CREATE TABLE HealthMonitor.ParameterTypes
(
    id   TINYINT PRIMARY KEY,
    Type VARCHAR(50) NOT NULL
);

CREATE TABLE HealthMonitor.Parameters
(
    id            INT IDENTITY PRIMARY KEY,
    ParameterCode VARCHAR(50) UNIQUE NOT NULL,
    ParameterName VARCHAR(50)        NOT NULL,
    ParameterType TINYINT            NOT NULL FOREIGN KEY REFERENCES HealthMonitor.ParameterTypes (id)
);

CREATE TABLE HealthMonitor.Messages
(
    id      INT IDENTITY PRIMARY KEY,
    message VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE HealthMonitor.FixedValue
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.MultiLevel
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    normal_msg  INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.MultiLevelStats
(
    id           INT IDENTITY PRIMARY KEY,
    MultiLevelID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.MultiLevel (id),
    value        VARCHAR(50) NOT NULL,
    severity     TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message      INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.Range
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    start       DECIMAL(5, 2) NOT NULL,
    [end]       DECIMAL(5, 2) NOT NULL,
    normal_msg  INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.RangeStats
(
    id          INT IDENTITY PRIMARY KEY,
    RangeID     INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Range (id),
    range_start DECIMAL(5, 2) NOT NULL,
    range_end   DECIMAL(5, 2) NOT NULL,
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message     INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.EqualString
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.PatternString
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT          NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)     NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT      NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    pattern     VARCHAR(100) NOT NULL,
    severity    TINYINT      NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.RadioStatus
(
    id          INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name  CHAR(10) FOREIGN KEY REFERENCES Radio.Radio (Name),
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message     VARCHAR(100) NOT NULL
);