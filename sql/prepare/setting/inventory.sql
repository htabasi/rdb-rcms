DECLARE @RN CHAR(10);
SET @RN='{}';
SELECT *
From Setting.Inventory
WHERE Radio_Name=@RN AND Date in (
    SELECT TOP 1 Date
    FROM Setting.Inventory
    WHERE Radio_Name=@RN
    GROUP BY Date
    ORDER BY Date DESC);