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
    -- Note: You need to replace 'YourSchema' with the actual schema name of Memory.LatestReception table
    ALTER TABLE Memory.LatestReception
    ALTER INDEX ALL ON Memory.LatestReception
    REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
END;
GO
-------------------------------
CREATE PROCEDURE Application.SetTransmissionBucketCount
    @BucketCount INT = NULL -- Optional parameter
AS
BEGIN
    DECLARE @TX_Count INT;
    DECLARE @TX_PPS INT;
    DECLARE @TX_Minute INT;
    DECLARE @CalculatedBucketCount INT;

    -- Retrieve RX_Count from Radio.Radio table
    SELECT @TX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 1;

    -- Retrieve RX_PPS and RX_Minute from Application.DBParameters table
    SELECT TOP 1 @TX_PPS = TX_PPS, @TX_Minute = TX_Minute FROM Application.DBParameters;

    -- Calculate Reception_BUCKET_COUNT if @BucketCount is not provided
    IF @BucketCount IS NULL
    BEGIN
        SET @CalculatedBucketCount = @TX_Count * @TX_PPS * @TX_Minute * 60;

        -- Update Reception_BUCKET_COUNT in Application.DBParameters table
        UPDATE Application.DBParameters
        SET Transmission_BUCKET_COUNT = @CalculatedBucketCount;
    END
    ELSE
    BEGIN
        -- Update Reception_BUCKET_COUNT with provided @BucketCount value
        UPDATE Application.DBParameters
        SET Transmission_BUCKET_COUNT = @BucketCount;
    END

    -- Now set the new bucket count for Memory.LatestReception table using ALTER TABLE command
    -- Note: You need to replace 'YourSchema' with the actual schema name of Memory.LatestReception table
    ALTER TABLE Memory.LatestTransmission
    ALTER INDEX ALL ON Memory.LatestTransmission
    REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
END;
GO

-------------------------------
CREATE PROCEDURE Application.SetTemperatureBucketCount
    @BucketCount INT = NULL -- Optional parameter
AS
BEGIN
    DECLARE @RX_Count INT;
    DECLARE @TX_Count INT;
    DECLARE @TEMP_PPS INT;
    DECLARE @TEMP_Minute INT;
    DECLARE @CalculatedBucketCount INT;

    -- Retrieve RX_Count from Radio.Radio table
    SELECT @RX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 0;
    SELECT @TX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 1;

    -- Retrieve RX_PPS and RX_Minute from Application.DBParameters table
    SELECT TOP 1 @TEMP_PPS = TEMP_PPS, @TEMP_Minute = TEMP_Minute FROM Application.DBParameters;

    -- Calculate Reception_BUCKET_COUNT if @BucketCount is not provided
    IF @BucketCount IS NULL
    BEGIN
        SET @CalculatedBucketCount = (@RX_Count + @TX_Count) * @TEMP_PPS * @TEMP_Minute * 60;

        -- Update Reception_BUCKET_COUNT in Application.DBParameters table
        UPDATE Application.DBParameters
        SET Temperature_BUCKET_COUNT = @CalculatedBucketCount;
    END
    ELSE
    BEGIN
        -- Update Reception_BUCKET_COUNT with provided @BucketCount value
        UPDATE Application.DBParameters
        SET Temperature_BUCKET_COUNT = @BucketCount;
    END

    -- Now set the new bucket count for Memory.LatestReception table using ALTER TABLE command
    -- Note: You need to replace 'YourSchema' with the actual schema name of Memory.LatestReception table
    ALTER TABLE Memory.LatestTemperature
    ALTER INDEX ALL ON Memory.LatestTemperature
    REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
END;
GO

CREATE PROCEDURE Application.SetTransmissionBucketCount
    @BucketCount INT = NULL -- Optional parameter
AS
BEGIN
    DECLARE @RX_Count INT;
    DECLARE @TX_Count INT;
    DECLARE @DC_PPS INT;
    DECLARE @DC_Minute INT;
    DECLARE @CalculatedBucketCount INT;

    -- Retrieve RX_Count from Radio.Radio table
    SELECT @RX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 0;
    SELECT @TX_Count = COUNT(Name) FROM Radio.Radio WHERE RadioType = 1;

    -- Retrieve RX_PPS and RX_Minute from Application.DBParameters table
    SELECT TOP 1 @DC_PPS = DC_PPS, @DC_Minute = DC_Minute FROM Application.DBParameters;

    -- Calculate Reception_BUCKET_COUNT if @BucketCount is not provided
    IF @BucketCount IS NULL
    BEGIN
        SET @CalculatedBucketCount = (@RX_Count + @TX_Count) * @DC_PPS * @DC_Minute * 60;

        -- Update Reception_BUCKET_COUNT in Application.DBParameters table
        UPDATE Application.DBParameters
        SET Voltage_BUCKET_COUNT = @CalculatedBucketCount;
    END
    ELSE
    BEGIN
        -- Update Reception_BUCKET_COUNT with provided @BucketCount value
        UPDATE Application.DBParameters
        SET Voltage_BUCKET_COUNT = @BucketCount;
    END

    -- Now set the new bucket count for Memory.LatestReception table using ALTER TABLE command
    -- Note: You need to replace 'YourSchema' with the actual schema name of Memory.LatestReception table
    ALTER TABLE Memory.LatestVoltage
    ALTER INDEX ALL ON Memory.LatestVoltage
    REBUILD PARTITION = ALL WITH (BUCKET_COUNT = COALESCE(@BucketCount, @CalculatedBucketCount));
END;
GO

