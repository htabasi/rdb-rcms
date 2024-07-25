DECLARE @RN CHAR(10);
SET @RN='{}';
INSERT INTO Analyze.Counter
    (Radio_Name, ResetDate, RecordType)
VALUES
    (@RN, GETUTCDATE(), 0),
    (@RN, GETUTCDATE(), 1);