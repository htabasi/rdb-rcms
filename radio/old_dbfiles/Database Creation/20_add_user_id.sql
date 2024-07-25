USE RCMS;
GO

ALTER TABLE Radio.UserStation
    ADD user_id BIGINT NOT NULL FOREIGN KEY REFERENCES Django.account_user (id);
GO

ALTER TABLE Command.History
    ADD user_id BIGINT NOT NULL FOREIGN KEY REFERENCES Django.account_user (id);
GO

ALTER TABLE Command.ManagerHistory
    ADD user_id BIGINT NOT NULL FOREIGN KEY REFERENCES Django.account_user (id);
GO