USE RCMS;
GO

SET IDENTITY_INSERT Django.auth_group ON
insert into Django.auth_group (id, name)
values  (1, N'Administrator'),
        (2, N'Expert'),
        (3, N'Supervisor'),
        (4, N'Operator'),
        (5, N'Observer');
SET IDENTITY_INSERT Django.auth_group ON
GO