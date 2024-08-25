MERGE INTO HealthMonitor.RadioStatus AS target
USING (SELECT '{}' AS Radio_Name, '{{}}' AS ParameterID, '{{}}' AS severity, '{{}}' AS message) AS source
ON (target.Radio_Name = source.Radio_Name AND target.ParameterID = source.ParameterID)
WHEN MATCHED THEN
    UPDATE
    SET severity = source.severity,
        message  = source.message
WHEN NOT MATCHED THEN
    INSERT (Radio_Name, ParameterID, severity, message)
    VALUES (source.Radio_Name, source.ParameterID, source.severity, source.message);