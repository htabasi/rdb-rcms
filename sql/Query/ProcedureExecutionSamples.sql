EXEC [Event].Radio_Status_Overall @RadioName='BUZ_RX_V1M';

EXEC [Event].Radio_Status_Overall @RadioName='BJD_RX_V1M';

EXEC [Event].Radio_Status_Special @RadioName='BUZ_RX_V1M', @Parameter=N'Connection' ;

EXEC [Event].Radio_Status_Special @RadioName='BJD_TX_V1M', @Parameter=N'CBIT' ;

EXEC [Event].Radio_Status_Special @RadioName='BJD_TX_V1M', @Parameter=N'Operation' ;

EXEC [Event].Radio_Status_Special @RadioName='BJD_TX_V1S', @Parameter=N'Session' ;

EXEC [Event].Radio_Status_Special @RadioName='BJD_TX_V1M', @Parameter=N'Activation' ;

EXEC [Event].Radio_Status_Special @RadioName='ISN_TX_V2S', @Parameter=N'Operation' ;