USE [SIG_COL_LOGISTICA_DW]
GO

/****** Object:  StoredProcedure [FAC].[PRTEMP_Reporte_Diario_TBL01_DETALLE_POR_INDICADOR_PARTE_01]    Script Date: 11/8/2022 7:47:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE  PROCEDURE [FAC].[PRTEMP_Reporte_Diario_TBL01_DETALLE_POR_INDICADOR_PARTE_01]

  @CPL_VEJEZ VARCHAR(MAX) = '0',
  @NUMERO_GUIA VARCHAR(MAX) = '0',
  @REGIONAL VARCHAR(MAX) = '0',
  @TIPO_REPORTE INT = 0
  AS

  BEGIN

---------------------------------------------------------
------PRUEBAS
-- DECLARE @CPL_VEJEZ NVARCHAR(MAX);  ----BORRAR
-- --SET @CPL_VEJEZ  = '1-288-9318,1-288-9364,1-288-9365,1-288-9310,1-288-9364,1-10-9362,1-10-9310,1-10-9310,1-90-9310,1-90-9310';  ----BORRAR PRUEBAS
-- SET @CPL_VEJEZ  = '0'   ----BORRAR PRUEBAS

-- DECLARE @NUMERO_GUIA NVARCHAR(MAX);  ----BORRAR
-- --SET @NUMERO_GUIA  = '2059112595,2059112596,2059112605,2059112629,2059112637,521911669';  ----BORRAR PRUEBAS
-- SET @NUMERO_GUIA  = '0'   ----BORRAR PRUEBAS

-- DECLARE @REGIONAL NVARCHAR(MAX);  ----BORRAR
-- SET @REGIONAL  = '9,3,6,1,10,4,5,2,11,8';  ----BORRAR PRUEBAS
-- --SET @REGIONAL  = '0'   ----BORRAR PRUEBAS

-- DECLARE @TIPO_REPORTE INT;
-- SET @TIPO_REPORTE = 3

-----------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

--DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,'2020-01-01'))));
DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()-30))));

---------------------------------------------------------------------------------------------------------------------------------------


--HORAS_VEJEZ_BODEGA
--HORAS_VEJEZ_CREACION_A_HOY



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: CPL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @QUERY_WHERE_CPL_VEJEZ NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216_20220610]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216_20220610]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216_20220610(CPL_VEJEZ varchar(20));

IF LEN(@CPL_VEJEZ) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216_20220610 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@CPL_VEJEZ,',') 
ELSE	SET @QUERY_WHERE_CPL_VEJEZ =  ' ';

IF LEN(@CPL_VEJEZ) > 1  SET @QUERY_WHERE_CPL_VEJEZ = ' AND ID_BODEGA_VEJEZ IN (SELECT CPL_VEJEZ FROM #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216_20220610) '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: NUMERO DE GUIA-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_NUMERO_GUIA NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216_20220610]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216_20220610]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216_20220610(NUMERO_GUIA varchar(20));


IF LEN(@NUMERO_GUIA) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216_20220610 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@NUMERO_GUIA,',') 
ELSE	SET @QUERY_WHERE_NUMERO_GUIA =  ' ';

IF LEN(@NUMERO_GUIA) > 1  SET @QUERY_WHERE_NUMERO_GUIA = 'AND NUMERO_GUIA IN (SELECT NUMERO_GUIA FROM #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216_20220610) '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: REGIONAL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_REGIONAL NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_REGIONAL2456216]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_REGIONAL2456216]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_REGIONAL2456216 (REGIONAL VARCHAR(20));


IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0' 
		INSERT INTO #LOCAL_TABLEVARIABLE_REGIONAL2456216 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@REGIONAL,',') 
ELSE	SET @QUERY_WHERE_REGIONAL =  ' ';

IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0'  
		SET @QUERY_WHERE_REGIONAL = 'AND ID_REGIONAL_DESTINO IN (SELECT REGIONAL FROM #LOCAL_TABLEVARIABLE_REGIONAL2456216) '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*************************************************************************************************************************/
