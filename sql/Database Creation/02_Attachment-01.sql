alter table Radio.Station
    add Latitude DECIMAL(9, 6)
go

alter table Radio.Station
    add Longitude DECIMAL(9, 6)
go

INSERT INTO RCMS.Radio.Station
    (Code, Availability, Name)
VALUES
    ('BRD', 0, 'Bojnord Haft Rig'),
    ('BAM', 0, 'Bam Airport'),
    ('BZM', 0, 'Tehran Kushk Bazm'),
    ('CEN', 0, 'Tehran ACC'),
    ('RST', 0, 'Rasht Abshar Lahijan'),
    ('ZNJ', 0, 'Zanjan Gilvan'),
    ('SRJ', 0, 'Sirjan Airport'),
    ('TBS', 0, 'Tabas Airport'),
    ('JRF', 0, 'Jiroft Jebal Barez'),
    ('RVR', 0, 'Ravar'),
    ('GGN', 0, 'Gorgan Derazno'),
    ('LAR', 0, 'Lar Kuh Kur');

UPDATE RCMS.Radio.Station SET Latitude='53.7231388888889', Longitude='33.5310277777778' WHERE Code='ANK'
UPDATE RCMS.Radio.Station SET Latitude='51.8635833333333', Longitude='32.7422222222222' WHERE Code='ISN'
UPDATE RCMS.Radio.Station SET Latitude='48.7446666666667', Longitude='31.3444166666667' WHERE Code='AWZ'
UPDATE RCMS.Radio.Station SET Latitude='57.3996111111111', Longitude='37.2703333333333' WHERE Code='BRD'
UPDATE RCMS.Radio.Station SET Latitude='58.4502222222222', Longitude='29.0799166666667' WHERE Code='BAM'
UPDATE RCMS.Radio.Station SET Latitude='56.1708611111111', Longitude='27.4256944444444' WHERE Code='BND'
UPDATE RCMS.Radio.Station SET Latitude='50.8257222222222', Longitude='28.9577222222222' WHERE Code='BUZ'
UPDATE RCMS.Radio.Station SET Latitude='59.2015', Longitude='32.9728333333333' WHERE Code='BJD'
UPDATE RCMS.Radio.Station SET Latitude='46.3328888888889', Longitude='38.0424166666667' WHERE Code='TBZ'
UPDATE RCMS.Radio.Station SET Latitude='50.8708888888889', Longitude='35.1638333333333' WHERE Code='BZM'
UPDATE RCMS.Radio.Station SET Latitude='51.2506388888889', Longitude='35.6827777777778' WHERE Code='CEN'
UPDATE RCMS.Radio.Station SET Latitude='60.6271388888889', Longitude='25.3388055555556' WHERE Code='CBH'
UPDATE RCMS.Radio.Station SET Latitude='50.10025', Longitude='37.1561944444444' WHERE Code='RST'
UPDATE RCMS.Radio.Station SET Latitude='61.63075', Longitude='27.2051666666667' WHERE Code='BRG'
UPDATE RCMS.Radio.Station SET Latitude='60.9524722222222', Longitude='29.4487222222222' WHERE Code='ZDN'
UPDATE RCMS.Radio.Station SET Latitude='48.7468055555556', Longitude='36.6955277777778' WHERE Code='ZNJ'
UPDATE RCMS.Radio.Station SET Latitude='55.6628888888889', Longitude='29.55175' WHERE Code='SRJ'
UPDATE RCMS.Radio.Station SET Latitude='53.0094722222222', Longitude='30.0282222222222' WHERE Code='SYZ'
UPDATE RCMS.Radio.Station SET Latitude='56.8979722222222', Longitude='33.6715555555555' WHERE Code='TBS'
UPDATE RCMS.Radio.Station SET Latitude='57.9564166666667', Longitude='28.9283888888889' WHERE Code='JIR'
UPDATE RCMS.Radio.Station SET Latitude='56.8021388888889', Longitude='31.26325' WHERE Code='RVR'
UPDATE RCMS.Radio.Station SET Latitude='46.8712222222222', Longitude='34.6018055555556' WHERE Code='KMS'
UPDATE RCMS.Radio.Station SET Latitude='53.9735833333333', Longitude='26.5324722222222' WHERE Code='KIS'
UPDATE RCMS.Radio.Station SET Latitude='54.1700555555556', Longitude='36.6703055555556' WHERE Code='GGN'
UPDATE RCMS.Radio.Station SET Latitude='54.4648055555556', Longitude='27.7490277777778' WHERE Code='LAR'
UPDATE RCMS.Radio.Station SET Latitude='59.3545555555556', Longitude='35.7494444444444' WHERE Code='MSD'
UPDATE RCMS.Radio.Station SET Latitude='54.3998888888889', Longitude='31.8814444444444' WHERE Code='YZD'

