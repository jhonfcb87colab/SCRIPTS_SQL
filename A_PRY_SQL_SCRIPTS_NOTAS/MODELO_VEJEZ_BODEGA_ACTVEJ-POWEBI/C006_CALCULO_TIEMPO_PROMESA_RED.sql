/*
/*******************************************************************************************************************************************
**Proyecto:       Cubo: ENVIOS MOVILIZADOS - Perspectiva: GUIAS ENTREGADAS EN TIEMPO DE PROMESA REDOPERATIVA.
**Descripción:    Determina el Tiempo sin tener en cuenta Domingos y Festivos por Guia, aplicado a TIEMPO_PROMESA_H
				  luego inserta la información agrupadamente (sin guias) en la tabla FAC.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
				  (Forma de calculo similar a PQR)
**Autor:          PRONÓSTICA SAS
**Fecha creación: 2018-04-10
********************************************************************************************************************************************/

-- =========================================================================================================
-- PASO 01 DEFINIR VARIABLES TEMPORALES
-- =========================================================================================================

	 DECLARE @NUM_REG INT
			,@CONSECUTIVO INT
			,@FECHA_MIN DATETIME
			,@FECHA_CAM DATETIME
			,@FECHA_ULT DATETIME
			,@FMIN DATETIME
			,@FMAX DATETIME
			,@FECHA_MINIMA DATETIME
			,@FECHA_MAX DATETIME
			,@MENOS_MI INT
			,@MENOS_MA INT
			,@TIEMPO INT
			,@CONCEPTO VARCHAR(2)
			
	/*CREACIÓN DE LAS TABLAS TEMPORALES PARA EL PROCESO EN EL WHILE*/
	IF OBJECT_ID('TEMPDB..#TMP_GUIA_FECHA') IS NOT NULL
	DROP TABLE #TMP_GUIA_FECHA
	
	IF OBJECT_ID('TEMPDB..#TMP_TIEMPO_ENV_MOV') IS NOT NULL
	DROP TABLE #TMP_TIEMPO_ENV_MOV
		
	CREATE TABLE #TMP_GUIA_FECHA
		(
			CONSECUTIVO INT IDENTITY(1,1),
			NUMERO_GUIA NUMERIC(20) NULL,
			ID_CONCEPTO VARCHAR(10) NULL,
			FECHA_ENVIO DATETIME NULL,
			FECHA_ENTREGA DATETIME NULL
		)

	CREATE TABLE #TMP_TIEMPO_ENV_MOV
		(
			CONSECUTIVO INT,
			NUMERO_GUIA NUMERIC(20) NULL,
			ID_CONCEPTO VARCHAR(10) NULL,
			FECHA_ENVIO DATETIME NULL,
			FECHA_ENTREGA DATETIME NULL,
			TIEMPO NUMERIC(18) NULL
		)

-- =========================================================================================================
-- PASO 02 INSERTAR EN UNA TABLA TEMPORAL LOS CAMPOS NECESARIOS PARA EL CALCULO DE TIEMPO
-- =========================================================================================================

	INSERT INTO  #TMP_GUIA_FECHA
               SELECT   NUMERO_GUIA
	               ,'0' ID_CONCEPTO
		,FECHA FECHA_ENVIO
                                ,ISNULL(FECHA_ENTREGA,CONVERT(DATETIME,CONVERT(DATE,GETDATE()))) FECHA_ENTREGA
	FROM SIG_COL_LOGISTICA_DW.TMP.PROMESA  AS EM WITH (NOLOCK)
	ORDER BY FECHA_ENVIO, NUMERO_GUIA

	CREATE INDEX IDX2 ON #TMP_GUIA_FECHA(CONSECUTIVO)

-- =========================================================================================================
-- PASO 03 BUCLE PARA EL CALCULO DEL TIEMPO DE PROMESA
-- =========================================================================================================

