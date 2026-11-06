
/*
TRUNCATE TABLE [dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO2];

WITH CTE AS(
SELECT 
ID_MES	
,ID_REGIONAL	
,NOMBRE_REGIONAL	
,Id_indicador	
,Nombre_Indicador	
,Marca_meta	
,Puntos	
,LIMITE_SUP	
,LIMITE_INF
,CONVERT(FLOAT,VALOR_REAL) VALOR_REAL
,VALOR_CUMPLIMIENTO = CONVERT(FLOAT,VALOR_REAL) / CONVERT(FLOAT,Marca_meta)
FROM [dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO1] WITH(NOLOCK)
UNION ALL
SELECT 
ID_MES	
,ID_REGIONAL=99	
,NOMBRE_REGIONAL='CONSOLIDADO NACIONAL'
,Id_indicador	
,Nombre_Indicador	
,MAX(Marca_meta) Marca_meta	
,MAX(Puntos) Puntos	
,MAX(LIMITE_SUP) LIMITE_SUP	
,MAX(LIMITE_INF) LIMITE_INF
,AVG(CONVERT(FLOAT,VALOR_REAL)) VALOR_REAL	
,VALOR_CUMPLIMIENTO = CONVERT(FLOAT,AVG(VALOR_REAL)) / CONVERT(FLOAT,AVG(Marca_meta))
FROM [dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO1] WITH(NOLOCK)
GROUP BY 
ID_MES	
,Id_indicador	
,Nombre_Indicador
) 
INSERT INTO [dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO2]
SELECT 
*
FROM CTE
*/


--SELECT 
--	ID_MES
--	,ID_REGIONAL
--	,NOMBRE_REGIONAL
--	,Id_indicador
--	,Nombre_Indicador
--	,Marca_meta
--	,Puntos
--	,LIMITE_SUP
--	,LIMITE_INF
--	,VALOR_REAL
--	,VALOR_CUMPLIMIENTO
--FROM
--[dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO2] WITH(NOLOCK)



--SELECT 
--*
--FROM
--[dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO3] WITH(NOLOCK)



/*



DECLARE @VAR INT;
SET @VAR = (SELECT ITERACCIONES_1 FROM DBO.DIM_CONTADOR WITH(NOLOCK))
IF  @VAR=1
BEGIN
INSERT INTO TRSF_FACT_INDICADORES_RANKING
SELECT 
		Id_Mes=TEMP.ID_MES	
		,Id_Regional= TEMP.ID_REGIONAL	
		,id_indicador	= TEMP.Id_indicador
		,Nombre_Indicador	= TEMP.Nombre_Indicador
		,valor_mes = 0
		,Valor_objetivo	= 0
		,Valor_tolerancia	=0.5
		,fec_actu	= GETDATE()
		,valor = 0	
		,valor_ant = 0	
		,meta	= TEMP.Marca_meta
		,VREAL = 	TEMP.VALOR_REAL
		,Puntaje_Mes	= TEMP.PUNTAJE_MES
		,Porc_Puntos	= TEMP.PORC_PUNTOS
		,Puntos	= TEMP.Puntos
		,valor_cumplimiento	= TEMP.VALOR_CUMPLIMIENTO
		,VALOR_LIMITE_SUPERIOR =	TEMP.LIMITE_SUP
		,VALOR_LIMITE_INFERIOR = TEMP.LIMITE_INF	
		,Marca_Puntaje = Marca_meta
		FROM [dbo].[EXTR_Indemnizaciones_regional_valor_indemnizado_indicador_id_62_PASO3] TEMP WITH(NOLOCK)
END


*/