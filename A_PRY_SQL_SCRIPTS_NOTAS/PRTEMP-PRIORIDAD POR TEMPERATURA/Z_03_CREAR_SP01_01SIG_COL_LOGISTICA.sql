USE [SIG_COL_LOGISTICA_DW]
GO

/****** Object:  StoredProcedure [FAC].[PRTEMP_Reporte_Diario_TBL01]    Script Date: 11/8/2022 7:47:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE  PROCEDURE [FAC].[PRTEMP_Reporte_Diario_TBL01]

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
DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()-40))));





-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: CPL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @QUERY_WHERE_CPL_VEJEZ NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216(CPL_VEJEZ varchar(20));

IF LEN(@CPL_VEJEZ) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@CPL_VEJEZ,',') 
ELSE	SET @QUERY_WHERE_CPL_VEJEZ =  ' ';

IF LEN(@CPL_VEJEZ) > 1  SET @QUERY_WHERE_CPL_VEJEZ = ' AND ID_BODEGA_VEJEZ IN (SELECT CPL_VEJEZ FROM #LOCAL_TABLEVARIABLE_CPL_VEJEZ52456216) '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: NUMERO DE GUIA-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_NUMERO_GUIA NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216(NUMERO_GUIA varchar(20));


IF LEN(@NUMERO_GUIA) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@NUMERO_GUIA,',') 
ELSE	SET @QUERY_WHERE_NUMERO_GUIA =  ' ';

IF LEN(@NUMERO_GUIA) > 1  SET @QUERY_WHERE_NUMERO_GUIA = 'AND NUMERO_GUIA IN (SELECT NUMERO_GUIA FROM #LOCAL_TABLEVARIABLE_NUMERO_GUIA52456216) '

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


------PENDIENTE POR PRUEBAS
--[ID_ESTADOENVIO] = 1 AND
    DECLARE @TOTAL_GUIAS_CREADAS NVARCHAR(MAX)=
    -- -- -- TOTAL_GUIAS_CREADAS
	    CONCAT('SELECT 
		COUNT(NUMERO_GUIA) CT_TOTAL_GUIAS_CREADAS,
		0 AS CT_TOTAL_GUIAS_MOVILIZADAS,
		0 AS CT_EN_OPERATIVO_LLEGADA,
		0 AS CT_EN_BODEGA,
		0 AS CT_EN_OPERATIVO_SALIDA,
		0 AS CT_ENTREGADAS
        FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO] (NOLOCK)
		WHERE 
		[ID_ESTADOENVIO] = 1 AND [ID_PROCESO] IN (7,12,46) AND
		CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	
		
    DECLARE @TOTAL_GUIAS_MOVILIZADAS NVARCHAR(MAX)=
    -- -- -- TOTAL_GUIAS_CREADAS
	    CONCAT('SELECT 
		0 CT_TOTAL_GUIAS_CREADAS,
		COUNT(NUMERO_GUIA) AS CT_TOTAL_GUIAS_MOVILIZADAS,
		0 AS CT_EN_OPERATIVO_LLEGADA,
		0 AS CT_EN_BODEGA,
		0 AS CT_EN_OPERATIVO_SALIDA,
		0 AS CT_ENTREGADAS
        FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO] (NOLOCK)
		WHERE 
		[ID_ESTADOENVIO] IN (2) AND
		CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
		@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	

    DECLARE @EN_OPERATIVO_LLEGADA NVARCHAR(MAX)=
    -- -- -- EN_OPERATIVO_LLEGADA
	    CONCAT('SELECT 
            0 CT_TOTAL_GUIAS_CREADAS,
            0 CT_TOTAL_GUIAS_MOVILIZADAS,
            COUNT(NUMERO_GUIA) AS CT_EN_OPERATIVO_LLEGADA,
            0 AS CT_EN_BODEGA,
            0 AS CT_EN_OPERATIVO_SALIDA,
            0 AS CT_ENTREGADAS
                FROM [FAC].[PRTEMP_GUIAS_OPERATIVO_LLEGADA] (NOLOCK)
            WHERE 
            [ID_ESTADOENVIO] IN (2) AND
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	
		
    DECLARE @EN_BODEGA NVARCHAR(MAX)=
    -- -- -- EN_BODEGA
	    CONCAT('SELECT 
            0 CT_TOTAL_GUIAS_CREADAS,
            0 CT_TOTAL_GUIAS_MOVILIZADAS,
            0 AS CT_EN_OPERATIVO_LLEGADA,
            COUNT(NUMERO_GUIA)  AS CT_EN_BODEGA,
            0 AS CT_EN_OPERATIVO_SALIDA,
            0 AS CT_ENTREGADAS
                FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_GUIAS_EN_BODEGA] (NOLOCK)
            WHERE 
            1=1 ',
           @QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)


            --WHERE 
            --CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            --@FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



    DECLARE @EN_OPERATIVO_SALIDA NVARCHAR(MAX)=
    -- -- -- EN_OPERATIVO_SALIDA
	    CONCAT('SELECT 
            0 CT_TOTAL_GUIAS_CREADAS,
            0 CT_TOTAL_GUIAS_MOVILIZADAS,
            0 AS CT_EN_OPERATIVO_LLEGADA,
            0 AS CT_EN_BODEGA,
            COUNT(NUMERO_GUIA)  AS CT_EN_OPERATIVO_SALIDA,
            0 AS CT_ENTREGADAS
            FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_GUIAS_OPERATIVO_SALIDA] (NOLOCK)
            WHERE 
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	



    DECLARE @ENTREGADAS NVARCHAR(MAX)=
    -- -- -- ENTREGADAS
	    CONCAT('SELECT 
            0 CT_TOTAL_GUIAS_CREADAS,
            0 CT_TOTAL_GUIAS_MOVILIZADAS,
            0 AS CT_EN_OPERATIVO_LLEGADA,
            0 AS CT_EN_BODEGA,
            0 AS CT_EN_OPERATIVO_SALIDA,
            COUNT(NUMERO_GUIA)  AS CT_ENTREGADAS
            FROM [SIG_COL_LOGISTICA_DW].[FAC].[PRTEMP_HISTORICO]
            WHERE   ([ID_ESTADOENVIO] IN (3) OR ID_PROCESO IN(11,24)) AND
            CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_HORA_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)	





DECLARE @CONSOLIDADO_1 NVARCHAR(MAX) = 
					CONCAT(@TOTAL_GUIAS_CREADAS,
							' UNION ALL ',
							@TOTAL_GUIAS_MOVILIZADAS,
              ' UNION ALL ',
              @EN_OPERATIVO_LLEGADA,
              ' UNION ALL ',
              @EN_BODEGA,
              ' UNION ALL ',
              @EN_OPERATIVO_SALIDA,
              ' UNION ALL ',
              @ENTREGADAS                             
              ) 

DECLARE @CONSOLIDADO NVARCHAR(MAX) = 
              CONCAT('WITH CTE 
                (
                            CT_TOTAL_GUIAS_CREADAS,
                            CT_TOTAL_GUIAS_MOVILIZADAS,
                            CT_EN_OPERATIVO_LLEGADA,
                            CT_EN_BODEGA,
                            CT_EN_OPERATIVO_SALIDA,
                            CT_ENTREGADAS
                )
                AS (',@CONSOLIDADO_1,')
                SELECT 
                            SUM(CT_TOTAL_GUIAS_CREADAS) CT_TOTAL_GUIAS_CREADAS,
                            SUM(CT_TOTAL_GUIAS_MOVILIZADAS) CT_TOTAL_GUIAS_MOVILIZADAS,
                            SUM(CT_EN_OPERATIVO_LLEGADA) CT_EN_OPERATIVO_LLEGADA,
                            SUM(CT_EN_BODEGA) CT_EN_BODEGA,
                            SUM(CT_EN_OPERATIVO_SALIDA) CT_EN_OPERATIVO_SALIDA,
                            SUM(CT_ENTREGADAS) CT_ENTREGADAS
                            FROM CTE')

--SELECT @TOTAL_GUIAS_MOVILIZADAS
 EXEC SP_EXECUTESQL @CONSOLIDADO 


  END




GO

