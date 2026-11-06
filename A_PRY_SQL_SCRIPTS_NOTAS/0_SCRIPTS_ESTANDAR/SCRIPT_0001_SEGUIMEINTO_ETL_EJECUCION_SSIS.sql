USE SSISDB;
GO

DECLARE @Folder_Name NVARCHAR(100) = 'DATA MART LOGISTICA';
DECLARE @Project_Name NVARCHAR(100) = 'MODELO GUIA MASIVA';

SELECT TOP 1
    e.execution_id AS [ID Ejecucion],
    e.folder_name AS [Carpeta],
    e.project_name AS [Proyecto],
    e.package_name AS [Paquete],
	e.start_time AS [Hora Inicio],
	DATEPART(HOUR,CONVERT(DATETIME,e.start_time))  AS HORA_INI,
	DATEDIFF(MINUTE,CONVERT(DATETIME,e.start_time),GETDATE()) DURACION_MINUTOS,
	DATEDIFF(HOUR,CONVERT(DATETIME,e.start_time),GETDATE()) DURACION_HORAS
FROM catalog.executions e
WHERE e.folder_name = @Folder_Name
  AND e.project_name = @Project_Name
ORDER BY e.execution_id DESC;

SELECT TOP 5
    e.execution_id AS [ID Ejecucion],
    e.folder_name AS [Carpeta],
    e.project_name AS [Proyecto],
    e.package_name AS [Paquete],
    
    -- Estado formateado
    CASE e.status
        WHEN 1 THEN '1 - Creado'
        WHEN 2 THEN '2 - En Ejecucion'
        WHEN 3 THEN '3 - Cancelado'
        WHEN 4 THEN '4 - Fallido'
        WHEN 5 THEN '5 - Pendiente'
        WHEN 6 THEN '6 - Terminado con errores'
        WHEN 7 THEN '7 - Exitoso'
        WHEN 8 THEN '8 - Detenido'
        WHEN 9 THEN '9 - Completado'
    END AS [Estado Ejecucion],

    e.executed_as_name AS [Ejecutado Por],
    e.created_time AS [Hora Creacion],
    e.start_time AS [Hora Inicio],
    e.end_time AS [Hora Fin],
    
    -- Duracion estimada en minutos
    DATEDIFF(MINUTE, e.start_time, ISNULL(e.end_time, GETDATE())) AS [Duracion (Min)],

    -- Mensaje de Error principal (si la ejecucion fallo)
    (
        SELECT TOP 1 em.message
        FROM catalog.event_messages em
        WHERE em.operation_id = e.execution_id
          AND em.event_name IN ('OnError', 'TaskFailed')
        ORDER BY em.event_message_id DESC
    ) AS [Ultimo Mensaje Error]

FROM catalog.executions e
WHERE e.folder_name = @Folder_Name
  AND e.project_name = @Project_Name
ORDER BY e.execution_id DESC;


DECLARE @Execution_ID BIGINT;

-- 1. Obtener la última ID de ejecución de tu proyecto
SELECT TOP 1 @Execution_ID = e.execution_id
FROM catalog.executions e
WHERE e.folder_name = @Folder_Name
  AND e.project_name = @Project_Name
ORDER BY e.execution_id DESC;

-- Si quieres auditar una ejecución en específico, descomenta la siguiente línea y asigna el ID:
-- SET @Execution_ID = 12345;

PRINT 'Mostrando seguimiento para Execution ID: ' + CAST(@Execution_ID AS VARCHAR(20));

-- 2. Detalle de ejecución paso a paso (Tasks/Containers)
SELECT 
    es.executable_id AS [ID Componente],
    ex.executable_name AS [Nombre del Paso / Task],
    ex.package_path AS [Ruta en el Paquete],
    
    -- Estado actual del paso
    CASE es.execution_path
        WHEN es.execution_path THEN 
            CASE 
                WHEN es.start_time IS NOT NULL AND es.end_time IS NULL THEN 'EN EJECUCION ⏳'
                WHEN es.execution_result = 0 THEN 'EXITOSO ✅'
                WHEN es.execution_result = 1 THEN 'FALLIDO ❌'
                WHEN es.execution_result = 2 THEN 'COMPLETADO ⚠️'
                WHEN es.execution_result = 3 THEN 'CANCELADO 🚫'
                ELSE 'PENDIENTE 💤'
            END
    END AS [Estatus Paso],

    es.start_time AS [Hora Inicio],
    es.end_time AS [Hora Fin],

    -- Duración del paso en Segundos y Minutos
    DATEDIFF(SECOND, es.start_time, ISNULL(es.end_time, GETDATE())) AS [Duracion (Seg)],
    CAST(DATEDIFF(SECOND, es.start_time, ISNULL(es.end_time, GETDATE())) / 60.0 AS DECIMAL(10,2)) AS [Duracion (Min)]

FROM catalog.executable_statistics es
INNER JOIN catalog.executables ex 
    ON es.executable_id = ex.executable_id 
   AND es.execution_id = ex.execution_id
WHERE es.execution_id = @Execution_ID
ORDER BY es.start_time DESC;