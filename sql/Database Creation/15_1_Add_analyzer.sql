USE RCMS;
GO

INSERT INTO Application.Names
    (id, App, JobInformation)
VALUES (18, 'Analyzer', '');
GO

ALTER TABLE Application.Configuration
    ADD AnalyzeCalm DECIMAL(4, 2) NOT NULL DEFAULT 5.0 -- Second
GO

INSERT INTO Application.LogConfig
    (RunMode, App, FileLevel, StreamLevel, FileFormat, StreamFormat)
VALUES (0, 18, 10, 30, 1, 1),
       (1, 18, 10, 50, 1, 1);
GO
