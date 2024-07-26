CREATE TRIGGER trg_UpdateFEAdjustment
ON Event.EAdjustment
AFTER INSERT
AS
BEGIN
UPDATE FEA SET FEA.AIAD = I.AIAD
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.AIAD IS NOT NULL AND
            I.AIAD <> FEA.AIAD;

UPDATE FEA SET FEA.AILA = I.AILA
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.AILA IS NOT NULL AND
            I.AILA <> FEA.AILA;

UPDATE FEA SET FEA.AISL = I.AISL
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.AISL IS NOT NULL AND
            I.AISL <> FEA.AISL;

UPDATE FEA SET FEA.GRME = I.GRME
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.GRME IS NOT NULL AND
            I.GRME <> FEA.GRME;

UPDATE FEA SET FEA.GRUI = I.GRUI
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.GRUI IS NOT NULL AND
            I.GRUI <> FEA.GRUI;

UPDATE FEA SET FEA.GRUO = I.GRUO
    FROM Final.FEAdjustment FEA
    INNER JOIN inserted I
        ON
            FEA.Radio_Name = I.Radio_Name AND
            I.GRUO IS NOT NULL AND
            I.GRUO <> FEA.GRUO;

END;
GO


CREATE TRIGGER trg_UpdateFEConnection
ON Event.EConnection
AFTER INSERT
AS
BEGIN
UPDATE FEC SET FEC.Connection = I.Connection
    FROM Final.FEConnection FEC
    INNER JOIN inserted I
        ON
            FEC.Radio_Name = I.Radio_Name AND
            I.Connection IS NOT NULL AND
            I.Connection <> FEC.Connection;

END;
GO


CREATE TRIGGER trg_UpdateFENetwork
ON Event.ENetwork
AFTER INSERT
AS
BEGIN
UPDATE FEN SET FEN.GRHN = I.GRHN
    FROM Final.FENetwork FEN
    INNER JOIN inserted I
        ON
            FEN.Radio_Name = I.Radio_Name AND
            I.GRHN IS NOT NULL AND
            I.GRHN <> FEN.GRHN;

UPDATE FEN SET FEN.GRNA = I.GRNA
    FROM Final.FENetwork FEN
    INNER JOIN inserted I
        ON
            FEN.Radio_Name = I.Radio_Name AND
            I.GRNA IS NOT NULL AND
            I.GRNA <> FEN.GRNA;

UPDATE FEN SET FEN.SCPG = I.SCPG
    FROM Final.FENetwork FEN
    INNER JOIN inserted I
        ON
            FEN.Radio_Name = I.Radio_Name AND
            I.SCPG IS NOT NULL AND
            I.SCPG <> FEN.SCPG;

UPDATE FEN SET FEN.SCSS = I.SCSS
    FROM Final.FENetwork FEN
    INNER JOIN inserted I
        ON
            FEN.Radio_Name = I.Radio_Name AND
            I.SCSS IS NOT NULL AND
            I.SCSS <> FEN.SCSS;

END;
GO


CREATE TRIGGER trg_UpdateFEOperation
ON Event.EOperation
AFTER INSERT
AS
BEGIN
UPDATE FEO SET FEO.ERGN = I.ERGN
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.ERGN IS NOT NULL AND
            I.ERGN <> FEO.ERGN;

UPDATE FEO SET FEO.FFMD = I.FFMD
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.FFMD IS NOT NULL AND
            I.FFMD <> FEO.FFMD;

UPDATE FEO SET FEO.FFSP = I.FFSP
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.FFSP IS NOT NULL AND
            I.FFSP <> FEO.FFSP;

UPDATE FEO SET FEO.FFTR = I.FFTR
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.FFTR IS NOT NULL AND
            I.FFTR <> FEO.FFTR;

UPDATE FEO SET FEO.MSAC = I.MSAC
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.MSAC IS NOT NULL AND
            I.MSAC <> FEO.MSAC;

UPDATE FEO SET FEO.RCPP = I.RCPP
    FROM Final.FEOperation FEO
    INNER JOIN inserted I
        ON
            FEO.Radio_Name = I.Radio_Name AND
            I.RCPP IS NOT NULL AND
            I.RCPP <> FEO.RCPP;

