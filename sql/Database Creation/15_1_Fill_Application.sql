INSERT INTO Application.Queries
    (code, query)
VALUES ('DHRadioStatus', 'DELETE FROM HealthMonitor.RadioStatus WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IACounter',
        'DECLARE @RN CHAR(10); SET @RN=''{}''; INSERT INTO Analyze.Counter (Radio_Name, ResetDate, RecordType) VALUES (@RN, GETUTCDATE(), 0), (@RN, GETUTCDATE(), 1);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IAModuleStatus',
        'Insert Into Application.ModuleStatus (Name, StartTime, PID, UpdateTime) VALUES (''{}'', ''{}'', {}, ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IARadioStatus', 'Insert Into Application.RadioStatus (Radio_Name, FirstConnection) VALUES (''{}'', ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IATimer',
        'DECLARE @RN CHAR(10); SET @RN=''{}''; INSERT INTO Analyze.Timer (Radio_Name, ResetDate, RecordType) VALUES (@RN, GETUTCDATE(), 0), (@RN, GETUTCDATE(), 1);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IATransmission',
        'INSERT INTO Analyze.Transmission (Radio_Name, Date, [Count], [Length], {}) VALUES (''{}'', ''{}'', {}, {}, {})');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ICCBITList',
        'INSERT INTO Common.CBITList (CBIT_Code, Level, Description, Configuration, Selectable) VALUES ({}, {}, ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEECBIT',
        'INSERT INTO Event.ECBIT (Date, Radio_Name, Code, Name, Level) VALUES (''{}'', ''{}'', {}, ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEEConnection', 'INSERT INTO Event.EConnection (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEENetwork', 'INSERT INTO Event.ENetwork (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEEOperation', 'INSERT INTO Event.EOperation (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEEStatus', 'INSERT INTO Event.EStatus (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEEAdjustment', 'INSERT INTO Event.EAdjustment (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IEEventList',
        'INSERT INTO Event.EventList (Date, Radio_Name, Event_No, Module, EventDate, Code, Event_Text, Event_Level) VALUES (''{}'', ''{}'', {}, {}, ''{}'', {}, ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IERXOperation', 'INSERT INTO Event.RXOperation (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IESession',
        'INSERT INTO Event.Session (Date, Radio_Name, IP, Client, Type, SessionNumber) VALUES (''{}'', ''{}'', ''{}'', {}, {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IESetCommands',
        'INSERT INTO Event.SetCommands (Date, Radio_Name, CKey, UserID, Action, Comment) VALUES (''{}'', ''{}'', ''{}'', {}, {}, ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IESpecialSetting',
        'INSERT INTO Event.SpecialSetting (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IETXOperation', 'INSERT INTO Event.TXOperation (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IOEEConnection', 'INSERT INTO Event.EConnection (Date, Radio_Name, Connection) VALUES (''{}'', ''{}'', 0);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISAccess',
        'INSERT INTO Setting.Access (Date, Radio_Name, ACL_Index, Allowed_IP) VALUES (''{}'', ''{}'', {}, ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISConfiguration',
        'INSERT INTO Setting.Configuration (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISIP',
        'INSERT INTO Setting.IP (Date, Radio_Name, IP_Type, IP, Subnet, Gateway) VALUES (''{}'', ''{}'', {}, ''{}'', ''{}'', ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISInstallation',
        'INSERT INTO Setting.Installation (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISInventory',
        'INSERT INTO Setting.Inventory (Date, Radio_Name, R_Index, Type, Component_Name, Ident_Number, Variant, Production_Index, Serial_Number, Production_Date) VALUES (''{}'', ''{}'', {}, {}, ''{}'', ''{}'', {}, ''{}'', ''{}'', ''{}'');');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISNetwork', 'INSERT INTO Setting.Network (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISRXConfiguration',
        'INSERT INTO Setting.RXConfiguration (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISSCBIT',
        'INSERT INTO Setting.SCBIT (Date, Radio_Name, CBIT_Code, Configuration) VALUES (''{}'', ''{}'',{}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISSNMP', 'INSERT INTO Setting.SNMP (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISSoftware',
        'INSERT INTO Setting.Software (Date, Radio_Name, Partition, Part_Number, Version, Status) VALUES (''{}'', ''{}'', {}), (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISStatus', 'INSERT INTO Setting.Status (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('ISTXConfiguration',
        'INSERT INTO Setting.TXConfiguration (Date, Radio_Name, Record, {}) VALUES (''{}'', ''{}'', {}, {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IVReception', 'INSERT INTO Variation.Reception (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IVTemperature',
        'INSERT INTO Variation.Temperature (Date, Radio_Name, RM_Temp, PS_Temp, PA_Temp) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IVTransmission', 'INSERT INTO Variation.Transmission (Date, Radio_Name, {}) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('IVVoltage',
        'INSERT INTO Variation.Voltage (Date, Radio_Name, Battery_Volt, DC_Section) VALUES (''{}'', ''{}'', {});');

