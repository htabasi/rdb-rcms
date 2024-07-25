USE [msdb]
GO

/****** Object:  Job [Purge_Old_Data_Job]    Script Date: 7/24/2024 6:41:43 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 7/24/2024 6:41:43 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Purge_Old_Data_Job',
		@enabled=1,
		@notify_level_eventlog=2,
		@notify_level_email=0,
		@notify_level_netsend=0,
		@notify_level_page=0,
		@delete_level=0,
		@description=N'No description available.',
		@category_name=N'[Uncategorized (Local)]',
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_ECBIT]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_ECBIT',
		@step_id=1,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[ECBIT] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_ERadio]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_ERadio',
		@step_id=2,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[ERadio] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_EventList]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_EventList',
		@step_id=3,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[EventList] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_Reception]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_Reception',
		@step_id=4,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[Reception] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_Session]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_Session',
		@step_id=5,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[Session] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_SpecialSetting]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_SpecialSetting',
		@step_id=6,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[SpecialSetting] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_Status]    Script Date: 7/24/2024 6:41:43 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_Status',
		@step_id=7,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[Status] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge_Event_Transmission]    Script Date: 7/24/2024 6:41:44 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge_Event_Transmission',
		@step_id=8,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=5,
		@retry_interval=5,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'DELETE FROM RCMS.[Event].[Transmission] WHERE DATEDIFF(MONTH, [Date], GETDATE()) > 2;
GO',
		@database_name=N'RCMS',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DailyPurgeSchedule',
		@enabled=1,
		@freq_type=4,
		@freq_interval=1,
		@freq_subday_type=1,
		@freq_subday_interval=0,
		@freq_relative_interval=0,
		@freq_recurrence_factor=0,
		@active_start_date=20240508,
		@active_end_date=99991231,
		@active_start_time=30000,
		@active_end_time=235959,
		@schedule_uid=N'7d694d2a-4f8b-4070-9b42-be598d6436a8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

