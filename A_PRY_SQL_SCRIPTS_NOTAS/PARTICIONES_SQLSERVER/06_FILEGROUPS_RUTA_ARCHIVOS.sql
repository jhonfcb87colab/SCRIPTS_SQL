--USE SIG_COLOMBIA_DW;
--USE SIG_COL_LOGISTICA_DW;
--USE SIG_COL_PYME_DM;
--USE SIG_COL_SCN_DM;
--USE SIG_COL_SDM_DW;
--USE SIG_FACTURACION_DM;
--USE SIG_LOGISTICA_DM;
--USE SIG_RETAIL_DM;
--USE SIG_COL_SAP_DW;--->NO CONTIENE
USE BICYP;--->NO CONTIENE

declare @db varchar(100) = (SELECT DB_NAME() AS [Current Database]);
SELECT 
	@db as name_database,
    fg.data_space_id, 
    fg.name AS [File Group Name], 
    fg.type_desc AS [File Group Type], 
    df.name AS [DB File Name], 
    df.size / 128 AS [File Size (MB)], 
    df.physical_name AS [File Path]
FROM 
    sys.filegroups fg
LEFT JOIN 
    sys.database_files df ON fg.data_space_id = df.data_space_id;