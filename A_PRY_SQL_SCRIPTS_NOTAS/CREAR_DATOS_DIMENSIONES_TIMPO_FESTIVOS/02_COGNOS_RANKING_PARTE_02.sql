--------INSERT INTO [COGNOS_STG_V3].[dbo].[DIM_TIEMPO_RANKING] 
SELECT  REPLACE([MONTH_ID],'2023','2024') as [MONTH_ID]
      ,2024 [THEYEAR]
      ,[QUARTEROFYEAR]
      ,[MONTHOFYEAR]
      ,[THEMONTH]
      ,getdate() as [FECHA_ACTUALIZACION]
      ,getdate() as [FECHA_CREACION]
  FROM [COGNOS_STG_V3].[dbo].[DIM_TIEMPO_RANKING] 
  where MONTH_ID like '2026%'
  order by 1



SELECT *   FROM [COGNOS_STG_V3].[dbo].[DIM_TIEMPO_RANKING] 
where MONTH_ID like '2026%' 
order by 1





/******************************** NO SE TOCA 
SE CARGA CON LA ETL DE RANKING
SELECT *
FROM [COGNOS_STG_V3].[dbo].[PRM_PROCESO_RAN] 
WHERE Id_Periodo>=202310 

*********************************/



/********************				actualizar tablas  de periodos			*****************/
SELECT  [ID_PERIODO]
      , [DESCRIPCION_PERIODO]
  FROM [SIG_COL_LOGISTICA_DW].[RAN].[PERIODOS]





SELECT * FROM [COGNOS_STG_V3].[dbo].[DIM_TIEMPO_RANKING] 
 where MONTH_ID like '2026%'


