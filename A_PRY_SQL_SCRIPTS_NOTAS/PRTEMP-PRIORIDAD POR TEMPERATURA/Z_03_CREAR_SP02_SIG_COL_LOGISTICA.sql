USE [SIG_COL_LOGISTICA_DW]
GO

/****** Object:  StoredProcedure [FAC].[PRTEMP_Reporte_Diario_TBL02]    Script Date: 11/8/2022 8:08:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   CREATE  PROCEDURE [FAC].[PRTEMP_Reporte_Diario_TBL02]

   @CPL_VEJEZ VARCHAR(MAX) = '0',
   @NUMERO_GUIA VARCHAR(MAX) = '0',
   @REGIONAL VARCHAR(MAX) = '0'

   AS

   BEGIN

---------------------------------------------------------
------PRUEBAS
--DECLARE @CPL_VEJEZ NVARCHAR(MAX);  ----BORRAR
----SET @CPL_VEJEZ  = '1-288-9318,1-288-9364,1-288-9365,1-288-9310,1-288-9364,1-10-9362,1-10-9310,1-10-9310,1-90-9310,1-90-9310';  ----BORRAR PRUEBAS
--SET @CPL_VEJEZ  = '0'   ----BORRAR PRUEBAS

--DECLARE @NUMERO_GUIA NVARCHAR(MAX);  ----BORRAR
----SET @NUMERO_GUIA  = '2059112595,2059112596,2059112605,2059112629,2059112637,521911669';  ----BORRAR PRUEBAS
--SET @NUMERO_GUIA  = '0'   ----BORRAR PRUEBAS

--DECLARE @REGIONAL NVARCHAR(MAX);  ----BORRAR
--SET @REGIONAL  = '9,3,6,1,10,4,5,2,11,8';  ----BORRAR PRUEBAS
----SET @REGIONAL  = '0'   ----BORRAR PRUEBAS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------




--DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,'2020-01-01'))));
DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()-30))));





-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: CPL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @QUERY_WHERE_CPL_VEJEZ NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247859]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247859]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247859(CPL_VEJEZ varchar(20));

IF LEN(@CPL_VEJEZ) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247859 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@CPL_VEJEZ,',') 
ELSE	SET @QUERY_WHERE_CPL_VEJEZ =  ' ';

IF LEN(@CPL_VEJEZ) > 1  SET @QUERY_WHERE_CPL_VEJEZ = ' AND ID_BODEGA_VEJEZ IN (SELECT CPL_VEJEZ FROM #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247859) '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: NUMERO DE GUIA-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_NUMERO_GUIA NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247859]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247859]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247859(NUMERO_GUIA varchar(20));


IF LEN(@NUMERO_GUIA) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247859 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@NUMERO_GUIA,',') 
ELSE	SET @QUERY_WHERE_NUMERO_GUIA =  ' ';

IF LEN(@NUMERO_GUIA) > 1  SET @QUERY_WHERE_NUMERO_GUIA = 'AND NUMERO_GUIA IN (SELECT NUMERO_GUIA FROM #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247859) '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: REGIONAL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_REGIONAL NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_REGIONAL6247859]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_REGIONAL6247859]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_REGIONAL6247859 (REGIONAL INT);


IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0' 
		INSERT INTO #LOCAL_TABLEVARIABLE_REGIONAL6247859 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@REGIONAL,',') 
ELSE	SET @QUERY_WHERE_REGIONAL =  ' ';

IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0'   SET @QUERY_WHERE_REGIONAL = 'AND ID_REGIONAL_DESTINO IN (SELECT REGIONAL FROM #LOCAL_TABLEVARIABLE_REGIONAL6247859) '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 0 AS MAX_4_HORAS_VEJEZ
-- 0 AS MAX_8_HORAS_VEJEZ
-- 0 AS MAX_12_HORAS_VEJEZ
-- 0 AS MAX_16_HORAS_VEJEZ
-- 0 AS URGENTE

--HORAS_VEJEZ_BODEGA
--HORAS_VEJEZ_CREACION_A_HOY

------PENDIENTE POR PRUEBAS
    DECLARE @MAX_4_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
      SELECT 
            MAX_4_HORAS_VEJEZ = COUNT(NUMERO_GUIA),
            MAX_8_HORAS_VEJEZ = 0,
            MAX_12_HORAS_VEJEZ = 0,
            MAX_16_HORAS_VEJEZ = 0,
            URGENTE = 0
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>0 AND HORAS_VEJEZ_BODEGA<4 
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	


    DECLARE @MAX_8_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            MAX_4_HORAS_VEJEZ = 0,
            MAX_8_HORAS_VEJEZ = COUNT(NUMERO_GUIA),
            MAX_12_HORAS_VEJEZ = 0,
            MAX_16_HORAS_VEJEZ = 0,
            URGENTE = 0
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=4 AND HORAS_VEJEZ_BODEGA<8 
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



    DECLARE @MAX_12_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            MAX_4_HORAS_VEJEZ = 0,
            MAX_8_HORAS_VEJEZ = 0,
            MAX_12_HORAS_VEJEZ =  COUNT(NUMERO_GUIA),
            MAX_16_HORAS_VEJEZ = 0,
            URGENTE = 0
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=8 AND HORAS_VEJEZ_BODEGA<12
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


    DECLARE @MAX_16_HORAS_VEJEZ NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            MAX_4_HORAS_VEJEZ = 0,
            MAX_8_HORAS_VEJEZ = 0,
            MAX_12_HORAS_VEJEZ = 0,
            MAX_16_HORAS_VEJEZ =  COUNT(NUMERO_GUIA),
            URGENTE = 0
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=12 AND HORAS_VEJEZ_BODEGA<16
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


    DECLARE @URGENTE NVARCHAR(MAX)=
	    CONCAT('
            SELECT 
            MAX_4_HORAS_VEJEZ = 0,
            MAX_8_HORAS_VEJEZ = 0,
            MAX_12_HORAS_VEJEZ = 0,
            MAX_16_HORAS_VEJEZ = 0,
            URGENTE =  COUNT(NUMERO_GUIA)
            FROM FAC.PRTEMP_GUIAS_SERVICIO_VEJEZ (NOLOCK)
            WHERE
            HORAS_VEJEZ_BODEGA>=16
            AND CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


DECLARE @CONSOLIDADO_1 NVARCHAR(MAX) = 
					CONCAT(
					@MAX_4_HORAS_VEJEZ,' UNION ALL ',@MAX_8_HORAS_VEJEZ,' UNION ALL ',@MAX_12_HORAS_VEJEZ,' UNION ALL ',@MAX_16_HORAS_VEJEZ,' UNION ALL ',@URGENTE                           
					 ) 

DECLARE @CONSOLIDADO NVARCHAR(MAX) = 
              CONCAT('WITH CTE 
                (
						MAX_4_HORAS_VEJEZ,
						MAX_8_HORAS_VEJEZ,
						MAX_12_HORAS_VEJEZ,
						MAX_16_HORAS_VEJEZ,
						URGENTE
                )
                AS (',@CONSOLIDADO_1,')
                
				SELECT 
						SUM(MAX_4_HORAS_VEJEZ) MAX_4_HORAS_VEJEZ,
						SUM(MAX_8_HORAS_VEJEZ) MAX_8_HORAS_VEJEZ,
						SUM(MAX_12_HORAS_VEJEZ) MAX_12_HORAS_VEJEZ,
						SUM(MAX_16_HORAS_VEJEZ) MAX_16_HORAS_VEJEZ,
						SUM(URGENTE) URGENTE
                            FROM CTE')


--SELECT  @CONSOLIDADO
 EXEC SP_EXECUTESQL @CONSOLIDADO 


END

GO

