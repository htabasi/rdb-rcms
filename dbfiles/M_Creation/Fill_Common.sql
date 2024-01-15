Use RCMS;
go

Insert Into Common.Activation
VALUES (0, 'Inactive'),
       (1, 'Active');
go

Insert Into Common.ATRMode
VALUES (0, 'RS Default'),
       (1, 'Latching');
go

Insert Into Common.AudioInterface
VALUES (0, 'Analog Audio'),
       (1, 'E1'),
       (2, 'VoIP');
go

INSERT INTO Common.CBITConfiguration
VALUES (0, 'NotConfigurable'),
       (1, 'Disabled'),
       (2, 'Warning'),
       (4, 'NoGo Error');
go

INSERT INTO Common.CBITResult
VALUES (1, 'Disabled'),
       (2, 'Warning'),
       (4, 'NoGo Error');
go

Insert Into Common.ChannelSpacing
VALUES (1, '8.33 KHz'),
       (2, '12.5 KHz'),
       (3, '25 KHz');
go

INSERT INTO Common.CommandStatus
VALUES (1, 'Registered'),
       (2, 'Received'),
       (3, 'Requested'),
       (4, 'Done'),
       (5, 'Failed'),
       (6, 'Running'),
       (7, 'Stopping'),
       (8, 'Fail-ONAIR');
go

Insert Into Common.Conn
Values (0, 'Disconnect'),
       (1, 'Connect');
go

Insert Into Common.ControlAccess
VALUES (0, 'Normal'),
       (1, 'Remote'),
       (2, 'Local');
go

Insert Into Common.Controller
VALUES (0, 'Remote Control'),
       (3, 'MMI');
go

Insert Into Common.EnableDisable
VALUES (0, 'Disabled'),
       (1, 'Enabled');
go

Insert Into Common.EventLevel
VALUES (0, 'Information'),
       (1, 'Warning'),
       (2, 'Error');
go

Insert Into Common.EVSWRPolarity
VALUES (0, 'Negative'),
       (1, 'Positive');
go

INSERT INTO Common.IPType
VALUES (0, 'Main IP'),
       (1, 'Second IP');
go

Insert Into Common.MainStandby
VALUES (0, 'Main'),
       (1, 'Standby'),
       (2, 'Both');
go

Insert Into Common.ModulationMode
VALUES (0, 'AM'),
       (1, 'ACARS'),
       (2, 'VDL2');
go

INSERT INTO Common.NewCommandDescription
VALUES (0, 'No New Command'),
       (1, 'New Command Registered');
go

Insert Into Common.OnOff
Values (0, 'OFF'),
       (1, 'ON');
go

Insert Into Common.Operation
VALUES (0, 'No Go'),
       (1, 'Go');
go

Insert Into Common.Partition
VALUES (0, 'Booted'),
       (1, 'Ready'),
       (2, 'Update');
go

Insert Into Common.PowerLevel
VALUES (1, 'Low'),
       (2, 'Normal');
go

Insert Into Common.PTTConfiguration
VALUES (0, 'Type I'),
       (1, 'Type II'),
       (2, 'RS Standard');
go

INSERT INTO Common.RadioModule
Values (0, 'FW', 'Firmware'),
       (2, 'SW', 'Software'),
       (3, 'HWMOD', 'Hardware Module'),
       (4, 'SWMOD', 'Software Module'),
       (5, 'DEV', 'Device');
go

Insert Into Common.RadioType
Values (0, 'TX'),
       (1, 'RX'),
       (2, 'Both');
go

Insert Into Common.RSSIOutput
VALUES (0, 'RS Standard'),
       (1, 'User defined');
go

Insert Into Common.RXSensitivity
VALUES (0, 'Low Noise'),
       (1, 'Low Distortion');
go

INSERT INTO Common.Selectable
VALUES (0, 'Not Configurable'),
       (3, 'Disabled|Warning'),
       (5, 'Disabled|NoGo'),
       (6, 'Warning|NoGo'),
       (7, 'Disabled|Warning|NoGo');
