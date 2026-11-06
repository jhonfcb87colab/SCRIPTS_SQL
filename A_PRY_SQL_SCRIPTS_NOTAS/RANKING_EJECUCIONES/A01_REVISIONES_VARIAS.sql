/******
INDICADORES INGRESADOS POR ORLANDO
******/

use [SIG_COL_LOGISTICA_DW]


SELECT TOP (1000) [ID_RENTABILIDAD]
      ,[ID_PERIODO]
      ,[ID_REGIONAL_PAIS]
      ,[PORCENTAJE_RENTABILIDAD]
  FROM [SIG_COL_LOGISTICA_DW].[RAN].[RENTABILIDAD]
  WHERE ID_PERIODO=202512

SELECT [ID_ROTACION_TH]
      ,[ID_PERIODO]
      ,[ID_REGIONAL_PAIS]
      ,[INGRESOS]
      ,[RETIROS]
      ,[PLANTA]
      ,[PORCENTAJE_ROTACION]
  FROM [RAN].[ROTACION_TH]
  WHERE ID_PERIODO=202512


SELECT [ID_SISO_INDICE]
      ,[ID_PERIODO]
      ,[ID_REGIONAL_PAIS]
      ,[INDICE_ANTERIOR]
      ,[INDICE_ACTUAL]
      ,[INDICE_ACCIDENTALIDAD]
  FROM [RAN].[SISO_INDICE]
  WHERE ID_PERIODO=202512
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/******
INDICADORES INGRESADOS POR LOS SCRIPTS DE LOS MANUALES ARCHIVO EXCEL DE ORLANDO
******/
----53-Gastos Lab vs Ventas
SELECT * FROM [SIG_COL_LOGISTICA_DW].[RAN].[GASTOS_LAB_VS_VENTAS] 
WHERE ID_PERIODO=202512 

----36-Cartera Riesgo
SELECT * FROM [SIG_COL_LOGISTICA_DW].[RAN].[CARTERA_RIESGO] 
WHERE ID_PERIODO=202512 

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


/******
REVISION DE TABLAS DE INDICADORES
******/

SELECT *
FROM [COGNOS_STG_V3].[dbo].[FACT_INDICADORES_RANKING]
  WHERE Id_Mes=202512

SELECT *  FROM [COGNOS_STG_V3].[dbo].[PRM_PROCESO_RAN] ORDER BY Id_Periodo DESC
--WHERE Id_Periodo>202211  
 
SELECT *  FROM [COGNOS_STG_V3].[dbo].[FACT_INDICADORES_RANKING] 
WHERE Id_Mes=202511 
 

