create table Users
(
    id               int identity,
    UserName         varchar(50)  not null,
    GroupID          int          not null,
    Name             nvarchar(50) not null,
    Family           nvarchar(50) not null,
    NationalCode     varchar(10),
    MobilePhone      varchar(13),
    WorkPhone        varchar(13),
    Email            varchar(50),
    RatingType       char(3),
    RatingLevel      varchar(5),
    YearOfEmployment int,
    OfficeName       nvarchar(50),
    City             nvarchar(50),
    primary key clustered (id asc),
    unique nonclustered (UserName asc),
    foreign key (GroupID) references Groups (id),
    constraint RatingLevel_Check
        check ([Users].[RatingLevel] = 'C' OR [Users].[RatingLevel] = 'B' OR [Users].[RatingLevel] = 'A' OR
               [Users].[RatingLevel] = 'Basic'),
    constraint RatingType_Check
        check ([Users].[RatingType] = 'COM' OR [Users].[RatingType] = 'INS' OR
               [Users].[RatingType] = 'NAV' OR [Users].[RatingType] = 'SUR')
);

exec sp_addextendedproperty 'MS_Description', N'نام', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN', 'Name';

exec sp_addextendedproperty 'MS_Description', N'نام خانوادگی', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'Family';

exec sp_addextendedproperty 'MS_Description', N'کد ملی', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'NationalCode';

exec sp_addextendedproperty 'MS_Description', N'شماره موبایل', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'MobilePhone';

exec sp_addextendedproperty 'MS_Description', N'شماره تلفن محل کار', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'WorkPhone';

exec sp_addextendedproperty 'MS_Description', N'ایمیل', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN', 'Email';

exec sp_addextendedproperty 'MS_Description', N'نوع ریتینگ', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'RatingType';

exec sp_addextendedproperty 'MS_Description', N'سطح ریتینگ', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'RatingLevel';

exec sp_addextendedproperty 'MS_Description', N'سال استخدام', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'YearOfEmployment';

exec sp_addextendedproperty 'MS_Description', N'نام اداره محل خدمت', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN',
     'OfficeName';

exec sp_addextendedproperty 'MS_Description', N'شهر محل خدمت', 'SCHEMA', 'Command', 'TABLE', 'Users', 'COLUMN', 'City';