END;
GO


CREATE TRIGGER trg_UpdateFEStatus
ON Event.EStatus
AFTER INSERT
AS
BEGIN
UPDATE FES SET FES.Activation = I.Activation
    FROM Final.FEStatus FES
    INNER JOIN inserted I
        ON
            FES.Radio_Name = I.Radio_Name AND
            I.Activation IS NOT NULL AND
            I.Activation <> FES.Activation;

UPDATE FES SET FES.Operation = I.Operation
    FROM Final.FEStatus FES
    INNER JOIN inserted I
        ON
            FES.Radio_Name = I.Radio_Name AND
            I.Operation IS NOT NULL AND
            I.Operation <> FES.Operation;

UPDATE FES SET FES.Access = I.Access
    FROM Final.FEStatus FES
    INNER JOIN inserted I
        ON
            FES.Radio_Name = I.Radio_Name AND
            I.Access IS NOT NULL AND
            I.Access <> FES.Access;

END;
GO


CREATE TRIGGER trg_UpdateFERXOperation
ON Event.RXOperation
AFTER INSERT
AS
BEGIN
UPDATE FERXO SET FERXO.FFSN = I.FFSN
    FROM Final.FERXOperation FERXO
    INNER JOIN inserted I
        ON
            FERXO.Radio_Name = I.Radio_Name AND
            I.FFSN IS NOT NULL AND
            I.FFSN <> FERXO.FFSN;

UPDATE FERXO SET FERXO.FFSQ = I.FFSQ
    FROM Final.FERXOperation FERXO
    INNER JOIN inserted I
        ON
            FERXO.Radio_Name = I.Radio_Name AND
            I.FFSQ IS NOT NULL AND
            I.FFSQ <> FERXO.FFSQ;

UPDATE FERXO SET FERXO.FFSR = I.FFSR
    FROM Final.FERXOperation FERXO
    INNER JOIN inserted I
        ON
            FERXO.Radio_Name = I.Radio_Name AND
            I.FFSR IS NOT NULL AND
            I.FFSR <> FERXO.FFSR;

UPDATE FERXO SET FERXO.RIRC = I.RIRC
    FROM Final.FERXOperation FERXO
    INNER JOIN inserted I
        ON
            FERXO.Radio_Name = I.Radio_Name AND
            I.RIRC IS NOT NULL AND
            I.RIRC <> FERXO.RIRC;

END;
GO


CREATE TRIGGER trg_UpdateFESpecialSetting
ON Event.SpecialSetting
AFTER INSERT
AS
BEGIN
UPDATE FESS SET FESS.AITP = I.AITP
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.AITP IS NOT NULL AND
            I.AITP <> FESS.AITP;

UPDATE FESS SET FESS.FFTO = I.FFTO
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.FFTO IS NOT NULL AND
            I.FFTO <> FESS.FFTO;

UPDATE FESS SET FESS.RCIT = I.RCIT
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.RCIT IS NOT NULL AND
            I.RCIT <> FESS.RCIT;

UPDATE FESS SET FESS.RCLP = I.RCLP
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.RCLP IS NOT NULL AND
            I.RCLP <> FESS.RCLP;

UPDATE FESS SET FESS.RCNP = I.RCNP
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.RCNP IS NOT NULL AND
            I.RCNP <> FESS.RCNP;

UPDATE FESS SET FESS.RCTS = I.RCTS
    FROM Final.FESpecialSetting FESS
    INNER JOIN inserted I
        ON
            FESS.Radio_Name = I.Radio_Name AND
            I.RCTS IS NOT NULL AND
            I.RCTS <> FESS.RCTS;

END;
GO


CREATE TRIGGER trg_UpdateFETXOperation
ON Event.TXOperation
AFTER INSERT
AS
BEGIN
UPDATE FETXO SET FETXO.RCMG = I.RCMG
    FROM Final.FETXOperation FETXO
    INNER JOIN inserted I
        ON
            FETXO.Radio_Name = I.Radio_Name AND
            I.RCMG IS NOT NULL AND
            I.RCMG <> FETXO.RCMG;

END;
GO


