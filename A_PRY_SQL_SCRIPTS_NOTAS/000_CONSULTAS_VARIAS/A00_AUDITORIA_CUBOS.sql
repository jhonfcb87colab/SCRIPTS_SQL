---max([currenttime])
SELECT * -----INTO [SIG_COL_LOGISTICA_DW].[TMP].[AUDIT_USER_LOGIN_CUBES_27_01_122023_bk_20231128]
FROM [SIG_COL_LOGISTICA_DW].[TMP].[AUDIT_USER_LOGIN_CUBES_11_15_122023] with(nolock)

/*
INSERT INTO  [SIG_COL_LOGISTICA_DW].[TMP].[AUDIT_USER_LOGIN_CUBES_27_01_122023] 
( 
      [EventClass] 
      ,[ConnectionID] 
      ,[SPID] 
      ,[NTCanonicalUserName] 
      ,[ObjectPath] 
      ,[StartTime] 
      ,[CurrentTime] 
      ,[DatabaseName] 
      ,[BinaryData] 
) 
SELECT  
      [EventClass] 
      ,[ConnectionID] 
      ,[SPID] 
      ,[NTCanonicalUserName] 
      ,[ObjectPath] 
      ,[StartTime] 
      ,[CurrentTime] 
      ,[DatabaseName] 
      ,[BinaryData] 
FROM [SIG_COL_LOGISTICA_DW].[TMP].[AUDIT_USER_LOGIN_CUBES_27_01_122023_bk_20231128]

*/

USE SIG_COL_LOGISTICA_DW
SELECT * FROM TMP.AUDIT_USER_LOGIN_CUBES_06_10_012025 with(nolock)
where NTCanonicalUserName like '%RODRIA%'

		 MAX(NUM_TABLE)+1---, ---@TABLA+@FECHA_SEMANA
SELECT	*	FROM TMP.AUDIT_TBL_TEMP_TRACE

SELECT * FROM [SIG_COL_LOGISTICA_DW].[TMP].[AUDIT_TBL_TEMP_TRACE]




SELECT * FROM DIM.AUDIT_FECHA_SEMANAS WITH (NOLOCK) /*Tabla con la fecha de los días lunes y viernes*/
WHERE YEAR(FECHA)=2024 AND MONTH(FECHA)=12 ------->='2024-12-20'
--- INSERT INTO DIM.AUDIT_FECHA_SEMANAS
SELECT 
DATE AS FECHA,
YEAR AS AÑO,
MONTH_OF_YEAR AS MES,
DAY([DATE]) AS DIA_INI_SEMANA_TBL,
DAY(DATEADD(DAY,4,[DATE])) DIA_FIN_SEMANA_TBL,
WEEK_OF_YEAR AS SEMANA_DEL_AÑO
FROM DIM.TIEMPO (NOLOCK)
WHERE [DAY]='Lunes' AND
YEAR([DATE])=2024 AND MONTH([DATE])=12
--[DATE]>'2025-01-04' and 





/*





------------INSERT INTO DIM.AUDIT_FECHA_SEMANAS
------------SELECT 
------------DATE AS FECHA,
------------YEAR AS AÑO,
------------MONTH_OF_YEAR AS MES,
------------DAY([DATE]) AS DIA_INI_SEMANA_TBL,
------------DAY(DATEADD(DAY,4,[DATE])) DIA_FIN_SEMANA_TBL,
------------WEEK_OF_YEAR AS SEMANA_DEL_AÑO
------------FROM DIM.TIEMPO (NOLOCK)
------------WHERE [DAY]='Lunes' AND
---------------YEAR([DATE])=2024 AND MONTH([DATE])=12
------------[DATE]>'2025-01-04'  








*/