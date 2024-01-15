Select
    AN.id,
    AN.App,
    AN.JobInformation,
    AT.Timing
FROM Application.Timing AT
    INNER JOIN Application.Names AN
        ON AN.id = AT.App