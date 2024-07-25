SELECT
    (Select CAST(COUNT(*) AS DECIMAL(10, 3)) / 600 AS Result FROM [Memory].[LatestReception]) AS RX_PPS,
    (Select CAST(COUNT(*) AS DECIMAL(10, 3)) / 600 AS Result FROM [Memory].[LatestTransmissioin]) AS TX_PPS,
    (Select CAST(COUNT(*) AS DECIMAL(10, 3)) / 600 AS Result FROM [Memory].[LatestVoltage]) AS DC_PPS,
    (Select CAST(COUNT(*) AS DECIMAL(10, 3)) / 600 AS Result FROM [Memory].[LatestTemparature]) AS TEMP_PPS;

DECLARE @RX_Count1 INT;
DECLARE @TX_Count2 INT;

DECLARE @RX_Minute1 INT;
DECLARE @TX_Minute1 INT;
DECLARE @DC_Minute1 INT;
DECLARE @TEMP_Minute1 INT;

DECLARE @RX_RC1 INT;
DECLARE @TX_RC1 INT;
DECLARE @DC_RC1 INT;
DECLARE @TEMP_RC1 INT;

SET @RX_Count1 = (SELECT Count(RR.id) From Radio.Radio RR WHERE RadioType=0);
--SET @RX_Count = 100;
SET @TX_Count2 = (SELECT Count(RR.id) From Radio.Radio RR WHERE RadioType=1);
--SET @TX_Count = 100;

SET @RX_Minute1 = 10;
SET @TX_Minute1 = 10;
SET @DC_Minute1 = 15;
SET @TEMP_Minute1 = 15;

SET @RX_RC1 = (Select COUNT(*) FROM [Memory].[LatestReception]);
SET @TX_RC1 = (Select COUNT(*) FROM [Memory].[LatestTransmission]);
SET @DC_RC1 = (Select COUNT(*) FROM [Memory].[LatestVoltage]);
SET @TEMP_RC1 = (Select COUNT(*) FROM [Memory].[LatestTemperature]);

SELECT
    (CAST(@RX_RC1 / (60 * @RX_Count1 * @RX_Minute1) AS DECIMAL(10, 3)))                    AS RX_PPS,
    (CAST(@TX_RC1 / (60 * @TX_Count2 * @TX_Minute1) AS DECIMAL(10, 3)))                    AS TX_PPS,
    (CAST(@DC_RC1 / (60 * (@RX_Count1 + @TX_Count2) * @DC_Minute1) AS DECIMAL(10, 3)))     AS DC_PPS,
    (CAST(@TEMP_RC1 / (60 * (@RX_Count1 + @TX_Count2) * @TEMP_Minute1) AS DECIMAL(10, 3))) AS TEMP_PPS;