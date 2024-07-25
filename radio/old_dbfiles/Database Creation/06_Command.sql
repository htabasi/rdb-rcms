USE RCMS;
GO

CREATE TABLE Command.History
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    RegisterTime DATETIME    NOT NULL DEFAULT GETDATE(),
--     user_id      BIGINT      NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
    Radio        char(10)    NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    CKey         char(4)     NOT NULL,
    Request      char(1)     NOT NULL,
    Value        varchar(50) NULL,
    SentTime     DATETIME    NULL,
    Status       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.CommandStatus (id),

    CONSTRAINT Request_Check CHECK (Request in ('G', 'S', 'T'))
);
GO

-- CREATE TABLE Command.ManagerHistory
-- (
--     id           INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
--     RegisterTime DATETIME    NOT NULL DEFAULT GETDATE(),
-- --     user_id      BIGINT      NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
--     Station      CHAR(3)     NOT NULL FOREIGN KEY REFERENCES Radio.Station (Code),
--     Frequency_No TINYINT     NOT NULL,
--     Sector       INT         NOT NULL FOREIGN KEY REFERENCES Radio.Sector (id),
--     RadioType    TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
--     MainStandby  TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
--     CKey         char(4)     NOT NULL,
--     Request      char(1)     NOT NULL,
--     Value        varchar(50) NULL,
--     SentTime     DATETIME    NULL,
--     Status       TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.CommandStatus (id),
--
--     CONSTRAINT Manager_Request_Check CHECK (Request in ('G', 'S', 'T'))
-- );
-- GO

CREATE TABLE Command.GroupCommandHistory
(
    id           INT          NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    RegisterTime DATETIME     NOT NULL DEFAULT GETDATE(),
    user_id      BIGINT       NOT NULL FOREIGN KEY REFERENCES Django.account_user (id),
    Station      VARCHAR(255) NOT NULL,
    Frequency_No VARCHAR(255) NOT NULL,
    Sector       VARCHAR(255) NOT NULL,
    RadioType    VARCHAR(255) NOT NULL,
    MainStandby  VARCHAR(255) NOT NULL,
    CKey         char(4)      NOT NULL,
    Request      char(1)      NOT NULL,
    Value        varchar(50)  NULL,
    SentTime     DATETIME     NULL,

    CONSTRAINT GroupCommandHistory_Request_Check CHECK (Request in ('G', 'S', 'T'))
);
GO
CREATE TABLE Command.RadioInitial
(
    id        INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    RadioType TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    CKey      CHAR(4)     NOT NULL,
    Request   CHAR(1)     NOT NULL,
    Value     VARCHAR(10) NOT NULL,
    Active    BIT         NOT NULL DEFAULT 1,

    CONSTRAINT InitialRequest_Check CHECK (Request in ('G', 'S', 'T'))
);
GO

CREATE TABLE Command.KeyInformation
(
    id                   INT IDENTITY   NOT NULL PRIMARY KEY CLUSTERED,
    CKey                 CHAR(4) UNIQUE NOT NULL,
    TX_Name              VARCHAR(50)    NULL,
    RX_Name              VARCHAR(50)    NULL,
    Parameter_Type       VARCHAR(30)    NOT NULL,
    Parameter_Unit       VARCHAR(6)     NULL,
    INT_Parameter_Min    INT            NULL,
    INT_Parameter_Max    INT            NULL,
    INT_Parameter_Step   INT            NULL,
    FLOAT_Parameter_Min  DECIMAL(2, 1)  NULL,
    FLOAT_Parameter_Max  DECIMAL(2, 1)  NULL,
    FLOAT_Parameter_Step DECIMAL(2, 1)  NULL,
    STRING_Max_Length    TINYINT        NULL,
    Convertor_Table      VARCHAR(50)    NULL,
    RegisterTable        VARCHAR(50)    NULL,
    TX_Support           BIT            NOT NULL,
    RX_Support           BIT            NOT NULL,
    GET_Support          BIT            NOT NULL,
    SET_Support          BIT            NOT NULL,
    TRAP_Support         BIT            NOT NULL,
    GET_Need_Value       BIT            NULL,
    Update_Need_Restart  BIT            NULL,
    Work_As_Expected     BIT            NULL,
    Fully_Identified     BIT            NULL
);
GO
