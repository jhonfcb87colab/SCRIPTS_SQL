

/*
EXTR_IND_63_Gastos_de_Transporte_vs_Ingresos 
EXTR_IND_64_Participacion_envios_movilizados_modelos_Flexibles
EXTR_IND_65_Cumpl_Ppto_Total_de_Ingresos
EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados
*/



/*

DECLARE @ID_INDICADOR INT,@ID_MES INT;
SET @ID_INDICADOR = 66;
SET @ID_MES= (SELECT ID_PERIODO FROM PRM_PROCESO_RAN where Estado_Proceso = 0)
SELECT 
		ID_MES = @ID_MES
		,ID_REGIONAL = GEO.ID_REGIONAL
		,NOMBRE_REGIONAL  = GEO.NOMBRE_REGIONAL
		,Id_indicador  = @ID_INDICADOR
		,Nombre_Indicador  = (SELECT INDIC.Nombre_Indicador FROM DBO.DIM_INDICADOR_RANKING INDIC WHERE id_indicador=@ID_INDICADOR)
		,Marca_meta  = 0
		,Puntos  = 0
		,LIMITE_SUP  = 0
		,LIMITE_INF  = 0
		,VALOR_REAL  = 0
		,VALOR_CUMPLIMIENTO  = 0
		,PUNTAJE_MES  = 0
		,PORC_PUNTOS  = 0
		--INTO [dbo].[EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados]
FROM DBO.DIM_GEOGRAFIA_RANKING GEO WITH(NOLOCK)
WHERE GEO.ID_REGIONAL>=1
ORDER BY 2


*/

/*
--------------------------------------------------------
TRUNCATE TABLE [dbo].[EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados];
DECLARE @ID_INDICADOR INT,@ID_MES INT;
SET @ID_INDICADOR = 66;
SET @ID_MES= (SELECT ID_PERIODO FROM PRM_PROCESO_RAN where Estado_Proceso = 0)
INSERT INTO [dbo].[EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados]
SELECT 
		ID_MES = @ID_MES
		,ID_REGIONAL = GEO.ID_REGIONAL
		,NOMBRE_REGIONAL  = GEO.NOMBRE_REGIONAL
		,Id_indicador  = @ID_INDICADOR
		,Nombre_Indicador  = (SELECT INDIC.Nombre_Indicador FROM DBO.DIM_INDICADOR_RANKING INDIC WHERE id_indicador=@ID_INDICADOR)
		,Marca_meta  = 0
		,Puntos  = 0
		,LIMITE_SUP  = 0
		,LIMITE_INF  = 0
		,VALOR_REAL  = 0
		,VALOR_CUMPLIMIENTO  = 0
		,PUNTAJE_MES  = 0
		,PORC_PUNTOS  = 0
FROM DBO.DIM_GEOGRAFIA_RANKING GEO WITH(NOLOCK)
WHERE GEO.ID_REGIONAL>=1
ORDER BY 2

*/





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
			FROM [dbo].[EXTR_IND_63_Gastos_de_Transporte_vs_Ingresos] TEMP WITH(NOLOCK)
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

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
			FROM [dbo].[EXTR_IND_64_Participacion_envios_movilizados_modelos_Flexibles] TEMP WITH(NOLOCK)
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

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
			FROM [dbo].[EXTR_IND_65_Cumpl_Ppto_Total_de_Ingresos] TEMP WITH(NOLOCK)
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
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
			FROM [dbo].[EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados] TEMP WITH(NOLOCK)

END

*/


select * from PRM_PROCESO_RAN where Estado_Proceso = 0

--SELECT 
--id_indicador,Estado  
------------UPDATE R SET R.Estado=0
--FROM PRM_INDICADORES R WHERE R.id_indicador IN
--(58
--,35
--,22
--,9
--,59
--,56
--,54)

SELECT SO.NAME NAME_TABLA, SC.NAME NAME_COLUMNA 
FROM sys.objects SO INNER JOIN sys.columns SC 
ON SO.OBJECT_ID = SC.OBJECT_ID 
WHERE SO.TYPE = 'U' and SC.NAME like '%ESTADO%'
ORDER BY SO.NAME, SC.NAME 



SELECT        id_indicador, Nombre_Indicador, id_agrupador1, nombre_agrupador1, id_agrupador2, nombre_agrupador2, id_agrupador3, nombre_agrupador3, Tipo_Medicion, Tipo_Calculo, Puntos, Limite_Sup, Limite_Inf, 
                         Fuente, Formula, Valor_Tolerancia, Tabla_Extraccion, Operador1, Operador2, Estado, Condicion_Consulta, Prefijo_Metrica, Prefijo_Calificador, Prefijo_Agrupador, Peso_Mejoramiento, Peso_Resultado, Posicion1, 
                         Posicion2, Posicion3, Posicion4, Posicion5, Posicion6, Posicion7, Posicion8, Posicion9, Posicion10, Umbral_Alto, Umbral_Bajo, Formato_Medida, Puntos_Si_Cumple, Marca_Meta, Marca_Acum, 
                         Marca_Calc_Cumpl, Marca_Puntaje
FROM            PRM_INDICADORES
