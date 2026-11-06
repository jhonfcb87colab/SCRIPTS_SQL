
select * from SIG_LOGISTICA_DM.[TMP].[COSTO_DARWIN_CONTROL_EJECUCION] with(nolock)
;with cte as(
select 
 max(FECHA_HORA_EJECUCION) fe_max
,min(FECHA_HORA_EJECUCION) fe_min
from SIG_LOGISTICA_DM.[TMP].[COSTO_DARWIN_CONTROL_EJECUCION] with(nolock)
)
select DATEDIFF(MINUTE,fe_min,fe_max) duracion_minutos from cte

--select * from SIG_COLOMBIA_DW.TMP.COSTO_DARWIN_BASE_OPERACION_MES_BASE04

--[FAC].[COSTO_DARWIN_BASE_OPERACION_MES]

--select count(1) from SIG_COLOMBIA_DW.[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE00] with(nolock)


--select COUNT(1),GETDATE() from [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE01] TMP01  WITH(NOLOCK)
--4380795	2025-07-30 16:52:47.990
--5877348	2025-07-30 16:54:28.377
--11439739	2025-07-30 16:59:32.280
--
--

--SELECT COUNT(1) FROM SIG_LOGISTICA_DM.[TMP].[COSTO_DARWIN_CONTROL_EJECUCION];
--SELECT COUNT(1) FROM SIG_LOGISTICA_DM.TMP.COSTO_DARWIN_BASE_OPERACION_MES;
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_RE_BASE_OPERACION];
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_SZU_BASE_OPERACION];
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE00];
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE01];
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE02];
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE03];                                          
--SELECT COUNT(1) FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE04];




/*
SP_WHO3
----KILL 70

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'SIG_COLOMBIA_DW';


USE SIG_COLOMBIA_DW;
GO
EXEC sp_helpfile;




SELECT 
    s.session_id,
    r.status,
    r.start_time AS request_start_time,
    s.open_transaction_count,
    at.transaction_id,
    at.transaction_type,
    at.transaction_state,
    DB_NAME(dt.database_id) AS database_name,
    dt.database_transaction_begin_time,
    txt.text AS executing_sql
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
JOIN sys.dm_tran_session_transactions st ON s.session_id = st.session_id
JOIN sys.dm_tran_active_transactions at ON st.transaction_id = at.transaction_id
JOIN sys.dm_tran_database_transactions dt ON at.transaction_id = dt.transaction_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS txt
WHERE DB_NAME(dt.database_id) = 'SIG_COLOMBIA_DW'
ORDER BY dt.database_transaction_begin_time;



SELECT 
    session_id,
    login_name,
    host_name,
    program_name,
    last_request_start_time,
    last_request_end_time
FROM sys.dm_exec_sessions
WHERE session_id = 71;


sp_who2
kill 71



--Limpiar cachés y buffers
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE ('ALL');
DBCC FREESESSIONCACHE;

-- Reemplaza <nombre_logico> con el nombre del archivo .ldf de cada DB
USE [SIG_LOGISTICA_DM];
CHECKPOINT;
DBCC SHRINKFILE (N'SIG_LOGISTICA_DM_log', 0, TRUNCATEONLY);


*/
