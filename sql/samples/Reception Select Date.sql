SELECT 
	ER.id,
	ER.FFRS,
	ER.SQ,
	ER.SQ_AGE,
	ER.SQ_ON,
	ER.SQ_OFF
FROM Event.Reception ER
WHERE 
	(ER.FFRS IS NOT NULL or ER.SQ IS NOT NULL)
	AND
	(ER.Date < CAST('2023-11-10' AS DATE) AND ER.Date > CAST('2023-11-08' AS DATE))