go

Insert Into Common.SessionType
VALUES (0, 'Monitor'),
       (2, 'Fixed');
go

Insert Into Common.SetCode
VALUES (0, 'Event List Cleared'),
       (1, 'All Trap OFF'),
       (2, 'Skip To GO'),
       (3, 'TX Pressed'),
       (4, 'TX Released'),
       (5, 'TX + Mod Pressed'),
       (6, 'TX + Mod Released'),
       (7, 'Radio Restarted');
go

Insert Into Common.SQLogic
VALUES (0, 'AND'),
       (1, 'OR');
go

INSERT INTO Common.StationAvailability
VALUES (1, 'Available'),
       (2, 'Not Available');
go

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
go

INSERT INTO Common.RecordStatus
VALUES (0, 'Archived'),
       (1, 'Usable');
go

INSERT INTO Common.SettingRecordType
VALUES (0, 'SingleParameter'),
       (1, 'AllParameters');
go

Insert Into Command.RadioInitial
    (rtype, CKey, Request, Value, Active)
VALUES (0, 'SCPG', 'S', 60, 1),
       (0, 'AIAD', 'T', 1, 1),
       (0, 'AILA', 'T', 1, 1),
       (0, 'AISL', 'T', 1, 1),
       (0, 'ERGN', 'T', 1, 1),
       (0, 'EVEE', 'T', 1, 1),
       (0, 'FFMD', 'T', 1, 1),
       (0, 'FFSP', 'T', 1, 1),
       (0, 'FFTR', 'T', 1, 1),
       (0, 'GRCS', 'T', 1, 1),
       (0, 'GRDS', 'T', 1, 1),
       (0, 'GRHN', 'T', 1, 1),
       (0, 'GRME', 'T', 1, 1),
       (0, 'GRNA', 'T', 1, 1),
       (0, 'GRTI', 'T', 1, 1),
       (0, 'GRUI', 'T', 1, 1),
       (0, 'GRUO', 'T', 1, 1),
       (0, 'MSAC', 'T', 1, 1),
       (0, 'RCLV', 'T', 1, 1),
       (0, 'RCMG', 'T', 1, 1),
       (0, 'RCMO', 'T', 1, 1),
       (0, 'RCMV', 'T', 1, 1),
       (0, 'RCPP', 'T', 1, 1),
       (0, 'RCTC', 'T', 1, 1),
       (0, 'RCTO', 'T', 1, 1),
       (0, 'RCTP', 'T', 1, 1),
       (0, 'RCTV', 'T', 1, 1),
       (0, 'RCTW', 'T', 1, 1),
       (0, 'RCVV', 'T', 1, 1),
       (0, 'SCSL', 'T', 1, 1),
       (0, 'SCSS', 'T', 1, 1),

       (1, 'SCPG', 'S', 60, 1),
       (1, 'AIAD', 'T', 1, 1),
       (1, 'AILA', 'T', 1, 1),
       (1, 'AISL', 'T', 1, 1),
       (1, 'ERGN', 'T', 1, 1),
       (1, 'EVEE', 'T', 1, 1),
       (1, 'FFMD', 'T', 1, 1),
       (1, 'FFRS', 'T', 1, 1),
       (1, 'FFSN', 'T', 1, 1),
       (1, 'FFSP', 'T', 1, 1),
       (1, 'FFSQ', 'T', 1, 1),
       (1, 'FFSR', 'T', 1, 1),
       (1, 'FFTR', 'T', 1, 1),
       (1, 'GRCS', 'T', 1, 1),
       (1, 'GRDS', 'T', 1, 1),
       (1, 'GRHN', 'T', 1, 1),
       (1, 'GRME', 'T', 1, 1),
       (1, 'GRNA', 'T', 1, 1),
       (1, 'GRTI', 'T', 1, 1),
       (1, 'GRUI', 'T', 1, 1),
       (1, 'GRUO', 'T', 1, 1),
       (1, 'MSAC', 'T', 1, 1),
       (1, 'RCLR', 'T', 1, 1),
       (1, 'RCMV', 'T', 1, 1),
       (1, 'RCPP', 'T', 1, 1),
       (1, 'RCRI', 'T', 1, 1),
       (1, 'RCTP', 'T', 1, 1),
       (1, 'RIRC', 'T', 1, 1),
       (1, 'SCSL', 'T', 1, 1),
       (1, 'SCSS', 'T', 1, 1);
