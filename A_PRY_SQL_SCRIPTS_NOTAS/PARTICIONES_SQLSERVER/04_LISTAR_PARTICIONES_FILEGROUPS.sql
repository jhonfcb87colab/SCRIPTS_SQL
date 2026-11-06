/*******************************************************************
********************************************************************
							LISTAR FILEGROUPS
********************************************************************
********************************************************************/

/*           LISTADO DE FILEGROUPS POR BASE DE DATOS CON PARTICIONES                             */

--USE SIG_COLOMBIA_DW;
USE SIG_COL_LOGISTICA_DW;
--USE SIG_COL_PYME_DM;
--USE SIG_COL_SCN_DM;
--USE SIG_COL_SDM_DW;
--USE SIG_FACTURACION_DM;
--USE SIG_LOGISTICA_DM;
--USE SIG_RETAIL_DM;
--USE SIG_COL_SAP_DW;--->NO CONTIENE
--USE BICYP;--->NO CONTIENE

SELECT physical_name
--DISTINCT
--CONCAT(
--[dbo].[UFN_SEPARATES_COLUMNS](physical_name,1,'\'),'\',
--[dbo].[UFN_SEPARATES_COLUMNS](physical_name,2,'\'),'\',
--[dbo].[UFN_SEPARATES_COLUMNS](physical_name,3,'\'),'\'
--)
--PUNTO_DE_MONTAGE 
FROM  SIG_COLOMBIA_DW.sys.database_files
WHERE physical_name LIKE '%PRUEBA_ENTREGA_MOD_SMALL%'
--E:\PM_CW_12\MSSQL_DATA\SIG_COLOMBIA_DW.mdf 




select 
DB_NAME() AS NM_DATABASE,
LEFT(
SIG_COL_LOGISTICA_DW.dbo.UFN_SEPARATES_COLUMNS(Name, 1, '20'),
LEN(SIG_COL_LOGISTICA_DW.dbo.UFN_SEPARATES_COLUMNS(Name, 1, '20'))-1) AS TABLA,
CONVERT(INT, SUBSTRING( NAME, CHARINDEX('2',name), 4)) as aÑo_particion,
Name,  
LEFT(physical_name,2) UNIDAD,
SUBSTRING(physical_name,1,14) AS URL_FILE,
physical_name,
STATE_DESC,
SIZE
from sys.database_files
WHERE physical_name LIKE '%PRUEBA_ENTREGA_MOD_SMALL%'
--where name like '%ATENCION_CLIENTE_HG%' AND
--NAME LIKE '%2011%'
--- CONVERT(INT, SUBSTRING( NAME, CHARINDEX('2',name), 4)) BETWEEN 2017 AND 2023
ORDER BY 1










/*
DECLARE @VAR VARCHAR(100)='SQL Tutorial';
DECLARE @LEN INT=LEN(@VAR);
SELECT @LEN
SELECT SUBSTRING(@VAR, 12, 3) AS ExtractString;

*/

--SELECT * FROM sys.filegroups WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.database_files  WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.partition_schemes WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.master_files WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.tables WHERE NAME LIKE '%MOV_POR_PROCESO_PRODUCTO_%'""								
								
								

--SELECT * FROM sys.filegroups WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.database_files  WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.partition_schemes WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.master_files WHERE NAME LIKE '%ATENCION_CLIENTE_HG%'
--SELECT * FROM sys.tables WHERE NAME LIKE '%MOV_POR_PROCESO_PRODUCTO_%'""										
								
								
								
/*******************************************************************
********************************************************************
							LISTAR FILEGROUPS
********************************************************************
********************************************************************/							
							
/*								
USE  
[SIG_COL_LOGISTICA_DW] 
--[SIG_COL_SCN_DM] 
--[SIG_COL_SDM_DW] 
--[SIG_COLOMBIA_DW] 
--[SIG_FACTURACION_DM] 
--[SIG_LOGISTICA_DM] 
--[SIG_RETAIL_DM] 
SELECT
DB_NAME() AS NM_DATABASE,
SCHT.TABLE_SCHEMA,
OBJECT_NAME(p.OBJECT_ID) NOMBRE_TABLA,
        c.name CAMPO_PART,
        ps.name ESQUEMA_PART,
        pf.name FUNCION_PART
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
        pf.name

*/

--SELECT name, database_id, create_date  
--FROM sys.databases; 

/*
DB SIN PARTICIONES: 
*/
--[COGNOS_STG_V3] 
--[CONTENT_METRICS_V3] 
--[DBASatellite] 
--[REPORTES_MEVI_EXPECIALES] 
--[SIG_BI_DM] 
--[SIG_CCM_DM] 
--[SIG_MEVI_DM] 
--[SIG_PAN_LOGISTICA_DW] 
--[SIG_PER_LOGISTICA_DW] 
--[SIG_COL_PYME_DM] 
--[SIG_COL_SAP_DW] 
--[SIG_COL_SPSS] 
--[SIG_ECU_LOGISTICA_DW] 
--[SIG_IMPUESTOS_DM] 
--[SIG_SERV_CLIENTE_DM]

/*
SELECT * FROM sys.partitions
SELECT * FROM sys.partition_schemes
SELECT * FROM sys.index_columns
SELECT * FROM sys.columns
SELECT * FROM sys.data_spaces 
SELECT * FROM sys.objects WHERE name LIKE '%MOV_POR_PROCESO_PRODUCTO%'
SELECT * FROM Information_Schema.Tables
*/


/*
SELECT * from [SIG_COLOMBIA_DW].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_2022%' 
UNION ALL 
SELECT * from [SIG_LOGISTICA_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_2022%' 
UNION ALL 
SELECT * from [SIG_COL_LOGISTICA_DW].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_2022%' 
UNION ALL 
SELECT * from [SIG_RETAIL_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_2022%' 
UNION ALL 
SELECT * from [SIG_COL_PYME_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_2022%' 
UNION ALL 
SELECT * from [SIG_COL_SCN_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_202%' 
UNION ALL 
SELECT * from [SIG_COL_SDM_DW].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_202%' 
UNION ALL 
SELECT * from [SIG_FACTURACION_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_202%' 
UNION ALL 
SELECT * from [SIG_RETAIL_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_202%' 
UNION ALL 
SELECT * from [SIG_SERV_CLIENTE_DM].Information_Schema.Tables TS where TS.TABLE_TYPE='VIEW' AND TS.TABLE_NAME LIKE '%_202%' 
*/



/*
SELECT *
--Obj.name AS table_name,Par.index_id, IDX.name AS index_name , AllUn.type_desc AS allocation_type, AllUn.data_pages, partition_number
FROM sys.allocation_units AS AllUn
    JOIN sys.partitions AS Par ON AllUn.container_id = Par.partition_id
    JOIN sys.objects AS Obj ON Par.object_id = Obj.object_id
    JOIN sys.indexes AS IDX ON Par.index_id = IDX.index_id AND IDX.object_id = Par.object_id
WHERE Obj.name = N'ATENCION_CLIENTE_HG'
*/						