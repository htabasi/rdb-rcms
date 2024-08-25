DECLARE @RN CHAR(10) = '{}';
DECLARE @PID INT = (Select id FROM HealthMonitor.Parameters Where ParameterCode='Connection');
DECLARE @SEV TINYINT
DECLARE @MSG VARCHAR(100)

Select @SEV=severity, @MSG=M.message
From HealthMonitor.FixedValue F JOIN HealthMonitor.Messages M on M.id = F.message
WHERE ParameterID=@PID;

MERGE INTO HealthMonitor.RadioStatus AS target
USING (SELECT @RN AS Radio_Name, @PID AS ParameterID, @SEV AS severity, @MSG AS message) AS source
ON (target.Radio_Name = source.Radio_Name AND target.ParameterID = source.ParameterID)
WHEN MATCHED THEN
    UPDATE
    SET severity = source.severity,
        message  = source.message
WHEN NOT MATCHED THEN
    INSERT (Radio_Name, ParameterID, severity, message)
    VALUES (source.Radio_Name, source.ParameterID, source.severity, source.message);