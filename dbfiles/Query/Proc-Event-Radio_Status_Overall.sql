USE [RCMS]
GO

/****** Object:  StoredProcedure [Event].[Radio_Status_Overall]    Script Date: 12/9/2023 9:13:23 PM ******/
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
این پروسیجر یک ورودی میگیرد:

@RadioName:	(Same as 'BUZ_RX_V1M' or 'BJD_TX_V3S')
	این پارامتر نام رادیویی است که میخواهیم نتایج خروجی اطلاعات آن رادیو باشد.
*/

CREATE PROCEDURE [Event].[Radio_Status_Overall]
    @RadioName CHAR(10)
AS
BEGIN
    SELECT
        est.id,
        est.Date,
        est.Radio_Name,
        cco.Stat AS 'Connection Status',
        cel.Level AS 'CBIT Level',
        cca.Stat AS 'Session Status',
        cac.Stat AS 'Activation Status',
        cop.Stat AS 'Operation Status'
    FROM 
        [RCMS].[Event].[Status] est
        FULL JOIN [RCMS].[Common].[Conn] cco ON est.Connection = cco.id
        FULL JOIN [RCMS].[Common].[EventLevel] cel ON est.CBIT = cel.id
        FULL JOIN [RCMS].[Common].[ControlAccess] cca ON est.Access = cca.id
        FULL JOIN [RCMS].[Common].[Activation] cac ON est.Activation = cac.id
        FULL JOIN [RCMS].[Common].[Operation] cop ON est.Operation = cop.id
    WHERE
        est.Radio_Name = @RadioName;
END;
GO