/*************************************************************************************************************************/
/***************************************  INDICADORES DE COMPORTAMIENTO GUIA  ********************************************/
/*************************************************************************************************************************/
/*************************************************************************************************************************/



/************************************** 1)  @TOTAL_GUIAS_CREADAS  ***************************************************************/

------PENDIENTE POR PRUEBAS
--[ID_ESTADOENVIO] = 1 AND
    DECLARE @TOTAL_GUIAS_CREADAS NVARCHAR(MAX)=
    -- -- -- TOTAL_GUIAS_CREADAS
	    CONCAT('SELECT 
				NUMERO_GUIA
        FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO] (NOLOCK)
		WHERE 
		[ID_ESTADOENVIO] = 1 AND
		CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



/************************************** 2)  @TOTAL_GUIAS_MOVILIZADAS  ***************************************************************/
		
    DECLARE @TOTAL_GUIAS_MOVILIZADAS NVARCHAR(MAX)=
    -- -- -- TOTAL_GUIAS_CREADAS
	    CONCAT('SELECT 
				NUMERO_GUIA
				FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO] (NOLOCK)
		WHERE 
		[ID_ESTADOENVIO] IN (2) AND
		CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



/************************************** 3)  @EN_OPERATIVO_LLEGADA ***************************************************************/

    DECLARE @EN_OPERATIVO_LLEGADA NVARCHAR(MAX)=
    -- -- -- EN_OPERATIVO_LLEGADA
	    CONCAT('SELECT 
				NUMERO_GUIA
                FROM [FAC].[PRTEMP_GUIAS_OPERATIVO_LLEGADA] (NOLOCK)
            WHERE 
            [ID_ESTADOENVIO] IN (2) AND
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	

/************************************** 4) @EN_BODEGA   ***************************************************************/
		
    DECLARE @EN_BODEGA NVARCHAR(MAX)=
    -- -- -- EN_BODEGA
	    CONCAT('SELECT 
				NUMERO_GUIA
                FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_GUIAS_EN_BODEGA] (NOLOCK)
            WHERE 
            1=1 ',
           @QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


            --WHERE 
            --CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            --@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	

/************************************** 5) @EN_OPERATIVO_SALIDA   ***************************************************************/

    DECLARE @EN_OPERATIVO_SALIDA NVARCHAR(MAX)=
    -- -- -- EN_OPERATIVO_SALIDA
	    CONCAT('SELECT 
				NUMERO_GUIA
            FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_GUIAS_OPERATIVO_SALIDA] (NOLOCK)
            WHERE 
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	

/************************************** 6) @ENTREGADAS   ***************************************************************/


    DECLARE @ENTREGADAS NVARCHAR(MAX)=
    -- -- -- ENTREGADAS
	    CONCAT('SELECT 
				NUMERO_GUIA
            FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO]
            WHERE   [ID_ESTADOENVIO] IN (3) AND
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



/*************************************************************************************************************************/
/*************************************************************************************************************************/
/***********************************    INDICADORES DE VEJEZ   ***********************************************************/
/*************************************************************************************************************************/
/*************************************************************************************************************************/


-- @MAX_4_HORAS_VEJEZ
-- @MAX_8_HORAS_VEJEZ
-- @MAX_12_HORAS_VEJEZ
-- @MAX_16_HORAS_VEJEZ
-- @URGENTE



/************************************** 7) @MAX_4_HORAS_VEJEZ   ***************************************************************/

    DECLARE @MAX_4_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
      SELECT 
            NUMERO_GUIA
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>0 AND HORAS_VEJEZ_BODEGA<4 
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	


/************************************** 8) @MAX_8_HORAS_VEJEZ   ***************************************************************/
    DECLARE @MAX_8_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            NUMERO_GUIA
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=4 AND HORAS_VEJEZ_BODEGA<8 
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	


/************************************** 9) @MAX_12_HORAS_VEJEZ   ***************************************************************/
    DECLARE @MAX_12_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            NUMERO_GUIA
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=8 AND HORAS_VEJEZ_BODEGA<12
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


/************************************** 10) @MAX_16_HORAS_VEJEZ  ***************************************************************/
    DECLARE @MAX_16_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            NUMERO_GUIA
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=12 AND HORAS_VEJEZ_BODEGA<16
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


/************************************** 11) @MAX_16_HORAS_VEJEZ  ***************************************************************/
    DECLARE @URGENTE NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            NUMERO_GUIA
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=16
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)













