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
			FROM [dbo].[EXTR_IND_15_Indemnizaciones_de_PQR_Vs_Venta] TEMP WITH(NOLOCK)
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
			FROM [dbo].[EXTR_IND_66_Cantidad_de_ineficiencas_x_cada_50MIL_movilizados] TEMP WITH(NOLOCK)

END
