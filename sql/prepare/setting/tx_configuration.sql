DECLARE @RN CHAR(10);
SET @RN='{}';
SELECT
    (SELECT TOP 1 AICA FROM Setting.TXConfiguration WHERE AICA IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS AICA,
    (SELECT TOP 1 AIML FROM Setting.TXConfiguration WHERE AIML IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS AIML,
    (SELECT TOP 1 GRAS FROM Setting.TXConfiguration WHERE GRAS IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS GRAS,
    (SELECT TOP 1 GRCO FROM Setting.TXConfiguration WHERE GRCO IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS GRCO,
    (SELECT TOP 1 GREX FROM Setting.TXConfiguration WHERE GREX IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS GREX,
    (SELECT TOP 1 RCDP FROM Setting.TXConfiguration WHERE RCDP IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS RCDP,
    (SELECT TOP 1 RIPC FROM Setting.TXConfiguration WHERE RIPC IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS RIPC,
    (SELECT TOP 1 RIVL FROM Setting.TXConfiguration WHERE RIVL IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS RIVL,
    (SELECT TOP 1 RIVP FROM Setting.TXConfiguration WHERE RIVP IS NOT NULL AND Radio_Name=@RN ORDER BY Date DESC) AS RIVP