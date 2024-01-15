SELECT
    SL.Code
FROM Station.StationList as SL
    JOIN Common.StationAvailability as SA
        ON SL.Availability = SA.id
WHERE
    SA.Status = 'Available';