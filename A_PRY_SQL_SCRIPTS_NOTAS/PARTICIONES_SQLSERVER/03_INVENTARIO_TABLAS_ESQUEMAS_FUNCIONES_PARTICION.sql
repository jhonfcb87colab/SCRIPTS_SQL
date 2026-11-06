/*

BASES DE DATOS QUE NO APLICAN PARA CREACION DE PARTICIONES

--	NO APLICA ----------USE [COGNOS_STG_V3] 
--	NO APLICA ----------USE [CONTENT_METRICS_V3] 
--	NO APLICA ----------USE [DBASatellite] 
--	NO APLICA ----------USE [REPORTES_MEVI_EXPECIALES] 
--	NO APLICA ----------USE [SIG_BI_DM] 
--	NO APLICA ----------USE [SIG_CCM_DM] 
--	NO APLICA ----------USE [SIG_COL_SAP_DW] 
--	NO APLICA ----------USE [SIG_COL_SPSS] 
--	NO APLICA ----------USE [SIG_ECU_LOGISTICA_DW] 
--	NO APLICA ----------USE [SIG_IMPUESTOS_DM] 
--	NO APLICA ----------USE [SIG_MEVI_DM] 
--	NO APLICA ----------USE [SIG_PAN_LOGISTICA_DW] 
--	NO APLICA ----------USE [SIG_PER_LOGISTICA_DW] 
--	NO APLICA ----------USE [SIG_SERV_CLIENTE_DM]

-------/*				*/
DROP TABLE IF EXISTS #TEMPORAL_INVENTARIO_SCHEMAS_FUNCTION_PARTITION	
CREATE TABLE #TEMPORAL_INVENTARIO_SCHEMAS_FUNCTION_PARTITION(
	[NM_DATABASE] [nvarchar](128) NULL,
	[TABLE_SCHEMA] [sysname] NULL,
	[NOMBRE_TABLA] [nvarchar](128) NULL,
	[CAMPO_PART] [sysname] NULL,
	[ESQUEMA_PART] [sysname] NOT NULL,
	[FUNCION_PART] [sysname] NOT NULL
) 

*/


USE [SIG_LOGISTICA_Dm] 
--USE [SIG_COL_PYME_DM] 
--USE [SIG_COL_SCN_DM] 
--USE [SIG_COL_SDM_DW] 
--USE [SIG_COLOMBIA_DW] 
--USE [SIG_FACTURACION_DM] 
--USE [SIG_LOGISTICA_DM] 
--USE [SIG_RETAIL_DM] 


drop table if exists #TEMPORAL_INVENTARIO_SCHEMAS_FUNCTION_PARTITION
SELECT 
DB_NAME() AS NM_DATABASE, 
SCHT.TABLE_SCHEMA, 
OBJECT_NAME(p.OBJECT_ID) NOMBRE_TABLA, 
        c.name CAMPO_PART, 
        ps.name ESQUEMA_PART, 
        pf.name FUNCION_PART 
		into #TEMPORAL_INVENTARIO_SCHEMAS_FUNCTION_PARTITION
FROM sys.data_spaces  d JOIN 
      sys.indexes i JOIN 
      (SELECT DISTINCT OBJECT_ID 
       FROM sys.partitions 
       WHERE partition_number > 1) p 
       ON i.OBJECT_ID = p.OBJECT_ID 
       ON d.data_space_id = i.data_space_id 
      JOIN sys.partition_schemes ps ON d.data_space_id = ps.data_space_id 
      JOIN sys.partition_functions pf ON ps.function_id = pf.function_id 
      JOIN sys.index_columns ic ON i.index_id = ic.index_id AND i.OBJECT_ID = ic.OBJECT_ID 
      JOIN sys.columns c ON c.OBJECT_ID = ic.OBJECT_ID AND c.column_id = ic.column_id 
  INNER JOIN Information_Schema.Tables SCHT ON SCHT.TABLE_NAME=OBJECT_NAME(p.OBJECT_ID) 
   WHERE i.index_id < 2 AND ic.partition_ordinal > 0 AND SCHT.TABLE_SCHEMA <> 'TMP' 
     --AND OBJECT_NAME(p.OBJECT_ID) LIKE '%SDM%' 
ORDER BY OBJECT_NAME(p.OBJECT_ID), 
        c.name, 
        ps.name, 
        pf.name ;



SELECT * FROM #TEMPORAL_INVENTARIO_SCHEMAS_FUNCTION_PARTITION