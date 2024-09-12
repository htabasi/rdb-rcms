SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       CKI.CKey          as 'key',
       HPA.ParameterName as 'name',
       HFV.Enable        as 'enable',
       HFV.correct       as 'correct',
       HFV.severity      as 'severity',
       HME.message       as 'normal_msg',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.FixedValue HFV ON HPA.id = HFV.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON HFV.normal_msg = HME.id
         INNER JOIN HealthMonitor.Messages HMS ON HFV.message = HMS.id
         INNER JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id
Where Radio_Name = '{}';