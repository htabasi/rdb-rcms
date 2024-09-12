
CREATE PROCEDURE NewFixedValueParameter
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 1);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 1
      AND HMP.ParameterCode = @ParameterCode
      AND HMO.message = @OK
      AND HMM.message = @UnNormalMessage
END;
GO

CREATE PROCEDURE NewFixedValueParameterTX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 1);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 1
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'TX'
END;
GO

CREATE PROCEDURE NewFixedValueParameterRX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 1);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 1
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'RX'
END;
GO

CREATE PROCEDURE NewMultiLevelParameter
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @OK VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 2);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
    SELECT HMP.id, RR.Name, 1, @Correct, HMM.id
    FROM HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 2
        AND HMP.ParameterCode = @ParameterCode
        AND HMM.message = @OK;
END;
GO

CREATE PROCEDURE NewMultiLevelParameterTX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @OK VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 2);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
    SELECT HMP.id, RR.Name, 1, @Correct, HMM.id
    FROM HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 2
        AND HMP.ParameterCode = @ParameterCode
        AND HMM.message = @OK
        AND CRT.Type = 'TX';
END;
GO

CREATE PROCEDURE NewMultiLevelParameterRX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @OK VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 2);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
    SELECT HMP.id, RR.Name, 1, @Correct, HMM.id
    FROM HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 2
        AND HMP.ParameterCode = @ParameterCode
        AND HMM.message = @OK
        AND CRT.Type = 'RX';
END;
GO

CREATE PROCEDURE NewMultiLevelStatus
    @ParameterCode VARCHAR(50),
    @Value VARCHAR(50),
    @Severity TINYINT,
    @Message VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Messages (message)
    SELECT @Message
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @Message);

    INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
    SELECT HML.id, @Value, @Severity, HMM.id
    FROM HealthMonitor.MultiLevel HML
        JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
        CROSS JOIN HealthMonitor.Messages HMM
    Where HMP.ParameterCode = @ParameterCode
        AND HMM.message = @Message;
END;
GO

CREATE PROCEDURE NewRangeParameterTX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Start DECIMAL(5, 2),
    @End DECIMAL(5, 2),
    @OK VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 3);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, [Enable], [start], [end], normal_msg)
    SELECT HMP.id, RR.Name, 1, @Start, @End, HMM.id
    FROM HealthMonitor.Parameters HMP
             CROSS JOIN Radio.Radio RR
             INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
             CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 3
      AND HMP.ParameterCode = @ParameterCode
      AND HMM.message = @OK
      AND CRT.Type='TX';
END;
GO

CREATE PROCEDURE NewRangeParameterRX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Start DECIMAL(5, 2),
    @End DECIMAL(5, 2),
    @OK VARCHAR(100)
AS
BEGIN
    -- Insert into Parameters table
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 3);

    -- Insert into Messages table if not exists
    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    -- Insert into Range table
    INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, [Enable], [start], [end], normal_msg)
    SELECT HMP.id, RR.Name, 1, @Start, @End, HMM.id
    FROM HealthMonitor.Parameters HMP
             CROSS JOIN Radio.Radio RR
             INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
             CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 3
      AND HMP.ParameterCode = @ParameterCode
      AND HMM.message = @OK
      AND CRT.Type='RX';
END;
GO

CREATE PROCEDURE NewRangeParameter
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Start DECIMAL(5, 2),
    @End DECIMAL(5, 2),
    @OK VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 3);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, [Enable], [start], [end], normal_msg)
    SELECT HMP.id, RR.Name, 1, @Start, @End, HMM.id
    FROM HealthMonitor.Parameters HMP
             CROSS JOIN Radio.Radio RR
             CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 3
      AND HMP.ParameterCode = @ParameterCode
      AND HMM.message = @OK
END;
GO

CREATE PROCEDURE NewRangeStatus
    @ParameterCode VARCHAR(50),
    @Start DECIMAL(5, 2),
    @End DECIMAL(5, 2),
    @Severity TINYINT,
    @Message VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Messages (message)
    SELECT @Message
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @Message);

    INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
    SELECT HMR.id, @Start, @End, @Severity, HMM.id
    FROM HealthMonitor.Range HMR
             JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
             CROSS JOIN HealthMonitor.Messages HMM
    Where HMP.ParameterCode = @ParameterCode
      AND HMM.message = @Message
END;
GO

CREATE PROCEDURE NewEqualStringParameter
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
END;
GO

CREATE PROCEDURE NewEqualStringParameterTX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'TX'
END;
GO

CREATE PROCEDURE NewEqualStringParameterRX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Correct VARCHAR(50),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Correct, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'RX'
END;
GO

CREATE PROCEDURE NewPatternStringParameter
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Pattern VARCHAR(100),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Pattern, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
END;
GO

CREATE PROCEDURE NewPatternStringParameterTX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Pattern VARCHAR(100),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Pattern, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'TX'
END;
GO

CREATE PROCEDURE NewPatternStringParameterRX
    @ParameterCode VARCHAR(50),
    @ParameterName VARCHAR(50),
    @Pattern VARCHAR(100),
    @Severity TINYINT,
    @OK VARCHAR(100),
    @UnNormalMessage VARCHAR(100)
AS
BEGIN
    INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
    VALUES (@ParameterCode, @ParameterName, 4);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @OK
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @OK);

    INSERT INTO HealthMonitor.Messages (message)
    SELECT @UnNormalMessage
    WHERE NOT EXISTS (SELECT 1 FROM HealthMonitor.Messages WHERE message = @UnNormalMessage);

    INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
    SELECT HMP.id, RR.Name, 1, @Pattern, @Severity, HMO.id, HMM.id
    From HealthMonitor.Parameters HMP
        CROSS JOIN Radio.Radio RR
        INNER JOIN Common.RadioType CRT ON RR.RadioType = CRT.id
        CROSS JOIN HealthMonitor.Messages HMO
        CROSS JOIN HealthMonitor.Messages HMM
    WHERE HMP.ParameterType = 4
        AND HMP.ParameterCode = @ParameterCode
        AND HMO.message = @OK
        AND HMM.message = @UnNormalMessage
        AND CRT.Type = 'RX'
END;
GO
