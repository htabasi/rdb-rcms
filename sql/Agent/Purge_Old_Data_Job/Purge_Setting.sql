DELETE FROM RCMS.[Setting].[Access] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Configuration] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Installation] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Inventory] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[IP] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Network] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[RXConfiguration] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[SCBIT] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[SNMP] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Software] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[Status] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Setting].[TXConfiguration] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Setting_Days FROM [Application].[DBParameters]);
GO