SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       CKI.CKey          as 'key',
       HPA.ParameterName as 'name',
       HML.Enable        as 'enable',
       HML.correct       as 'correct',
       HME.message       as 'normal_msg',
       MLS.value         as 'value',
       MLS.severity      as 'severity',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.MultiLevel HML ON HPA.id = HML.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON HML.normal_msg = HME.id
         INNER JOIN HealthMonitor.MultiLevelStats MLS on HML.id = MLS.MultiLevelID
         INNER JOIN HealthMonitor.Messages HMS ON MLS.message = HMS.id
         FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id
Where Radio_Name = '{}';