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
    ParameterType TINYINT            NOT NULL FOREIGN KEY REFERENCES HealthMonitor.ParameterTypes (id),
    [Key]         INT DEFAULT Null FOREIGN KEY REFERENCES Command.KeyInformation (id)
);

CREATE TABLE HealthMonitor.Messages
(
    id      INT IDENTITY PRIMARY KEY,
    message VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE HealthMonitor.FixedValue
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.MultiLevel
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    normal_msg  INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.MultiLevelStats
(
    id           INT IDENTITY PRIMARY KEY,
    MultiLevelID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.MultiLevel (id),
    value        VARCHAR(50) NOT NULL,
    severity     TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message      INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.Range
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT           NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)      NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT       NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    start       DECIMAL(5, 2) NOT NULL,
    [end]       DECIMAL(5, 2) NOT NULL,
    normal_msg  INT           NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.RangeStats
(
    id          INT IDENTITY PRIMARY KEY,
    RangeID     INT           NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Range (id),
    range_start DECIMAL(5, 2) NOT NULL,
    range_end   DECIMAL(5, 2) NOT NULL,
    severity    TINYINT       NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message     INT           NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.EqualString
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT     NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    correct     VARCHAR(50) NOT NULL,
    severity    TINYINT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT         NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.PatternString
(
    id          INT IDENTITY PRIMARY KEY,
    ParameterID INT          NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Radio_Name  CHAR(10)     NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Enable      TINYINT      NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    pattern     VARCHAR(100) NOT NULL,
    severity    TINYINT      NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    normal_msg  INT          NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id),
    message     INT          NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);

CREATE TABLE HealthMonitor.RadioStatus
(
    id          INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name  CHAR(10) FOREIGN KEY REFERENCES Radio.Radio (Name),
    ParameterID INT          NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    severity    TINYINT      NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message     VARCHAR(100) NOT NULL
);

Create Table HealthMonitor.RecentAlert
(
    id      INT IDENTITY PRIMARY KEY CLUSTERED,
    user_id BIGINT FOREIGN KEY REFERENCES Django.account_user (id),
    Seen    BIT NOT NULL DEFAULT 0,
    alert   INT FOREIGN KEY REFERENCES HealthMonitor.RadioStatus (id) ON DELETE CASCADE
);

CREATE Table HealthMonitor.ErrorLog
(
    id          INT IDENTITY PRIMARY KEY CLUSTERED,
    LogDate     DATETIME    NOT NULL,
    Description VARCHAR(50) NOT NULL,
    Details     VARCHAR(1000)
);
GO

CREATE TABLE HealthMonitor.FrequencyParameters
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    ParameterID  INT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Station      CHAR(3) NOT NULL FOREIGN KEY REFERENCES Radio.Station (Code),
    Frequency_No TINYINT NOT NULL,
    Enable       TINYINT NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Common.EnableDisable (id),
    TXM          TINYINT NULL,
    TXS          TINYINT NULL,
    RXM          TINYINT NULL,
    RXS          TINYINT NULL,
    Level        TINYINT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message      INT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);
GO

CREATE TABLE HealthMonitor.FrequencyStatus
(
    id           INT IDENTITY PRIMARY KEY CLUSTERED,
    ParameterID  INT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Parameters (id),
    Station      CHAR(3) NOT NULL FOREIGN KEY REFERENCES Radio.Station (Code),
    Frequency_No TINYINT NOT NULL,
    Sector       INT     NOT NULL FOREIGN KEY REFERENCES Radio.Sector (id),
    severity     TINYINT NOT NULL FOREIGN KEY REFERENCES HealthMonitor.StatusTypes (id),
    message      INT     NOT NULL FOREIGN KEY REFERENCES HealthMonitor.Messages (id)
);
GO

