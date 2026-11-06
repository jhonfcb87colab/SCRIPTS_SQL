


SELECT 
    r.session_id,
    r.status,
    r.start_time,
    r.command,
    r.wait_type,
    r.blocking_session_id,
    r.cpu_time,
    r.total_elapsed_time,
    r.reads,
    r.writes,
	--porc = (r.writes/@conteo)*100,
    t.text AS query_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE t.text LIKE '%COSTO_DARWIN_PROC_01_CARGUE_CALCULO_BASE_OPERACION_TEMP%'
  AND s.is_user_process = 1;




