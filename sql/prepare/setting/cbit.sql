SELECT SSC.CBIT_Code, SSC.Configuration
FROM Setting.SCBIT SSC
INNER JOIN (
    SELECT Radio_Name, CBIT_Code, MAX(Date) as MaxDate
    FROM Setting.SCBIT
    WHERE Radio_Name='{}'
    GROUP BY Radio_Name, CBIT_Code
) SCD
ON SSC.Radio_Name = SCD.Radio_Name AND SSC.CBIT_Code = SCD.CBIT_Code AND SSC.Date = SCD.MaxDate