SELECT [RecordType]
      ,[IndicatorONSec]
      ,[IndicatorOFFSec]
      ,[ConnectTimeSec]
      ,[DisconnectTimeSec]
      ,[OperatingHour]
FROM Analyze.Timer
WHERE Radio_Name='{}';