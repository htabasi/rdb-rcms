CREATE PROCEDURE HealthMonitor.CopyRadioParameters
    @NewRadioName CHAR(10),
    @BaseRadioName CHAR(10)
AS
BEGIN
    -- Insert new records into HealthMonitor.FixedValue based on the BaseRadio
    INSERT INTO HealthMonitor.FixedValue (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
        SELECT ParameterID, @NewRadioName AS Radio_Name, Enable, correct, severity, normal_msg, message
        FROM HealthMonitor.FixedValue
        WHERE Radio_Name = @BaseRadioName;

    -- Insert new records into HealthMonitor.MultiLevel and HealthMonitor.MultiLevelStats based on the BaseRadio
    DECLARE @NewMultiLevelIDTable TABLE (id INT);
    DECLARE @BaseMultiLevelID INT;

    -- Cursor to iterate over each MultiLevel record for the BaseRadio
    DECLARE cur CURSOR FOR
        SELECT id FROM HealthMonitor.MultiLevel WHERE Radio_Name = @BaseRadioName;

    OPEN cur;
    FETCH NEXT FROM cur INTO @BaseMultiLevelID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert new record into HealthMonitor.MultiLevel
        INSERT INTO HealthMonitor.MultiLevel (ParameterID, Radio_Name, Enable, correct, normal_msg)
            OUTPUT INSERTED.id INTO @NewMultiLevelIDTable
            SELECT ParameterID, @NewRadioName AS Radio_Name, Enable, correct, normal_msg
            FROM HealthMonitor.MultiLevel
            WHERE id = @BaseMultiLevelID;

        -- Insert new records into HealthMonitor.MultiLevelStats based on the new MultiLevel record
        INSERT INTO HealthMonitor.MultiLevelStats (MultiLevelID, value, severity, message)
        SELECT NMT.id AS MultiLevelID, MLS.value, MLS.severity, MLS.message
        FROM HealthMonitor.MultiLevelStats MLS
            CROSS JOIN @NewMultiLevelIDTable NMT
        WHERE MultiLevelID = @BaseMultiLevelID;

        -- Clear the table variable for the next iteration
        DELETE FROM @NewMultiLevelIDTable;

        FETCH NEXT FROM cur INTO @BaseMultiLevelID;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- Insert new records into HealthMonitor.Range and HealthMonitor.RangeStats based on the BaseRadio
    DECLARE @NewRangeIDTable TABLE (id INT);
    DECLARE @BaseRangeID INT;

    -- Cursor to iterate over each MultiLevel record for the BaseRadio
    DECLARE  cur CURSOR FOR
        SELECT id FROM HealthMonitor.Range WHERE Radio_Name = @BaseRadioName;

    OPEN cur;
    FETCH NEXT FROM cur INTO @BaseRangeID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert new record into HealthMonitor.Range
        INSERT INTO HealthMonitor.Range (ParameterID, Radio_Name, Enable, start, [end], normal_msg)
            OUTPUT INSERTED.id INTO @NewRangeIDTable
            SELECT ParameterID, @NewRadioName AS Radio_Name, Enable, start, [end], normal_msg
            FROM HealthMonitor.Range
            WHERE id = @BaseRangeID;

        -- Insert new records into HealthMonitor.RangeStats based on the new Range record
        INSERT INTO HealthMonitor.RangeStats (RangeID, range_start, range_end, severity, message)
            SELECT RT.id, RS.range_start, RS.range_end, RS.severity, RS.message
            FROM HealthMonitor.RangeStats RS
                CROSS JOIN @NewRangeIDTable RT
            WHERE RangeID = @BaseRangeID

        -- Clear the table variable for the next iteration
        DELETE FROM @NewRangeIDTable;

        FETCH NEXT FROM cur INTO @BaseRangeID;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- Insert new records into HealthMonitor.EqualString based on the BaseRadio
    INSERT INTO HealthMonitor.EqualString (ParameterID, Radio_Name, Enable, correct, severity, normal_msg, message)
        SELECT ParameterID, @NewRadioName AS Radio_Name, Enable, correct, severity, normal_msg, message
        FROM HealthMonitor.EqualString
        WHERE Radio_Name = @BaseRadioName;

    -- Insert new records into HealthMonitor.PatternString based on the BaseRadio
    INSERT INTO HealthMonitor.PatternString (ParameterID, Radio_Name, Enable, pattern, severity, normal_msg, message)
        SELECT ParameterID, @NewRadioName AS Radio_Name, Enable, pattern, severity, normal_msg, message
        FROM HealthMonitor.PatternString
        WHERE Radio_Name = @BaseRadioName;
END;
GO

CREATE PROCEDURE HealthMonitor.CopyFrequencyParameters
    @NewStation CHAR(10),
    @NewFrequency INT,
    @BaseStation CHAR(10),
    @BaseFrequency INT
AS
BEGIN
    INSERT INTO HealthMonitor.FrequencyParameters
        (ParameterID, Station, Frequency_No, Enable, TXM, TXS, RXM, RXS, Level, message)
    SELECT
        ParameterID,
        @NewStation AS Station,
        @NewFrequency AS Frequency_No,
        Enable,
        TXM,
        TXS,
        RXM,
        RXS,
        Level,
        message
    FROM
        HealthMonitor.FrequencyParameters
    WHERE Station = @BaseStation
      AND Frequency_No = @BaseFrequency
END
GO

CREATE PROCEDURE Final.AddNewRadio
    @RN CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Final.FEAdjustment WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FEAdjustment (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FEConnection WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FEConnection (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FENetwork WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FENetwork (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FEOperation WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FEOperation (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FEStatus WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FEStatus (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FSConfiguration WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FSConfiguration (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FSInstallation WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FSInstallation (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FSNetwork WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FSNetwork (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FSSNMP WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FSSNMP (Radio_Name) VALUES (@RN);
    END
    IF NOT EXISTS (SELECT 1 FROM Final.FSStatus WHERE Radio_Name = @RN) BEGIN
        INSERT INTO Final.FSStatus (Radio_Name) VALUES (@RN);
    END

    IF @RN LIKE '%TX%' BEGIN
        IF NOT EXISTS (SELECT 1 FROM Final.FETXOperation WHERE Radio_Name = @RN) BEGIN
            INSERT INTO Final.FETXOperation (Radio_Name) VALUES (@RN);
        END
        IF NOT EXISTS (SELECT 1 FROM Final.FESpecialSetting WHERE Radio_Name = @RN) BEGIN
            INSERT INTO Final.FESpecialSetting (Radio_Name) VALUES (@RN);
        END
        IF NOT EXISTS (SELECT 1 FROM Final.FSTXConfiguration WHERE Radio_Name = @RN) BEGIN
            INSERT INTO Final.FSTXConfiguration (Radio_Name) VALUES (@RN);
        END
    END ELSE BEGIN
        IF NOT EXISTS (SELECT 1 FROM Final.FERXOperation WHERE Radio_Name = @RN) BEGIN
            INSERT INTO Final.FERXOperation (Radio_Name) VALUES (@RN);
        END
        IF NOT EXISTS (SELECT 1 FROM Final.FSRXConfiguration WHERE Radio_Name = @RN) BEGIN
            INSERT INTO Final.FSRXConfiguration (Radio_Name) VALUES (@RN);
        END
    END
END
GO


CREATE PROCEDURE Analyze.AddNewRadio
    @RN CHAR(10)
AS
BEGIN
    INSERT INTO Analyze.Timer (Radio_Name, ResetDate, RecordType)
        VALUES (@RN, GETUTCDATE(), 0), (@RN, GETUTCDATE(), 1);

    INSERT INTO Analyze.Counter (Radio_Name, ResetDate, RecordType)
        VALUES (@RN, GETUTCDATE(), 0), (@RN, GETUTCDATE(), 1);

END
GO



CREATE PROCEDURE Radio.ActiveNewStation
    @StationCode CHAR(3),
    @ThirdOctet INT,
    @Frequencies INT,
    @BaseStation CHAR(3)='TBZ'
AS
BEGIN
    DECLARE @f INT = 1;
    DECLARE @TXM CHAR(10);
    DECLARE @TXS CHAR(10);
    DECLARE @RXM CHAR(10);
    DECLARE @RXS CHAR(10);
    DECLARE @BTXM CHAR(10);
    DECLARE @BTXS CHAR(10);
    DECLARE @BRXM CHAR(10);
    DECLARE @BRXS CHAR(10);

    -- Update the station availability
    UPDATE RCMS.Radio.Station
    SET Availability = 1
    WHERE RCMS.Radio.Station.Code = @StationCode;

    -- Loop to insert multiple rows
    WHILE @f <= @Frequencies
    BEGIN
        SET @TXM =  CONCAT(@StationCode, '_TX_V', @f, 'M')
        SET @BTXM =  CONCAT(@BaseStation, '_TX_V', @f, 'M')
        SET @TXS =  CONCAT(@StationCode, '_TX_V', @f, 'S')
        SET @BTXS =  CONCAT(@BaseStation, '_TX_V', @f, 'S')
        SET @RXM =  CONCAT(@StationCode, '_RX_V', @f, 'M')
        SET @BRXM =  CONCAT(@BaseStation, '_RX_V', @f, 'M')
        SET @RXS =  CONCAT(@StationCode, '_RX_V', @f, 'S')
        SET @BRXS =  CONCAT(@BaseStation, '_RX_V', @f, 'S')

        INSERT INTO Radio.Radio
            (Name, Station, Frequency_No, Sector, RadioType, MainStandBy, IP)
        VALUES
            (@TXM, @StationCode, @f, 1, 1, 0, CONCAT('192.168.', @ThirdOctet, '.1', @f)),
            (@TXS, @StationCode, @f, 1, 1, 1, CONCAT('192.168.', @ThirdOctet, '.2', @f)),
            (@RXM, @StationCode, @f, 1, 0, 0, CONCAT('192.168.', @ThirdOctet, '.3', @f)),
            (@RXS, @StationCode, @f, 1, 0, 1, CONCAT('192.168.', @ThirdOctet, '.4', @f));

        EXEC Final.AddNewRadio @TXM;
        EXEC Final.AddNewRadio @TXS;
        EXEC Final.AddNewRadio @RXM;
        EXEC Final.AddNewRadio @RXS;

        EXEC Analyze.AddNewRadio @TXM;
        EXEC Analyze.AddNewRadio @TXS;
        EXEC Analyze.AddNewRadio @RXM;
        EXEC Analyze.AddNewRadio @RXS;

        EXEC HealthMonitor.CopyRadioParameters @TXM, @BTXM;
        EXEC HealthMonitor.CopyRadioParameters @TXS, @BTXS;
        EXEC HealthMonitor.CopyRadioParameters @RXM, @BRXM;
        EXEC HealthMonitor.CopyRadioParameters @RXS, @BRXS;

        EXEC HealthMonitor.CopyFrequencyParameters @StationCode, @f, @BaseStation, @f;

        SET @f = @f + 1;
    END;
END;
GO

CREATE PROCEDURE HealthMonitor.UpdateCorrectValues
    @StationCode CHAR(3)
AS
BEGIN
    -- Radio_Name Temp Table
    CREATE TABLE #RadioList (Name CHAR(10));

    INSERT INTO #RadioList (Name) SELECT Name FROM Radio.Radio WHERE Station = @StationCode;

    -- ParameterID Temp Table
    CREATE TABLE #Parameters (
        id INT,
        ParameterCode VARCHAR(50)
    );

    INSERT INTO #Parameters (id, ParameterCode)
    SELECT id, ParameterCode FROM HealthMonitor.Parameters
    WHERE ParameterCode IN ('Frequency', 'RxInputSensitivity', 'CarrierOverride', 'SQLogicOperation', 'CarrierOffset',
                            'IPAddress', 'SecondIPAddress', 'SerialNumber', 'FTPLogin', 'FTPPassword');

    -- Update FixedValue.correct for Frequency
    UPDATE HFV
    SET correct = FEO.FFTR
    FROM HealthMonitor.FixedValue HFV
    JOIN #RadioList rl ON HFV.Radio_Name = rl.Name
    JOIN #Parameters pid ON HFV.ParameterID = pid.id
    JOIN Final.FEOperation FEO ON HFV.Radio_Name = FEO.Radio_Name
    WHERE pid.ParameterCode = 'Frequency';

    -- Update FixedValue.correct for RxInputSensitivity
    UPDATE HFV
    SET correct = FSR.GRIS
    FROM HealthMonitor.FixedValue HFV
    JOIN #RadioList rl ON HFV.Radio_Name = rl.Name
    JOIN #Parameters pid ON HFV.ParameterID = pid.id
    JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = HFV.Radio_Name
    WHERE pid.ParameterCode = 'RxInputSensitivity';

    -- Update FixedValue.correct for CarrierOverride
    UPDATE HFV
    SET correct = FSR.FFCO
    FROM HealthMonitor.FixedValue HFV
    JOIN #RadioList rl ON HFV.Radio_Name = rl.Name
    JOIN #Parameters pid ON HFV.ParameterID = pid.id
    JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = HFV.Radio_Name
    WHERE pid.ParameterCode = 'CarrierOverride';

    -- Update FixedValue.correct for SQLogicOperation
    UPDATE HFV
    SET correct = FSR.FFSL
    FROM HealthMonitor.FixedValue HFV
    JOIN #RadioList rl ON HFV.Radio_Name = rl.Name
    JOIN #Parameters pid ON HFV.ParameterID = pid.id
    JOIN Final.FSRXConfiguration FSR ON FSR.Radio_Name = HFV.Radio_Name
    WHERE pid.ParameterCode = 'SQLogicOperation';

    -- Update FixedValue.correct for CarrierOffset
    UPDATE HFV
    SET correct = FES.FFTO
    FROM HealthMonitor.FixedValue HFV
    JOIN #RadioList rl ON HFV.Radio_Name = rl.Name
    JOIN #Parameters pid ON HFV.ParameterID = pid.id
    JOIN Final.FESpecialSetting FES ON FES.Radio_Name = HFV.Radio_Name
    WHERE pid.ParameterCode = 'CarrierOffset';

    -- Update EqualString.correct for IPAddress
    UPDATE HES
    SET correct = RR.IP
    FROM HealthMonitor.EqualString HES
    JOIN #RadioList rl ON HES.Radio_Name = rl.Name
    JOIN #Parameters pid ON HES.ParameterID = pid.id
    JOIN Radio.Radio RR ON RR.Name = HES.Radio_Name
    WHERE pid.ParameterCode = 'IPAddress';

    -- Update EqualString.correct for SecondIPAddress
    UPDATE HES
    SET correct = FFS.IP
    FROM HealthMonitor.EqualString HES
    JOIN #RadioList rl ON HES.Radio_Name = rl.Name
    JOIN #Parameters pid ON HES.ParameterID = pid.id
    JOIN Final.FSIP FFS ON FFS.Radio_Name = HES.Radio_Name
    WHERE pid.ParameterCode = 'SecondIPAddress' AND
          FFS.IP_Type = 1;

    -- Update EqualString.correct for SerialNumber
    UPDATE HES
    SET correct = FFI.Serial_Number
    FROM HealthMonitor.EqualString HES
    JOIN #RadioList rl ON HES.Radio_Name = rl.Name
    JOIN #Parameters pid ON HES.ParameterID = pid.id
    JOIN Final.FSInventory FFI ON FFI.Radio_Name = HES.Radio_Name
    WHERE pid.ParameterCode = 'SerialNumber' AND
          FFI.R_Index = 0;

    -- Update EqualString.correct for FTPLogin
    UPDATE HES
    SET correct = COALESCE(FFS.RUFL, '')
    FROM HealthMonitor.EqualString HES
    JOIN #RadioList rl ON HES.Radio_Name = rl.Name
    JOIN #Parameters pid ON HES.ParameterID = pid.id
    JOIN Final.FSSNMP FFS ON FFS.Radio_Name = HES.Radio_Name
    WHERE pid.ParameterCode = 'FTPLogin';

    -- Update EqualString.correct for FTPPassword
    UPDATE HES
    SET correct = COALESCE(FFS.RUFP, '')
    FROM HealthMonitor.EqualString HES
    JOIN #RadioList rl ON HES.Radio_Name = rl.Name
    JOIN #Parameters pid ON HES.ParameterID = pid.id
    JOIN Final.FSSNMP FFS ON FFS.Radio_Name = HES.Radio_Name
    WHERE pid.ParameterCode = 'FTPPassword';

    DROP TABLE #RadioList;
    DROP TABLE #Parameters;
END;


