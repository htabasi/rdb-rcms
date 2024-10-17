MERGE INTO HealthMonitor.FrequencyStatusMem AS target
USING (SELECT '{{}}' AS PID, '{}' AS Station, '{}' AS FNo, '{}' AS Sector, '{{}}' AS severity, '{{}}' AS message) AS Source
ON (target.ParameterID = source.PID AND
    target.Station = source.Station AND
    target.Frequency_No = Source.FNo)
WHEN MATCHED THEN
    UPDATE SET severity=Source.severity,
               message=Source.message,
               Sector=Source.Sector
WHEN NOT MATCHED THEN
    INSERT (ParameterID, Station, Frequency_No, Sector, severity, message)
    VALUES (Source.PID, Source.Station, Source.FNo, Source.Sector, Source.severity, Source.message);