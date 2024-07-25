--- Activing In-Memory OLTP
-- Check supporting
SELECT SERVERPROPERTY('IsXTPSupported')
GO
-- Active for database
ALTER DATABASE RCMS
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON
GO
-- check if In-Memory OLTP is active for database
SELECT name, is_memory_optimized_elevate_to_snapshot_on
FROM sys.databases
WHERE is_memory_optimized_elevate_to_snapshot_on = 1
GO

--ایجاد یک Filegroup جدید با CONTAINS MEMORY_OPTIMIZED_DATA:

ALTER DATABASE RCMS
ADD FILEGROUP OLTP_RCMS_FG CONTAINS MEMORY_OPTIMIZED_DATA
GO

--اضافه کردن فایل به Filegroup:

ALTER DATABASE RCMS
ADD FILE (name = 'RCMS_OLTP', filename = '/var/opt/mssql/data/RCMS.oltp')
TO FILEGROUP OLTP_RCMS_FG
GO