CREATE TRIGGER trg_UpdateFSConfiguration
ON Setting.Configuration
AFTER INSERT
AS
BEGIN
UPDATE FSC SET FSC.AISE = I.AISE
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.AISE IS NOT NULL AND
            I.AISE <> FSC.AISE;

UPDATE FSC SET FSC.AISF = I.AISF
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.AISF IS NOT NULL AND
            I.AISF <> FSC.AISF;

UPDATE FSC SET FSC.EVSR = I.EVSR
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.EVSR IS NOT NULL AND
            I.EVSR <> FSC.EVSR;

UPDATE FSC SET FSC.FFBL = I.FFBL
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.FFBL IS NOT NULL AND
            I.FFBL <> FSC.FFBL;

UPDATE FSC SET FSC.FFEA = I.FFEA
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.FFEA IS NOT NULL AND
            I.FFEA <> FSC.FFEA;

UPDATE FSC SET FSC.FFFC = I.FFFC
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.FFFC IS NOT NULL AND
            I.FFFC <> FSC.FFFC;

UPDATE FSC SET FSC.FFLM = I.FFLM
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.FFLM IS NOT NULL AND
            I.FFLM <> FSC.FFLM;

UPDATE FSC SET FSC.FFLT = I.FFLT
    FROM Final.FSConfiguration FSC
    INNER JOIN inserted I
        ON
            FSC.Radio_Name = I.Radio_Name AND
            I.FFLT IS NOT NULL AND
            I.FFLT <> FSC.FFLT;

END;
GO


CREATE TRIGGER trg_UpdateFSInstallation
ON Setting.Installation
AFTER INSERT
AS
BEGIN
UPDATE FSI SET FSI.AIAI = I.AIAI
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.AIAI IS NOT NULL AND
            I.AIAI <> FSI.AIAI;

UPDATE FSI SET FSI.AIEL = I.AIEL
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.AIEL IS NOT NULL AND
            I.AIEL <> FSI.AIEL;

UPDATE FSI SET FSI.FFFE = I.FFFE
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.FFFE IS NOT NULL AND
            I.FFFE <> FSI.FFFE;

UPDATE FSI SET FSI.FFSC = I.FFSC
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.FFSC IS NOT NULL AND
            I.FFSC <> FSI.FFSC;

UPDATE FSI SET FSI.GRIN = I.GRIN
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.GRIN IS NOT NULL AND
            I.GRIN <> FSI.GRIN;

UPDATE FSI SET FSI.GRLO = I.GRLO
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.GRLO IS NOT NULL AND
            I.GRLO <> FSI.GRLO;

UPDATE FSI SET FSI.MSTY = I.MSTY
    FROM Final.FSInstallation FSI
    INNER JOIN inserted I
        ON
            FSI.Radio_Name = I.Radio_Name AND
            I.MSTY IS NOT NULL AND
            I.MSTY <> FSI.MSTY;

END;
GO


CREATE TRIGGER trg_UpdateFSNetwork
ON Setting.Network
AFTER INSERT
AS
BEGIN
UPDATE FSN SET FSN.GRDH = I.GRDH
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRDH IS NOT NULL AND
            I.GRDH <> FSN.GRDH;

UPDATE FSN SET FSN.GRDN = I.GRDN
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRDN IS NOT NULL AND
            I.GRDN <> FSN.GRDN;

UPDATE FSN SET FSN.GRIE = I.GRIE
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRIE IS NOT NULL AND
            I.GRIE <> FSN.GRIE;

UPDATE FSN SET FSN.GRIV = I.GRIV
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRIV IS NOT NULL AND
            I.GRIV <> FSN.GRIV;

UPDATE FSN SET FSN.GRNS = I.GRNS
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRNS IS NOT NULL AND
            I.GRNS <> FSN.GRNS;

UPDATE FSN SET FSN.GRVE = I.GRVE
    FROM Final.FSNetwork FSN
    INNER JOIN inserted I
        ON
            FSN.Radio_Name = I.Radio_Name AND
            I.GRVE IS NOT NULL AND
            I.GRVE <> FSN.GRVE;

END;
GO


