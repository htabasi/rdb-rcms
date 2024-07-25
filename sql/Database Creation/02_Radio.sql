USE RCMS;
GO

CREATE TABLE Radio.Station
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Code         CHAR(3)     NOT NULL UNIQUE,
    Availability TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.StationAvailability (id),
    Name         VARCHAR(50) NULL
);
GO

CREATE TABLE Radio.Sector
(
    id        INT           NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Name      VARCHAR(30)   NOT NULL UNIQUE,
    Frequency DECIMAL(6, 3) NOT NULL,
);
GO

CREATE TABLE Radio.Radio
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
    Name         CHAR(10)    NOT NULL UNIQUE,
    Station      CHAR(3)     NOT NULL FOREIGN KEY REFERENCES Radio.Station (Code),
    Frequency_No TINYINT     NOT NULL,
    Sector       INT         NOT NULL FOREIGN KEY REFERENCES Radio.Sector (id),
    RadioType    TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.RadioType (id),
    MainStandBy  TINYINT     NOT NULL FOREIGN KEY REFERENCES Common.MainStandby (id),
    IP           VARCHAR(15) NOT NULL
);
GO

CREATE TABLE Radio.UserStation
(
    id      INT NOT NULL IDENTITY PRIMARY KEY,
    Station INT NOT NULL FOREIGN KEY REFERENCES Radio.Station (id)
);
GO
