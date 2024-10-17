USE RCMS;
GO

INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are connected');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios are disconnected');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both receivers are disconnected');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both transmitters are disconnected');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are disconnected');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are active');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios are inactive');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both receivers are inactive');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both transmitters are inactive');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are inactive');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios are NO-GO');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both receivers are NO-GO');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both transmitters are NO-GO');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are NO-GO');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR LED of transmitters is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR LED of standby transmitter is ON');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR LED of main transmitter is ON');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR LEDs of both transmitters are ON');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both transmitters are on-air');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Standby transmitter is inhibited');
GO

INSERT INTO HealthMonitor.Messages (message) VALUES ('Main transmitter is inhibited');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Both transmitters are inhibited');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBIT of all radios is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBIT of Some radios are in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBIT of Some radios are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBITs of both receivers are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBITs of both transmitters are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('CBITs of all radios are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All Radios are in Monitor Mode');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios are in Remote Mode');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios are in Local Mode');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are in Remote Mode');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are in Local Mode');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radio sessions are in normal status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Sessions of some radios are in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Sessions of some radios are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radio sessions are in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radio sessions are in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of both transmitters is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of the standby transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of the standby transmitter is in warning status');
GO

INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of the main transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of both transmitters is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of the main transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The power of both transmitters is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of both transmitters is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of the standby transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of the standby transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of the main transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of both transmitters is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of the main transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The modulation of both transmitters is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of both transmitters is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of the standby transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of the standby transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of the main transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of both transmitters is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of the main transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('VSWR of both transmitters is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of both transmitters is normal');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of the standby transmitter is in notice status');
GO

INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of the standby transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of the main transmitter is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of both transmitters is in notice status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of the main transmitter is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('External VSWR of both transmitters is in warning status');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios are booted normally');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Some radios have errors during boot');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The receivers had error during boot');
INSERT INTO HealthMonitor.Messages (message) VALUES ('The transmitters had error during boot');
INSERT INTO HealthMonitor.Messages (message) VALUES ('All radios had error during boot');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #1 of all radios is up to date');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #1 of some radios needs to be updated');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #1 of all radios needs to be updated');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #2 of all radios is up to date');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #2 of some radios needs to be updated');
INSERT INTO HealthMonitor.Messages (message) VALUES ('Partition #2 of all radios needs to be updated');
GO

