SELECT SAC.Date, SAC.Radio_Name, SAC.ACL_Index, SAC.Allowed_IP
FROM Setting.Access SAC
INNER JOIN (
    SELECT Radio_Name, ACL_Index, MAX(Date) as MaxDate
    FROM Setting.Access
    GROUP BY Radio_Name, ACL_Index
) SAD
ON SAC.Radio_Name = SAD.Radio_Name AND SAC.ACL_Index = SAD.ACL_Index AND SAC.Date = SAD.MaxDate
WHERE SAC.Radio_Name='BJD_TX_V2S'