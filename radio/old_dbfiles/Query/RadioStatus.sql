Select
	est.id,
	est.Date,
	est.Radio_Name,
	cco.Stat 'Connection Status',
	cel.Level 'CBIT Level',
	cca.Stat 'Session Status',
	cac.Stat 'Activation Status',
	cop.Stat 'Operation Status'
From 
	[RCMS].[Event].[Status] est
		full Join
	[RCMS].[Common].[Conn] cco ON est.Connection = cco.id
		full Join
	[RCMS].[Common].[EventLevel] cel ON est.CBIT = cel.id
		full Join
	[RCMS].[Common].[ControlAccess] cca ON est.Access = cca.id
		full Join
	[RCMS].[Common].[Activation] cac ON est.Activation = cac.id
		full Join
	[RCMS].[Common].[Operation] cop ON est.Operation = cop.id;