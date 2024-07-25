Select
    CGP.GroupName,
    CKI.CKey

From Command.GroupCommandAccess GCA

INNER JOIN Command.Groups CGP
    ON CGP.id = GCA.GroupID

INNER JOIN Command.KeyInformation CKI
    ON CKI.id = GCA.CommandID

