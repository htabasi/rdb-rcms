DROP TABLE Analyze.Transmission;

UPDATE Application.Queries
Set query = 'INSERT INTO Analyze.Transmission (Radio_Name, Date, {}) VALUES (''{}'', ''{}'', {})'
where code = 'IATransmission'

CREATE TABLE Analyze.Transmission
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Date              DATETIME NOT NULL DEFAULT GETUTCDATE(),
    PTT_Length        FLOAT    NULL,
    PTT_Count         INT      NULL,
    PTT_Max           FLOAT    NULL,
    PTT_Min           FLOAT    NULL,
    PTT_Difference    FLOAT    NULL,
    PTT_Mean          FLOAT    NULL,
    PTT_Median        FLOAT    NULL,
    PTT_Variance      FLOAT    NULL,
    PTT_Deviation     FLOAT    NULL,
    PTT_Quantiles25   FLOAT    NULL,
    PTT_Quantiles50   FLOAT    NULL,
    PTT_Quantiles75   FLOAT    NULL,
    PTT_Skewness      FLOAT    NULL,
    PTT_Kurtosis      FLOAT    NULL,
    PWR_Count         INT      NULL,
    PWR_Max           FLOAT    NULL,
    PWR_Min           FLOAT    NULL,
    PWR_Difference    FLOAT    NULL,
    PWR_Mean          FLOAT    NULL,
    PWR_Median        FLOAT    NULL,
    PWR_Variance      FLOAT    NULL,
    PWR_Deviation     FLOAT    NULL,
    PWR_Quantiles25   FLOAT    NULL,
    PWR_Quantiles50   FLOAT    NULL,
    PWR_Quantiles75   FLOAT    NULL,
    PWR_Skewness      FLOAT    NULL,
    PWR_Kurtosis      FLOAT    NULL,
    MOD_Count         INT      NULL,
    MOD_Max           FLOAT    NULL,
    MOD_Min           FLOAT    NULL,
    MOD_Difference    FLOAT    NULL,
    MOD_Mean          FLOAT    NULL,
    MOD_Median        FLOAT    NULL,
    MOD_Variance      FLOAT    NULL,
    MOD_Deviation     FLOAT    NULL,
    MOD_Quantiles25   FLOAT    NULL,
    MOD_Quantiles50   FLOAT    NULL,
    MOD_Quantiles75   FLOAT    NULL,
    MOD_Skewness      FLOAT    NULL,
    MOD_Kurtosis      FLOAT    NULL,
    SWR_Count         INT      NULL,
    SWR_Max           FLOAT    NULL,
    SWR_Min           FLOAT    NULL,
    SWR_Difference    FLOAT    NULL,
    SWR_Mean          FLOAT    NULL,
    SWR_Median        FLOAT    NULL,
    SWR_Variance      FLOAT    NULL,
    SWR_Deviation     FLOAT    NULL,
    SWR_Quantiles25   FLOAT    NULL,
    SWR_Quantiles50   FLOAT    NULL,
    SWR_Quantiles75   FLOAT    NULL,
    SWR_Skewness      FLOAT    NULL,
    SWR_Kurtosis      FLOAT    NULL,
    EXSWR_Count       INT      NULL,
    EXSWR_Max         FLOAT    NULL,
    EXSWR_Min         FLOAT    NULL,
    EXSWR_Difference  FLOAT    NULL,
    EXSWR_Mean        FLOAT    NULL,
    EXSWR_Median      FLOAT    NULL,
    EXSWR_Variance    FLOAT    NULL,
    EXSWR_Deviation   FLOAT    NULL,
    EXSWR_Quantiles25 FLOAT    NULL,
    EXSWR_Quantiles50 FLOAT    NULL,
    EXSWR_Quantiles75 FLOAT    NULL,
    EXSWR_Skewness    FLOAT    NULL,
    EXSWR_Kurtosis    FLOAT    NULL
);
GO

-- DROP TABLE Analyze.Reception;

CREATE TABLE Analyze.Reception
(
    id                      INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name              CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Date                    DATETIME NOT NULL DEFAULT GETUTCDATE(),
    SQ_ON_Length            FLOAT    NULL,
    SQ_OFF_Length           FLOAT    NULL,
    SQ_ON_Count             INT      NULL,
    SQ_ON_Mean              FLOAT    NULL,
    SQ_ON_Median            FLOAT    NULL,
    SQ_ON_Deviation         FLOAT    NULL,
    SQ_ON_Quantiles15       FLOAT    NULL,
    SQ_ON_Quantiles85       FLOAT    NULL,
    SQ_OFF_Count            INT      NULL,
    SQ_OFF_Mean             FLOAT    NULL,
    SQ_OFF_Median           FLOAT    NULL,
    SQ_OFF_Deviation        FLOAT    NULL,
    SQ_OFF_Quantiles15      FLOAT    NULL,
    SQ_OFF_Quantiles85      FLOAT    NULL,
    Noise_Count             INT      NULL,
    Noise_Duration          FLOAT    NULL,
    Noise_Mean              FLOAT    NULL,
    Noise_Median            FLOAT    NULL,
    Noise_Deviation         FLOAT    NULL,
    Noise_Quantiles15       FLOAT    NULL,
    Noise_Quantiles85       FLOAT    NULL,
    FarAway_Count           INT      NULL,
    FarAway_Duration        FLOAT    NULL,
    FarAway_Mean            FLOAT    NULL,
    FarAway_Median          FLOAT    NULL,
    FarAway_Deviation       FLOAT    NULL,
    FarAway_Quantiles15     FLOAT    NULL,
    FarAway_Quantiles85     FLOAT    NULL,
    Detected_Count          INT      NULL,
    Detected_Duration       FLOAT    NULL,
    Detected_Mean           FLOAT    NULL,
    Detected_Median         FLOAT    NULL,
    Detected_Deviation      FLOAT    NULL,
    Detected_Quantiles15    FLOAT    NULL,
    Detected_Quantiles85    FLOAT    NULL,
    Transmitter_Count       INT      NULL,
    Transmitter_Duration    FLOAT    NULL,
    Transmitter_Mean        FLOAT    NULL,
    Transmitter_Median      FLOAT    NULL,
    Transmitter_Deviation   FLOAT    NULL,
    Transmitter_Quantiles15 FLOAT    NULL,
    Transmitter_Quantiles85 FLOAT    NULL,
);


INSERT INTO Application.Queries
    (code, query)
VALUES ('IAReception', 'INSERT INTO Analyze.Reception (Radio_Name, Date, {}) VALUES (''{}'', ''{}'', {});');

Update Application.Queries
SET query = 'INSERT INTO Analyze.Reception (Radio_Name, Date, {}) VALUES (''{}'', ''{}'', {});'
Where code = 'IAReception';

ALTER TABLE Analyze.Reception ADD Noise_Duration FLOAT;
ALTER TABLE Analyze.Reception ADD FarAway_Duration FLOAT;
ALTER TABLE Analyze.Reception ADD Detected_Duration FLOAT;
ALTER TABLE Analyze.Reception ADD Transmitter_Duration FLOAT;
