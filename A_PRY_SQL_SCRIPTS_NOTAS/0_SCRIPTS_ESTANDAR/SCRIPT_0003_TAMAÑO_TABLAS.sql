USE SIG_COL_LOGISTICA_DW
USE [SIG_MEVI_DM];
USE SIG_COLOMBIA_DW;

--select * from sys.sysaltfiles

 ------truncate table TMP.COSTO_DARWIN_BASE_OPERACION_MES_BACKUP_FEB2025_20250424

SELECT t.NAME AS Tabla, s.Name AS Esquema,P.partition_number, p.rows AS NumeroDeFilas, CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalEspacio_MB,
CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 0)) AS EspacioUtilizado_MB,
CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024, 2) AS NUMERIC(36,2)) AS EspacioNoUtilizado_MB
FROM sys.tables t 
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id 
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id 
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id 
LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id 
GROUP BY t.Name, s.Name, p.Rows ,P.partition_number
HAVING p.rows <> 0 --AND t.NAME like '%_B%'
--AND t.NAME LIKE 'TARIF%'
----ORDER BY 4 desc ,t.NAME DESC
ORDER BY 5 desc