DECLARE @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'Connection';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All radios are connected')),
    (0, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (0, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (0, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are disconnected')),
    (0, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (0, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (0, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (0, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are disconnected')),
    (1, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (1, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (1, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are disconnected')),
    (1, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are disconnected')),
    (1, 1, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are disconnected')),
    (1, 1, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are disconnected')),
    (1, 1, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are disconnected')),
    (1, 1, 1, 1, 6, (SELECT id FROM HealthMonitor.Messages Where message='All radios are disconnected')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'ActivationStatus';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All radios are active')),
    (0, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (0, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (0, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are inactive')),
    (0, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (0, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (0, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (0, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are inactive')),
    (1, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (1, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (1, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are inactive')),
    (1, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are inactive')),
    (1, 1, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inactive')),
    (1, 1, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inactive')),
    (1, 1, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inactive')),
    (1, 1, 1, 1, 4, (SELECT id FROM HealthMonitor.Messages Where message='All radios are inactive')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'GONOGOStatus';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All radios are normal')),
    (0, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (0, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (0, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are NO-GO')),
    (0, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (0, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (0, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (0, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are NO-GO')),
    (1, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (1, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (1, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are NO-GO')),
    (1, 0, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both receivers are NO-GO')),
    (1, 1, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are NO-GO')),
    (1, 1, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are NO-GO')),
    (1, 1, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are NO-GO')),
    (1, 1, 1, 1, 4, (SELECT id FROM HealthMonitor.Messages Where message='All radios are NO-GO')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'VSWRLED';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of transmitters is normal')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of transmitters is normal')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of transmitters is normal')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of transmitters is normal')),
    (0, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of standby transmitter is ON')),
    (0, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of standby transmitter is ON')),
    (0, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of standby transmitter is ON')),
    (0, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of standby transmitter is ON')),
    (1, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of main transmitter is ON')),
    (1, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of main transmitter is ON')),
    (1, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of main transmitter is ON')),
    (1, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LED of main transmitter is ON')),
    (1, 1, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LEDs of both transmitters are ON')),
    (1, 1, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LEDs of both transmitters are ON')),
    (1, 1, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LEDs of both transmitters are ON')),
    (1, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR LEDs of both transmitters are ON')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'TXInhibition';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are on-air')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are on-air')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are on-air')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are on-air')),
    (0, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Standby transmitter is inhibited')),
    (0, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Standby transmitter is inhibited')),
    (0, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Standby transmitter is inhibited')),
    (0, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Standby transmitter is inhibited')),
    (1, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Main transmitter is inhibited')),
    (1, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Main transmitter is inhibited')),
    (1, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Main transmitter is inhibited')),
    (1, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Main transmitter is inhibited')),
    (1, 1, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inhibited')),
    (1, 1, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inhibited')),
    (1, 1, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inhibited')),
    (1, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='Both transmitters are inhibited')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'CBITLevel';


WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of all radios is normal')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 0, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (0, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 1, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (0, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 0, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in notice status')),
    (1, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 1, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (1, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 0, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='CBIT of Some radios are in warning status')),
    (2, 1, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both receivers are in warning status')),
    (2, 2, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 0, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 1, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 2, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 2, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of both transmitters are in warning status')),
    (2, 2, 2, 2, 4, (SELECT id FROM HealthMonitor.Messages Where message='CBITs of all radios are in warning status')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'Access';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All Radios are in Monitor Mode')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (0, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Remote Mode')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='All radios are in Remote Mode')),
    (1, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Some radios are in Local Mode')),
    (2, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='All radios are in Local Mode')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'Session';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES 
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All radio sessions are in normal status')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (0, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='All radio sessions are in notice status')),
    (1, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='Sessions of some radios are in warning status')),
    (2, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='All radio sessions are in warning status')))
	AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'AnalyzedTXPowerValue';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 0, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 1, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 2, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 2, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 0, 2, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is normal')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in notice status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 0, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in notice status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in notice status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the standby transmitter is in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The power of the main transmitter is in warning status')),
    (2, 2, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 0, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 1, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 2, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 2, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')),
    (2, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The power of both transmitters is in warning status')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'AnalyzedModulationDepthValue';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
                                             (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 0, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 1, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 2, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 2, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 0, 2, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is normal')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in notice status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 0, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in notice status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in notice status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the standby transmitter is in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of the main transmitter is in warning status')),
    (2, 2, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 0, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 1, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 2, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 2, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')),
    (2, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='The modulation of both transmitters is in warning status')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'AnalyzedVSWRValue';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 0, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 1, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 2, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 2, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 0, 2, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is normal')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in notice status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in notice status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in notice status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the standby transmitter is in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of the main transmitter is in warning status')),
    (2, 2, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 0, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 1, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 2, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 2, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')),
    (2, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='VSWR of both transmitters is in warning status')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'AnalyzedExternalVSWRVoltage';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 0, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 0, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 1, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 1, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 1, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 2, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 2, 1, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 0, 2, 2, 0, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is normal')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in notice status')),
    (0, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (0, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 0, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in notice status')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 0, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 1, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 2, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 2, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 1, 2, 2, 1, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in notice status')),
    (1, 2, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (1, 2, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the standby transmitter is in warning status')),
    (2, 0, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 0, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 0, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 1, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 1, 2, 2, 2, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of the main transmitter is in warning status')),
    (2, 2, 0, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 0, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 0, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 1, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 1, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 2, 0, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 2, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')),
    (2, 2, 2, 2, 3, (SELECT id FROM HealthMonitor.Messages Where message='External VSWR of both transmitters is in warning status')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'BootErrorList';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='All radios are booted normally')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (0, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The receivers had error during boot')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (0, 1, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The receivers had error during boot')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Some radios have errors during boot')),
    (1, 0, 1, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The receivers had error during boot')),
    (1, 1, 0, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The transmitters had error during boot')),
    (1, 1, 0, 1, 2, (SELECT id FROM HealthMonitor.Messages Where message='The transmitters had error during boot')),
    (1, 1, 1, 0, 2, (SELECT id FROM HealthMonitor.Messages Where message='The transmitters had error during boot')),
    (1, 1, 1, 1, 3, (SELECT id FROM HealthMonitor.Messages Where message='All radios had error during boot')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO
Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'PartitionVersions1';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of all radios is up to date')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of some radios needs to be updated')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #1 of all radios needs to be updated')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO

Declare @PID INT;
SELECT @PID = id
FROM HealthMonitor.Parameters
WHERE ParameterCode = 'PartitionVersions2';

WITH StationFrequency AS (SELECT DISTINCT Station, Frequency_No
                          FROM Radio.Radio)

INSERT INTO HealthMonitor.FrequencyParameters
    (ParameterID, Station, Frequency_No, TXM, TXS, RXM, RXS, Level, message)
SELECT @PID,
       sf.Station,
       sf.Frequency_No,
       t.TXM,
       t.TXS,
       t.RXM,
       t.RXS,
       t.Level,
       t.mid
FROM StationFrequency sf CROSS JOIN (VALUES
    (0, 0, 0, 0, 0, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of all radios is up to date')),
    (0, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (0, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 0, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 0, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 0, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 0, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 1, 0, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 1, 0, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 1, 1, 0, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of some radios needs to be updated')),
    (1, 1, 1, 1, 1, (SELECT id FROM HealthMonitor.Messages Where message='Partition #2 of all radios needs to be updated')))
    AS t (TXM, TXS, RXM, RXS, Level, mid);
GO