CREATE TRIGGER trg_UpdateFSRXConfiguration
ON Setting.RXConfiguration
AFTER INSERT
AS
BEGIN
UPDATE FSRXC SET FSRXC.AIGA = I.AIGA
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.AIGA IS NOT NULL AND
            I.AIGA <> FSRXC.AIGA;

UPDATE FSRXC SET FSRXC.AITS = I.AITS
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.AITS IS NOT NULL AND
            I.AITS <> FSRXC.AITS;

UPDATE FSRXC SET FSRXC.FFCO = I.FFCO
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.FFCO IS NOT NULL AND
            I.FFCO <> FSRXC.FFCO;

UPDATE FSRXC SET FSRXC.FFSL = I.FFSL
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.FFSL IS NOT NULL AND
            I.FFSL <> FSRXC.FFSL;

UPDATE FSRXC SET FSRXC.GRBS = I.GRBS
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.GRBS IS NOT NULL AND
            I.GRBS <> FSRXC.GRBS;

UPDATE FSRXC SET FSRXC.GRIS = I.GRIS
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.GRIS IS NOT NULL AND
            I.GRIS <> FSRXC.GRIS;

UPDATE FSRXC SET FSRXC.RIRO = I.RIRO
    FROM Final.FSRXConfiguration FSRXC
    INNER JOIN inserted I
        ON
            FSRXC.Radio_Name = I.Radio_Name AND
            I.RIRO IS NOT NULL AND
            I.RIRO <> FSRXC.RIRO;

END;
GO


CREATE TRIGGER trg_UpdateFSSNMP
ON Setting.SNMP
AFTER INSERT
AS
BEGIN
UPDATE FSSNMP SET FSSNMP.GRSE = I.GRSE
    FROM Final.FSSNMP FSSNMP
    INNER JOIN inserted I
        ON
            FSSNMP.Radio_Name = I.Radio_Name AND
            I.GRSE IS NOT NULL AND
            I.GRSE <> FSSNMP.GRSE;

UPDATE FSSNMP SET FSSNMP.GRSN = I.GRSN
    FROM Final.FSSNMP FSSNMP
    INNER JOIN inserted I
        ON
            FSSNMP.Radio_Name = I.Radio_Name AND
            I.GRSN IS NOT NULL AND
            I.GRSN <> FSSNMP.GRSN;

UPDATE FSSNMP SET FSSNMP.RUFL = I.RUFL
    FROM Final.FSSNMP FSSNMP
    INNER JOIN inserted I
        ON
            FSSNMP.Radio_Name = I.Radio_Name AND
            I.RUFL IS NOT NULL AND
            I.RUFL <> FSSNMP.RUFL;

UPDATE FSSNMP SET FSSNMP.RUFP = I.RUFP
    FROM Final.FSSNMP FSSNMP
    INNER JOIN inserted I
        ON
            FSSNMP.Radio_Name = I.Radio_Name AND
            I.RUFP IS NOT NULL AND
            I.RUFP <> FSSNMP.RUFP;

END;
GO


CREATE TRIGGER trg_UpdateFSStatus
ON Setting.Status
AFTER INSERT
AS
BEGIN
UPDATE FSS SET FSS.ERBE = I.ERBE
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.ERBE IS NOT NULL AND
            I.ERBE <> FSS.ERBE;

UPDATE FSS SET FSS.GRLR = I.GRLR
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.GRLR IS NOT NULL AND
            I.GRLR <> FSS.GRLR;

UPDATE FSS SET FSS.GRLT = I.GRLT
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.GRLT IS NOT NULL AND
            I.GRLT <> FSS.GRLT;

UPDATE FSS SET FSS.GRTI = I.GRTI
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.GRTI IS NOT NULL AND
            I.GRTI <> FSS.GRTI;

UPDATE FSS SET FSS.RCLR = I.RCLR
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.RCLR IS NOT NULL AND
            I.RCLR <> FSS.RCLR;

UPDATE FSS SET FSS.RCLV = I.RCLV
    FROM Final.FSStatus FSS
    INNER JOIN inserted I
        ON
            FSS.Radio_Name = I.Radio_Name AND
            I.RCLV IS NOT NULL AND
            I.RCLV <> FSS.RCLV;

END;
GO


