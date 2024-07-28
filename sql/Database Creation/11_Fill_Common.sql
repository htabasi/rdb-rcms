Use RCMS;
GO

Insert Into Common.Activation
VALUES (0, 'Inactive'),
       (1, 'Active');
GO

Insert Into Common.ATRMode
VALUES (0, 'RS Default'),
       (1, 'Latching');
GO

Insert Into Common.AudioInterface
VALUES (0, 'Analog Audio'),
       (1, 'E1'),
       (2, 'VoIP');
GO

INSERT INTO Common.CBITConfiguration
VALUES (0, 'NotConfigurable'),
       (1, 'Disabled'),
       (2, 'Warning'),
       (4, 'NoGo Error');
GO

INSERT INTO Common.CBITResult
VALUES (1, 'Disabled'),
       (2, 'Warning'),
       (4, 'NoGo Error');
GO

Insert Into Common.ChannelSpacing
VALUES (1, '8.33 KHz'),
       (2, '12.5 KHz'),
       (3, '25 KHz');
GO

INSERT INTO Common.CommandStatus
VALUES (1, 'Registered'),
       (2, 'Received'),
       (3, 'Requested'),
       (4, 'Done'),
       (5, 'Failed'),
       (6, 'Running'),
       (7, 'Stopping'),
       (8, 'Fail-ONAIR'),
	   (9, 'Expired');
GO

Insert Into Common.Conn
Values (0, 'Disconnect'),
       (1, 'Connect');
GO

Insert Into Common.ControlAccess
VALUES (0, 'Normal'),
       (1, 'Remote'),
       (2, 'Local');
GO

Insert Into Common.Controller
VALUES (0, 'Remote Control'),
       (3, 'MMI');
GO

Insert Into Common.EnableDisable
VALUES (0, 'Disabled'),
       (1, 'Enabled');
GO

Insert Into Common.EventLevel
VALUES (0, 'Information'),
       (1, 'Warning'),
       (2, 'Error');
GO

Insert Into Common.EVSWRPolarity
VALUES (0, 'Negative'),
       (1, 'Positive');
GO

INSERT INTO Common.Inhibit
Values (0, 'On Air'),
       (1, 'Inhibit');
GO

INSERT INTO Common.IPType
VALUES (0, 'Main IP'),
       (1, 'Second IP');
GO

Insert Into Common.MainStandby
VALUES (0, 'Main'),
       (1, 'Standby'),
       (2, 'Both');
GO

Insert Into Common.ModulationMode
VALUES (0, 'AM'),
       (1, 'ACARS'),
       (2, 'VDL2');
GO

Insert Into Common.OnOff
Values (0, 'OFF'),
       (1, 'ON');
GO

Insert Into Common.Operation
VALUES (0, 'No Go'),
       (1, 'Go');
GO

Insert Into Common.Partition
VALUES (0, 'Booted'),
       (1, 'Ready'),
       (2, 'Update');
GO

Insert Into Common.PowerLevel
VALUES (1, 'Low'),
       (2, 'Normal');
GO

Insert Into Common.PTTConfiguration
VALUES (0, 'Type I'),
       (1, 'Type II'),
       (2, 'RS Standard');
GO

INSERT INTO Common.RadioModule
Values (0, 'FW', 'Firmware'),
       (2, 'SW', 'Software'),
       (3, 'HWMOD', 'Hardware Module'),
       (4, 'SWMOD', 'Software Module'),
       (5, 'DEV', 'Device');
GO

Insert Into Common.RadioType
Values (0, 'RX'),
       (1, 'TX'),
       (2, 'Both');
GO

Insert Into Common.RSSIOutput
VALUES (0, 'RS Standard'),
       (1, 'User defined');
GO

Insert Into Common.RXSensitivity
VALUES (0, 'Low Noise'),
       (1, 'Low Distortion');
GO

INSERT INTO Common.Selectable
VALUES (0, 'Not Configurable'),
       (3, 'Disabled|Warning'),
       (5, 'Disabled|NoGo'),
       (6, 'Warning|NoGo'),
       (7, 'Disabled|Warning|NoGo');
GO

Insert Into Common.SessionType
VALUES (0, 'Monitor'),
       (2, 'Fixed');
GO

Insert Into Common.SetCode
VALUES (0, 'Event List Cleared'),
       (1, 'All Trap OFF'),
       (2, 'Skip To GO'),
       (3, 'TX Pressed'),
       (4, 'TX Released'),
       (5, 'TX + Mod Pressed'),
       (6, 'TX + Mod Released'),
       (7, 'Radio Restarted'),
       (8, 'SQ Circuit OFF'),
       (9, 'SQ Circuit ON');
