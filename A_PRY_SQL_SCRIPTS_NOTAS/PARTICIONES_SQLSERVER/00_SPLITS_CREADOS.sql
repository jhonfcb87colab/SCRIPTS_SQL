--USE SIG_COLOMBIA_DW;
--USE SIG_COL_LOGISTICA_DW;
--USE SIG_LOGISTICA_DM;
--USE SIG_RETAIL_DM;
--USE SIG_COL_PYME_DM;
--USE SIG_COL_SCN_DM;
--USE SIG_COL_SDM_DW;
--USE SIG_FACTURACION_DM; ------------------------> COMENTARIAR FECHAS 
--USE BICYP;

DECLARE @DATABASE VARCHAR(50) = 'BICYP';
use BICYP;
SELECT DISTINCT
@DATABASE AS DATABESE,
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
END + ISNULL(STR(CAST(right_prv.value AS BIGINT)), 'INF') AS range_desc
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
WHERE f.NAME LIKE '%2020%'
AND (
	t.name NOT LIKE ('%NEIV%')  
AND t.name NOT LIKE ('%PERE%')
AND t.name NOT LIKE ('%BARR%')
AND t.name NOT LIKE ('%BOGO%')
AND t.name NOT LIKE ('%BUCA%')
AND t.name NOT LIKE ('%BUGA%')
AND t.name NOT LIKE ('%CALI%')
AND t.name NOT LIKE ('%CART%')
AND t.name NOT LIKE ('%COTA%')
AND t.name NOT LIKE ('%CUCU%')
AND t.name NOT LIKE ('%IBAG%')
AND t.name NOT LIKE ('%MANI%')
AND t.name NOT LIKE ('%MEDE%')
AND t.name NOT LIKE ('%SINC%')
AND t.name NOT LIKE ('%VILL%')
AND t.name NOT LIKE ('%TEST%')
)
ORDER BY f.NAME