CREATE TRIGGER trg_UpdateFSTXConfiguration
ON Setting.TXConfiguration
AFTER INSERT
AS
BEGIN
UPDATE FSTXC SET FSTXC.AICA = I.AICA
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.AICA IS NOT NULL AND
            I.AICA <> FSTXC.AICA;

UPDATE FSTXC SET FSTXC.AIML = I.AIML
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.AIML IS NOT NULL AND
            I.AIML <> FSTXC.AIML;

UPDATE FSTXC SET FSTXC.GRAS = I.GRAS
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.GRAS IS NOT NULL AND
            I.GRAS <> FSTXC.GRAS;

UPDATE FSTXC SET FSTXC.GRCO = I.GRCO
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.GRCO IS NOT NULL AND
            I.GRCO <> FSTXC.GRCO;

UPDATE FSTXC SET FSTXC.GREX = I.GREX
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.GREX IS NOT NULL AND
            I.GREX <> FSTXC.GREX;

UPDATE FSTXC SET FSTXC.RCDP = I.RCDP
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.RCDP IS NOT NULL AND
            I.RCDP <> FSTXC.RCDP;

UPDATE FSTXC SET FSTXC.RIPC = I.RIPC
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.RIPC IS NOT NULL AND
            I.RIPC <> FSTXC.RIPC;

UPDATE FSTXC SET FSTXC.RIVL = I.RIVL
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.RIVL IS NOT NULL AND
            I.RIVL <> FSTXC.RIVL;

UPDATE FSTXC SET FSTXC.RIVP = I.RIVP
    FROM Final.FSTXConfiguration FSTXC
    INNER JOIN inserted I
        ON
            FSTXC.Radio_Name = I.Radio_Name AND
            I.RIVP IS NOT NULL AND
            I.RIVP <> FSTXC.RIVP;

END;
GO

--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--

CREATE TRIGGER trg_UpdateFESession
ON Event.Session
AFTER INSERT
AS
    BEGIN
        DECLARE @RN CHAR(10);
        DECLARE @DT DATETIME;
        SELECT @RN=Radio_Name, @DT=Date FROM inserted;

        DELETE FROM Final.FESession
               WHERE Radio_Name=@RN AND
                     Date < @DT;

        INSERT INTO Final.FESession
            (Date, Radio_Name, IP, Client, Type, SessionNumber)
        SELECT Date, Radio_Name, IP, Client, Type, SessionNumber
        FROM inserted
    END;
GO


CREATE TRIGGER trg_UpdateFECBIT
ON Event.ECBIT
AFTER INSERT
AS
    BEGIN
        DECLARE @RN CHAR(10);
        DECLARE @DT DATETIME;
        SELECT @RN=Radio_Name, @DT=Date FROM inserted;

        DELETE FROM Final.FECBIT
               WHERE Radio_Name=@RN AND
                     Date < @DT;

        INSERT INTO Final.FECBIT
            ([Date], [Radio_Name], [Code], [Name], [Level])
        SELECT [Date], [Radio_Name], [Code], [Name], [Level]
        FROM inserted
    END;
GO

CREATE TRIGGER trg_UpdateFSAccess
ON Setting.Access
AFTER INSERT
AS
    BEGIN
        MERGE INTO Final.FSAccess AS Target
        USING inserted AS Source
        ON Target.Radio_Name = Source.Radio_Name AND Target.ACL_Index = Source.ACL_Index

        WHEN MATCHED THEN
            UPDATE SET Target.Allowed_IP=Source.Allowed_IP
        WHEN NOT MATCHED THEN
            INSERT (Radio_Name, ACL_Index, Allowed_IP)
            VALUES (Source.Radio_Name, Source.ACL_Index, Source.Allowed_IP);
    END;
GO

