USE RCMS
GO

WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AIAD FROM Event.EAdjustment WHERE AIAD IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AIAD,
        (SELECT TOP 1 AILA FROM Event.EAdjustment WHERE AILA IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AILA,
        (SELECT TOP 1 AISL FROM Event.EAdjustment WHERE AISL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AISL,
        (SELECT TOP 1 GRME FROM Event.EAdjustment WHERE GRME IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRME,
        (SELECT TOP 1 GRUI FROM Event.EAdjustment WHERE GRUI IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRUI,
        (SELECT TOP 1 GRUO FROM Event.EAdjustment WHERE GRUO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRUO
    FROM Radio.Radio
)
INSERT INTO Final.FEAdjustment
    (Radio_Name,  AIAD, AILA, AISL, GRME, GRUI, GRUO)
SELECT Radio_Name,  AIAD, AILA, AISL, GRME, GRUI, GRUO
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 Connection FROM Event.EConnection WHERE Connection IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS Connection
    FROM Radio.Radio
)
INSERT INTO Final.FEConnection
    (Radio_Name,  Connection)
SELECT Radio_Name,  Connection
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 GRHN FROM Event.ENetwork WHERE GRHN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRHN,
        (SELECT TOP 1 GRNA FROM Event.ENetwork WHERE GRNA IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRNA,
        (SELECT TOP 1 SCPG FROM Event.ENetwork WHERE SCPG IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS SCPG,
        (SELECT TOP 1 SCSS FROM Event.ENetwork WHERE SCSS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS SCSS
    FROM Radio.Radio
)
INSERT INTO Final.FENetwork
    (Radio_Name,  GRHN, GRNA, SCPG, SCSS)
SELECT Radio_Name,  GRHN, GRNA, SCPG, SCSS
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 ERGN FROM Event.EOperation WHERE ERGN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS ERGN,
        (SELECT TOP 1 FFMD FROM Event.EOperation WHERE FFMD IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFMD,
        (SELECT TOP 1 FFSP FROM Event.EOperation WHERE FFSP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSP,
        (SELECT TOP 1 FFTR FROM Event.EOperation WHERE FFTR IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFTR,
        (SELECT TOP 1 MSAC FROM Event.EOperation WHERE MSAC IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS MSAC,
        (SELECT TOP 1 RCPP FROM Event.EOperation WHERE RCPP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCPP
    FROM Radio.Radio
)
INSERT INTO Final.FEOperation
    (Radio_Name,  ERGN, FFMD, FFSP, FFTR, MSAC, RCPP)
SELECT Radio_Name,  ERGN, FFMD, FFSP, FFTR, MSAC, RCPP
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 Activation FROM Event.EStatus WHERE Activation IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS Activation,
        (SELECT TOP 1 Operation FROM Event.EStatus WHERE Operation IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS Operation,
        (SELECT TOP 1 Access FROM Event.EStatus WHERE Access IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS Access
    FROM Radio.Radio
)
INSERT INTO Final.FEStatus
    (Radio_Name,  Activation, Operation, Access)
SELECT Radio_Name,  Activation, Operation, Access
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 FFSN FROM Event.RXOperation WHERE FFSN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSN,
        (SELECT TOP 1 FFSQ FROM Event.RXOperation WHERE FFSQ IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSQ,
        (SELECT TOP 1 FFSR FROM Event.RXOperation WHERE FFSR IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSR,
        (SELECT TOP 1 RIRC FROM Event.RXOperation WHERE RIRC IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RIRC
    FROM Radio.Radio
)
INSERT INTO Final.FERXOperation
    (Radio_Name,  FFSN, FFSQ, FFSR, RIRC)
SELECT Radio_Name,  FFSN, FFSQ, FFSR, RIRC
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AITP FROM Event.SpecialSetting WHERE AITP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AITP,
        (SELECT TOP 1 FFTO FROM Event.SpecialSetting WHERE FFTO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFTO,
        (SELECT TOP 1 RCIT FROM Event.SpecialSetting WHERE RCIT IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCIT,
        (SELECT TOP 1 RCLP FROM Event.SpecialSetting WHERE RCLP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCLP,
        (SELECT TOP 1 RCNP FROM Event.SpecialSetting WHERE RCNP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCNP,
        (SELECT TOP 1 RCTS FROM Event.SpecialSetting WHERE RCTS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCTS
    FROM Radio.Radio
)
INSERT INTO Final.FESpecialSetting
    (Radio_Name,  AITP, FFTO, RCIT, RCLP, RCNP, RCTS)
SELECT Radio_Name,  AITP, FFTO, RCIT, RCLP, RCNP, RCTS
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 RCMG FROM Event.TXOperation WHERE RCMG IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCMG
    FROM Radio.Radio
)
INSERT INTO Final.FETXOperation
    (Radio_Name,  RCMG)
SELECT Radio_Name,  RCMG
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AISE FROM Setting.Configuration WHERE AISE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AISE,
        (SELECT TOP 1 AISF FROM Setting.Configuration WHERE AISF IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AISF,
        (SELECT TOP 1 EVSR FROM Setting.Configuration WHERE EVSR IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS EVSR,
        (SELECT TOP 1 FFBL FROM Setting.Configuration WHERE FFBL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFBL,
        (SELECT TOP 1 FFEA FROM Setting.Configuration WHERE FFEA IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFEA,
        (SELECT TOP 1 FFFC FROM Setting.Configuration WHERE FFFC IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFFC,
        (SELECT TOP 1 FFLM FROM Setting.Configuration WHERE FFLM IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFLM,
        (SELECT TOP 1 FFLT FROM Setting.Configuration WHERE FFLT IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFLT
    FROM Radio.Radio
)
INSERT INTO Final.FSConfiguration
    (Radio_Name,  AISE, AISF, EVSR, FFBL, FFEA, FFFC, FFLM, FFLT)
SELECT Radio_Name,  AISE, AISF, EVSR, FFBL, FFEA, FFFC, FFLM, FFLT
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AIAI FROM Setting.Installation WHERE AIAI IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AIAI,
        (SELECT TOP 1 AIEL FROM Setting.Installation WHERE AIEL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AIEL,
        (SELECT TOP 1 FFFE FROM Setting.Installation WHERE FFFE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFFE,
        (SELECT TOP 1 FFSC FROM Setting.Installation WHERE FFSC IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSC,
        (SELECT TOP 1 GRIN FROM Setting.Installation WHERE GRIN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRIN,
        (SELECT TOP 1 GRLO FROM Setting.Installation WHERE GRLO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRLO,
        (SELECT TOP 1 MSTY FROM Setting.Installation WHERE MSTY IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS MSTY
    FROM Radio.Radio
)
INSERT INTO Final.FSInstallation
    (Radio_Name,  AIAI, AIEL, FFFE, FFSC, GRIN, GRLO, MSTY)
SELECT Radio_Name,  AIAI, AIEL, FFFE, FFSC, GRIN, GRLO, MSTY
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 GRDH FROM Setting.Network WHERE GRDH IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRDH,
        (SELECT TOP 1 GRDN FROM Setting.Network WHERE GRDN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRDN,
        (SELECT TOP 1 GRIE FROM Setting.Network WHERE GRIE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRIE,
        (SELECT TOP 1 GRIV FROM Setting.Network WHERE GRIV IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRIV,
        (SELECT TOP 1 GRNS FROM Setting.Network WHERE GRNS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRNS,
        (SELECT TOP 1 GRVE FROM Setting.Network WHERE GRVE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRVE
    FROM Radio.Radio
)
INSERT INTO Final.FSNetwork
    (Radio_Name,  GRDH, GRDN, GRIE, GRIV, GRNS, GRVE)
SELECT Radio_Name,  GRDH, GRDN, GRIE, GRIV, GRNS, GRVE
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AIGA FROM Setting.RXConfiguration WHERE AIGA IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AIGA,
        (SELECT TOP 1 AITS FROM Setting.RXConfiguration WHERE AITS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AITS,
        (SELECT TOP 1 FFCO FROM Setting.RXConfiguration WHERE FFCO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFCO,
        (SELECT TOP 1 FFSL FROM Setting.RXConfiguration WHERE FFSL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS FFSL,
        (SELECT TOP 1 GRBS FROM Setting.RXConfiguration WHERE GRBS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRBS,
        (SELECT TOP 1 GRIS FROM Setting.RXConfiguration WHERE GRIS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRIS,
        (SELECT TOP 1 RIRO FROM Setting.RXConfiguration WHERE RIRO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RIRO
    FROM Radio.Radio
)
INSERT INTO Final.FSRXConfiguration
    (Radio_Name,  AIGA, AITS, FFCO, FFSL, GRBS, GRIS, RIRO)
SELECT Radio_Name,  AIGA, AITS, FFCO, FFSL, GRBS, GRIS, RIRO
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 GRSE FROM Setting.SNMP WHERE GRSE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRSE,
        (SELECT TOP 1 GRSN FROM Setting.SNMP WHERE GRSN IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRSN,
        (SELECT TOP 1 RUFL FROM Setting.SNMP WHERE RUFL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RUFL,
        (SELECT TOP 1 RUFP FROM Setting.SNMP WHERE RUFP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RUFP
    FROM Radio.Radio
)
INSERT INTO Final.FSSNMP
    (Radio_Name,  GRSE, GRSN, RUFL, RUFP)
SELECT Radio_Name,  GRSE, GRSN, RUFL, RUFP
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 ERBE FROM Setting.Status WHERE ERBE IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS ERBE,
        (SELECT TOP 1 GRLR FROM Setting.Status WHERE GRLR IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRLR,
        (SELECT TOP 1 GRLT FROM Setting.Status WHERE GRLT IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRLT,
        (SELECT TOP 1 GRTI FROM Setting.Status WHERE GRTI IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRTI,
        (SELECT TOP 1 RCLR FROM Setting.Status WHERE RCLR IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCLR,
        (SELECT TOP 1 RCLV FROM Setting.Status WHERE RCLV IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCLV
    FROM Radio.Radio
)
INSERT INTO Final.FSStatus
    (Radio_Name, ERBE, GRLR, GRLT, GRTI, RCLR, RCLV)
SELECT Radio_Name, ERBE, GRLR, GRLT, GRTI, RCLR, RCLV
FROM RadioCTE;
GO


WITH RadioCTE AS (
    SELECT
        Name AS Radio_Name,
        (SELECT TOP 1 AICA FROM Setting.TXConfiguration WHERE AICA IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AICA,
        (SELECT TOP 1 AIML FROM Setting.TXConfiguration WHERE AIML IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS AIML,
        (SELECT TOP 1 GRAS FROM Setting.TXConfiguration WHERE GRAS IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRAS,
        (SELECT TOP 1 GRCO FROM Setting.TXConfiguration WHERE GRCO IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GRCO,
        (SELECT TOP 1 GREX FROM Setting.TXConfiguration WHERE GREX IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS GREX,
        (SELECT TOP 1 RCDP FROM Setting.TXConfiguration WHERE RCDP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RCDP,
        (SELECT TOP 1 RIPC FROM Setting.TXConfiguration WHERE RIPC IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RIPC,
        (SELECT TOP 1 RIVL FROM Setting.TXConfiguration WHERE RIVL IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RIVL,
        (SELECT TOP 1 RIVP FROM Setting.TXConfiguration WHERE RIVP IS NOT NULL AND Radio_Name=Radio.Radio.Name ORDER BY Date DESC) AS RIVP
    FROM Radio.Radio
)
INSERT INTO Final.FSTXConfiguration
    (Radio_Name,  AICA, AIML, GRAS, GRCO, GREX, RCDP, RIPC, RIVL, RIVP)
SELECT Radio_Name,  AICA, AIML, GRAS, GRCO, GREX, RCDP, RIPC, RIVL, RIVP
FROM RadioCTE;
GO
