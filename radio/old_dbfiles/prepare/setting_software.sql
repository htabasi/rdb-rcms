SELECT Partition, Version, Part_Number, Status
FROM Setting.Software WHERE Radio_Name='{}' AND
      Date IN (SELECT TOP 1 Date FROM Setting.Software WHERE Radio_Name='{}' GROUP BY Date ORDER BY Date DESC)
ORDER BY Partition;