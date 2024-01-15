WITH CTE AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY Radio_Name, CBIT_Code ORDER BY Date DESC) AS rn
    FROM Setting.SCBIT
)
SELECT id, Date, Radio_Name, CBIT_Code, Configuration
FROM CTE
WHERE rn = 1 AND Radio_Name='BJD_TX_V2S'

SELECT Radio_Name, CBIT_Code, MAX(Date) as MaxDate
    FROM Setting.SCBIT
    GROUP BY Radio_Name, CBIT_Code
----------------------------------------------------------------------------------------------------

SELECT t1.id, t1.Date, t1.Radio_Name, t1.CBIT_Code, t1.Configuration
FROM Setting.SCBIT t1
INNER JOIN (
    SELECT Radio_Name, CBIT_Code, MAX(Date) as MaxDate
    FROM Setting.SCBIT
    GROUP BY Radio_Name, CBIT_Code
) t2
ON t1.Radio_Name = t2.Radio_Name AND t1.CBIT_Code = t2.CBIT_Code AND t1.Date = t2.MaxDate
WHERE t1.Radio_Name='BJD_TX_V2S'
----------------------------------------------------------------------------------------------------

DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;

SET @StartTime = GETDATE();

WITH CTE AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY Radio_Name, CBIT_Code ORDER BY Date DESC) AS RN
    FROM Setting.SCBIT
)
SELECT id, Date, Radio_Name, CBIT_Code, Configuration
FROM CTE
WHERE RN = 1 AND Radio_Name='BJD_TX_V2S'

SET @EndTime = GETDATE();

SELECT DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS ElapsedTime;
----------------------------------------------------------------------------------------------------

DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;

SET @StartTime = GETDATE();

SELECT SSC.id, SSC.Date, SSC.Radio_Name, SSC.CBIT_Code, SSC.Configuration
FROM Setting.SCBIT SSC
INNER JOIN (
    SELECT Radio_Name, CBIT_Code, MAX(Date) as MaxDate
    FROM Setting.SCBIT
    GROUP BY Radio_Name, CBIT_Code
) t2
ON SSC.Radio_Name = t2.Radio_Name AND SSC.CBIT_Code = t2.CBIT_Code AND SSC.Date = t2.MaxDate
WHERE SSC.Radio_Name='BJD_TX_V2S'

SET @EndTime = GETDATE();

SELECT DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS ElapsedTime;
-----------------------------------------------------------------------------------------------------------

SELECT SSC.CBIT_Code, SSC.Configuration
FROM Setting.SCBIT SSC
INNER JOIN (
    SELECT Radio_Name, CBIT_Code, MAX(Date) as MaxDate
    FROM Setting.SCBIT
    GROUP BY Radio_Name, CBIT_Code
) SCD
ON SSC.Radio_Name = SCD.Radio_Name AND SSC.CBIT_Code = SCD.CBIT_Code AND SSC.Date = SCD.MaxDate
WHERE SSC.Radio_Name='BJD_TX_V2S'