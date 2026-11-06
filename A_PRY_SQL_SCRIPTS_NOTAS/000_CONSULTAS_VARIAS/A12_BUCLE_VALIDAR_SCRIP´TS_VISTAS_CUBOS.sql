
----USE SIG_COL_LOGISTICA_DW;
----SELECT * FROM 
----[TMP].[GUIAMA_ENV_MOV_TIPO_GUIA_IMPRESION] WITH(NOLOCK)
USE SIG_COL_LOGISTICA_DW;
DROP TABLE IF EXISTS #fechas_procesos_20240217_01;
DROP TABLE IF EXISTS #fechas_procesos_20240217_02;

SELECT 
YEAR*100+MONTH_OF_YEAR ANIOMES,
1 AS NU,
LEFT(CONVERT(VARCHAR(6),S.YEAR*100+MONTH_OF_YEAR),4) ANIO,
RIGHT(CONVERT(VARCHAR(6),S.YEAR*100+MONTH_OF_YEAR),2) MES
INTO #fechas_procesos_20240217_01
FROM DIM.TIEMPO S WITH(NOLOCK) WHERE YEAR>=2003 GROUP BY S.YEAR*100+MONTH_OF_YEAR

SELECT 
ROW_NUMBER() OVER ( PARTITION BY NU ORDER by ANIOMES ASC )  #ROW_ID,
* 
into #fechas_procesos_20240217_02
FROM #fechas_procesos_20240217_01 ORDER BY ANIOMES ASC
------select * from #fechas_procesos_20240217_02
declare @contador int=1;
declare @contador_max int= (select max(#ROW_ID) from #fechas_procesos_20240217_02)
print(@contador_max)
while @contador<=@contador_max
begin 
	DECLARE @ANIO VARCHAR(4) = (select ANIO from #fechas_procesos_20240217_02 WHERE #ROW_ID=@contador)
    DECLARE @MES VARCHAR(2) = (select MES from #fechas_procesos_20240217_02 WHERE #ROW_ID=@contador)
    declare @var_sql nvarchar(max)= 'select TOP 1 ID_TIPO_FORMATO_IMPRESION from fac.ENVIOS_MOVILIZADOS_'+@ANIO+'_'+@MES
	PRINT(CONVERT(VARCHAR,@contador) + '-' + @var_sql)	
	SET @contador = @contador+1;
	---EXEC(@var_sql)
end
