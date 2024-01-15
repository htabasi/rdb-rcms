Select
    CGP.GroupName,
    CKI.CKey
From Command.GroupCommandAccess GCA
INNER JOIN Command.Groups CGP
    ON CGP.id = GCA.GroupID
INNER JOIN Command.KeyInformation CKI
    ON CKI.id = GCA.CommandID;
GO


SELECT
    CUS.UserName,
    CUS.Name,
    CUS.Family,
    CGP.GroupName,
    SSL.Code 'Station'
FROM Command.UserStationAccess USA
INNER JOIN Command.Users CUS
    ON CUS.id = USA.UserID
INNER JOIN Station.StationList SSL
    ON SSL.id = USA.StationID
INNER JOIN Command.Groups CGP
    ON CGP.id = CUS.GroupID
GO


SELECT
    CUS.id,
    GCA.CommandID
FROM Command.Users CUS
INNER JOIN Command.Groups CGP
    ON CUS.GroupID = CGP.id
INNER JOIN Command.GroupCommandAccess GCA
    ON CGP.id = GCA.GroupID
GO


SELECT
    CUS.UserName,
    CGP.GroupName,
    CKI.CKey
FROM Command.Users CUS
INNER JOIN Command.Groups CGP on CGP.id = CUS.GroupID
INNER JOIN Command.UserCommandAccess UCA on CUS.id = UCA.UserID
INNER JOIN Command.KeyInformation CKI on CKI.id = UCA.CommandID
GO
