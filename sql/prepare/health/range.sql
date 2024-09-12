SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       CKI.CKey          as 'key',
       HPA.ParameterName as 'name',
       R.Enable          as 'enable',
       R.start           as 'start',
       R.[end]           as 'end',
       HME.message       as 'normal_msg',
       RS.range_start    as 'r_start',
       RS.range_end      as 'r_end',
       RS.severity       as 'severity',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.Range R ON HPA.id = R.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON R.normal_msg = HME.id
         INNER JOIN HealthMonitor.RangeStats RS on R.id = RS.RangeID
         INNER JOIN HealthMonitor.Messages HMS ON RS.message = HMS.id
         INNER JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id
Where Radio_Name = '{}';