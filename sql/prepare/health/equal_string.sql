SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       HPA.ParameterName as 'name',
       HES.correct       as 'correct',
       HES.severity      as 'severity',
       HME.message       as 'normal_msg',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.EqualString HES ON HPA.id = HES.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON HES.normal_msg = HME.id
         INNER JOIN HealthMonitor.Messages HMS ON HES.message = HMS.id
Where HES.Enable = 1
  AND Radio_Name = '{}';