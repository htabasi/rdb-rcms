
CREATE TRIGGER trg_AfterInsertRadioStatus
    ON HealthMonitor.RadioStatus
    AFTER INSERT AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            WITH CTE
                AS(
                    SELECT AU.id as user_id
                    FROM inserted I
                        INNER JOIN Radio.Radio RR ON I.Radio_Name=RR.Name
                        INNER JOIN Radio.Station RS ON RR.Station=RS.Code
                        INNER JOIN Radio.UserStation US ON RS.id=US.Station
                        INNER JOIN Django.account_user AU ON US.user_id = AU.id
                )
            INSERT INTO HealthMonitor.RecentAlert (user_id, alert)
            SELECT CTE.user_id, HRS.id From inserted HRS
                CROSS JOIN CTE;

            DECLARE @Radio_Name CHAR(10);
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Radio_Name = I.Radio_Name, @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Insert Trigger',
                    CONCAT('ID:', @ID, 'Radio_Name: ', @Radio_Name, ', ParameterID: ', @ParameterID))
        END CATCH
    END;
GO

CREATE TRIGGER trg_AfterUpdateRadioStatus
    ON HealthMonitor.RadioStatus
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            UPDATE HealthMonitor.RecentAlert SET Seen=0
                WHERE alert IN (SELECT i.id FROM DELETED d JOIN INSERTED i ON d.id = i.id);

            DECLARE @Radio_Name CHAR(10);
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Radio_Name = I.Radio_Name, @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Update Trigger',
                    CONCAT('ID:', @ID, 'Radio_Name: ', @Radio_Name, ', ParameterID: ', @ParameterID))
        END CATCH

    END
GO

CREATE TRIGGER trg_AfterInsertFrequencyStatus
    ON HealthMonitor.FrequencyStatus
    AFTER INSERT AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            WITH CTE
                AS(
                    SELECT AU.id as user_id
                    FROM inserted I
                        INNER JOIN Radio.Station RS ON I.Station=RS.Code
                        INNER JOIN Radio.UserStation US ON RS.id=US.Station
                        INNER JOIN Django.account_user AU ON US.user_id = AU.id
                )
            INSERT INTO HealthMonitor.RecentFrequencyAlert (user_id, alert)
            SELECT CTE.user_id, HRS.id From inserted HRS
                CROSS JOIN CTE;

            DECLARE @Station CHAR(3);
            DECLARE @Freq_No TINYINT;
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Station = I.Station, @Freq_No=I.Frequency_No, @ParameterID = I.ParameterID
            FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Frequency Insert Trigger',
                    CONCAT('ID:', @ID, 'Station: ', @Station, ', Frequency_No: ', @Freq_No, ', ParameterID: ', @ParameterID))
        END CATCH
    END;
go

CREATE TRIGGER trg_AfterUpdateFrequencyStatus
    ON HealthMonitor.FrequencyStatus
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            UPDATE HealthMonitor.RecentFrequencyAlert SET Seen=0
                WHERE alert IN (SELECT i.id FROM DELETED d JOIN INSERTED i ON d.id = i.id);

            DECLARE @Station CHAR(3);
            DECLARE @Freq_No TINYINT;
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Station = I.Station, @Freq_No=I.Frequency_No , @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Frequency Update Trigger',
                    CONCAT('ID:', @ID, 'Station: ', @Station, ', Frequency_No: ', @Freq_No, ', ParameterID: ', @ParameterID))
        END CATCH

    END
go
----------------------------------------------------------------------------------

CREATE TRIGGER trg_AfterInsertRadioStatusMem
    ON HealthMonitor.RadioStatusMem
    AFTER INSERT AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            WITH CTE
                AS(
                    SELECT AU.id as user_id
                    FROM inserted I
                        INNER JOIN Radio.Radio RR ON I.Radio_Name=RR.Name
                        INNER JOIN Radio.Station RS ON RR.Station=RS.Code
                        INNER JOIN Radio.UserStation US ON RS.id=US.Station
                        INNER JOIN Django.account_user AU ON US.user_id = AU.id
                )
            INSERT INTO HealthMonitor.RecentAlert (user_id, alert)
            SELECT CTE.user_id, HRS.id From inserted HRS
                CROSS JOIN CTE;

            DECLARE @Radio_Name CHAR(10);
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Radio_Name = I.Radio_Name, @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Insert Trigger',
                    CONCAT('ID:', @ID, 'Radio_Name: ', @Radio_Name, ', ParameterID: ', @ParameterID))
        END CATCH
    END;