Create Table HealthMonitor.RecentFrequencyAlert
(
    id      INT IDENTITY PRIMARY KEY CLUSTERED,
    user_id BIGINT FOREIGN KEY REFERENCES Django.account_user (id),
    Seen    BIT NOT NULL DEFAULT 0,
    alert   INT FOREIGN KEY REFERENCES HealthMonitor.FrequencyStatus (id) ON DELETE CASCADE
);
--
-- CREATE TABLE HealthMonitor.RadioStatusMem
-- (
--     id          INT IDENTITY PRIMARY KEY NONCLUSTERED,
--     Radio_Name  CHAR(10)     NOT NULL,
--     ParameterID INT          NOT NULL,
--     severity    TINYINT      NOT NULL,
--     message     VARCHAR(100) NOT NULL,
--     INDEX IDX_RadioStatusMem_Radio_Name NONCLUSTERED (Radio_Name),
--     INDEX IDX_RadioStatusMem_ParameterID NONCLUSTERED (ParameterID)
-- );
-- GO

--Create Table HealthMonitor.RecentAlert
--(
--    id      INT IDENTITY PRIMARY KEY CLUSTERED,
--    user_id BIGINT FOREIGN KEY REFERENCES Django.account_user (id),
--    Seen    BIT NOT NULL DEFAULT 0,
--    alert   INT NOT NULL
--);

-- CREATE TABLE HealthMonitor.FrequencyStatusMem
-- (
--     id           INT IDENTITY PRIMARY KEY NONCLUSTERED,
--     ParameterID  INT     NOT NULL,
--     Station      CHAR(3) NOT NULL,
--     Frequency_No TINYINT NOT NULL,
--     Sector       INT     NOT NULL,
--     severity     TINYINT NOT NULL,
--     message      INT     NOT NULL,
--     INDEX IDX_FrequencyStatusMem_ParameterID NONCLUSTERED (ParameterID),
--     INDEX IDX_FrequencyStatusMem_Station NONCLUSTERED (Station),
--     INDEX IDX_FrequencyStatusMem_Frequency_No NONCLUSTERED (Frequency_No),
--     INDEX IDX_FrequencyStatusMem_Sector NONCLUSTERED (Sector)
-- );
-- GO

--Create Table HealthMonitor.RecentFrequencyAlert
--(
--    id      INT IDENTITY PRIMARY KEY CLUSTERED,
--    user_id BIGINT FOREIGN KEY REFERENCES Django.account_user (id),
--    Seen    BIT NOT NULL DEFAULT 0,
--    alert   INT NOT NULL
--);


--CREATE TABLE HealthMonitor.RadioStatusMem
--(
--    id          INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 20000),
--    Radio_Name  CHAR(10)     NOT NULL,
--    ParameterID INT          NOT NULL,
--    severity    TINYINT      NOT NULL,
--    message     VARCHAR(100) NOT NULL,
--    INDEX IDX_RadioStatusMem_Radio_Name NONCLUSTERED (Radio_Name),
--    INDEX IDX_RadioStatusMem_ParameterID NONCLUSTERED (ParameterID)
--) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
--GO

--CREATE TABLE HealthMonitor.FrequencyStatusMem
--(
--    id           INT IDENTITY PRIMARY KEY NONCLUSTERED HASH WITH ( BUCKET_COUNT = 2000),
--    ParameterID  INT     NOT NULL,
--    Station      CHAR(3) NOT NULL,
--    Frequency_No TINYINT NOT NULL,
--    Sector       INT     NOT NULL,
--    severity     TINYINT NOT NULL,
--    message      INT     NOT NULL,
--    INDEX IDX_FrequencyStatusMem_ParameterID NONCLUSTERED (ParameterID),
--    INDEX IDX_FrequencyStatusMem_Station NONCLUSTERED (Station),
--    INDEX IDX_FrequencyStatusMem_Frequency_No NONCLUSTERED (Frequency_No),
--    INDEX IDX_FrequencyStatusMem_Sector NONCLUSTERED (Sector)
--) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA );
--GO