USE [msdb]
GO

/****** Object:  Job [SIG_MULTIPRECIO_MOBIPETARIF_PESOS_POR_CANAL]    Script Date: 4/10/2022 6:06:05 p.m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [SIG_LOGISTICA]    Script Date: 4/10/2022 6:06:05 p.m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'SIG_LOGISTICA' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'SIG_LOGISTICA'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'SIG_MULTIPRECIO_MOBIPETARIF_PESOS_POR_CANAL', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'SIG_MULTIPRECIO_MOBIPETARIF_PESOS_POR_CANAL', 
		@category_name=N'SIG_LOGISTICA', 
		@owner_login_name=N'SERVIENT\inteligencianegocios', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PS01_EXTRACCION]    Script Date: 4/10/2022 6:06:06 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PS01_EXTRACCION', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\DATA MART LOGISTICA\MOBIPETARIF_PESOS_POR_CANAL\01_EXTRACT.dtsx\"" /SERVER "\"SERV-DBI01\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";100 /Par "\"$ServerOption::CUSTOMIZED_LOGGING_LEVEL\"";"\"Errors & Warnings\"" /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E', 
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=N'PRX_ETL-INTELIGENCIA'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PS02_TRANSFORMACION]    Script Date: 4/10/2022 6:06:06 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PS02_TRANSFORMACION', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\DATA MART LOGISTICA\MOBIPETARIF_PESOS_POR_CANAL\02 TRANSFORMACION.dtsx\"" /SERVER "\"SERV-DBI01\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";100 /Par "\"$ServerOption::CUSTOMIZED_LOGGING_LEVEL\"";"\"Errors & Warnings\"" /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E', 
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=N'PRX_ETL-INTELIGENCIA'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PS03_CARGA]    Script Date: 4/10/2022 6:06:06 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PS03_CARGA', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\DATA MART LOGISTICA\MOBIPETARIF_PESOS_POR_CANAL\03 CARGA.dtsx\"" /SERVER "\"SERV-DBI01\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";100 /Par "\"$ServerOption::CUSTOMIZED_LOGGING_LEVEL\"";"\"Errors & Warnings\"" /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E', 
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=N'PRX_ETL-INTELIGENCIA'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CALENDARIO_EJECUCION_MOBIPETARIF', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20221004, 
		@active_end_date=99991231, 
		@active_start_time=200000, 
		@active_end_time=235959, 
		@schedule_uid=N'7ef7430f-04c2-476a-b57c-8512bb2200fc'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