DECLARE @QUERY_REPORTE_DRILLTROUGHT NVARCHAR(MAX);

IF @TIPO_REPORTE = 1
    SET @QUERY_REPORTE_DRILLTROUGHT = @TOTAL_GUIAS_CREADAS
ELSE IF @TIPO_REPORTE = 2
    SET @QUERY_REPORTE_DRILLTROUGHT = @TOTAL_GUIAS_MOVILIZADAS
ELSE IF @TIPO_REPORTE = 3
    SET @QUERY_REPORTE_DRILLTROUGHT = @EN_OPERATIVO_LLEGADA
ELSE IF @TIPO_REPORTE = 4
    SET @QUERY_REPORTE_DRILLTROUGHT = @EN_BODEGA
ELSE IF @TIPO_REPORTE = 5
    SET @QUERY_REPORTE_DRILLTROUGHT = @EN_OPERATIVO_SALIDA
ELSE IF @TIPO_REPORTE = 6
    SET @QUERY_REPORTE_DRILLTROUGHT = @ENTREGADAS
ELSE IF @TIPO_REPORTE = 7
    SET @QUERY_REPORTE_DRILLTROUGHT = @MAX_4_HORAS_VEJEZ
ELSE IF @TIPO_REPORTE = 8
    SET @QUERY_REPORTE_DRILLTROUGHT = @MAX_8_HORAS_VEJEZ
ELSE IF @TIPO_REPORTE = 9
    SET @QUERY_REPORTE_DRILLTROUGHT = @MAX_12_HORAS_VEJEZ
ELSE IF @TIPO_REPORTE = 10
    SET @QUERY_REPORTE_DRILLTROUGHT = @MAX_16_HORAS_VEJEZ
ELSE IF @TIPO_REPORTE = 11
    SET @QUERY_REPORTE_DRILLTROUGHT = @URGENTE
ELSE SET @QUERY_REPORTE_DRILLTROUGHT = '0'

DECLARE @QUERY_PRINCIPAL NVARCHAR(MAX)=
          CONCAT(
          'SELECT 
                 [NUMERO_GUIA]
                ,[ID_CLIENTE]
                ,[NOMBRE_CLIENTE]
                ,[FECHA_GENERACION] = CONVERT(varchar,FECHA_GENERACION,20)
                ,[FECHA_ENTREGA] = CONVERT(varchar,FECHA_ENTREGA,20)
                ,[FECHA_RECOLECCION] = CONVERT(varchar,FECHA_RECOLECCION,20)
                ,[FECHA_ULTIMO_MOVIMIENTO] = CONVERT(varchar,FECHA_ULTIMO_MOVIMIENTO,20)
                ,[Tiempo_de_Vida]
                ,[ULTIMO_PROCESO_LOGISTICO]
                ,[CIUDAD_ULTIMO_MOVIMIENTO]
                ,[USUARIO_ULTIMO_MOVIMIENTO]
                ,[NOMBRE_USUARIO_ULTIMO_MOVIMIENTO]
                ,[ULTIMO_OPERATIVO]
                ,[BODEGA]
                ,[CIUDAD_ORDIGEN]
                ,[REGIONAL_ORIGEN]
                ,[CIUDAD_DESTINO]
                ,[REGIONAL_DESTINO]
                ,[REGIONA_ID_INTERNO]
                ,[BODEGA_ID_INTERNO]
            FROM [FAC].[PRTEMP_REPORTE_CONSOLIDADO] (NOLOCK)
            WHERE [NUMERO_GUIA] IN (',@QUERY_REPORTE_DRILLTROUGHT,')',' ORDER BY [FECHA_ULTIMO_MOVIMIENTO] DESC')


			EXEC SP_EXECUTESQL  @QUERY_PRINCIPAL
			--SELECT  @QUERY_PRINCIPAL

END

GO