go

Insert Into Common.Radio
    (Radio_Name, Station_Code, Frequency_No, Type, IP)
VALUES ('BUZ_RX_V1M', 'BUZ', 1, 1, '192.168.6.11'),
       ('BUZ_RX_V1S', 'BUZ', 1, 1, '192.168.6.21'),
       ('BUZ_TX_V1M', 'BUZ', 1, 0, '192.168.6.31'),
       ('BUZ_TX_V1S', 'BUZ', 1, 0, '192.168.6.41'),
       ('BUZ_RX_V2M', 'BUZ', 2, 1, '192.168.6.12'),
       ('BUZ_RX_V2S', 'BUZ', 2, 1, '192.168.6.22'),
       ('BUZ_TX_V2M', 'BUZ', 2, 0, '192.168.6.32'),
       ('BUZ_TX_V2S', 'BUZ', 2, 0, '192.168.6.42'),
       ('BUZ_RX_V3M', 'BUZ', 3, 1, '192.168.6.13'),
       ('BUZ_RX_V3S', 'BUZ', 3, 1, '192.168.6.23'),
       ('BUZ_TX_V3M', 'BUZ', 3, 0, '192.168.6.33'),
       ('BUZ_TX_V3S', 'BUZ', 3, 0, '192.168.6.43'),

       ('KMS_RX_V1M', 'KMS', 1, 1, '192.168.6.14'),
       ('KMS_RX_V1S', 'KMS', 1, 1, '192.168.6.24'),
       ('KMS_TX_V1M', 'KMS', 1, 0, '192.168.6.34'),
       ('KMS_TX_V1S', 'KMS', 1, 0, '192.168.6.44'),
       ('KMS_RX_V2M', 'KMS', 2, 1, '192.168.6.15'),
       ('KMS_RX_V2S', 'KMS', 2, 1, '192.168.6.25'),
       ('KMS_TX_V2M', 'KMS', 2, 0, '192.168.6.35'),
       ('KMS_TX_V2S', 'KMS', 2, 0, '192.168.6.45'),
       ('KMS_RX_V3M', 'KMS', 3, 1, '192.168.6.16'),
       ('KMS_RX_V3S', 'KMS', 3, 1, '192.168.6.26'),
       ('KMS_TX_V3M', 'KMS', 3, 0, '192.168.6.36'),
       ('KMS_TX_V3S', 'KMS', 3, 0, '192.168.6.46'),

       ('BJD_RX_V1M', 'BJD', 1, 1, '192.168.6.17'),
       ('BJD_RX_V1S', 'BJD', 1, 1, '192.168.6.27'),
       ('BJD_TX_V1M', 'BJD', 1, 0, '192.168.6.37'),
       ('BJD_TX_V1S', 'BJD', 1, 0, '192.168.6.47'),
       ('BJD_RX_V2M', 'BJD', 2, 1, '192.168.6.18'),
       ('BJD_RX_V2S', 'BJD', 2, 1, '192.168.6.28'),
       ('BJD_TX_V2M', 'BJD', 2, 0, '192.168.6.38'),
       ('BJD_TX_V2S', 'BJD', 2, 0, '192.168.6.48'),
       ('BJD_RX_V3M', 'BJD', 3, 1, '192.168.6.19'),
       ('BJD_RX_V3S', 'BJD', 3, 1, '192.168.6.29'),
       ('BJD_TX_V3M', 'BJD', 3, 0, '192.168.6.39'),
       ('BJD_TX_V3S', 'BJD', 3, 0, '192.168.6.49'),

       ('ISN_RX_V1M', 'IFN', 1, 1, '192.168.6.51'),
       ('ISN_RX_V1S', 'IFN', 1, 1, '192.168.6.61'),
       ('ISN_TX_V1M', 'IFN', 1, 0, '192.168.6.71'),
       ('ISN_TX_V1S', 'IFN', 1, 0, '192.168.6.81'),
       ('ISN_RX_V2M', 'IFN', 2, 1, '192.168.6.52'),
       ('ISN_RX_V2S', 'IFN', 2, 1, '192.168.6.62'),
       ('ISN_TX_V2M', 'IFN', 2, 0, '192.168.6.72'),
       ('ISN_TX_V2S', 'IFN', 2, 0, '192.168.6.82'),
       ('ISN_RX_V3M', 'IFN', 3, 1, '192.168.6.53'),
       ('ISN_RX_V3S', 'IFN', 3, 1, '192.168.6.63'),
       ('ISN_TX_V3M', 'IFN', 3, 0, '192.168.6.73'),
       ('ISN_TX_V3S', 'IFN', 3, 0, '192.168.6.83'),

       ('ANK_RX_V1M', 'ANK', 1, 1, '192.168.6.54'),
       ('ANK_RX_V1S', 'ANK', 1, 1, '192.168.6.64'),
       ('ANK_TX_V1M', 'ANK', 1, 0, '192.168.6.74'),
       ('ANK_TX_V1S', 'ANK', 1, 0, '192.168.6.84'),
       ('ANK_RX_V2M', 'ANK', 2, 1, '192.168.6.55'),
       ('ANK_RX_V2S', 'ANK', 2, 1, '192.168.6.65'),
       ('ANK_TX_V2M', 'ANK', 2, 0, '192.168.6.75'),
       ('ANK_TX_V2S', 'ANK', 2, 0, '192.168.6.85'),
       ('ANK_RX_V3M', 'ANK', 3, 1, '192.168.6.56'),
       ('ANK_RX_V3S', 'ANK', 3, 1, '192.168.6.66'),
       ('ANK_TX_V3M', 'ANK', 3, 0, '192.168.6.76'),
       ('ANK_TX_V3S', 'ANK', 3, 0, '192.168.6.86');
