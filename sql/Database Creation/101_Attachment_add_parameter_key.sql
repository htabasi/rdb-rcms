-- alter table HealthMonitor.Parameters
--     add [Key] INT default Null FOREIGN KEY REFERENCES Command.KeyInformation (id)
-- go
--

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AIAD')
    Where ParameterCode='AudioDelay'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AIAI')
    Where ParameterCode='AudioInterface'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AICA')
    Where ParameterCode='TxAudioALC'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AIEL')
    Where ParameterCode='LineInterfaceInLocalMode'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AIGA')
    Where ParameterCode='RxAudioAGC'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AILA')
    Where ParameterCode='AudioLevel'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='AITP')
    Where ParameterCode='TxPreEmphasis'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='ERBE')
    Where ParameterCode='BootErrorList'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='ERGN')
    Where ParameterCode='GONOGOStatus'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFCO')
    Where ParameterCode='CarrierOverride'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFEA')
    Where ParameterCode='ACARSDataMode'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFLM')
    Where ParameterCode='LocalMode'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFLT')
    Where ParameterCode='LocalModeTimeout'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFMD')
    Where ParameterCode='ModulationMode'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSC')
    Where ParameterCode='SingleChannel'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSL')
    Where ParameterCode='SQLogicOperation'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSN')
    Where ParameterCode='SNRSquelchThreshold'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSP')
    Where ParameterCode='ChannelSpacing'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSQ')
    Where ParameterCode='SQCircuit'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFSR')
    Where ParameterCode='RSSISquelchThreshold'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFTO')
    Where ParameterCode='CarrierOffset'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='FFTR')
    Where ParameterCode='Frequency'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRAS')
    Where ParameterCode='ATRSwitchMode'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRDH')
    Where ParameterCode='DHCPEnabled'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRHN')
    Where ParameterCode='Hostname'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRIE')
    Where ParameterCode='SecondIPAddressEnabled'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRIN')
    Where ParameterCode='InstallationInfo'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRIS')
    Where ParameterCode='RxInputSensitivity'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRIV')
    Where ParameterCode='IPv6Enabled'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRLR')
    Where ParameterCode='MeasureRXAudioLevel'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRLT')
    Where ParameterCode='MeasureTXAudioLevel'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRNA')
    Where ParameterCode='NTPSyncActive'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRNS')
    Where ParameterCode='NTPServer'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRSE')
    Where ParameterCode='SNMPEnable'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRSN')
    Where ParameterCode='SNMPCommunityString'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='GRVE')
    Where ParameterCode='GB2PPVersion'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RIRO')
    Where ParameterCode='RSSIOutputType'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='MSAC')
    Where ParameterCode='ActivationStatus'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='MSTY')
    Where ParameterCode='MainStandbyType'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCDP')
    Where ParameterCode='PTTTimeout'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCIT')
    Where ParameterCode='TXInhibition'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCLP')
    Where ParameterCode='TxLowPowerLevel'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCMG')
    Where ParameterCode='ModulationDepthSetting'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCMO')
    Where ParameterCode='ModulationDepthValue'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCPP')
    Where ParameterCode='PresetPageNumber'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCTO')
    Where ParameterCode='TXPowerValue'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCTV')
    Where ParameterCode='VSWRValue'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCTW')
    Where ParameterCode='VSWRLED'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RCVV')
    Where ParameterCode='ExternalVSWRVoltage'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RIPC')
    Where ParameterCode='PTTInputConfiguration'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RIVL')
    Where ParameterCode='EXTVSWRlimit'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RIVP')
    Where ParameterCode='EXTVSWRPolarity'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RUFL')
    Where ParameterCode='FTPLogin'

UPDATE HealthMonitor.Parameters
    SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RUFP')
    Where ParameterCode='FTPPassword'

-- UPDATE HealthMonitor.Parameters
--     SET [Key]=(SELECT id From Command.KeyInformation Where CKey='RUFP')
--     Where ParameterCode='FTPPassword'
