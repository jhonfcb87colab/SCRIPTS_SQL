--USE SIG_COL_LOGISTICA_DW;
--USE SIG_COLOMBIA_DW;
--USE SIG_LOGISTICA_DM;
--USE SIG_RETAIL_DM;
--USE SIG_COL_PYME_DM;
--USE SIG_COL_SCN_DM;
--USE SIG_COL_SDM_DW;
--USE SIG_FACTURACION_DM; ------------------------> COMENTARIAR FECHAS 
USE BICYP;

drop table if exists #splits_creados_202305171352

SELECT distinct
DB_NAME() BASEDEDATOS, 
f.data_space_id,
f.NAME AS file_group_name,
SCHEMA_NAME(t.schema_id) AS table_schema,
t.name AS table_name,
p.partition_number,
ps.name AS partition_schem_name,
pf.name AS partition_function_name,
pf.boundary_value_on_right,
left_prv.value AS left_range,
right_prv.value AS right_value,
ISNULL(STR(CAST(left_prv.value AS BIGINT)), '-INF')
+ CASE WHEN pf.boundary_value_on_right = 0 THEN ' < '
ELSE ' <= '
END + 'X' + CASE WHEN pf.boundary_value_on_right = 0 THEN ' <= '
ELSE ' < '
END + ISNULL(STR(CAST(right_prv.value AS BIGINT)), 'INF') AS range_desc,
pf.create_date,
PF.modify_date
into #splits_creados_202305171352
FROM sys.partitions p
JOIN sys.tables t
ON p.object_id = t.object_id
JOIN sys.indexes i
ON p.object_id = i.object_id
AND p.index_id = i.index_id
JOIN sys.allocation_units au
ON p.hobt_id = au.container_id
JOIN sys.filegroups f
ON au.data_space_id = f.data_space_id
LEFT JOIN sys.partition_schemes ps
ON ps.data_space_id = i.data_space_id
LEFT JOIN sys.partition_functions pf
ON ps.function_id = pf.function_id
LEFT JOIN sys.partition_range_values left_prv
ON left_prv.function_id = ps.function_id
AND left_prv.boundary_id + 1 = p.partition_number
LEFT JOIN sys.partition_range_values right_prv
ON right_prv.function_id = ps.function_id
AND right_prv.boundary_id = p.partition_number
WHERE 

-------------------------------------------------------------------------
--t.name='CONFIRMACIONES' AND SCHEMA_NAME(t.schema_id)='LOG' and ---ORDER BY p.partition_number DESC 
----and
-------------------------------------------------------------------------
/**/
ps.name IS NOT NULL ----AND right_prv.value IS NOT NULL
--AND 
--left_prv.value IS NOT NULL --AND right_prv.value IS NOT NULL
;
with cte as( 
select 
		ROW_NUMBER ( )   OVER ( PARTITION BY table_schema,table_name order by left_range  desc )  #ROW_id,  
		* from #splits_creados_202305171352 WHERE range_desc LIKE '% X %'
)
SELECT 
*
--,SPLIT_IZQUIERDA = convert(datetime,left_range)  ----------IIF (LEN(left_range)>6,left_range,convert(datetime,left_range))
--,SPLIT_DERECHA = convert(datetime,right_value) ---------------------IIF (LEN(right_value)>6,left_range,convert(datetime,right_value))
FROM CTE WHERE #ROW_id	BETWEEN 1 AND 1	----IN(1,2,3,4,5) ---,2,3

--[PRF].[MECE_LOGISTICO_GUIAS]



/*
SELECT * FROM sys.partitions p
SELECT * FROM  sys.partition_functions pf


SELECT CONVERT(INT,CONVERT(DATETIME,'2025-01-01')) AS INI
SELECT CONVERT(INT,CONVERT(DATETIME,'2023-11-30')) AS FINI
	
	44864	44894
	45290
	
	45259


SELECT CONVERT(DATETIME, 45259) AS INI
SELECT CONVERT(DATETIME, 44894) AS FINI


*/







