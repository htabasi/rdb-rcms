SELECT ACL_Index, Allowed_IP FROM Setting.Access WHERE Radio_Name='{}' AND Date in (SELECT TOP 1 Date FROM Setting.Access WHERE Radio_Name='{}' GROUP BY Date ORDER BY Date DESC);