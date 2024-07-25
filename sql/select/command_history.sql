SELECT CH.id,
       CH.user_id,
       KI.id as CKey_id,
       CH.CKey,
       CH.Request,
       CH.Value
FROM Command.History CH
    JOIN Command.KeyInformation KI on CH.CKey = KI.CKey
WHERE CH.Status=1 AND CH.Radio='{}' AND CH.RegisterTime >= DATEADD(minute , -5, GETUTCDATE())
ORDER BY CH.id;