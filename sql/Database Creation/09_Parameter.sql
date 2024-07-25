USE RCMS;

CREATE TABLE Application.DBParameters
(
    id                        INT IDENTITY PRIMARY KEY CLUSTERED,
    RX_Count                  INT DEFAULT 100,
    TX_Count                  INT DEFAULT 100,
    RX_Minute                 INT DEFAULT 10,
    TX_Minute                 INT DEFAULT 10,
    DC_Minute                 INT DEFAULT 10,
    TEMP_Minute               INT DEFAULT 10,
    RX_PPS                    INT DEFAULT 5,
    TX_PPS                    INT DEFAULT 2,
    DC_PPS                    INT DEFAULT 2,
    TEMP_PPS                  INT DEFAULT 2,
    Reception_BUCKET_COUNT    INT DEFAULT 300000,
    Transmission_BUCKET_COUNT INT DEFAULT 120000,
    Voltage_BUCKET_COUNT      INT DEFAULT 240000,
    Temperature_BUCKET_COUNT  INT DEFAULT 240000,
)

-- RX_BUCKET = RX_Count * RX_PPS * RX_Minute * 60
-- TX_BUCKET = TX_Count * TX_PPS * TX_Minute * 60
-- DC_BUCKET = (RX_Count + TX_Count) * DC_PPS * DC_Minute * 60
-- TEMP_BUCKET = (RX_Count + TX_Count) * TEMP_PPS * TEMP_Minute * 60
-- BUCKET_COUNT = RX_BUCKET + TX_BUCKET + DC_BUCKET + TEMP_BUCKET

-- SELECT (SELECT COUNT(Radio.Name) FROM Radio.Radio WHERE RadioType = 0) AS RX_Count,
--        (SELECT COUNT(Radio.Name) FROM Radio.Radio WHERE RadioType = 1) AS TX_Count

CREATE PROCEDURE Application.SetReceptionBucketCount
    @BucketCount INT = NULL -- Optional parameter
AS
BEGIN
    DECLARE @RX_Count INT;
    DECLARE @RX_PPS INT;
    DECLARE @RX_Minute INT;
    DECLARE @CalculatedBucketCount INT;

    -- Retrieve RX_Count from Radio.Radio table
    SELECT @RX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 0;

    -- Retrieve RX_PPS and RX_Minute from Application.DBParameters table
    SELECT TOP 1 @RX_PPS = RX_PPS, @RX_Minute = RX_Minute FROM Application.DBParameters;

    -- Calculate Reception_BUCKET_COUNT if @BucketCount is not provided
    IF @BucketCount IS NULL
    BEGIN
        SET @CalculatedBucketCount = @RX_Count * @RX_PPS * @RX_Minute * 60;

        -- Update Reception_BUCKET_COUNT in Application.DBParameters table

        UPDATE Application.DBParameters
        SET Reception_BUCKET_COUNT = @CalculatedBucketCount;
    END
    ELSE
    BEGIN
        -- Update Reception_BUCKET_COUNT with provided @BucketCount value
        UPDATE Application.DBParameters
        SET Reception_BUCKET_COUNT = @BucketCount;
    END

    -- Now set the new bucket count for Memory.LatestReception table using ALTER TABLE command
    ALTER TABLE Memory.LatestReception
    ALTER INDEX ALL ON Memory.LatestReception
    REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
END;
GO


-- CREATE PROCEDURE Application.SetTransmissionBucketCount
--     @BucketCount INT = NULL -- Optional parameter
-- AS
-- BEGIN
--     DECLARE @TX_Count INT;
--     DECLARE @TX_PPS INT;
--     DECLARE @TX_Minute INT;
--     DECLARE @CalculatedBucketCount INT;
--
--     -- Retrieve TX_Count from Radio.Radio table
--     SELECT @TX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 1;
--
--     -- Retrieve TX_PPS and TX_Minute from Application.DBParameters table
--     SELECT TOP 1 @TX_PPS = TX_PPS, @TX_Minute = TX_Minute FROM Application.DBParameters;
--
--     -- Calculate Transmission_BUCKET_COUNT if @BucketCount is not provided
--     IF @BucketCount IS NULL
--     BEGIN
--         SET @CalculatedBucketCount = @TX_Count * @TX_PPS * @TX_Minute * 60;
--
--         -- Update Transmission_BUCKET_COUNT in Application.DBParameters table
--
--         UPDATE Application.DBParameters
--         SET Transmission_BUCKET_COUNT = @CalculatedBucketCount;
--     END
--     ELSE
--     BEGIN
--         -- Update Transmission_BUCKET_COUNT with provided @BucketCount value
--         UPDATE Application.DBParameters
--         SET Transmission_BUCKET_COUNT = @BucketCount;
--     END
--
--     -- Now set the new bucket count for Memory.LatestReception table using ALTER TABLE command
--     -- Note: You need to replace 'YourSchema' with the actual schema name of Memory.LatestReception table
--     ALTER TABLE Memory.LatestTransmission
--     ALTER INDEX ALL ON Memory.LatestTransmission
--     REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
-- END;
-- GO
