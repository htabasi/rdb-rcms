USE RCMS;
GO

Delete From Django.account_sendkeycommand
GO

SELECT [CKey], [id] as Key_id, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id
 INTO #TempCKey
 FROM [RCMS].[Command].[KeyInformation]
 Where [Command].[KeyInformation].Fully_Identified=1
GO

SET IDENTITY_INSERT [RCMS].[Django].[account_sendkeycommand] ON;
INSERT INTO [RCMS].[Django].[account_sendkeycommand]
	(id, CKey, Key_id)
Select id, [CKey], Key_id
FROM #TempCKey;
SET IDENTITY_INSERT [RCMS].[Django].[account_sendkeycommand] OFF;
GO

Drop table #TempCKey;

