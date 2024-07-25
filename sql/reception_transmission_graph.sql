SELECT FFRS
From Event.Reception
WHERE FFRS IS NOT NULL AND
      Radio_Name = 'BJD_RX_V1M' AND
      Date >= DATEADD(MINUTE, -10, GETDATE())

SELECT Reception.SQ_ON
From Event.Reception
WHERE Reception.SQ_ON IS NOT NULL AND
      Radio_Name = 'BJD_RX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

SELECT Reception.SQ_OFF
From Event.Reception
WHERE Reception.SQ_OFF IS NOT NULL AND
      Radio_Name = 'BJD_RX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

SELECT Reception.Battery_Volt, Reception.DC_Section
From Event.Reception
WHERE Reception.Battery_Volt IS NOT NULL AND
      Radio_Name = 'BJD_RX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

SELECT Reception.RX_Temp, PS_Temp, PA_Temp
From Event.Reception
WHERE Reception.RX_Temp IS NOT NULL AND
      Radio_Name = 'BJD_RX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

--==========================================================================--
--Graph 1: TX Power
SELECT RCTO
From Event.Transmission
WHERE Transmission.RCTO IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -15, GETDATE())

--Graph 2: TX Modulation
SELECT RCMO
From Event.Transmission
WHERE Transmission.RCMO IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -15, GETDATE())

--Graph 3: TX VSWR
SELECT RCTV
From Event.Transmission
WHERE Transmission.RCTV IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -15, GETDATE())

--Graph 4: TX External VSWR
SELECT RCTW
From Event.Transmission
WHERE Transmission.RCTW IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -15, GETDATE())

--Graph 5: TX Voltages
SELECT Transmission.Battery_Volt, Transmission.DC_Section
From Event.Transmission
WHERE Transmission.Battery_Volt IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

--Graph 6: TX Temperature
SELECT TX_Temp, PS_Temp, PA_Temp
From Event.Transmission
WHERE Transmission.TX_Temp IS NOT NULL AND
      Radio_Name = 'BJD_TX_V1M' AND
      Date >= DATEADD(MINUTE, -30, GETDATE())

