USE SIG_COL_LOGISTICA_DW;
SELECT 
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
where 
---t.name='%ATENCION_CLIENTE_HG%'
--left_prv.value  IS NOT NULL
--AND SCHEMA_NAME(t.schema_id)='FAC'
--ORDER BY p.partition_number DESC
---f.NAME LIKE '%ATENCION_CLIENTE_HG%'
pf.name like '%PF_ATENCION_CLIENTE_HG%'
ORDER BY 5 ASC

SELECT CONVERT(DATETIME,45625)





--SELECT CONVERT(DATETIME,45259) DT