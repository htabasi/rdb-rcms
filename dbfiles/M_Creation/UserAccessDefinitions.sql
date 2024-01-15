CREATE TABLE Command.Groups
(
    id        INT         NOT NULL IDENTITY PRIMARY KEY,
    GroupName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Command.Users
(
    id           INT         NOT NULL IDENTITY PRIMARY KEY,
    UserName     VARCHAR(50) NOT NULL UNIQUE,
    GroupID      INT         NOT NULL FOREIGN KEY REFERENCES Command.Groups (id),
    Name         VARCHAR(50) NOT NULL,
    Family       VARCHAR(50) NOT NULL,
    NationalCode VARCHAR(10),
    Phone        VARCHAR(13),
    Email        VARCHAR(50)
);
GO

CREATE TABLE Command.UserCommandAccess
(
    id        INT NOT NULL IDENTITY PRIMARY KEY,
    UserID    INT NOT NULL FOREIGN KEY REFERENCES Command.Users (id),
    CommandID INT NOT NULL FOREIGN KEY REFERENCES Command.KeyInformation (id)
);
GO

CREATE TABLE Command.UserStationAccess
(
    id        INT NOT NULL IDENTITY PRIMARY KEY,
    UserID    INT NOT NULL FOREIGN KEY REFERENCES Command.Users (id),
    StationID INT NOT NULL FOREIGN KEY REFERENCES Station.StationList (id)
);
GO

CREATE TABLE Command.GroupCommandAccess
(
    id        INT NOT NULL IDENTITY PRIMARY KEY,
    GroupID   INT NOT NULL FOREIGN KEY REFERENCES Command.Groups (id),
    CommandID INT NOT NULL FOREIGN KEY REFERENCES Command.KeyInformation (id)
);
GO
