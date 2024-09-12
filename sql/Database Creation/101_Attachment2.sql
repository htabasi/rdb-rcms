EXEC NewRangeParameterTX @ParameterCode='AnalyzedTXPowerValue', @ParameterName='Analyzed TX Power Value',
     @OK='OK', @Start=48, @End=52;

EXEC NewRangeStatus @ParameterCode='AnalyzedTXPowerValue', @Start=-1, @End=46, @Severity=2,
     @Message='TX Power Value (Analyzed) Low ({})';

EXEC NewRangeStatus @ParameterCode='AnalyzedTXPowerValue', @Start=46, @End=48, @Severity=1,
     @Message='TX Power Value (Analyzed) Below Normal ({})';

EXEC NewRangeStatus @ParameterCode='AnalyzedTXPowerValue', @Start=52, @End=-1, @Severity=1,
     @Message='TX Power Value (Analyzed) above Normal ({})';
-----------------------------------------------------------------------------------------------------

EXEC NewRangeParameterTX @ParameterCode='AnalyzedModulationDepthValue',
     @ParameterName='Analyzed Modulation Depth Value', @OK='OK', @Start=85, @End=96;

EXEC NewRangeStatus @ParameterCode='AnalyzedModulationDepthValue', @Start=-1, @End=30, @Severity=2,
     @Message='TX Pressed without Modulation (Analyzed Mod={}%)';

EXEC NewRangeStatus @ParameterCode='AnalyzedModulationDepthValue', @Start=30, @End=75, @Severity=2,
     @Message='Modulation Depth Value (Analyzed) Low ({}%)';

EXEC NewRangeStatus @ParameterCode='AnalyzedModulationDepthValue', @Start=75, @End=85, @Severity=1,
     @Message='Modulation Depth Value (Analyzed) below Normal ({}%)';

EXEC NewRangeStatus @ParameterCode='AnalyzedModulationDepthValue', @Start=96, @End=-1, @Severity=1,
     @Message='Modulation Depth Value (Analyzed) above Normal ({})';
-----------------------------------------------------------------------------------------------------

EXEC NewRangeParameterTX @ParameterCode='AnalyzedVSWRValue', @ParameterName='Analyzed VSWR Value', @OK='OK',
     @Start=-1, @End=1.7;

EXEC NewRangeStatus @ParameterCode='AnalyzedVSWRValue', @Start=1.7, @End=2, @Severity=1,
     @Message='VSWR Value (Analyzed) above Normal ({})';

EXEC NewRangeStatus @ParameterCode='AnalyzedVSWRValue', @Start=2, @End=-1, @Severity=2,
     @Message='VSWR Value (Analyzed) High ({})';
-----------------------------------------------------------------------------------------------------

EXEC NewRangeParameterTX @ParameterCode='AnalyzedExternalVSWRVoltage',
     @ParameterName='Analyzed External VSWR Voltage', @OK='OK', @Start=4.9, @End=-1;

EXEC NewRangeStatus @ParameterCode='AnalyzedExternalVSWRVoltage', @Start=-1, @End=4.9, @Severity=1,
     @Message='External VSWR Voltage (Analyzed) Low ({})';
-----------------------------------------------------------------------------------------------------

Update HealthMonitor.Range
SET RCMS.HealthMonitor.Range.Enable=0
Where RCMS.HealthMonitor.Range.ParameterID=(SELECT id FROM HealthMonitor.Parameters Where ParameterCode='TXPowerValue')

Update HealthMonitor.Range
SET RCMS.HealthMonitor.Range.Enable=0
Where RCMS.HealthMonitor.Range.ParameterID=(SELECT id FROM HealthMonitor.Parameters Where ParameterCode='ModulationDepthValue')

Update HealthMonitor.Range
SET RCMS.HealthMonitor.Range.Enable=0
Where RCMS.HealthMonitor.Range.ParameterID=(SELECT id FROM HealthMonitor.Parameters Where ParameterCode='VSWRValue')

Update HealthMonitor.Range
SET RCMS.HealthMonitor.Range.Enable=0
Where RCMS.HealthMonitor.Range.ParameterID=(SELECT id FROM HealthMonitor.Parameters Where ParameterCode='ExternalVSWRVoltage')
