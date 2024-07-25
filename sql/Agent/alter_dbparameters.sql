alter table Application.DBParameters
    add Keep_Old_Variation_Days int default 60 not null
go

alter table Application.DBParameters
    add Keep_Old_Event_Days int default 180 not null
go

alter table Application.DBParameters
    add Keep_Old_Setting_Days int default 360 not null
go