GO

Insert Into Common.SQLogic
VALUES (0, 'AND'),
       (1, 'OR');
GO

INSERT INTO Common.StationAvailability
VALUES (0, 'Not Available'),
       (1, 'Available');
GO

Insert Into Common.TXOffset
VALUES (0, 'Off'),
       (1, '+7.5'),
       (2, '+5.0'),
       (3, '+2.5'),
       (4, '0.0'),
       (5, '-2.5'),
       (6, '-5.0'),
       (7, '-7.5'),
       (8, '+8.0'),
       (9, '+4.0'),
       (10, '-4.0'),
       (11, '-8.0'),
       (12, '+7.3'),
       (13, '-7.3');
GO

INSERT INTO Common.RecordStatus
VALUES (0, 'Archived'),
       (1, 'Usable');
GO

INSERT INTO Common.SettingRecordType
VALUES (0, 'SingleParameter'),
       (1, 'AllParameters');
GO

INSERT INTO Common.CBITList
    (CBIT_Code, Level, Description, Configuration, Selectable)
VALUES (1, 0, 'RESTART', 0, 0),
       (2, 0, 'TIME CHANGED', 0, 0),
       (3, 0, 'EVENT LIST FULL', 0, 0),
       (101, 1, 'INACTIVE WARNING', 2, 3),
       (102, 2, 'NOGO ERROR', 0, 0),
       (103, 1, 'MAIN FAN WARNING', 4, 6),
       (104, 2, 'MAIN FAN ERROR', 0, 0),
       (107, 1, 'MMI WD RESTART', 0, 0),
       (108, 1, 'OCXO OVEN WARNING', 0, 0),
       (109, 1, 'MODE IMPOSSIBLE', 0, 0),
       (110, 0, 'MMI PART', 0, 0),
       (201, 1, 'PSU FAN WARNING', 4, 6),
       (202, 2, 'PSU FAN ERROR', 0, 0),
       (203, 1, 'PSU TEMP WARNING', 0, 0),
       (204, 2, 'PSU TEMP ERROR', 0, 0),
       (301, 1, 'TX DC BATTERY', 2, 7),
       (302, 1, 'TX AC MAIN', 1, 7),
       (303, 1, 'PA DC 28V VLT LOW', 0, 0),
       (304, 2, 'PA DC 28V OVERVOLT', 0, 0),
       (305, 2, 'PA DC 28V UNDERVOLT', 0, 0),
       (306, 2, 'TX DC 1.2V FAIL', 0, 0),
       (307, 2, 'TX DC 1.8V FAIL', 0, 0),
       (308, 2, 'TX DC 5.7V FAIL', 0, 0),
       (309, 2, 'TX DC 8.7V FAIL', 0, 0),
       (310, 2, 'TX DC 28V FAIL', 0, 0),
       (311, 2, 'TX DC 28V PTT FAIL', 0, 0),
       (312, 2, 'TX DC -48V PTT FAIL', 0, 0),
       (313, 2, 'TX DC -11V FAIL', 0, 0),
       (314, 2, 'TX DC -5.7V FAIL', 0, 0),
       (315, 2, 'TX INT REF UNLOCK', 0, 0),
       (316, 2, 'TX SYNTH UNLOCK', 0, 0),
       (317, 1, 'PA TEMP WARNING', 0, 0),
       (318, 2, 'PA TEMP ERROR', 0, 0),
       (319, 1, 'TX TEMP WARNING', 0, 0),
       (320, 2, 'TX TEMP ERROR', 0, 0),
       (321, 2, 'PA NO OUTPUT PWR', 0, 0),
       (322, 1, 'PA POWER LOW -1DB', 0, 0),
       (323, 1, 'PA POWER LOW -3DB', 4, 6),
       (324, 2, 'PA POWER HIGH 1DB', 0, 0),
       (325, 1, 'PA POWER REDUCED DC', 0, 0),
       (326, 1, 'PA PWR REDUCED VSWR', 0, 0),
       (327, 1, 'PA PWR REDUCED TEMP', 0, 0),
       (328, 1, 'PWR REDUCED PSU TEMP', 0, 0),
       (329, 1, 'TX IQ OVERLOAD', 0, 0),
       (330, 2, 'TX IQ LOOP UNLOCK', 0, 0),
       (331, 1, 'PA VSWR ABOVE 2', 4, 6),
       (332, 1, 'TX WD RESTART', 0, 0),
       (333, 2, 'TX DSP ERROR', 0, 0),
       (334, 2, 'TX NO MMI CONNECT', 0, 0),
       (335, 1, 'TX USB CONNECT', 2, 3),
       (336, 1, 'TX LOCAL MODE', 2, 3),
       (337, 1, 'TX PTT TIMEOUT EXPIR', 0, 0),
       (338, 1, 'TX EXT VSWR HIGH X7', 1, 7),
       (339, 1, 'EXT FILTER TIMEOUT', 0, 0),
       (340, 1, 'EXT FILTER ALARM', 0, 0),
       (341, 1, 'EXT FILTER LOCAL', 0, 0),
       (342, 1, 'USER CONTACT WARNING', 1, 3),
       (343, 1, 'TX SNMPD WD RESTART', 0, 0),
       (344, 1, 'BOOT ERROR', 0, 0),
       (345, 2, 'TX E1 LOS', 1, 5),
       (346, 2, 'TX E1 LOF', 1, 5),
       (347, 1, 'TX E1 RAI', 2, 6),
       (348, 1, 'TX E1 CRC4 ERROR', 2, 6),
       (349, 1, 'EXT PA ALARM', 0, 0),
       (350, 1, 'PWR REDUCED TO LOW', 0, 0),
       (351, 0, 'TX PART', 0, 0),
       (352, 0, 'TX RST REQ RC', 0, 0),
       (353, 1, 'TX NTP SYNC LOST', 0, 0),
       (354, 1, 'TX REC CONNECT FAIL', 0, 0),
       (401, 1, 'RX DC BATTERY', 2, 7),
       (402, 1, 'RX AC MAIN', 1, 7),
       (403, 1, 'RX DC 28V VLT LOW', 0, 0),
       (404, 2, 'RX DC 28V OVERVOLT', 0, 0),
       (405, 2, 'RX INT REF UNLOCK', 0, 0),
       (406, 1, 'RX RF OVERLOAD', 0, 0),
       (407, 1, 'RX IF OVERLOAD', 0, 0),
       (408, 2, 'RX DSP ERROR', 0, 0),
       (409, 1, 'RX WD RESTART', 0, 0),
       (410, 2, 'RX SYNTH UNLOCK', 0, 0),
       (411, 1, 'RX TEMP WARNING', 0, 0),
       (412, 2, 'RX TEMP ERROR', 0, 0),
       (413, 2, 'RX NO MMI CONNECT', 0, 0),
       (414, 1, 'RX USB CONNECT', 2, 3),
       (415, 1, 'RX LOCAL MODE', 2, 3),
       (416, 2, 'RX DC 1.2V FAIL', 0, 0),
       (417, 2, 'RX DC 1.25V FAIL', 0, 0),
       (418, 2, 'RX DC 3.3V FAIL', 0, 0),
       (419, 2, 'RX DC 4.0V FAIL', 0, 0),
       (420, 2, 'RX DC 13V FAIL', 0, 0),
       (421, 2, 'RX DC 5.7V FAIL', 0, 0),
       (422, 2, 'RX DC 8.7V FAIL', 0, 0),
       (423, 2, 'RX DC 28V FAIL', 0, 0),
       (424, 2, 'RX DC -20V FAIL', 0, 0),
       (425, 2, 'RX DC -11V FAIL', 0, 0),
       (426, 2, 'RX DC -5.7V FAIL', 0, 0),
       (427, 1, 'EXT FILTER TIMEOUT', 0, 0),
       (428, 1, 'EXT FILTER ALARM', 0, 0),
       (429, 1, 'EXT FILTER LOCAL', 0, 0),
       (430, 1, 'USER CONTACT WARNING', 1, 3),
       (431, 1, 'RX SNMPD WD RESTART', 0, 0),
       (433, 1, 'CONGESTION TIMEOUT', 0, 0),
       (434, 1, 'BOOT ERROR', 0, 0),
       (435, 2, 'RX E1 LOS', 1, 5),
       (436, 2, 'RX E1 LOF', 1, 5),
       (437, 1, 'RX E1 RAI', 2, 6),
       (438, 1, 'RX E1 CRC4 ERROR', 2, 6),
       (439, 0, 'RX PART', 0, 0),
       (440, 0, 'RX RST REQ RC', 0, 0),
       (445, 1, 'RX NTP SYNC LOST', 0, 0),
       (446, 0, 'STD', 0, 0),
       (447, 1, 'RX REC CONNECT FAIL', 0, 0);

GO