-- =========================================================================================================
-- PASO 03.01 INICIA CONTADORES DEL BUCLE
-- =========================================================================================================

	SET @NUM_REG = 0
	SET @CONSECUTIVO = 0

	SELECT	@NUM_REG = COUNT(CONSECUTIVO)
	FROM	#TMP_GUIA_FECHA

-- =========================================================================================================
-- PASO 03.02 INICIA EL BUCLE
-- =========================================================================================================
	WHILE @NUM_REG >= @CONSECUTIVO
	BEGIN	
		SET	@CONSECUTIVO = @CONSECUTIVO + 1
		
	-- =========================================================================================================
	-- PASO 03.02.01 ASIGNA LAS FECHAS A LAS VARIABLES
	-- =========================================================================================================
		SET @FMIN = (	SELECT FECHA_ENVIO
						FROM #TMP_GUIA_FECHA WITH (NOLOCK)
						WHERE CONSECUTIVO = @CONSECUTIVO
					) 

		SET @FMAX = (	SELECT FECHA_ENTREGA
						FROM #TMP_GUIA_FECHA WITH (NOLOCK)
						WHERE CONSECUTIVO = @CONSECUTIVO
					) 
	-- =========================================================================================================
	-- PASO 03.02.02 DECLARA TABLA PARA LOS FESTIVOS
	-- =========================================================================================================
		DECLARE @FestivosNal TABLE 
		(	FECHA DATETIME, 
			DiaHabil bit )

	-- =========================================================================================================
	-- PASO 03.02.03 ASIGNA LAS FECHAS SIN HORAS Y LA FECHA DE PASO CON EL VALOR  DE LA FECHA MINIMA
	-- =========================================================================================================
		SELECT @FECHA_MIN = @FMIN
		SET @FECHA_MIN = CONVERT(DATETIME, CONVERT(VARCHAR,@FECHA_MIN,112))
		SET @FECHA_CAM = @FECHA_MIN
		SET @FECHA_ULT = CONVERT(DATETIME, CONVERT(VARCHAR,@FMAX,112))
		
	-- =========================================================================================================
	-- PASO 03.02.04 RECORRE ENTRE LA FMIN Y LA FMAX, IDENTIFICA LOS DOMINGOS CON 0 Y LOS DEMÁS DÍAS CON 1
	-- =========================================================================================================
		WHILE @FECHA_CAM <= @FECHA_ULT
		BEGIN
			
			IF DATEPART(DW,@FECHA_CAM) = 1 /* 1 = DOMINGO */
				INSERT INTO @FestivosNal (FECHA,DiaHabil) VALUES(@FECHA_CAM,0) /*0 = NO HÁBIL*/
			ELSE
				INSERT INTO @FestivosNal (FECHA,DiaHabil) VALUES(@FECHA_CAM,1) /*1 = HÁBIL*/		         
			SET @FECHA_CAM=DATEADD(D,1,@FECHA_CAM)
		END
			  
	-- =========================================================================================================
	-- PASO 03.02.05 ELIMINA DE LA TEMPORAL LO DÍAS FESTIVOS
	-- =========================================================================================================
		DELETE A 
		FROM @FestivosNal A 
			INNER JOIN DIM.TIEMPO_FESTIVOS_NACIONALES B (NOLOCK) 
				ON A.FECHA = B.FECHA_FESTIVA 
		WHERE ID_PAIS = 1 /*1 = COLOMBIA*/
		
	-- =========================================================================================================
	-- PASO 03.02.06 INSERTA DE LA TEMPORAL LO DÍAS FESTIVOS Y LOS MARCA CON CERO
	-- =========================================================================================================
		INSERT INTO @FestivosNal 
		SELECT FECHA_FESTIVA,0 /*MARCA EL FESTIVO COMO NO HABIL: 0*/
		FROM DIM.TIEMPO_FESTIVOS_NACIONALES (NOLOCK) 
		WHERE FECHA_FESTIVA BETWEEN @FECHA_MIN AND @FECHA_ULT
			AND ID_PAIS = 1  /*1 = COLOMBIA*/
				
	-- =========================================================================================================
	-- PASO 03.02.07 ASIGNA LAS VARIABLES PARA LA DIFERENCIA EN MINUTOS DEL PRIMER Y ULTIMO DÍA
	-- =========================================================================================================
		SET @FECHA_Minima = @FMIN
		SET @FECHA_Max = @FMAX
		SET @MENOS_MI = 0
		SET @MENOS_MA = 0

	-- =========================================================================================================
	-- PASO 03.02.08 CALCULA LA DIFERENCIA EN MINUTOS ENTRE LAS CERO HORAS DEL INICIAL HASTA LA HORA DE LA FECHA MINIMA
	-- =========================================================================================================
		IF EXISTS (SELECT * FROM  @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_MINIMA)) AND DiaHabil = 1)
		BEGIN
			SET @MENOS_MI =	(SELECT DATEDIFF(MI,FECHA,@FECHA_Minima) FROM @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_Minima)))
		END	
		ELSE
		BEGIN
			IF EXISTS (SELECT * FROM  @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_MINIMA)) AND DiaHabil = 0)
			BEGIN
				SET @MENOS_MI =	0
			END
		END

	-- =========================================================================================================
	-- PASO 03.02.09 CALCULA LA DIFERENCIA EN MINUTOS ENTRE LA FECHA MAXIMA Y LAS CERO HORAS DEL DIA SIGUIENTE
	-- =========================================================================================================
		IF EXISTS (SELECT * FROM  @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_MAX)) AND DiaHabil = 1)
		BEGIN
			SET @MENOS_MA = (SELECT DATEDIFF(MI,@FECHA_MAX,DATEADD(DAY,1,FECHA)) FROM @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_MAX)))
		END	
		ELSE
		BEGIN		
			IF EXISTS (SELECT * FROM  @FestivosNal WHERE (CONVERT(DATE,FECHA)) = (CONVERT(DATE,@FECHA_MAX)) AND DiaHabil = 0)
			BEGIN
				SET @MENOS_MA = 0
			END
		END	
		
	-- =========================================================================================================
	-- PASO 03.02.10 CALCULA EL TIEMPO SUMANDO LOS DÍAS HABILES, MULTIPLICANDOLOS POR 1440 Y RESTANDO LAS DIFERENCIAS DE LOS PASOS
	-- 03.02.08 Y 03.02.09
	-- =========================================================================================================
		SET @TIEMPO = (SELECT (SUM(CONVERT(INT,DiaHabil))*1440 /*24 Horas*/) - @MENOS_MI - @MENOS_MA TIEMPO_TOT FROM @FestivosNal)

	-- =========================================================================================================
	-- PASO 03.02.11 BORRA LOS DÍAS DE LA TABLA TEMPORAL Y LA PREPARA PARA UNA SIGUIENTE GUÍA
	-- =========================================================================================================
		DELETE @FestivosNal
		
	-- =========================================================================================================
	-- PASO 03.02.12 INSERTA X CADA GUÍA DEL BUCLE EL TIEMPO Y EL CONCEPTO CALCULADO
	-- =========================================================================================================
				
	SET @CONCEPTO = '1'

		      
	   IF EXISTS(SELECT * FROM (SELECT TOP 2 * FROM (SELECT * FROM (SELECT * FROM  TMP.PROMESA_PROCESOS WHERE NUMERO_GUIA = (SELECT NUMERO_GUIA  FROM #TMP_GUIA_FECHA WHERE CONSECUTIVO = @CONSECUTIVO) ) TA WHERE ID_PROCESO = 21) TB) TC WHERE ID_CONCEPTO = 71)
BEGIN
	SET @CONCEPTO = '2'

		
END
ELSE
BEGIN 

	IF EXISTS(SELECT * FROM (SELECT TOP 2 * FROM (SELECT * FROM (SELECT * FROM  TMP.PROMESA_PROCESOS WHERE NUMERO_GUIA = (SELECT NUMERO_GUIA  FROM #TMP_GUIA_FECHA WHERE CONSECUTIVO = @CONSECUTIVO)) TA WHERE ID_PROCESO = 21) TB) TC WHERE ID_CONCEPTO = 72)
	BEGIN
	SET @CONCEPTO = '3'

	
	END	
	ELSE
	BEGIN

		IF EXISTS(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM  TMP.PROMESA_PROCESOS WHERE NUMERO_GUIA = (SELECT NUMERO_GUIA  FROM #TMP_GUIA_FECHA WHERE CONSECUTIVO = @CONSECUTIVO)) TA WHERE ID_PROCESO = 9) TB) TC WHERE ID_CONCEPTO IN (2,4,7,9))
		BEGIN
			SET @CONCEPTO = '4'

						
		END  
		ELSE
		BEGIN

			IF EXISTS(SELECT * FROM (SELECT * FROM (SELECT TOP 2 * FROM (SELECT * FROM (SELECT * FROM  TMP.PROMESA_PROCESOS WHERE NUMERO_GUIA = (SELECT NUMERO_GUIA  FROM #TMP_GUIA_FECHA WHERE CONSECUTIVO = @CONSECUTIVO)) TA WHERE ID_PROCESO = 21) TB) TC WHERE ID_CONCEPTO = 73) TD WHERE DATEPART(WEEKDAY,FECHA_HORA_MOVIMIENTO) = 7)
			BEGIN
				SET @CONCEPTO = '5'

			
			END
			ELSE
			BEGIN
				SET @CONCEPTO = '1'
			

			END
		END
	END
END
UPDATE	#TMP_GUIA_FECHA SET ID_CONCEPTO = @CONCEPTO WHERE  CONSECUTIVO = @CONSECUTIVO		
			
				INSERT INTO #TMP_TIEMPO_ENV_MOV
				SELECT	CONSECUTIVO 
					,NUMERO_GUIA
					,ID_CONCEPTO 
					,FECHA_ENVIO 
					,FECHA_ENTREGA					
					,@TIEMPO
			 FROM	#TMP_GUIA_FECHA 
				WHERE CONSECUTIVO = @CONSECUTIVO


DELETE FROM #TMP_GUIA_FECHA WHERE CONSECUTIVO = @CONSECUTIVO

END


 --=========================================================================================================
-- PASO 04 CALCULAR LA PROMESA
-- =========================================================================================================
	
	--=========================================================================================================
	-- PASO 04.01 INSERTA EN LA TABLA TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	-- =========================================================================================================
	
		TRUNCATE TABLE TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA

	
	INSERT INTO TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	(
	   [TIME_ID]
      ,[FECHA]
      ,[DIA]
      ,[MES]
      ,[AÑO]
      ,[ID_CIUDAD_ORIGEN]
      ,[ID_CIUDAD_DESTINO]
      ,[ID_ESTADOENVIO]
	  ,[ID_PRODUCTO]
      ,[ID_SUBPRODUCTO]
	  ,[ID_CLIENTE]
      ,[ID_CONCEPTO]
      ,[ID_TIEMPO_ENTREGA]
      ,[ID_MEDTRANS]
      ,[NUMERO_GUIA]      
      ,[TIEMPO_PROMESA_H]  
	  ,[TIEMPO_PROMESA_CUMPLE_H] 	
	 , [HORAS_ND]
 	,[ID_ESTADO_ND]
	,[GR_ID_TIPO_COBRO]
		 
	)
	SELECT 	    
	    CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),EM.FECHA)))AS TIMEID
		,CONVERT(DATETIME,CONVERT(CHAR(11),EM.FECHA))AS FECHA
		,DAY (EM.FECHA) AS DIA
		,MONTH (EM.FECHA) AS MES
		,YEAR (EM.FECHA) AS AÑO
		,ISNULL(EM.ID_CIUDAD_ORIGEN,0) AS ID_CIUDAD_ORIGEN
		,ISNULL(EM.ID_CIUDAD_DESTINO,0) AS ID_CIUDAD_DESTINO
                                ,EM.ID_ESTADOENVIO
   		,EM.ID_PRODUCTO
                                ,EM.ID_SUBPRODUCTO
                               ,EM.ID_CLIENTE
		,T.ID_CONCEPTO
		,ISNULL(EM.ID_TIEMPO_ENTREGA,0) AS ID_TIEMPO_ENTREGA
		,ISNULL(EM.ID_MEDTRANS,0) AS ID_MEDTRANS
		,EM.NUMERO_GUIA
		,CASE /*Se toman las condiciones como en el campo TIEMPO_EN_ENTREGA, omitiendo Domingos y festivos y sin aplicar 2880 (48 Horas), sino 2160/60 (36 Horas), para no impactar en el resultado del campo TIEMPO_PROMESA_CUMPLE_H mas adelante (Revisado con Aldemar Sanchez)*/
			WHEN EM.ID_ESTADOENVIO < 3 AND EM.FECHA_ENTREGA IS NULL 
				THEN T.TIEMPO/60
			WHEN (EM.ID_DOCU_ULT_MOVI <> 11 OR EM.ID_DOCU_ULT_MOVI <> 24) AND EM.FECHA_ENTREGA IS NULL 
				THEN T.TIEMPO/60						
			ELSE T.TIEMPO/60
		END AS TIEMPO_PROMESA_H,
			-- Si el tiempo de entrega es hoy mismo, aquí se cálcula la promesa	
			CASE WHEN EM.ID_TIEMPO_ENTREGA = 2 THEN
				-- Si el tiempo de entrega es hoy mismo y tiene novedad operativa, la promesa debe ser hoy o el siguiente día
				CASE WHEN (SELECT SUM(ISNULL(ND_HORAS,0)) FROM SIG_COLOMBIA_DW.TMP.PROMESA_ND WHERE NUMERO_GUIA = EM.NUMERO_GUIA) > 0 THEN
					CASE WHEN (CONVERT(DATE,EM.FECHA_ENTREGA) =  CONVERT(DATE,EM.FECHA)) OR (CONVERT(DATE,EM.FECHA_ENTREGA) =  DATEADD(DAY,1,CONVERT(DATE,EM.FECHA))) THEN
						'SI'
					ELSE
						'NO'
					END
				ELSE
					-- Si el tiempo de entrega es hoy mismo y no tiene novedad operativa, la promesa debe ser hoy
					CASE WHEN (CONVERT(DATE,EM.FECHA_ENTREGA) =  CONVERT(DATE,EM.FECHA)) THEN
						'SI'
					ELSE
						'NO'
					END
				END
			ELSE
				-- Si el tiempo de entrega es cero horas, aquí se cálcula la promesa	
				CASE WHEN EM.ID_TIEMPO_ENTREGA = 3 THEN
					-- Si el tiempo de entrega es cero horas y tiene novedad operativa, la promesa la puede cumplir hasta el final del dia del siguiente día habil
					CASE WHEN (SELECT SUM(ISNULL(ND_HORAS,0)) FROM SIG_COLOMBIA_DW.TMP.PROMESA_ND WHERE NUMERO_GUIA = EM.NUMERO_GUIA) > 0 THEN
						CASE WHEN EM.FECHA_ENTREGA < DATEADD(DAY,1,CONVERT(DATETIME,CONVERT(DATE,EM.FECHA_VIGENTE)))   THEN 
							'SI'
						ELSE 
							'NO'
						END
					ELSE
						-- Si el tiempo de entrega es cero horas y no tiene novedad operativa, la promesa la puede cumplir hasta las 9:00am del siguiente día habil
						CASE WHEN EM.FECHA_ENTREGA <= EM.FECHA_VIGENTE   THEN 
							'SI'
						ELSE 
							'NO'
						END
					END
				ELSE
					--Si no es hoy mismo o cero horas, la promesa se cálcula con la red operativa
					NULL
				END
			END TIEMPO_PROMESA_CUMPLE_H 
                                               , 0  HORAS_ND
 			,'NO'  ID_ESTADO_ND
			,EM.GR_ID_TIPO_COBRO
	   FROM #TMP_TIEMPO_ENV_MOV T
			INNER JOIN  SIG_COL_LOGISTICA_DW.TMP.PROMESA EM WITH (NOLOCK)
				ON T.NUMERO_GUIA = EM.NUMERO_GUIA	
				

	 --=========================================================================================================
	 --PASO 04.02 CREA INDICES PARA OPTIMIZAR EL CÁLCULO
	 --=========================================================================================================

	IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA') AND NAME ='IX_TMP_GUIAS_RED_OPERATIVA_PROMESA')
		DROP INDEX IX_TMP_GUIAS_RED_OPERATIVA_PROMESA ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA

	CREATE NONCLUSTERED INDEX IX_TMP_GUIAS_RED_OPERATIVA_PROMESA ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	(
		TIEMPO_PROMESA_H ASC
	)
	INCLUDE (TIEMPO_OFERTA)

	IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA') AND NAME ='IX_TMP_GUIAS_RED_OPERATIVA_RUTA')
		DROP INDEX IX_TMP_GUIAS_RED_OPERATIVA_RUTA ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA

	CREATE NONCLUSTERED INDEX IX_TMP_GUIAS_RED_OPERATIVA_RUTA ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	(
		ID_RUTA ASC
	)

	IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA') AND NAME ='IX_TMP_GUIAS_RED_OPERATIVA_TIME_ID')
		DROP INDEX IX_TMP_GUIAS_RED_OPERATIVA_TIME_ID ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA

	CREATE NONCLUSTERED INDEX IX_TMP_GUIAS_RED_OPERATIVA_TIME_ID ON TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	(
		TIME_ID ASC
	)	
				
	 --=========================================================================================================
	 --PASO 04.03 OBTIENE LAS RUTAS DE RED OPERATIVA HABILES Y LAS LLEVA A UNA TEMPORAL
	 --=========================================================================================================

	TRUNCATE TABLE TMP.RED_OPERATIVA_RUTA

	INSERT INTO TMP.RED_OPERATIVA_RUTA
	(
		 ID_RUTA
		,ID_CIUDAD_ORIGEN
		,ID_CIUDAD_DESTINO
		,ID_TIEMPO
		,ID_MEDTRANS
	)
	SELECT
		 MAX(ID_RUTA) ID_RUTA
		,ID_CIUDAD_ORIGEN
		,ID_CIUDAD_DESTINO
		,ID_TIEMPO
		,ID_MEDTRANS
	FROM
		DIM.RED_OPERATIVA_RUTA
	WHERE
		ID_ESTADO_RUTA = 1
	GROUP BY
		 ID_CIUDAD_ORIGEN
		,ID_CIUDAD_DESTINO
		,ID_TIEMPO
		,ID_MEDTRANS

	 --=========================================================================================================
	 --PASO 04.04 CREA INDICES PARA OPTIMIZAR EL CÁLCULO
	 --=========================================================================================================


	IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('TMP.RED_OPERATIVA_RUTA') AND NAME ='IX_TMP_RED_OPERATIVA_RUTA_ESTADO_CIUDAD')
		DROP INDEX [IX_TMP_RED_OPERATIVA_RUTA_ESTADO_CIUDAD] ON [TMP].[RED_OPERATIVA_RUTA]

	CREATE NONCLUSTERED INDEX [IX_TMP_RED_OPERATIVA_RUTA_ESTADO_CIUDAD] ON [TMP].[RED_OPERATIVA_RUTA]
	(
		 ID_CIUDAD_ORIGEN
		,ID_CIUDAD_DESTINO
		,ID_TIEMPO
		,ID_MEDTRANS
	)
	INCLUDE (ID_RUTA)

	 --=========================================================================================================
	 --PASO 04.05 ASIGNA LA RUTA AL NÚMERO DE GUÍA SEGÚN ORIGEN, DESTINO, TIE. ENTREGA Y MED. TRANSPORTE
	 --========================================================================================================

	UPDATE 
		TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA 
	SET 
		ID_RUTA = ISNULL(RED.ID_RUTA,0)
	FROM 
	    TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA GUIAS
	INNER JOIN
		TMP.RED_OPERATIVA_RUTA RED
	ON
		GUIAS.ID_CIUDAD_ORIGEN = RED.ID_CIUDAD_ORIGEN
	AND
		GUIAS.ID_CIUDAD_DESTINO = RED.ID_CIUDAD_DESTINO
	AND
		GUIAS.ID_TIEMPO_ENTREGA = RED.ID_TIEMPO
	AND
		GUIAS.ID_MEDTRANS = RED.ID_MEDTRANS


	 --=========================================================================================================
	 --PASO 04.06 ASIGNA SIN RUTA LAS GUIAS QUE NO TENGAN RUTA EN RED OPERATIVA
	 --========================================================================================================


	UPDATE 
		 TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA 
	SET 
		ID_RUTA = 0
	WHERE
		ID_RUTA IS NULL


	 --=========================================================================================================
	 --PASO 04.07 ASIGNA A LA GUIA EL TIEMPO DE LA PROMESA EN HORAS SEGÚN LA RUTA DE RED OPERATIVA
	 --========================================================================================================


	UPDATE 
		TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA 
	SET 
		TIEMPO_OFERTA = RED.TIEMPO_ENTREGA_COMERCIAL_HOR
		,ID_GRUPO_RED = 
		CASE WHEN RED.ID_RUTA = 0 THEN 0  
					WHEN RED.TIEMPO_ENTREGA_COMERCIAL_HOR BETWEEN 0 AND 36 THEN 1 
					WHEN RED.TIEMPO_ENTREGA_COMERCIAL_HOR BETWEEN 37 AND 60 THEN 2
					WHEN RED.TIEMPO_ENTREGA_COMERCIAL_HOR BETWEEN 61 AND 84 THEN 3
					WHEN RED.TIEMPO_ENTREGA_COMERCIAL_HOR BETWEEN 85 AND 108 THEN 4
					ELSE 5 END 			
	    
	FROM 
		TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA GUIAS
	INNER JOIN
		DIM.RED_OPERATIVA_RUTA RED
	ON
		GUIAS.ID_RUTA = RED.ID_RUTA





	 --=========================================================================================================
	 --PASO 04.08 CALCULA SI CUMPLE O NO LA PROMESA
	 --========================================================================================================

	UPDATE
		 TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	SET
		 HORAS_ND = ISNULL(ND.ND_HORAS,0)
		,ID_ESTADO_ND = CASE WHEN ISNULL(ND.ND_HORAS,0)> 0 THEN 'SI' ELSE 'NO' END
	FROM
		TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA PR
	INNER JOIN
		SIG_COLOMBIA_DW.TMP.PROMESA_ND ND
	ON
	ND.NUMERO_GUIA = PR.NUMERO_GUIA
	

	UPDATE
	 TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	SET
	TIEMPO_PROMESA_CUMPLE_H = (CASE WHEN TIEMPO_PROMESA_H >  (CASE WHEN  ID_RUTA = 0
                          									THEN 0  
									       WHEN TIEMPO_OFERTA  <= 36
										THEN (36 + HORAS_ND)
									      WHEN TIEMPO_OFERTA > 36 AND (TIEMPO_OFERTA + HORAS_ND) <= 60
										THEN (60 + HORAS_ND)
									      WHEN TIEMPO_OFERTA > 60 AND (TIEMPO_OFERTA + HORAS_ND) <= 84
										THEN (84 + HORAS_ND)
									      WHEN TIEMPO_OFERTA  > 84 AND (TIEMPO_OFERTA + HORAS_ND) <= 108
										THEN (108 + HORAS_ND)
									ELSE TIEMPO_OFERTA + HORAS_ND END) THEN 'NO' ELSE 'SI' END)
   										WHERE ID_TIEMPO_ENTREGA NOT IN (2,3)
             													AND TIEMPO_PROMESA_CUMPLE_H IS NULL

					  


















	/*UPDATE
		 TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	SET
		TIEMPO_PROMESA_CUMPLE_H = (CASE WHEN TIEMPO_PROMESA_H >  (CASE 
													WHEN  ID_RUTA = 0
                          												THEN 0  
													WHEN TIEMPO_OFERTA <= 36
													THEN 36
													WHEN TIEMPO_OFERTA > 36 AND TIEMPO_OFERTA <= 60
													THEN 60
													WHEN TIEMPO_OFERTA > 60 AND TIEMPO_OFERTA <= 84
													THEN 84
													WHEN TIEMPO_OFERTA > 84 AND TIEMPO_OFERTA <= 108
													THEN 108
													ELSE TIEMPO_OFERTA END) THEN 'NO' ELSE 'SI' END)
   
																WHERE ID_TIEMPO_ENTREGA NOT IN (2,3)
             													AND TIEMPO_PROMESA_CUMPLE_H IS NULL */
													


 

													


	 --=========================================================================================================
	 --PASO 04.10 ELIMINA DE LOS HECHOS LOS DÍAS EXTRAIDOS
	 --========================================================================================================

	 	DELETE 
		FAC.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	WHERE
		TIME_ID IN
	(SELECT DISTINCT TIME_ID FROM TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA) 	

	 --=========================================================================================================
	 --PASO 04.11 INSERTA DE LA TEMPORAL A LOS HECHOS
	 --========================================================================================================

	 
	
  INSERT INTO FAC.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA
	(
		 TIME_ID
		,FECHA
		,DIA
		,MES
		,AÑO
		,ID_CIUDAD_ORIGEN
		,ID_CIUDAD_DESTINO
		,ID_CLIENTE
		,ID_ESTADOENVIO
		,ID_PRODUCTO
		,ID_SUBPRODUCTO
		,ID_PROD_SUBP
		,ID_TIEMPO_ENTREGA
		,NUMERO_GUIA
		,ID_RUTA
		,ID_GRUPO_RED
		,TIEMPO_PROMESA_H
		,TIEMPO_OFERTA
		,TIEMPO_PROMESA_CUMPLE_H
		,ID_GEOGRAFIA_CONCEPTO
		,HORAS_ND 
		,ID_ESTADO_ND
		,GR_ID_TIPO_COBRO
	)
	SELECT 
		 T.TIME_ID
		,T.FECHA
		,T.DIA
		,T.MES
		,T.AÑO
		,T.ID_CIUDAD_ORIGEN
		,T.ID_CIUDAD_DESTINO
		,T.ID_CLIENTE
		,T.ID_ESTADOENVIO
		,T.ID_PRODUCTO
		,T.ID_SUBPRODUCTO
                                ,CONVERT(VARCHAR(6),right('00' + convert(varchar,ID_PRODUCTO),2) + right( '0000' +  convert(varchar, ID_SUBPRODUCTO),4)) ID_PROD_SUBP
		,T.ID_TIEMPO_ENTREGA
		,T.NUMERO_GUIA
		,T.ID_RUTA
		,T.ID_GRUPO_RED
		,T.TIEMPO_PROMESA_H
		,T.TIEMPO_OFERTA
		,T.TIEMPO_PROMESA_CUMPLE_H
		,CONVERT(VARCHAR,G.ID_REGIONAL) +'-'+ CONVERT(VARCHAR,T.ID_CONCEPTO) ID_GEOGRAFIA_CONCEPTO 
                                ,T.HORAS_ND 
		,T.ID_ESTADO_ND
		,T.GR_ID_TIPO_COBRO
	FROM 
   TMP.GUIAS_ENTREG_TIEMPO_PROMESA_RED_OPERATIVA T 
 LEFT JOIN
			SIG_COLOMBIA_DW.DIM.GEOGRAFIA G
ON
	T.ID_CIUDAD_DESTINO = G.ID_CIUDAD




	*/