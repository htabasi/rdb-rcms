SELECT
    SL.Code
FROM Radio.Station as SL
    JOIN Common.StationAvailability as SA
        ON SL.Availability = SA.id
WHERE
    SA.Status = 'Available';