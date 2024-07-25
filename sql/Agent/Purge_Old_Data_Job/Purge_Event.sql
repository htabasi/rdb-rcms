DELETE FROM RCMS.[Event].[EAdjustment] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[ECBIT] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[EConnection] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[ENetwork] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[EOperation] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[EStatus] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[EventList] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[RXOperation] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[Session] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[SetCommands] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[SpecialSetting] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
DELETE FROM RCMS.[Event].[TXOperation] WHERE DATEDIFF(DAY, [Date], GETUTCDATE()) > (SELECT Keep_Old_Event_Days FROM [Application].[DBParameters]);
GO