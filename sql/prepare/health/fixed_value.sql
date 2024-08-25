SELECT HPA.id            as 'id',
       HPA.ParameterCode as 'code',
       HPA.ParameterName as 'name',
       HFV.correct       as 'correct',
       HFV.severity      as 'severity',
       HME.message       as 'normal_msg',
       HMS.message       as 'message'
FROM HealthMonitor.Parameters HPA
         INNER JOIN HealthMonitor.FixedValue HFV ON HPA.id = HFV.ParameterID
         INNER JOIN HealthMonitor.Messages HME ON HFV.normal_msg = HME.id
         INNER JOIN HealthMonitor.Messages HMS ON HFV.message = HMS.id
Where HFV.Enable = 1
  AND Radio_Name = '{}';