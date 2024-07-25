/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [id]
      ,[Date]
      ,[Radio_Name]
      ,[RCTV]
  FROM [RCMS].[Event].[Transmission]
  Where [RCTV] is not null and RCTV > 0