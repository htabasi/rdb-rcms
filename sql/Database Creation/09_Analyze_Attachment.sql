CREATE TABLE Analyze.Transmission
(
    id                INT IDENTITY PRIMARY KEY CLUSTERED,
    Radio_Name        CHAR(10) NOT NULL FOREIGN KEY REFERENCES Radio.Radio (Name),
    Date              DATETIME NOT NULL DEFAULT GETUTCDATE(),
    Count             INT      NOT NULL,
    Length            FLOAT    NOT NULL,
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
)