--
-- CREATE TABLE Radio.SectorBoundaries
-- (
--     id  INT IDENTITY PRIMARY KEY ,
--     sector INT NOT NULL FOREIGN KEY REFERENCES RCMS.Radio.Sector (id),
--     point_index INT Not Null,
--     latitude  DECIMAL(9,6) Not Null,
--     longitude DECIMAL(9,6) Not Null,
--     line      int default 0
-- )

alter table Radio.Station
    add FullName VARCHAR(50) NULL
go

UPDATE Radio.Station SET Station.FullName=Station.Name

UPDATE RCMS.Radio.Station SET Name = N'Anarak' WHERE id = 1;
UPDATE RCMS.Radio.Station SET Name = N'Ahwaz' WHERE id = 2;
UPDATE RCMS.Radio.Station SET Name = N'Birjand' WHERE id = 3;
UPDATE RCMS.Radio.Station SET Name = N'BandarAbbas' WHERE id = 4;
UPDATE RCMS.Radio.Station SET Name = N'Birg' WHERE id = 5;
UPDATE RCMS.Radio.Station SET Name = N'Bushehr' WHERE id = 6;
UPDATE RCMS.Radio.Station SET Name = N'Chahbahar' WHERE id = 7;
UPDATE RCMS.Radio.Station SET Name = N'Isfahan' WHERE id = 8;
UPDATE RCMS.Radio.Station SET Name = N'Kish' WHERE id = 9;
UPDATE RCMS.Radio.Station SET Name = N'Kermanshah' WHERE id = 10;
UPDATE RCMS.Radio.Station SET Name = N'Mashhad' WHERE id = 11;
UPDATE RCMS.Radio.Station SET Name = N'Shiraz' WHERE id = 12;
UPDATE RCMS.Radio.Station SET Name = N'Tabriz' WHERE id = 13;
UPDATE RCMS.Radio.Station SET Name = N'Yazd' WHERE id = 14;
UPDATE RCMS.Radio.Station SET Name = N'Zahedan' WHERE id = 15;
UPDATE RCMS.Radio.Station SET Name = N'Workshop' WHERE id = 16;
UPDATE RCMS.Radio.Station SET Name = N'Bojnord' WHERE id = 17;
UPDATE RCMS.Radio.Station SET Name = N'Bam' WHERE id = 18;
UPDATE RCMS.Radio.Station SET Name = N'Bazm' WHERE id = 19;
UPDATE RCMS.Radio.Station SET Name = N'Center' WHERE id = 20;
UPDATE RCMS.Radio.Station SET Name = N'Rasht' WHERE id = 21;
UPDATE RCMS.Radio.Station SET Name = N'Zanjan' WHERE id = 22;
UPDATE RCMS.Radio.Station SET Name = N'Sirjan' WHERE id = 23;
UPDATE RCMS.Radio.Station SET Name = N'Tabas' WHERE id = 24;
UPDATE RCMS.Radio.Station SET Name = N'Jiroft' WHERE id = 25;
UPDATE RCMS.Radio.Station SET Name = N'Ravar' WHERE id = 26;
UPDATE RCMS.Radio.Station SET Name = N'Gorgan' WHERE id = 27;
UPDATE RCMS.Radio.Station SET Name = N'Lar' WHERE id = 28;
