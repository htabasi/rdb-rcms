SELECT
    ET.Radio_Name,
    ET.ConnectTimeSec,
    ET.IndicatorOFFSec,
    ET.IndicatorONSec
FROM Event.Timer ET
JOIN Radio.Radio RR ON ET.Radio_Name=RR.Name
JOIN Radio.Sector RS on RS.id = RR.Sector
WHERE RS.Frequency='132.750'
    AND RR.RadioType=1


DELETE FROM RCMS.[Event].[ERadio] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO