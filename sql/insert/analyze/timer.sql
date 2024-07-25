DECLARE @RN CHAR(10);
SET @RN='{}';
INSERT INTO Analyze.Timer
    (Radio_Name, ResetDate, RecordType)
VALUES
    (@RN, GETUTCDATE(), 0),
    (@RN, GETUTCDATE(), 1);