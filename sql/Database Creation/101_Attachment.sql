
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType) VALUES ('Subnet', 'Subnet', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType) VALUES ('SecondSubnet', 'Second Subnet', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType) VALUES ('Gateway', 'Gateway', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType) VALUES ('SecondGateway', 'Second Gateway', 4);
GO

INSERT INTO HealthMonitor.Messages (message) VALUES ('Subnet Changed');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Second Subnet Changed');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Gateway Changed');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Second Gateway Changed');
GO

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, '255.255.255.0', 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'Subnet'
  AND HMM.message = 'Subnet Changed';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, '255.255.255.0', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'SecondSubnet'
  AND HMM.message = 'Second Subnet Changed';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, IP.Gateway, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSIP IP ON RR.Name=IP.Radio_Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'Gateway'
  AND HMM.message = 'Gateway Changed'
  AND IP.IP_Type=0;

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, IP.Gateway, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSIP IP ON RR.Name=IP.Radio_Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'SecondGateway'
  AND HMM.message = 'Second Gateway Changed'
  AND IP.IP_Type=0;

Update HealthMonitor.PatternString
    SET pattern = '^"192\.168\.\d{1,3}\.200"$'
Where ParameterID = (SELECT id FROM HealthMonitor.Parameters WHERE ParameterCode='NTPServer')

Update HealthMonitor.PatternString
    SET pattern = '^"[A-Z]{3}(TX|RX)V\d[M|S]"$'
Where ParameterID = (SELECT id FROM HealthMonitor.Parameters WHERE ParameterCode='Hostname')
