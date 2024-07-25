
ALTER TABLE Common.Radio
ADD MainStandBy TINYINT NOT NULL FOREIGN KEY REFERENCES Common.MainStandby (id) DEFAULT 0;
GO

UPDATE Common.Radio
SET MainStandBy = CASE
    WHEN RIGHT(Radio_Name, 1) = 'M' THEN 0
    WHEN RIGHT(Radio_Name, 1) = 'S' THEN 1
    ELSE MainStandBy
END;
GO
