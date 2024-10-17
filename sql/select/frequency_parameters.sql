SELECT
    HFP.ParameterID 'pid',
    HFP.Station,
    HFP.Frequency_No,
    HFP.TXM,
    HFP.TXS,
    HFP.RXM,
    HFP.RXS,
    HFP.Level,
    HFP.message
FROM HealthMonitor.FrequencyParameters HFP
Where HFP.Enable = 1;