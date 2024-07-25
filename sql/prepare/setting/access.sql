DECLARE @RN CHAR(10);
SET @RN='{}';
SELECT ACL_Index, Allowed_IP
FROM Setting.Access
WHERE Radio_Name=@RN AND Date in (
    SELECT TOP 1 Date
    FROM Setting.Access
    WHERE Radio_Name=@RN
    GROUP BY Date
    ORDER BY Date DESC);