Select
	est.id,
	est.Date,
	est.Radio_Name,
	est.Connection,
	cco.Stat,
	est.CBIT,
	cel.Level,
	est.Access,
	cca.Stat,
	est.Activation,
	cac.Stat,
	est.Operation,
	cop.Stat
From 
	Event.Status est
		full Join
	[RCMS].[Common].Conn cco ON est.Connection = cco.id
		full Join
	Common.EventLevel cel ON est.CBIT = cel.id
		full Join
	Common.ControlAccess cca ON est.Access = cca.id
		full Join
	Common.Activation cac ON est.Activation = cac.id
		full Join
	Common.Operation cop ON est.Operation = cop.id
;