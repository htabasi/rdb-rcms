DECLARE @RN CHAR(10);
SET @RN='{}';
SELECT Partition, Version, Part_Number, Status
FROM Setting.Software
WHERE Radio_Name=@RN AND Date IN (
    SELECT TOP 1 Date
    FROM Setting.Software
    WHERE Radio_Name=@RN
    GROUP BY Date
    ORDER BY Date DESC)
ORDER BY Partition;