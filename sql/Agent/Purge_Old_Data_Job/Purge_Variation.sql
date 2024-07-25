DELETE FROM RCMS.[Variation].[Reception] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Variation_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Variation].[Temperature] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Variation_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Variation].[Transmission] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Variation_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Variation].[Voltage] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Variation_Days FROM [Application].[DBParameters]);
GO