CREATE TRIGGER trg_UpdateFSInventory
ON Setting.Inventory
AFTER INSERT
AS
    BEGIN
        MERGE INTO Final.FSInventory AS Target
        USING inserted AS Source
        ON Target.Radio_Name = Source.Radio_Name AND Target.R_Index=Source.R_Index

        WHEN MATCHED THEN
            UPDATE SET Target.Date=Source.Date,
                       Target.Type=Source.Type,
                       Target.Component_Name=Source.Component_Name,
                       Target.Ident_Number=Source.Ident_Number,
                       Target.Variant=Source.Variant,
                       Target.Production_Index=Source.Production_Index,
                       Target.Serial_Number=Source.Serial_Number,
                       Target.Production_Date=Source.Production_Date
        WHEN NOT MATCHED THEN
            INSERT (Date, Radio_Name, R_Index, Type, Component_Name, Ident_Number,
                    Variant, Production_Index, Serial_Number, Production_Date)
            VALUES (Source.Date, Source.Radio_Name, Source.R_Index, Source.Type,
                    Source.Component_Name, Source.Ident_Number, Source.Variant,
                    Source.Production_Index, Source.Serial_Number, Source.Production_Date);
    END;
GO

CREATE TRIGGER trg_UpdateFSIP
ON Setting.IP
AFTER INSERT
AS
    BEGIN
        MERGE INTO Final.FSIP AS Target
        USING inserted AS Source
        ON Target.Radio_Name = Source.Radio_Name AND Target.IP_Type=Source.IP_Type

        WHEN MATCHED THEN
            UPDATE SET Target.Date=Source.Date,
                       Target.IP=Source.IP,
                       Target.Subnet=Source.Subnet,
                       Target.Gateway=Source.Gateway
        WHEN NOT MATCHED THEN
            INSERT (Date, Radio_Name, IP_Type, IP, Subnet, Gateway)
            VALUES (Source.Date, Source.Radio_Name, Source.IP_Type, Source.IP, Source.Subnet, Source.Gateway);
    END;
GO

CREATE TRIGGER trg_UpdateFSCBIT
ON Setting.SCBIT
AFTER INSERT
AS
    BEGIN
        MERGE INTO Final.FSCBIT AS Target
        USING inserted AS Source
        ON Target.Radio_Name = Source.Radio_Name AND Target.CBIT_Code = Source.CBIT_Code

        WHEN MATCHED THEN
            UPDATE SET Target.Date = Source.Date, Target.Configuration = Source.Configuration

        WHEN NOT MATCHED THEN
            INSERT (Date, Radio_Name, CBIT_Code, Configuration)
            VALUES (Source.Date, Source.Radio_Name, Source.CBIT_Code, Source.Configuration);
    END;
GO

CREATE TRIGGER trg_UpdateFSSoftware
ON Setting.Software
AFTER INSERT
AS
    BEGIN
        MERGE INTO Final.FSSoftware AS Target
        USING inserted AS Source
        ON Target.Radio_Name = Source.Radio_Name AND Target.Partition = Source.Partition

        WHEN MATCHED THEN
            UPDATE SET Target.Date = Source.Date,
                       Target.Part_Number = Source.Part_Number,
                       Target.Version = Source.Version,
                       Target.Status = Source.Status
        WHEN NOT MATCHED THEN
            INSERT (Date, Radio_Name, Partition, Part_Number, Version, Status)
            VALUES (Source.Date, Source.Radio_Name, Source.Partition,
                    Source.Part_Number, Source.Version, Source.Status);
    END;
GO

CREATE TRIGGER trg_RRadio
ON Radio.Radio
AFTER INSERT
AS
    BEGIN
        INSERT INTO Final.FEAdjustment (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FEConnection (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FENetwork (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FEOperation (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FEStatus (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FSConfiguration (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FSInstallation (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FSNetwork (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FSSNMP (Radio_Name) VALUES inserted.Name;
        INSERT INTO Final.FSStatus (Radio_Name) VALUES inserted.Name;

        IF inserted.RadioType=1 BEGIN
            INSERT INTO Final.FETXOperation (Radio_Name) VALUES inserted.Name;
            INSERT INTO Final.FESpecialSetting (Radio_Name) VALUES inserted.Name;
            INSERT INTO Final.FSTXConfiguration (Radio_Name) VALUES inserted.Name;
        END ELSE BEGIN
            INSERT INTO Final.FERXOperation (Radio_Name) VALUES inserted.Name;
            INSERT INTO Final.FSRXConfiguration (Radio_Name) VALUES inserted.Name;
        END
    END;