GO

CREATE TRIGGER trg_AfterUpdateRadioStatusMem
    ON HealthMonitor.RadioStatusMem
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            UPDATE HealthMonitor.RecentAlert SET Seen=0
                WHERE alert IN (SELECT i.id FROM DELETED d JOIN INSERTED i ON d.id = i.id);

            DECLARE @Radio_Name CHAR(10);
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Radio_Name = I.Radio_Name, @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Update Trigger',
                    CONCAT('ID:', @ID, 'Radio_Name: ', @Radio_Name, ', ParameterID: ', @ParameterID))
        END CATCH

    END
GO

CREATE TRIGGER trg_AfterDeleteRadioStatusMem
    ON HealthMonitor.RadioStatusMem
    AFTER DELETE AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            DELETE FROM HealthMonitor.RecentAlert
            WHERE alert IN (SELECT d.id FROM deleted d);

            DECLARE @Radio_Name CHAR(10);
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=D.id, @Radio_Name = D.Radio_Name, @ParameterID = D.ParameterID FROM deleted D;
        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Delete Trigger',
                    CONCAT('ID:', @ID, 'Radio_Name: ', @Radio_Name, ', ParameterID: ', @ParameterID))
        END CATCH
    END;
GO

CREATE TRIGGER trg_AfterInsertFrequencyStatusMem
    ON HealthMonitor.FrequencyStatusMem
    AFTER INSERT AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            WITH CTE
                AS(
                    SELECT AU.id as user_id
                    FROM inserted I
                        INNER JOIN Radio.Station RS ON I.Station=RS.Code
                        INNER JOIN Radio.UserStation US ON RS.id=US.Station
                        INNER JOIN Django.account_user AU ON US.user_id = AU.id
                )
            INSERT INTO HealthMonitor.RecentFrequencyAlert (user_id, alert)
            SELECT CTE.user_id, HRS.id From inserted HRS
                CROSS JOIN CTE;

            DECLARE @Station CHAR(3);
            DECLARE @Freq_No TINYINT;
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Station = I.Station, @Freq_No=I.Frequency_No, @ParameterID = I.ParameterID
            FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Frequency Insert Trigger',
                    CONCAT('ID:', @ID, 'Station: ', @Station, ', Frequency_No: ', @Freq_No, ', ParameterID: ', @ParameterID))
        END CATCH
    END;
go

CREATE TRIGGER trg_AfterUpdateFrequencyStatusMem
    ON HealthMonitor.FrequencyStatusMem
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            UPDATE HealthMonitor.RecentFrequencyAlert SET Seen=0
                WHERE alert IN (SELECT i.id FROM DELETED d JOIN INSERTED i ON d.id = i.id);

            DECLARE @Station CHAR(3);
            DECLARE @Freq_No TINYINT;
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=I.id, @Station = I.Station, @Freq_No=I.Frequency_No , @ParameterID = I.ParameterID FROM inserted I;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Frequency Update Trigger',
                    CONCAT('ID:', @ID, 'Station: ', @Station, ', Frequency_No: ', @Freq_No, ', ParameterID: ', @ParameterID))
        END CATCH

    END
go

CREATE TRIGGER trg_AfterDeleteFrequencyStatusMem
    ON HealthMonitor.FrequencyStatusMem
    AFTER DELETE AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            DELETE FROM HealthMonitor.RecentFrequencyAlert
            WHERE alert IN (SELECT d.id FROM deleted d);

            DECLARE @Station CHAR(3);
            DECLARE @Freq_No TINYINT;
            DECLARE @ParameterID INT;
            DECLARE @ID INT;

            SELECT TOP 1 @ID=D.id, @Station = D.Station, @Freq_No=D.Frequency_No , @ParameterID = D.ParameterID FROM deleted D;

        END TRY
        BEGIN CATCH
            INSERT INTO HealthMonitor.ErrorLog (LogDate, Description, Details)
            VALUES (GETUTCDATE(), 'Error in Frequency Delete Trigger',
                    CONCAT('ID:', @ID, 'Station: ', @Station, ', Frequency_No: ', @Freq_No, ', ParameterID: ', @ParameterID))
        END CATCH
    END