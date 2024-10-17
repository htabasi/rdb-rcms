USE RCMS;
GO

INSERT INTO Application.Names
    (id, App, JobInformation)
VALUES (1, 'Core', ''),
       (2, 'Reception', ''),
       (3, 'Keeper', ''),
       (4, 'Connector', ''),
       (5, 'Coordinator', ''),
       (6, 'Sender', ''),
       (7, 'Constructor', ''),
       (8, 'Executor', ''),
       (9, 'Generator', ''),
       (10, 'Commander', ''),
       (11, 'Preparer', ''),
       (12, 'Status', ''),
       (13, 'TimerUpdate', ''),
       (14, 'SettingsUpdate', ''),
       (15, 'SpecialUpdate', ''),
       (16, 'Optimum', ''),
       (17, 'Manager', ''),
       (18, 'Analyzer', '');

GO

INSERT INTO Application.RunningMode
    (id, Mode)
VALUES (0, 'Single Radio'),
       (1, 'Run By Manager');
GO

INSERT INTO Application.Configuration
(Date, Status, ConnectionTryInterval, PeriodicSettingCheck, MaxDelaySettingCheck, PeriodicTimerUpdate,
 MaxDelayTimerUpdate, PeriodicSpecialUpdate, MaxDelaySpecialUpdate, CoreCheckInterval, PingTimeout, SenderCalm,
 GenerationCalm, ExecutorCalm, CommanderCalm, SessionWarningThreshold, FistCommandID, LastCommandID)
VALUES (GETDATE(), 1, 60, 1440, 60, 5, 2, 5, 2, 1, 20, 0.3, 2.0, 3.0, 5.0, 3, 1000, 9999);
GO


INSERT INTO Application.LogLevel
VALUES (0, 'NOTSET'),
       (10, 'DEBUG'),
       (20, 'INFO'),
       (30, 'WARNING'),
       (40, 'ERROR'),
       (50, 'CRITICAL');
GO

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
        2, 10, 0, 0, 5, 0);
GO

INSERT INTO Application.LogConfig
    (RunMode, App, FileLevel, StreamLevel, FileFormat, StreamFormat)
VALUES (0, 1, 20, 30, 1, 1),
       (0, 2, 20, 30, 1, 1),
       (0, 3, 20, 30, 1, 1),
       (0, 4, 20, 30, 1, 1),
       (0, 6, 20, 30, 1, 1),
       (0, 7, 20, 30, 1, 1),
       (0, 8, 20, 30, 1, 1),
       (0, 9, 20, 30, 1, 1),
       (0, 10, 20, 30, 1, 1),
       (1, 1, 20, 50, 1, 1),
       (1, 2, 20, 50, 1, 1),
       (1, 3, 20, 50, 1, 1),
       (1, 4, 20, 50, 1, 1),
       (1, 6, 20, 50, 1, 1),
       (1, 7, 20, 50, 1, 1),
       (1, 8, 20, 50, 1, 1),
       (1, 9, 20, 50, 1, 1),
       (1, 10, 20, 50, 1, 1);
GO

INSERT INTO Application.StatusUpdater
    (Part, FileLevel, StreamLevel, FileFormat, StreamFormat)
VALUES ('Core', 20, 50, 1, 1)