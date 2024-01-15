SELECT
    CR.id,
    CR.Station_Code,
    CR.Frequency_No,
    RT.Type,
    RIGHT(CR.Radio_Name, 1) as Position,
    CR.IP
FROM Common.Radio CR
    INNER JOIN Common.RadioType RT
        ON RT.id = CR.Type
WHERE CR.Radio_Name='{}';