go

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

go

INSERT INTO Command.KeyInformation
(CKey, TX_Name, RX_Name, Parameter_Type, Parameter_Unit, INT_Parameter_Min, INT_Parameter_Max,
 INT_Parameter_Step, FLOAT_Parameter_Min, FLOAT_Parameter_Max, FLOAT_Parameter_Step, STRING_Max_Length,
 Convertor_Table, TX_Support, RX_Support, GET_Support, SET_Support, TRAP_Support, GET_Need_Value,
 Update_Need_Restart, Work_As_Expected, Fully_Identified)
VALUES ('ACBC', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACBF', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('ACBS', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACDF', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('ACMC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 0, 0, 0, 1, 0),
       ('ACPL', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACRC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('ACST', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 0, 0, 0, 1, 0),
       ('ACTE', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACTF', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACTI', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('ACUF', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AIAD', 'Audio Delay', 'Audio Delay', 'INT', 'ms', 0, '250', 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0,
        0, 1, 1),
       ('AIAI', 'Select Audio Interface', 'Select Audio Interface', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, 'Common.AudioInterface', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('AICA', 'Tx Audio ALC', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.EnableDisable', 1,
        0, 1, 1, 0, 0, 1, 1, 1),
       ('AICE', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AICV', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AIEL', 'Line Interface in local mode', 'Line Interface in local mode', 'INT', NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, 'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('AIGA', NULL, 'Rx Audio AGC', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.EnableDisable', 0,
        1, 1, 1, 0, 0, 1, 1, 1),
       ('AIGE', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AIGV', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AIIW', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AILA', 'TX Audio Level', 'RX Audio Level', 'INT', 'dBm', '-30', '10', 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1,
        1, 1, 0, 0, 1, 1),
       ('AILE', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AILV', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('AIML', 'Mute Loudspeaker', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.EnableDisable',
        1, 0, 1, 1, 0, 0, 1, 1, 1),
       ('AISE', 'PTT Signaling', 'SQ-RSSI Signaling', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('AISF', 'PTT Signaling Frequency', 'SQ Signaling Frequency', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('AISL', 'PTT Signaling Threshold', 'SQ-RSSI Signaling Level', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('AITP', 'Tx Pre-Emphasis', NULL, '*', 'dBm', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0,
        0, 1, 1),
       ('AITS', NULL, 'True Side-tone Transceiver', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 0, 1, 1, 1, 0, 0, 1, 1, 1),
       ('AIWL', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 1, 1, 0, 0, 1, 0),
       ('BMEB', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('ERBE', 'Boot Error List', 'Boot Error List', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1,
        1, 0, 0, 0, 0, 1, 1),
       ('ERGN', 'GO-NOGO Status', 'GO-NOGO Status', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.Operation', 1, 1, 1, 0, 1, 0, 0, 1, 1),
       ('EVAC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('EVCL', 'Clear Event List', 'Clear Event List', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1,
        0, 1, 0, 0, 0, 1, 1),
       ('EVEE', 'Read Event Entry', 'Read Event Entry', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1,
        0, 0, 1, 0, 0, 1, 1),
       ('EVEL', 'Event Log List', 'Event Log List', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1,
        0, 0, 0, 0, 1, 1),
       ('EVSR', 'Read Sequence Number Page', 'Read Sequence Number Page', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 1),
       ('FFBI', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('FFBL', 'Frequency Blocking Ranges', 'Frequency Blocking Ranges', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFCO', NULL, 'Carrier Override', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.EnableDisable',
        0, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFEA', 'ACARS Data Mode', 'ACARS Data Mode', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFEC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('FFEW', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('FFFC', 'Filter Configuration', 'Filter Configuration', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, 1, 1, 1, 0, 0, 0, 0, 1, 1),
       ('FFFE', 'Motor Tuned Telsa Filter', 'Motor Tuned Telsa Filter', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, 'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFLM', 'Local Mode', 'Local Mode', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFLT', 'Local Mode Timeout', 'Local Mode Timeout', 'INT', 'Second', '60', '900', 1, NULL, NULL, NULL, NULL,
        NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFMD', 'Modulation Mode', 'Modulation Mode', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.ModulationMode', 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('FFRS', NULL, 'RSSI', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 1, 0, 0, 1, 1),
       ('FFSC', 'Single Channel', 'Single Channel', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFSL', NULL, 'SNR-RSSI SQ Logic Operation', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.SQLogic', 0, 1, 1, 1, 0, 0, 1, 1, 1),
       ('FFSN', NULL, 'SNR Squelch Threshold', 'INT', 'dB', '6', '20', 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1,
        0, 0, 1, 1),
       ('FFSP', 'Channel Spacing', 'Channel Spacing', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.ChannelSpacing', 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('FFSQ', NULL, 'SQ Circuit', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.OnOff', 0, 1, 1, 1,
        1, 0, 0, 1, 1),
       ('FFSR', NULL, 'RSSI Squelch Threshold', 'INT', 'uV', 1, '50', 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 0,
        0, 1, 1),
       ('FFTO', 'Carrier Offset', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.TXOffset', 1, 0,
        1, 1, 0, 0, 0, 1, 1),
       ('FFTR', 'Frequency', 'Frequency', 'INT', 'Hz', '118000000', '136975000', '25000', NULL, NULL, NULL, NULL, NULL,
        1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('GRAC', 'ACL (Access Control List)', 'ACL (Access Control List)', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRAD', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('GRAP', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('GRAS', 'ATR Switch Mode', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.ATRMode', 1, 0,
        1, 1, 0, 0, 1, 1, 1),
       ('GRAT', 'All Trap OFF', 'All Trap OFF', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1,
        0, 0, 0, 1, 1),
       ('GRBS', NULL, 'Best Signal Selection', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 0, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRCB', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 0, 0, 0, 1, 0),
       ('GRCO', '5 Carrier Offset', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.EnableDisable',
        1, 0, 1, 1, 0, 0, 1, 1, 1),
       ('GRCP', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('GRCS', 'CBIT Status', 'CBIT Status', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0,
        1, 0, 0, 1, 1),
       ('GRCU', NULL, NULL, 'FLOAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 0, 0, 0, 1, 0),
       ('GRDH', 'DHCP Enabled', 'DHCP Enabled', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRDN', 'Primary and Secondary DNS', 'Primary and Secondary DNS', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRDS', 'Device Status', 'Device Status', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0,
        1, 0, 0, 1, 1),
       ('GREX', 'External Amplifier', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 0, 1, 1, 0, 0, 1, 1, 1),
       ('GRHN', 'Hostname', 'Hostname', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '24', NULL, 1, 1, 1, 1, 1, 0, 0,
        1, 1),
       ('GRIE', 'Second IP Address Enabled', 'Second IP Address Enabled', 'INT', NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRII', 'Second IP Address', 'Second IP Address', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1,
        1, 1, 1, 1, 0, 1, 1, 1),
       ('GRIL', 'Inventory List', 'Inventory List', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1,
        0, 0, 1, 0, 1, 1),
       ('GRIN', 'Installation Info', 'Installation Info', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '20', NULL, 1,
        1, 1, 1, 0, 0, 1, 1, 1),
       ('GRIP', 'IP Address', 'IP Address', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0,
        1, 1, 1),
       ('GRIS', NULL, 'Rx Input Sensitivity', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.RXSensitivity', 0, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRIV', 'IPv6 Enabled', 'IPv6 Enabled', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRKD', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('GRKU', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('GRLO', 'Location Info', 'Location Info', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '20', NULL, 1, 1, 1, 1,
        0, 0, 1, 1, 1),
       ('GRLR', NULL, 'Measure RX Audio Level', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0,
        0, 0, 0, 1, 1),
       ('GRLT', 'Measure TX Audio Level', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0,
        0, 0, 0, 1, 1),
       ('GRME', 'Last Maintenance TimeStamp', 'Last Maintenance TimeStamp', 'INT', NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 'Timestamp', 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('GRNA', 'NTP Sync Active', 'NTP Sync Active', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.Activation', 1, 1, 1, 0, 1, 0, 0, 1, 1),
       ('GRNC', 'CBIT Items with Configurability', 'CBIT Items with Configurability', '*', NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRND', 'Inventory Item', 'Inventory Item', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1,
        0, 0, 1, 0, 1, 1),
       ('GRNS', 'NTP Server', 'NTP Server', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0,
        1, 1, 1),
       ('GRRI', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('GRRO', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('GRSE', 'SNMP Enable', 'SNMP Enable', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EnableDisable', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRSN', 'SNMP Community String', 'SNMP Community String', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('GRSV', 'Software Versions', 'Software Versions', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1,
        1, 1, 0, 0, 0, 0, 1, 1),
       ('GRTI', 'RTC Time and Date', 'RTC Time and Date', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1,
        1, 1, 0, 1, 0, 0, 1, 1),
       ('GRUI', 'User Input', 'User Input', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1,
        0, 0, 1, 1),
       ('GRUO', 'User Output', 'User Output', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1,
        0, 0, 0, 0),
       ('GRVE', 'GB2PP Version', 'GB2PP Version', 'FLOAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1,
        1, 0, 0, 0, 0, 1, 1),
       ('LBPT', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('LBRT', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('LBSR', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('MSAC', 'Activation Status', 'Activation Status', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.Activation', 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('MSGO', 'Skip to GO', 'Skip to GO', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0,
        0, 1, 1),
       ('MSTY', 'Main-Standby Type', 'Main-Standby Type', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.MainStandby', 1, 1, 1, 1, 0, 0, 1, 1, 1),
       ('NMBQ', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('NMSL', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('OPOL', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('PTDC', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('PTDE', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('PTDT', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('PTUC', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('PTUE', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('PTUT', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('RCDP', 'PTT Timeout', NULL, '*', 'Second', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1,
        1, 1),
       ('RCIT', 'TX Inhibition', NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 0,
        1, 1),
       ('RCLP', 'Tx Low Power Level', NULL, '*', 'Watt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0,
        0, 0, 1, 1),
       ('RCLR', NULL, 'Last RSSI Value', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 1, 0,
        0, 1, 1),
       ('RCLV', 'Last VSWR Value', NULL, 'FLOAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1,
        0, 0, 1, 1),
       ('RCMG', 'TX Modulation Depth', NULL, 'INT', '%', '30', '90', 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 1, 0,
        0, 1, 1),
       ('RCMO', 'Measuring Modulation Depth', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0,
        1, 0, 1, 0, 0, 1, 1),
       ('RCMV', 'DC Voltages', 'DC Voltages', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1,
        0, 0, 1, 1),
       ('RCNP', 'TX Normal Power Level', NULL, '*', 'Watt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1,
        0, 0, 0, 1, 1),
       ('RCOC', 'Operating Hours Counter', 'Operating Hours Counter', 'INT', 'Hour', NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 1),
       ('RCPF', 'Press Command Without Tone', 'Press Command Without Tone', '*', NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 1, 1),
       ('RCPP', 'Preset Page Number', 'Preset Page Number', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('RCPT', 'Press Command With Tone', 'Press Command With Tone', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 1, 1),
       ('RCPV', 'Preset Page', 'Preset Page', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0,
        0, 1, 1, 1),
       ('RCRI', NULL, 'SQ Indicator', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, 1, 0, 0,
        1, 1),
       ('RCRR', 'Restart Radio', 'Restart Radio', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1,
        0, 0, 0, 1, 1),
       ('RCTC', 'PTT Indicator', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, 0, 0,
        1, 1),
       ('RCTO', 'Measure TX Power', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, 0,
        0, 1, 1),
       ('RCTP', 'Temperatures', 'Temperatures', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0,
        1, 0, 0, 1, 1),
       ('RCTS', 'RF Power Level', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.PowerLevel', 1,
        0, 1, 1, 0, 0, 0, 1, 1),
       ('RCTT', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 1, 0),
       ('RCTV', 'VSWR Value', NULL, 'FLOAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, 0, 0,
        1, 1),
       ('RCTW', 'VSWR LED', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, 0, 0, 1,
        1),
       ('RCVV', 'External VSWR Voltage', NULL, 'FLOAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1,
        0, 1, 0, 0, 1, 1),
       ('RIPC', 'PTT Input Configuration', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.PTTConfiguration', 1, 0, 1, 1, 0, 0, 1, 1, 1),
       ('RIRC', NULL, 'RSSI Output Curve', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 0,
        0, 1, 1),
       ('RIRO', NULL, 'RSSI Output Type', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Common.RSSIOutput', 0,
        1, 1, 1, 0, 0, 1, 1, 1),
       ('RIVL', 'EXT VSWR limit', NULL, 'FLOAT', 'Volt', NULL, NULL, NULL, '0.0', '5.0', '0.1', NULL, NULL, 1, 0, 1, 1,
        0, 0, 1, 1, 1),
       ('RIVP', 'EXT VSWR Polarity', NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.EVSWRPolarity', 1, 0, 1, 1, 0, 0, 1, 1, 1),
       ('RUFL', 'FTP Login', 'FTP Login', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0,
        1, 1, 1),
       ('RUFP', 'FTP Password', 'FTP Password', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1,
        0, 0, 1, 1, 1),
       ('RUSI', NULL, NULL, 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 0, 1, 0),
       ('RUUS', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 0, 0, 0, 1, 0),
       ('SCPG', 'Ping Timeout', 'Ping Timeout', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1,
        0, 0, 0, 1, 1),
       ('SCSL', 'Session List', 'Session List', '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 0,
        1, 0, 0, 1, 1),
       ('SCSS', 'Session Type', 'Session Type', 'INT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        'Common.SessionType', 1, 1, 1, 1, 1, 0, 0, 1, 1),
       ('STBC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('STCT', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('STEC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('STEN', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('STEU', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('STSF', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOAC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOAN', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOAP', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOCD', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VODS', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOJB', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOLS', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOMS', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VORP', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOSC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VOSM', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VREN', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0),
       ('VRRC', NULL, NULL, '*', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 0, 0, 0, 1, 0);

go

INSERT INTO Station.StationList
    (Code, Availability)
VALUES ('ANK', 1),
       ('AWZ', 2),
       ('BJD', 1),
       ('BND', 2),
       ('BRG', 2),
       ('BUZ', 1),
       ('CBH', 2),
       ('IFN', 1),
       ('KIS', 2),
       ('KMS', 1),
       ('MSD', 2),
       ('SYZ', 2),
       ('TBZ', 2),
       ('YZD', 2),
       ('ZDN', 2),
       ('WSP', 1);

INSERT INTO Application.Names
    (id, App, JobInformation)
VALUES (1, 'Core', 'Main Class that full control other threads.'),
       (2, 'Reception', 'The task of Reading from the Socket and preparation processes of the corresponding' +
                             ' parameter and value is the responsibility of this section'),
       (3, 'Transmission', 'The task of writing on the Socket, the processes of sending a command (reading' +
                                ' from the database and sending to the radio)'),
       (4, 'Generator', 'All processes related to updating database Data, Events & Configuration, by generating' +
                             ' relevant queries are done in this section.'),
       (5, 'Log', 'The processes related to log the activity of other parts are carried out by the Log unit.'),
       (6, 'Interface', 'The UI provide an interface to control and monitor by user.'),
       (7, 'Connector', 'Prepared queries are delivered to this part and applied in the database.'),
       (8, 'Analyzer', 'A thread that collect and analyze RX & TX data and save them into database.'),
       (9, 'Manager', 'Core Connector class that control connection, reception and transmission objects.'),
       (10, 'Commander', 'Sending Commands to Radio');
go

INSERT INTO Application.Timing
    (id, App, Timing)
VALUES (1, 1, 0.5),
       (2, 2, 0.5),
       (3, 3, 0.5),
       (4, 4, 3),
       (5, 5, 3),
       (6, 6, 3),
       (7, 7, 3),
       (8, 8, 0.5),
       (9, 9, 1.0),
       (10, 10, 5);
go

INSERT INTO Application.Configuration
(Date, Status, ConnectionTryInterval, MaxDelaySettingFetch, PeriodicSettingCheck, PeriodicAgeUpdate)
VALUES (GETDATE(), 1, 60, 60, 1440, 5);
go

INSERT INTO Application.LogLevel
VALUES (0, 'NOTSET'),
       (10, 'DEBUG'),
       (20, 'INFO'),
       (30, 'WARNING'),
       (40, 'ERROR'),
       (50, 'CRITICAL');
go

INSERT INTO Application.LogFormat
(separator, radio, radio_len, asctime, asctime_len, name, name_len,
 pathname, pathname_len, filename, filename_len, module, module_len,
 funcName, funcName_len, [lineno], lineno_len, processName, processName_len,
 process, process_len, threadName, threadName_len, thread, thread_len,
 levelname, levelname_len, levelno, levelno_len, message, message_len)
VALUES ('|', 3, 12, 1, 24, 4, 14,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        2, 10, 0, 0, 5, 0)

INSERT INTO Application.LogConfig
    (App, FileLevel, StreamLevel, FileFormat, StreamFormat)
VALUES (1, 20, 30, 1, 1),
       (2, 20, 30, 1, 1),
       (3, 20, 30, 1, 1),
       (4, 20, 30, 1, 1),
       (6, 20, 30, 1, 1),
       (7, 20, 30, 1, 1),
       (8, 20, 30, 1, 1),
       (9, 20, 30, 1, 1),
       (10, 20, 30, 1, 1);
