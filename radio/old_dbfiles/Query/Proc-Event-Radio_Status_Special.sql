USE [RCMS]
GO

/****** Object:  StoredProcedure [Event].[Radio_Status_Special]    Script Date: 12/9/2023 9:14:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
در این پروسیجر وقایع مربوط به
	* Radio Connection Events
	* Changes is Radio CBIT Level
	* Changes in radio sessions
	* Changes in Activation status
	* Changes in Operation (Go / No GO) Status
در خروجی آورده می شود.
این پروسیجر دو ورودی میگیرد:

@RadioName:	(Same as 'BUZ_RX_V1M' or 'BJD_TX_V3S')
	این پارامتر نام رادیویی است که میخواهیم نتایج خروجی اطلاعات آن رادیو باشد.

@Parameter	('Connection', 'CBIT', 'Session', 'Activation', 'Operation')
	تعیین میکند کدام تغییر حالت رادیو باید در خروجی حاضر باشد.
	این پارامتر 5 مقدار مختلف میتواند داشته باشد که در زیر آورده می شوند:
	'Connection':
		در این حالت وقایع مربوط به اتصال به رادیو آورده می شود
	'CBIT':
		در این حالت وقایع مربوط به همین پارامتر آورده می شود.
	'Session' or 'Activation' or 'Operation':
		هر کدام از این سه مقدار در ورودی قرار بگیرد باعث می شود تغییرات هر سه این پارامترها آورده شود
*/


CREATE PROCEDURE [Event].[Radio_Status_Special]
    @RadioName CHAR(10),
    @Parameter CHAR(10)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = N'SELECT
                    est.id,
                    est.Date,
                    est.Radio_Name,
                    cco.Stat AS ''Connection Status'',
                    cel.Level AS ''CBIT Level'',
                    cca.Stat AS ''Session Status'',
                    cac.Stat AS ''Activation Status'',
                    cop.Stat AS ''Operation Status''
                FROM 
                    [RCMS].[Event].[Status] est
                    FULL JOIN [RCMS].[Common].[Conn] cco ON est.Connection = cco.id
                    FULL JOIN [RCMS].[Common].[EventLevel] cel ON est.CBIT = cel.id
                    FULL JOIN [RCMS].[Common].[ControlAccess] cca ON est.Access = cca.id
                    FULL JOIN [RCMS].[Common].[Activation] cac ON est.Activation = cac.id
                    FULL JOIN [RCMS].[Common].[Operation] cop ON est.Operation = cop.id
                WHERE
                    est.Radio_Name = @RadioName'
    
    IF @Parameter = N'Connection'
        SET @SQL = @SQL + N' AND cco.Stat IS NOT NULL'
    ELSE IF @Parameter = N'CBIT'
        SET @SQL = @SQL + N' AND cel.Level IS NOT NULL'
    ELSE IF @Parameter = N'Session'
        SET @SQL = @SQL + N' AND cca.Stat IS NOT NULL'
    ELSE IF @Parameter = N'Activation'
        SET @SQL = @SQL + N' AND cac.Stat IS NOT NULL'
    ELSE IF @Parameter = N'Operation'
        SET @SQL = @SQL + N' AND cop.Stat IS NOT NULL'

    EXEC sp_executesql @SQL, N'@RadioName CHAR(10)', @RadioName
END
GO


