USE RCMS;
GO

INSERT INTO Application.Names
    (id, App, JobInformation)
Values (19, 'HealthMonitor', '');

INSERT INTO Application.LogConfig
    (RunMode, App, FileLevel, StreamLevel, FileFormat, StreamFormat)
Values (0, 19, 10, 30, 1, 1),
       (1, 19, 10, 50, 1, 1);

ALTER TABLE Application.Configuration
    ADD HealthCalm DECIMAL(4, 2) DEFAULT 1;

ALTER TABLE Analyze.Counter
    ADD CntStatusUpdated BIGINT NOT NULL DEFAULT 0;

ALTER TABLE Analyze.Counter
    ADD CntErrorStatusUpdating BIGINT NOT NULL DEFAULT 0;

ALTER TABLE Application.ModuleStatus
    ADD HealthAlive BIT NOT NULL DEFAULT 0;
GO

INSERT INTO HealthMonitor.StatusTypes
    (id, StatusName, StatusChar, BackgroundColor, ForegroundColor)
VALUES (0, 'Normal', 'N', '#3cb043', '#000000'),
       (1, 'Notice', 'T', '#aef359', '#000000'),
       (2, 'Warning', 'W', '#ffff00', '#000000'),
       (3, 'Error', 'E', '#f9a602', '#000000'),
       (4, 'Critical', 'C', '#ff2400', '#000000'),
       (5, 'Emergency', 'M', '#8d021f', '#A8FFFF');

INSERT INTO HealthMonitor.ParameterTypes
    (id, Type)
VALUES (1, 'FixedValue'),
       (2, 'MultiLevel'),
       (3, 'RangeValue'),
       (4, 'EqualString'),
       (5, 'PatternString')
GO

INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('AudioInterface', 'Audio Interface', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TxAudioALC', 'Tx Audio ALC', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('LineInterfaceInLocalMode', 'Line Interface in local mode', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RxAudioAGC', 'Rx Audio AGC', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('GONOGOStatus', 'GO-NOGO Status', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('LocalMode', 'Local Mode', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ModulationMode', 'Modulation Mode', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SingleChannel', 'Single Channel', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SQLogicOperation', 'SQ Logic Operation', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ChannelSpacing', 'Channel Spacing', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SQCircuit', 'SQ Circuit', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('CarrierOffset', 'Carrier Offset', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('Frequency', 'Frequency', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('CarrierOverride', 'Carrier Override', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ACARSDataMode', 'ACARS Data Mode', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ATRSwitchMode', 'ATR Switch Mode', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('DHCPEnabled', 'DHCP Enabled', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SecondIPAddressEnabled', 'Second IP Address Enabled', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RxInputSensitivity', 'Rx Input Sensitivity', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('IPv6Enabled', 'IPv6 Enabled', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('NTPSyncActive', 'NTP Sync Active', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SNMPEnable', 'SNMP Enable', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ActivationStatus', 'Activation Status', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('MainStandbyType', 'Main-Standby Type', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXInhibition', 'TX Inhibition', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('VSWRLED', 'VSWR LED', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('PTTInputConfiguration', 'PTT Input Configuration', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RSSIOutputType', 'RSSI Output Type', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('EXTVSWRPolarity', 'EXT VSWR Polarity', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('MySessionType', 'My Session Type', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('OtherSessionType', 'Other Session Type', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('Connection', 'Connection', 1);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('PresetPageNumber', 'Preset Page Number', 1);
GO

INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('Access', 'Access', 2);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('Session', 'Session', 2);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('CBITLevel', 'CBIT Level', 2);
GO

INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('AudioDelay', 'Audio Delay', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TxPreEmphasis', 'Tx Pre-Emphasis', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('LocalModeTimeout', 'Local Mode Timeout', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SNRSquelchThreshold', 'SNR Squelch Threshold', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RSSISquelchThreshold', 'RSSI Squelch Threshold', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('MeasureRXAudioLevel', 'Measure RX Audio Level', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('MeasureTXAudioLevel', 'Measure TX Audio Level', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('PTTTimeout', 'PTT Timeout', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TxLowPowerLevel', 'Tx Low Power Level', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ModulationDepthSetting', 'Modulation Depth Setting', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ModulationDepthValue', 'Modulation Depth Value', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RXDCSectionVoltage', 'RX DC Section Voltage', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RXBatteryVoltage', 'RX Battery Voltage', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXDCSectionVoltage', 'TX DC Section Voltage', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXBatteryVoltage', 'TX Battery Voltage', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXPowerValue', 'TX Power Value', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RXRadioModuleTemperatures', 'RX Radio Module Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RXPowerSupplyTemperatures', 'RX Power Supply Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RXPowerAmplifierTemperatures', 'RX Power Amplifier Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXRadioModuleTemperatures', 'TX Radio Module Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXPowerSupplyTemperatures', 'TX Power Supply Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('TXPowerAmplifierTemperatures', 'TX Power Amplifier Temperatures', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('VSWRValue', 'VSWR Value', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('ExternalVSWRVoltage', 'External VSWR Voltage', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('EXTVSWRlimit', 'EXT VSWR limit', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('AudioLevel', 'Audio Level', 3);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('RTCTimeAndDate', 'RTC Time and Date', 3);
GO

INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('BootErrorList', 'Boot Error List', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('IPAddress', 'IP Address', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SecondIPAddress', 'Second IP Address', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SerialNumber', 'SerialNumber', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('SNMPCommunityString', 'SNMP Community String', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('PartitionVersions1', 'Partition Versions 1', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('PartitionVersions2', 'Partition Versions 2', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('GB2PPVersion', 'GB2PP Version', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('FTPLogin', 'FTP Login', 4);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('FTPPassword', 'FTP Password', 4);
GO

INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('Hostname', 'Hostname', 5);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('InstallationInfo', 'Installation Info', 5);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('DisplayedName', 'Displayed Name', 5);
INSERT INTO HealthMonitor.Parameters (ParameterCode, ParameterName, ParameterType)
VALUES ('NTPServer', 'NTP Server', 5);
GO

INSERT INTO HealthMonitor.Messages (message)
VALUES ('OK');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Wrong Interface Selected');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Tx Audio ALC is Disabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Line Interface in local mode is Disabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Rx Audio AGC is Disabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('NO GO');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Local Mode Disabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Mode is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Single Channel is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Different Logic');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Channel Spacing is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('SQ Circuit is off');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Carrier Offset is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Frequency is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Carrier Override is Disabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('ACARS Data Mode is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('ATR Switch Mode is different');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('DHCP is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Second IP is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Rx Input Sensitivity is different');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('IPv6 is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Time is not synchronized');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('SNMP is Enabled');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('InActivated');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Main-Standby Type is different');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Inhibited');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('VSWR LED is On');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('PTT Input Configuration is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('RSSI Output Type is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('EXT VSWR Polarity is wrong');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Myself Control Session Established');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Another Control Session Activated');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio is Disconnect');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Preset Page Number is wrong');
GO
INSERT INTO HealthMonitor.Messages (message)
VALUES ('A controller session was detected');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Local controller was detected');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Another Connection Detected');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Two other connections were identified');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Three other connections were identified');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('CBIT Warning Detected');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('CBIT Error Detected');
GO
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Delay above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Delay High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Pre-Emphasis above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Pre-Emphasis High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Local Mode Timeout above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('SNR Squelch Threshold below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('SNR Squelch Threshold above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('RSSI Squelch Threshold below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('RSSI Squelch Threshold above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Level ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('PTT Timeout below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('PTT Timeout above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Tx Low Power Level below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Tx Low Power Level above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Depth Setting Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Depth Setting below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Depth Value Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Depth Value below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Modulation Depth Value above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('DC Section Voltage Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('DC Section Voltage below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('DC Section Voltage above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('DC Section Voltage High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Battery Voltage Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Battery Voltage below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Battery Voltage above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Battery Voltage High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Value Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Value Below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Value above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio Module Temperatures Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio Module Temperatures below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio Module Temperatures above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio Module Temperatures High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Supply Temperatures Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Supply Temperatures below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Supply Temperatures above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Supply Temperatures High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Amplifier Temperatures Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Amplifier Temperatures below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Amplifier Temperatures above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Power Amplifier Temperatures High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('VSWR Value above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('VSWR Value High ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('External VSWR Voltage Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('EXT VSWR limit below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('EXT VSWR limit above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Level Low ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Level below Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Audio Level above Normal ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Time and Date difference is above Normal ({:.3f}) seconds');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Time and Date is not Sync');
GO
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Error occurred during boot');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('IP Address Changed');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Second IP Address Changed');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Radio Changed');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('SNMP Community String is different');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Partition 1 Need to Update');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Partition 2 Need to Update');
GO

INSERT INTO HealthMonitor.Messages (message)
VALUES ('GB2PP Version is different ({})');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('FTP Login is different');
GO
INSERT INTO HealthMonitor.Messages (message)
VALUES ('FTP Password is different');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('Pattern Unmatch');
INSERT INTO HealthMonitor.Messages (message)
VALUES ('NTP Server IP is wrong');
GO

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'ACARSDataMode'
  AND HMM.message = 'ACARS Data Mode is Enabled';
INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'ActivationStatus'
  AND HMM.message = 'InActivated';
INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'AudioInterface'
  AND HMM.message = 'Wrong Interface Selected';
INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 3, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'ChannelSpacing'
  AND HMM.message = 'Channel Spacing is wrong';
INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'Connection'
  AND HMM.message = 'Radio is Disconnect';
GO

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'DHCPEnabled'
  AND HMM.message = 'DHCP is Enabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FEO.FFTR, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FEOperation FEO ON FEO.Radio_Name = RR.Name
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'Frequency'
  AND HMM.message = 'Frequency is wrong';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'GONOGOStatus'
  AND HMM.message = 'NO GO';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'IPv6Enabled'
  AND HMM.message = 'IPv6 is Enabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'LineInterfaceInLocalMode'
  AND HMM.message = 'Line Interface In Local Mode is Disabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'LocalMode'
  AND HMM.message = 'Local Mode Disabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'MainStandbyType'
  AND HMM.message = 'Main-Standby Type is different';
GO

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'ModulationMode'
  AND HMM.message = 'Modulation Mode is wrong';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'MySessionType'
  AND HMM.message = 'Myself Control Session Established';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'NTPSyncActive'
  AND HMM.message = 'Time is not synchronized';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'OtherSessionType'
  AND HMM.message = 'Another Control Session Activated';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'PresetPageNumber'
  AND HMM.message = 'Preset Page Number is wrong';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'SecondIPAddressEnabled'
  AND HMM.message = 'Second IP is Enabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'SingleChannel'
  AND HMM.message = 'Single Channel is Enabled';

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'SNMPEnable'
  AND HMM.message = 'SNMP is Enabled';
GO

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FSR.GRIS, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = RR.Name
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'RxInputSensitivity'
  AND HMM.message = 'Rx Input Sensitivity is different'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FSR.FFCO, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = RR.Name
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'CarrierOverride'
  AND HMM.message = 'Carrier Override is Disabled'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'RSSIOutputType'
  AND HMM.message = 'RSSI Output Type is wrong'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'RxAudioAGC'
  AND HMM.message = 'Rx Audio AGC is Disabled'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'SQCircuit'
  AND HMM.message = 'SQ Circuit is off'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FSR.FFSL, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = RR.Name
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'SQLogicOperation'
  AND HMM.message = 'Different Logic'
  AND RR.RadioType = 0;
GO

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'ATRSwitchMode'
  AND HMM.message = 'ATR Switch Mode is different'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FES.FFTO, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FESpecialSetting FES ON FES.Radio_Name = RR.Name
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'CarrierOffset'
  AND HMM.message = 'Carrier Offset is wrong'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'EXTVSWRPolarity'
  AND HMM.message = 'EXT VSWR Polarity is wrong'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 2, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'PTTInputConfiguration'
  AND HMM.message = 'PTT Input Configuration is wrong'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 1, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'TxAudioALC'
  AND HMM.message = 'Tx Audio ALC is Disabled'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'TXInhibition'
  AND HMM.message = 'Inhibited'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 0, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 1
  AND HMP.ParameterCode = 'VSWRLED'
  AND HMM.message = 'VSWR LED is On'
  AND RR.RadioType = 1;
GO

INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
SELECT HMP.id, RR.Name, 1, 0, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 2
  AND HMP.ParameterCode = 'Access'
  AND HMM.message = 'OK';

INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
SELECT HMP.id, RR.Name, 1, 1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 2
  AND HMP.ParameterCode = 'Session'
  AND HMM.message = 'OK';


INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
SELECT HMP.id, RR.Name, 1, 0, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 2
  AND HMP.ParameterCode = 'CBITLevel'
  AND HMM.message = 'OK';
GO

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 1, 1, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'Access'
  AND HMM.message = 'A controller session was detected';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 2, 2, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'Access'
  AND HMM.message = 'Local controller was detected';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 2, 1, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'Session'
  AND HMM.message = 'Another Connection Detected';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 3, 2, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'Session'
  AND HMM.message = 'Two other connections were identified';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 4, 2, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'Session'
  AND HMM.message = 'Three other connections were identified';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 1, 1, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'CBITLevel'
  AND HMM.message = 'CBIT Warning Detected';

INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
SELECT HML.id, 2, 2, HMM.id
FROM HealthMonitor.MultiLevel HML
         JOIN HealthMonitor.Parameters HMP on HMP.id = HML.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'CBITLevel'
  AND HMM.message = 'CBIT Error Detected';
GO


INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 0, 5, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'AudioDelay'
  AND HMM.message = 'OK';

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, -10, 0, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'AudioLevel'
  AND HMM.message = 'OK';

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 60, 120, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'LocalModeTimeout'
  AND HMM.message = 'OK';

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, -1, -1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'MeasureRXAudioLevel'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 0, 3, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RTCTimeAndDate'
  AND HMM.message = 'OK';
GO

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 2, 11, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RSSISquelchThreshold'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 27.9, 30.1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RXBatteryVoltage'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 28.1, 30.7, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RXDCSectionVoltage'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 35, 44, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RXPowerAmplifierTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 41, 49, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RXPowerSupplyTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 37, 48, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'RXRadioModuleTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 10, 15, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'SNRSquelchThreshold'
  AND HMM.message = 'OK'
  AND RR.RadioType = 0;
GO

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 4.9, -1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'ExternalVSWRVoltage'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 2, 2.1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'EXTVSWRlimit'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, -1, -1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'MeasureTXAudioLevel'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 85, -1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'ModulationDepthSetting'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 85, 91, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'ModulationDepthValue'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 60, 121, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'PTTTimeout'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 27.6, 30.1, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXBatteryVoltage'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 27.4, 29.9, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXDCSectionVoltage'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;
GO

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 5, 21, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TxLowPowerLevel'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 23, 37, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXPowerAmplifierTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 19, 34, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXPowerSupplyTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 48, 52, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXPowerValue'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 0, 2, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TxPreEmphasis'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 24, 34, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'TXRadioModuleTemperatures'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;

INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
SELECT HMP.id, RR.Name, 1, 0, 1.7, HMM.id
FROM HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 3
  AND HMP.ParameterCode = 'VSWRValue'
  AND HMM.message = 'OK'
  AND RR.RadioType = 1;
GO


INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 5, 50, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'AudioDelay'
  AND HMM.message = 'Audio Delay above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 50, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'AudioDelay'
  AND HMM.message = 'Audio Delay High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -30, -20, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'AudioLevel'
  AND HMM.message = 'Audio Level Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -20, -10, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'AudioLevel'
  AND HMM.message = 'Audio Level below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 0, 10, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'AudioLevel'
  AND HMM.message = 'Audio Level above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 120, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'LocalModeTimeout'
  AND HMM.message = 'Local Mode Timeout above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 3, 30, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RTCTimeAndDate'
  AND HMM.message = 'Time and Date difference is above Normal ({:.3f}) seconds';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RTCTimeAndDate'
  AND HMM.message = 'Time and Date is not Sync';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 0, 0, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'MeasureRXAudioLevel'
  AND HMM.message = 'Audio Level ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 2, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RSSISquelchThreshold'
  AND HMM.message = 'RSSI Squelch Threshold below Normal ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 11, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RSSISquelchThreshold'
  AND HMM.message = 'RSSI Squelch Threshold above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 27.7, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXBatteryVoltage'
  AND HMM.message = 'RX Battery Voltage Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 27.7, 27.9, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXBatteryVoltage'
  AND HMM.message = 'RX Battery Voltage below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.1, 30.2, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXBatteryVoltage'
  AND HMM.message = 'RX Battery Voltage above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.2, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXBatteryVoltage'
  AND HMM.message = 'RX Battery Voltage High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 28, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXDCSectionVoltage'
  AND HMM.message = 'RX DC Section Voltage Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 28, 28.1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXDCSectionVoltage'
  AND HMM.message = 'RX DC Section Voltage below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.7, 30.8, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXDCSectionVoltage'
  AND HMM.message = 'RX DC Section Voltage above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.8, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXDCSectionVoltage'
  AND HMM.message = 'RX DC Section Voltage High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 34, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerAmplifierTemperatures'
  AND HMM.message = 'RX Power Amplifier Temperatures Low ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 34, 35, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerAmplifierTemperatures'
  AND HMM.message = 'RX Power Amplifier Temperatures below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 44, 45, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerAmplifierTemperatures'
  AND HMM.message = 'RX Power Amplifier Temperatures above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 45, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerAmplifierTemperatures'
  AND HMM.message = 'RX Power Amplifier Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 40, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerSupplyTemperatures'
  AND HMM.message = 'RX Power Supply Temperatures Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 40, 41, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerSupplyTemperatures'
  AND HMM.message = 'RX Power Supply Temperatures below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 49, 50, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerSupplyTemperatures'
  AND HMM.message = 'RX Power Supply Temperatures above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 50, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXPowerSupplyTemperatures'
  AND HMM.message = 'RX Power Supply Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 36, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXRadioModuleTemperatures'
  AND HMM.message = 'RX Radio Module Temperatures Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 36, 37, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXRadioModuleTemperatures'
  AND HMM.message = 'RX Radio Module Temperatures below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 48, 49, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXRadioModuleTemperatures'
  AND HMM.message = 'RX Radio Module Temperatures above Normal ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 49, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'RXRadioModuleTemperatures'
  AND HMM.message = 'RX Radio Module Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 6, 10, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'SNRSquelchThreshold'
  AND HMM.message = 'SNR Squelch Threshold below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 15, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'SNRSquelchThreshold'
  AND HMM.message = 'SNR Squelch Threshold above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 0.1, 4.9, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ExternalVSWRVoltage'
  AND HMM.message = 'External VSWR Voltage Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 2, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'EXTVSWRlimit'
  AND HMM.message = 'EXT VSWR limit below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 2.1, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'EXTVSWRlimit'
  AND HMM.message = 'EXT VSWR limit above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 0, 0, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'MeasureTXAudioLevel'
  AND HMM.message = 'Audio Level ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30, 75, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ModulationDepthSetting'
  AND HMM.message = 'Modulation Depth Setting Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 75, 85, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ModulationDepthSetting'
  AND HMM.message = 'Modulation Depth Setting below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30, 75, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ModulationDepthValue'
  AND HMM.message = 'Modulation Depth Value Low ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 75, 85, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ModulationDepthValue'
  AND HMM.message = 'Modulation Depth Value below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 91, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'ModulationDepthValue'
  AND HMM.message = 'Modulation Depth Value above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 0, 60, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'PTTTimeout'
  AND HMM.message = 'PTT Timeout below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 121, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'PTTTimeout'
  AND HMM.message = 'PTT Timeout above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 27.5, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXBatteryVoltage'
  AND HMM.message = 'TX Battery Voltage Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 27.5, 27.6, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXBatteryVoltage'
  AND HMM.message = 'TX Battery Voltage below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.1, 30.2, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXBatteryVoltage'
  AND HMM.message = 'TX Battery Voltage above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30.2, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXBatteryVoltage'
  AND HMM.message = 'TX Battery Voltage High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 27.2, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXDCSectionVoltage'
  AND HMM.message = 'TX DC Section Voltage Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 27.2, 27.4, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXDCSectionVoltage'
  AND HMM.message = 'TX DC Section Voltage below Normal ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 29.9, 30, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXDCSectionVoltage'
  AND HMM.message = 'TX DC Section Voltage above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 30, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXDCSectionVoltage'
  AND HMM.message = 'TX DC Section Voltage High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 5, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TxLowPowerLevel'
  AND HMM.message = 'Tx Low Power Level below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 21, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TxLowPowerLevel'
  AND HMM.message = 'Tx Low Power Level above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 21, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerAmplifierTemperatures'
  AND HMM.message = 'TX Power Amplifier Temperatures Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 21, 22, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerAmplifierTemperatures'
  AND HMM.message = 'TX Power Amplifier Temperatures below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 37, 43, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerAmplifierTemperatures'
  AND HMM.message = 'TX Power Amplifier Temperatures above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 43, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerAmplifierTemperatures'
  AND HMM.message = 'TX Power Amplifier Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 17, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerSupplyTemperatures'
  AND HMM.message = 'TX Power Supply Temperatures Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 17, 19, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerSupplyTemperatures'
  AND HMM.message = 'TX Power Supply Temperatures below Normal ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 34, 38, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerSupplyTemperatures'
  AND HMM.message = 'TX Power Supply Temperatures above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 38, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerSupplyTemperatures'
  AND HMM.message = 'TX Power Supply Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 46, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerValue'
  AND HMM.message = 'TX Power Value Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 46, 48, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerValue'
  AND HMM.message = 'TX Power Value Below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 52, -1, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXPowerValue'
  AND HMM.message = 'TX Power Value above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 2, 5, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TxPreEmphasis'
  AND HMM.message = 'Pre-Emphasis above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 5, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TxPreEmphasis'
  AND HMM.message = 'Pre-Emphasis High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, -1, 21, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXRadioModuleTemperatures'
  AND HMM.message = 'TX Radio Module Temperatures Low ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 21, 24, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXRadioModuleTemperatures'
  AND HMM.message = 'TX Radio Module Temperatures below Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 34, 37, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXRadioModuleTemperatures'
  AND HMM.message = 'TX Radio Module Temperatures above Normal ({})';
GO

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 37, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'TXRadioModuleTemperatures'
  AND HMM.message = 'TX Radio Module Temperatures High ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 1.7, 2, 1, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'VSWRValue'
  AND HMM.message = 'VSWR Value above Normal ({})';

INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
SELECT HMR.id, 2, -1, 2, HMM.id
FROM HealthMonitor.Range HMR
         JOIN HealthMonitor.Parameters HMP on HMP.id = HMR.ParameterID
         CROSS JOIN HealthMonitor.Messages HMM
Where HMP.ParameterCode = 'VSWRValue'
  AND HMM.message = 'VSWR Value High ({})';
GO



INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '0', 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'BootErrorList'
  AND HMM.message = 'Error occurred during boot';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, RR.IP, 2, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'IPAddress'
  AND HMM.message = 'IP Address Changed';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FFS.IP, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSIP FFS ON FFS.Radio_Name = RR.Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'SecondIPAddress'
  AND HMM.message = 'Second IP Address Changed'
  AND FFS.IP_Type = 1;

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, FFI.Serial_Number, 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSInventory FFI ON FFI.Radio_Name = RR.Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'SerialNumber'
  AND HMM.message = 'Radio Changed'
  AND FFI.R_Index = 0;

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, 'public', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'SNMPCommunityString'
  AND HMM.message = 'SNMP Community String is different';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '11.05', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'PartitionVersions1'
  AND HMM.message = 'Partition 1 Need to Update';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '11.05', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'PartitionVersions2'
  AND HMM.message = 'Partition 2 Need to Update';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '11.00', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'GB2PPVersion'
  AND HMM.message = 'GB2PP Version is different ({})';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, COALESCE(FFS.RUFL, ''), 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSSNMP FFS ON FFS.Radio_Name = RR.Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'FTPLogin'
  AND HMM.message = 'FTP Login is different';

INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, COALESCE(FFS.RUFP, ''), 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
         INNER JOIN Final.FSSNMP FFS ON FFS.Radio_Name = RR.Name
WHERE HMP.ParameterType = 4
  AND HMP.ParameterCode = 'FTPPassword'
  AND HMM.message = 'FTP Password is different';
GO

INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '^[A-Z]{3}(TX|RX)V\d[M|S]$', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 5
  AND HMP.ParameterCode = 'Hostname'
  AND HMM.message = 'Pattern Unmatch';

INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '^(TX|RX)-V\d[M|S] \d{6}-\d{6}$', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 5
  AND HMP.ParameterCode = 'InstallationInfo'
  AND HMM.message = 'Pattern Unmatch';

INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '^[A-Z]{3}_(TX|RX)_V\d[M|S]$', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 5
  AND HMP.ParameterCode = 'DisplayedName'
  AND HMM.message = 'Pattern Unmatch';

INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
SELECT HMP.id, RR.Name, 1, '^192\.168\.\d{1,3}\.200$', 1, 1, HMM.id
From HealthMonitor.Parameters HMP
         CROSS JOIN Radio.Radio RR
         CROSS JOIN HealthMonitor.Messages HMM
WHERE HMP.ParameterType = 5
  AND HMP.ParameterCode = 'NTPServer'
  AND HMM.message = 'NTP Server IP is wrong';
GO