SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       HPA.ParameterName as 'name',
       HPS.pattern       as 'pattern',
       HPS.severity      as 'severity',
       HME.message       as 'normal_msg',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.PatternString HPS ON HPA.id = HPS.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON HPS.normal_msg = HME.id
         INNER JOIN HealthMonitor.Messages HMS ON HPS.message = HMS.id
Where HPS.Enable = 1
  AND Radio_Name = '{}';