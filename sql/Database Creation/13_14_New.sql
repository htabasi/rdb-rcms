USE RCMS;
GO

INSERT INTO Setting.Configuration
    (Date, Radio_Name, Record, AISE, AISF, EVSR, FFBL, FFEA, FFFC, FFLM, FFLT)
SELECT Date, Radio_Name, Record, AISE, AISF, EVSR, FFBL, FFEA, FFFC, FFLM, FFLT
FROM Setting.SRadio
WHERE AISE IS NOT NULL OR
      AISF IS NOT NULL OR
      EVSR IS NOT NULL OR
      FFBL IS NOT NULL OR
      FFEA IS NOT NULL OR
      FFFC IS NOT NULL OR
      FFLM IS NOT NULL OR
      FFLT IS NOT NULL;
GO

INSERT INTO Setting.Installation
    (Date, Radio_Name, Record, AIAI, AIEL, FFFE, FFSC, GRIN, GRLO, MSTY)
SELECT Date, Radio_Name, Record, AIAI, AIEL, FFFE, FFSC, GRIN, GRLO, MSTY
FROM Setting.SRadio
WHERE AIAI IS NOT NULL OR
      AIEL IS NOT NULL OR
      FFFE IS NOT NULL OR
      FFSC IS NOT NULL OR
      GRIN IS NOT NULL OR
      GRLO IS NOT NULL OR
      MSTY IS NOT NULL;
GO

INSERT INTO Setting.Network
    (Date, Radio_Name, Record, GRDH, GRDN, GRIE, GRIV, GRNS, GRVE)
SELECT Date, Radio_Name, Record, GRDH, GRDN, GRIE, GRIV, GRNS, GRVE
FROM Setting.SRadio
WHERE GRDH IS NOT NULL OR
      GRDN IS NOT NULL OR
      GRIE IS NOT NULL OR
      GRIV IS NOT NULL OR
      GRNS IS NOT NULL OR
      GRVE IS NOT NULL;
GO

INSERT INTO Setting.RXConfiguration
    (Date, Radio_Name, Record, AIGA, AITS, FFCO, FFSL, GRBS, GRIS, RIRO)
SELECT Date, Radio_Name, Record, AIGA, AITS, FFCO, FFSL, GRBS, GRIS, RIRO
FROM Setting.SRadio
WHERE AIGA IS NOT NULL OR
      AITS IS NOT NULL OR
      FFCO IS NOT NULL OR
      FFSL IS NOT NULL OR
      GRBS IS NOT NULL OR
      GRIS IS NOT NULL OR
      RIRO IS NOT NULL;
GO

INSERT INTO Setting.SNMP
    (Date, Radio_Name, Record, GRSE, GRSN, RUFL, RUFP)
SELECT Date, Radio_Name, Record, GRSE, GRSN, RUFL, RUFP
FROM Setting.SRadio
WHERE GRSE IS NOT NULL OR
      GRSN IS NOT NULL OR
      RUFL IS NOT NULL OR
      RUFP IS NOT NULL;
GO

INSERT INTO Setting.Status
    (Date, Radio_Name, Record, ERBE, GRLR, GRLT)  --, RCLR, RCLV, GRTI)
SELECT Date, Radio_Name, Record, ERBE, GRLR, GRLT --, RCLR, RCLV, GRTI
FROM Setting.SRadio
WHERE ERBE IS NOT NULL OR
      GRLR IS NOT NULL OR
      GRLT IS NOT NULL;
GO

INSERT INTO Setting.Status
    (Date, Radio_Name, Record, RCLR, RCLV, GRTI)
SELECT Date, Radio_Name, 0, RCLR, RCLV, GRTI
FROM Event.ERadio
WHERE RCLR IS NOT NULL OR
      RCLV IS NOT NULL OR
      GRTI IS NOT NULL;
GO

INSERT INTO Setting.TXConfiguration
    (Date, Radio_Name, Record, AICA, AIML, GRAS, GRCO, GREX, RCDP, RIPC, RIVL, RIVP)
SELECT Date, Radio_Name, Record, AICA, AIML, GRAS, GRCO, GREX, RCDP, RIPC, RIVL, RIVP
FROM Setting.SRadio
WHERE AICA IS NOT NULL OR
      AIML IS NOT NULL OR
      GRAS IS NOT NULL OR
      GRCO IS NOT NULL OR
      GREX IS NOT NULL OR
      RCDP IS NOT NULL OR
      RIPC IS NOT NULL OR
      RIVL IS NOT NULL OR
      RIVP IS NOT NULL;
GO

--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--=*=--

INSERT INTO Event.EAdjustment
    (Date, Radio_Name, AIAD, AILA, AISL, GRME, GRUI, GRUO)
SELECT Date, Radio_Name, AIAD, AILA, AISL, GRME, GRUI, GRUO
FROM Event.ERadio
WHERE AIAD  IS NOT NULL OR
      AILA  IS NOT NULL OR
      AISL  IS NOT NULL OR
      GRME IS NOT NULL OR
      GRUI IS NOT NULL OR
      GRUO IS NOT NULL;
GO

INSERT INTO Event.EConnection
    (Date, Radio_Name, Connection)
SELECT Date, Radio_Name, Connection
FROM Event.Status
WHERE Connection IS NOT NULL ;
GO

INSERT INTO Event.EStatus
    (Date, Radio_Name, Activation, Operation, Access)
SELECT Date, Radio_Name, Activation, Operation, Access
FROM Event.Status
WHERE Activation IS NOT NULL;
GO

INSERT INTO Event.ENetwork
    (Date, Radio_Name, GRHN, GRNA, SCPG, SCSS)
SELECT Date, Radio_Name, GRHN, GRNA, SCPG, SCSS
FROM Event.ERadio
WHERE GRHN IS NOT NULL OR
      GRNA IS NOT NULL OR
      SCPG IS NOT NULL OR
      SCSS IS NOT NULL;
GO

INSERT INTO Event.EOperation
    (Date, Radio_Name, ERGN, FFMD, FFSP, FFTR, MSAC, RCPP)
SELECT Date, Radio_Name, ERGN, FFMD, FFSP, FFTR, MSAC, RCPP
FROM Event.ERadio
WHERE ERGN IS NOT NULL OR
      FFMD IS NOT NULL OR
      FFSP IS NOT NULL OR
      FFTR IS NOT NULL OR
      MSAC IS NOT NULL OR
      RCPP IS NOT NULL;
GO

INSERT INTO Event.RXOperation
    (Date, Radio_Name, FFSN, FFSQ, FFSR, RIRC)
SELECT Date, Radio_Name, FFSN, FFSQ, FFSR, RIRC
FROM Event.ERadio
WHERE FFSN IS NOT NULL OR
      FFSQ IS NOT NULL OR
      FFSR IS NOT NULL OR
      RIRC IS NOT NULL;
GO

INSERT INTO Event.TXOperation
    (Date, Radio_Name, RCMG)
SELECT Date, Radio_Name, RCMG
FROM Event.ERadio
WHERE RCMG IS NOT NULL ;
GO