INSERT INTO Application.Queries
    (code, query)
VALUES ('MHFrequencyStatus',
        'MERGE INTO HealthMonitor.FrequencyStatus AS target USING (SELECT ''{{}}'' AS PID, ''{}'' AS Station, ''{}'' AS FNo, ''{}'' AS Sector, ''{{}}'' AS severity, ''{{}}'' AS message) AS Source ON (target.ParameterID = source.PID AND target.Station = source.Station AND target.Frequency_No = Source.FNo) WHEN MATCHED THEN UPDATE SET severity=Source.severity, message=Source.message, Sector=Source.Sector WHEN NOT MATCHED THEN INSERT (ParameterID, Station, Frequency_No, Sector, severity, message) VALUES (Source.PID, Source.Station, Source.FNo, Source.Sector, Source.severity, Source.message);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('MHRadioStatus',
        'MERGE INTO HealthMonitor.RadioStatus AS target USING (SELECT ''{}'' AS Radio_Name, ''{{}}'' AS ParameterID, ''{{}}'' AS severity, ''{{}}'' AS message) AS source ON (target.Radio_Name = source.Radio_Name AND target.ParameterID = source.ParameterID) WHEN MATCHED THEN UPDATE SET severity = source.severity, message = source.message WHEN NOT MATCHED THEN INSERT (Radio_Name, ParameterID, severity, message) VALUES (source.Radio_Name, source.ParameterID, source.severity, source.message);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('MOHRadioStatus',
        'DECLARE @RN CHAR(10) = ''{}''; DECLARE @PID INT = (Select id FROM HealthMonitor.Parameters Where ParameterCode=''Connection''); DECLARE @SEV TINYINT DECLARE @MSG VARCHAR(100) Select @SEV=severity, @MSG=M.message From HealthMonitor.FixedValue F JOIN HealthMonitor.Messages M on M.id = F.message WHERE ParameterID=@PID; MERGE INTO HealthMonitor.RadioStatus AS target USING (SELECT @RN AS Radio_Name, @PID AS ParameterID, @SEV AS severity, @MSG AS message) AS source ON (target.Radio_Name = source.Radio_Name AND target.ParameterID = source.ParameterID) WHEN MATCHED THEN UPDATE SET severity = source.severity, message = source.message WHEN NOT MATCHED THEN INSERT (Radio_Name, ParameterID, severity, message) VALUES (source.Radio_Name, source.ParameterID, source.severity, source.message);');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SAConfiguration', 'Select TOP 1 * From Application.Configuration WHERE Status=1 ORDER BY Date DESC;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SACounter',
        'SELECT [RecordType] ,[CntConnect] ,[CntDisconnect] ,[CntIndicatorOn] ,[CntCBITWarning] ,[CntCBITError] ,[CntSentPacket] ,[CntKeepConnectionPacket] ,[CntReceivedPacket] ,[CntReceivedMessage] ,[CntReceivedCommandError] ,[CntReceivedAccessError] ,[CntReceivedTrapAnswer] ,[CntReceivedGetAnswer] ,[CntReceivedTrapAcknowledge] ,[CntReceivedSetAcknowledge] ,[CntQueryGenerated] ,[CntQueryExecuted] ,[CntCommandExecuted] ,[CntCommandRejected] ,[CntUpdateSettings] ,[CntUpdateSpecial] ,[CntUpdateTimer] ,[CntErrorPacketReceive] ,[CntErrorPacketEvaluation] ,[CntErrorPacketSending] ,[CntErrorConnection] ,[CntErrorQueryGeneration] ,[CntErrorQueryExecution] ,[CnrErrorCommandExecution] ,[CntErrorUpdateSettings] ,[CntErrorUpdateSpecial] ,[CntErrorUpdateTimer] FROM Analyze.Counter WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SALogConfig',
        'SELECT AN.App, ALC.FileLevel, ALC.FileFormat, ALC.StreamLevel, ALC.StreamFormat FROM Application.LogConfig ALC JOIN Application.Names AN on AN.id = ALC.App WHERE ALC.RunMode={};');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SALogFormat', 'SELECT * FROM Application.LogFormat');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SAModuleStatus', 'Select id FROM Application.ModuleStatus WHERE Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SARRadio', 'Select Name FROM Radio.Radio ORDER BY Name;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SARadioStatus', 'Select * From Application.RadioStatus Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SAResetCommand', 'SELECT ResetCounter, ResetTimer From Analyze.ResetCommand WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SAStatusUpdater',
        'SELECT Part as ''App'', FileLevel, FileFormat, StreamLevel, StreamFormat FROM Application.StatusUpdater');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SATimer',
        'SELECT [RecordType] ,[IndicatorONSec] ,[IndicatorOFFSec] ,[ConnectTimeSec] ,[DisconnectTimeSec] ,[OperatingHour] FROM Analyze.Timer WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SCCBITList', 'SELECT CBIT_Code FROM Common.CBITList ORDER BY CBIT_Code;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SCHistory',
        'SELECT CH.id, CH.user_id, KI.id as CKey_id, CH.CKey, CH.Request, CH.Value FROM Command.History CH JOIN Command.KeyInformation KI on CH.CKey = KI.CKey WHERE CH.Status=1 AND CH.Radio=''{}'' AND CH.RegisterTime >= DATEADD(minute , -5, GETUTCDATE()) ORDER BY CH.id;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SCRadioInitial', 'Select CKey, Request, Value From Command.RadioInitial WHERE RadioType = {} AND Active=1;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SDUser',
        'Select dau.username, dag.name, cki.CKey, ap.codename From Django.account_user dau JOIN Django.account_user_groups aug on dau.id = aug.user_id JOIN Django.auth_group dag on dag.id = aug.group_id JOIN Django.guardian_groupobjectpermission gg on dag.id = gg.group_id JOIN Django.account_sendkeycommand ask ON gg.object_pk = ask.id JOIN Command.KeyInformation cki ON ask.Key_id = cki.id JOIN Django.auth_permission ap ON gg.permission_id = ap.id WHERE dau.id = {} AND cki.id = {} AND ap.codename = ''{}''');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SESpecialSetting',
        'SELECT AITP, FFTO, RCIT, RCLP, RCNP, RCTS From Final.FESpecialSetting Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHEqualString',
        'SELECT HPA.id as ''id'', HPA.ParameterCode as ''code'', CKI.CKey as ''key'', HPA.ParameterName as ''name'', HES.Enable as ''enable'', HES.correct as ''correct'', HES.severity as ''severity'', HME.message as ''normal_msg'', HMS.message as ''message'' FROM HealthMonitor.Parameters HPA INNER JOIN HealthMonitor.EqualString HES ON HPA.id = HES.ParameterID INNER JOIN HealthMonitor.Messages HME ON HES.normal_msg = HME.id INNER JOIN HealthMonitor.Messages HMS ON HES.message = HMS.id FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id Where Radio_Name = ''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHFixedValue',
        'SELECT HPA.id as ''id'', HPA.ParameterCode as ''code'', CKI.CKey as ''key'', HPA.ParameterName as ''name'', HFV.Enable as ''enable'', HFV.correct as ''correct'', HFV.severity as ''severity'', HME.message as ''normal_msg'', HMS.message as ''message'' FROM HealthMonitor.Parameters HPA INNER JOIN HealthMonitor.FixedValue HFV ON HPA.id = HFV.ParameterID INNER JOIN HealthMonitor.Messages HME ON HFV.normal_msg = HME.id INNER JOIN HealthMonitor.Messages HMS ON HFV.message = HMS.id FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id Where Radio_Name = ''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHFrequencyParameters',
        'SELECT HFP.ParameterID ''pid'', HFP.Station, HFP.Frequency_No, HFP.TXM, HFP.TXS, HFP.RXM, HFP.RXS, HFP.Level, HFP.message FROM HealthMonitor.FrequencyParameters HFP Where HFP.Enable = 1;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHMultiLevel',
        'SELECT HPA.id as ''id'', HPA.ParameterCode as ''code'', CKI.CKey as ''key'', HPA.ParameterName as ''name'', HML.Enable as ''enable'', HML.correct as ''correct'', HME.message as ''normal_msg'', MLS.value as ''value'', MLS.severity as ''severity'', HMS.message as ''message'' FROM HealthMonitor.Parameters HPA INNER JOIN HealthMonitor.MultiLevel HML ON HPA.id = HML.ParameterID INNER JOIN HealthMonitor.Messages HME ON HML.normal_msg = HME.id INNER JOIN HealthMonitor.MultiLevelStats MLS on HML.id = MLS.MultiLevelID INNER JOIN HealthMonitor.Messages HMS ON MLS.message = HMS.id FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id Where Radio_Name = ''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHPatternString',
        'SELECT HPA.id as ''id'', HPA.ParameterCode as ''code'', CKI.CKey as ''key'', HPA.ParameterName as ''name'', HPS.Enable as ''enable'', HPS.pattern as ''pattern'', HPS.severity as ''severity'', HME.message as ''normal_msg'', HMS.message as ''message'' FROM HealthMonitor.Parameters HPA INNER JOIN HealthMonitor.PatternString HPS ON HPA.id = HPS.ParameterID INNER JOIN HealthMonitor.Messages HME ON HPS.normal_msg = HME.id INNER JOIN HealthMonitor.Messages HMS ON HPS.message = HMS.id FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id Where Radio_Name = ''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHRadioStatus', 'Select Radio_Name, ParameterID ''pid'', severity From HealthMonitor.RadioStatus;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SHRange',
        'SELECT HPA.id as ''id'', HPA.ParameterCode as ''code'', CKI.CKey as ''key'', HPA.ParameterName as ''name'', R.Enable as ''enable'', R.start as ''start'', R.[end] as ''end'', HME.message as ''normal_msg'', RS.range_start as ''r_start'', RS.range_end as ''r_end'', RS.severity as ''severity'', HMS.message as ''message'' FROM HealthMonitor.Parameters HPA INNER JOIN HealthMonitor.Range R ON HPA.id = R.ParameterID INNER JOIN HealthMonitor.Messages HME ON R.normal_msg = HME.id INNER JOIN HealthMonitor.RangeStats RS on R.id = RS.RangeID INNER JOIN HealthMonitor.Messages HMS ON RS.message = HMS.id FULL JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id Where Radio_Name = ''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SIRRadio',
        'SELECT id, Name, Station, Frequency_No, Sector, RadioType, MainStandBy, IP FROM RCMS.Radio.Radio WHERE Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SMRRadio', 'SELECT Name FROM Radio.Radio WHERE Station IN {} ORDER BY Name;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SRStation',
        'SELECT SL.Code FROM Radio.Station as SL JOIN Common.StationAvailability as SA ON SL.Availability = SA.id WHERE SA.Status = ''Available'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSAccess', 'SELECT ACL_Index, Allowed_IP From Final.FSAccess Where Radio_Name=''{}'' ORDER BY ACL_Index;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSConfiguration',
        'SELECT AISE, AISF, EVSR, FFBL, FFEA, FFFC, FFLM, FFLT From Final.FSConfiguration Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSIP', 'SELECT IP, Subnet, Gateway FROM Final.FSIP WHERE Radio_Name = ''{}'' AND IP_Type=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSInstallation',
        'SELECT AIAI, AIEL, FFFE, FFSC, GRIN, GRLO, MSTY From Final.FSInstallation Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSInventory', 'SELECT * From Final.FSInventory Where Radio_Name=''{}'' ORDER BY R_Index;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSNetwork', 'SELECT GRDH, GRDN, GRIE, GRIV, GRNS, GRVE From Final.FSNetwork Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSRRadio', 'SELECT Name FROM Radio.Radio WHERE Station = ''{}'' ORDER BY Name;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSRXConfiguration',
        'SELECT AIGA, AITS, FFCO, FFSL, GRBS, GRIS, RIRO From Final.FSRXConfiguration Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSSCBIT', 'SELECT CBIT_Code, Configuration From Final.FSCBIT Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSSNMP', 'SELECT GRSE, GRSN, RUFL, RUFP FROM Final.FSSNMP Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSSoftware',
        'SELECT Partition, Version, Part_Number, Status FROM Final.FSSoftware Where Radio_Name=''{}'' ORDER BY Partition;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSStatus', 'SELECT ERBE, GRLR, GRLT, GRTI, RCLR, RCLV From Final.FSStatus Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SSTXConfiguration',
        'SELECT AICA, AIML, GRAS, GRCO, GREX, RCDP, RIPC, RIVL, RIVP FROM Final.FSTXConfiguration Where Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UACounter', 'UPDATE Analyze.Counter SET {} WHERE Radio_Name=''{}'' AND RecordType=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UAModuleStatus', 'Update Application.ModuleStatus SET {} Where id={};');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UATimer', 'UPDATE Analyze.Timer SET {} WHERE Radio_Name=''{}'' AND RecordType=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UCAResetCommand', 'UPDATE Analyze.ResetCommand SET ResetCounter=0 WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UCHistory', 'Update Command.History SET SentTime=''{}'', Status={} WHERE id={};');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UOACounter', 'UPDATE Analyze.Counter SET {} WHERE Radio_Name=''{}'' AND RecordType=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UOAModuleStatus', 'Update Application.ModuleStatus SET {} Where id={};');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UOATimer', 'UPDATE Analyze.Timer SET {} WHERE Radio_Name=''{}'' AND RecordType=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('URACounter',
        'UPDATE Analyze.Counter SET ResetDate=''{}'', [CntConnect]=0, [CntDisconnect]=0, [CntIndicatorOn]=0, [CntCBITWarning]=0, [CntCBITError]=0, [CntSentPacket]=0, [CntKeepConnectionPacket]=0, [CntReceivedPacket]=0, [CntReceivedMessage]=0, [CntReceivedCommandError]=0, [CntReceivedAccessError]=0, [CntReceivedTrapAnswer]=0, [CntReceivedGetAnswer]=0, [CntReceivedTrapAcknowledge]=0, [CntReceivedSetAcknowledge]=0, [CntQueryGenerated]=0, [CntQueryExecuted]=0, [CntCommandExecuted]=0, [CntCommandRejected]=0, [CntUpdateSettings]=0, [CntUpdateSpecial]=0, [CntUpdateTimer]=0, [CntErrorPacketReceive]=0, [CntErrorPacketEvaluation]=0, [CntErrorPacketSending]=0, [CntErrorConnection]=0, [CntErrorQueryGeneration]=0, [CntErrorQueryExecution]=0, [CnrErrorCommandExecution]=0, [CntErrorUpdateSettings]=0, [CntErrorUpdateSpecial]=0, [CntErrorUpdateTimer]=0 WHERE Radio_Name = ''{}'' AND RecordType=1;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('URATimer',
        'UPDATE Analyze.Timer SET ResetDate=''{}'', IndicatorONSec=''0.0'', IndicatorOFFSec=''0.0'', ConnectTimeSec=''0.0'', DisconnectTimeSec=''0.0'' WHERE Radio_Name=''{}'' AND RecordType=1;');

INSERT INTO Application.Queries
    (code, query)
VALUES ('URRadio',
        'UPDATE Radio.Radio SET Radio.Sector=(Select id From Radio.Sector Where Sector.Frequency={}) WHERE Radio.Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('USAModuleStatus',
        'Update Application.ModuleStatus SET StartTime=''{}'', UpdateTime=''{}'', PID={} WHERE id={};');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UTAResetCommand', 'UPDATE Analyze.ResetCommand SET ResetTimer=0 WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('UARadioStatus', 'Update Application.RadioStatus SET EventListCollect=''{}'' WHERE Radio_Name=''{}'';');

INSERT INTO Application.Queries
    (code, query)
VALUES ('SFRRadio', 'SELECT Name, Station, Frequency_No, Sector FROM Radio.Radio;');


