USE [SIG_COL_LOGISTICA_DW]
GO

/****** Object:  StoredProcedure [FAC].[PRTEMP_Reporte_Diario_TBL04]    Script Date: 11/8/2022 8:10:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     CREATE  PROCEDURE [FAC].[PRTEMP_Reporte_Diario_TBL04]

     @CPL_VEJEZ VARCHAR(MAX) = '0',
     @NUMERO_GUIA VARCHAR(MAX) = '0',
     @REGIONAL VARCHAR(MAX) = '0',
     @FECHA_INI VARCHAR(MAX) = NULL,
     @FECHA_FIN VARCHAR(MAX) = NULL

     AS

     BEGIN

-----------------------------------------------------
------PRUEBAS
--DECLARE @CPL_VEJEZ NVARCHAR(MAX);  ----BORRAR
----SET @CPL_VEJEZ  = '1-288-9318,1-288-9364,1-288-9365,1-288-9310,1-288-9364,1-10-9362,1-10-9310,1-10-9310,1-90-9310,1-90-9310';  ----BORRAR PRUEBAS
--SET @CPL_VEJEZ  = '0'   ----BORRAR PRUEBAS

--DECLARE @NUMERO_GUIA NVARCHAR(MAX);  ----BORRAR
--SET @NUMERO_GUIA  = '2059112595,2059112596,2059112605,2059112629,2059112637,521911669';  ----BORRAR PRUEBAS
----SET @NUMERO_GUIA  = '0'   ----BORRAR PRUEBAS

--DECLARE @REGIONAL NVARCHAR(MAX);  ----BORRAR
--SET @REGIONAL  = '9,3,6,1,10,4,5,2,11,8';  ----BORRAR PRUEBAS
----SET @REGIONAL  = '0'   ----BORRAR PRUEBAS

--DECLARE @FECHA_INI VARCHAR(12), @FECHA_FIN VARCHAR(12);
--SET  @FECHA_INI = NULL;
--SET  @FECHA_FIN = NULL;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------




-- DECLARE @FECHA_VARIABLE INT = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,'2020-01-01'))));
--SET @FECHA_VARIABLE = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()))));





-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: CPL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @QUERY_WHERE_CPL_VEJEZ NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247880]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247880]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247880(CPL_VEJEZ varchar(20));

IF LEN(@CPL_VEJEZ) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247880 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@CPL_VEJEZ,',') 
ELSE	SET @QUERY_WHERE_CPL_VEJEZ =  ' 1=1  AND ';

IF LEN(@CPL_VEJEZ) > 1  SET @QUERY_WHERE_CPL_VEJEZ = ' [BODEGA_ID_INTERNO] IN (SELECT CPL_VEJEZ FROM #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247880) AND '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: NUMERO DE GUIA-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_NUMERO_GUIA NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247880]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247880]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247880(NUMERO_GUIA varchar(20));


IF LEN(@NUMERO_GUIA) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247880 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@NUMERO_GUIA,',') 
ELSE	SET @QUERY_WHERE_NUMERO_GUIA =  ' 1=1 AND ';

IF LEN(@NUMERO_GUIA) > 1  SET @QUERY_WHERE_NUMERO_GUIA = 'NUMERO_GUIA IN (SELECT NUMERO_GUIA FROM #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247880) AND '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: REGIONAL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_REGIONAL NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_REGIONAL6247880]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_REGIONAL6247880]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_REGIONAL6247880 (REGIONAL INT);


IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0' 
		INSERT INTO #LOCAL_TABLEVARIABLE_REGIONAL6247880 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@REGIONAL,',') 
ELSE	SET @QUERY_WHERE_REGIONAL =  ' 1=1 ';

IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0'   SET @QUERY_WHERE_REGIONAL = ' [REGIONA_ID_INTERNO] IN (SELECT REGIONAL FROM #LOCAL_TABLEVARIABLE_REGIONAL6247880) '




-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: FECHA FINAL FECHA INICIAL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_RANGO_FECHAS NVARCHAR(MAX);
DECLARE @FECHA_INI_N INT; 
DECLARE @FECHA_FIN_N INT; 

IF LEN(@FECHA_INI)>=4 SET @FECHA_INI_N = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,@FECHA_INI))));
IF LEN(@FECHA_FIN)>=4 SET @FECHA_FIN_N = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,@FECHA_FIN))));


IF CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@FECHA_INI)))>CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@FECHA_FIN)))
SET @QUERY_WHERE_RANGO_FECHAS = ' CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,  DATEADD(yy,-1,DATEADD(yy,DATEDIFF(yy,0,GETDATE()),0))   >=  CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO])))    AND '

ELSE IF (@FECHA_INI IS NOT NULL OR @FECHA_INI <>') AND (@FECHA_FIN IS NOT NULL OR @FECHA_FIN <>') 
    SET @QUERY_WHERE_RANGO_FECHAS = CONCAT(' CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO]))) >= ',@FECHA_INI_N,'  AND    CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO]))) <=   ',@FECHA_FIN_N,'AND ')

ELSE IF (@FECHA_INI IS NULL OR @FECHA_INI =' OR @FECHA_INI=NULL) AND (@FECHA_FIN IS NULL OR @FECHA_FIN ='  OR @FECHA_FIN=NULL) 
    SET @QUERY_WHERE_RANGO_FECHAS = ' CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO])))    >=  CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,  DATEADD(yy,0,DATEADD(yy,DATEDIFF(yy,0,GETDATE()),0)))))   AND '

ELSE IF  (@FECHA_INI IS NOT NULL OR @FECHA_INI <>' OR @FECHA_INI <> NULL)   
    SET @QUERY_WHERE_RANGO_FECHAS = CONCAT(' CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO])))  >=  ',@FECHA_INI_N,' AND ')

ELSE IF  (@FECHA_FIN IS NOT NULL OR @FECHA_FIN <>' OR @FECHA_FIN<>NULL ) 
    SET @QUERY_WHERE_RANGO_FECHAS = CONCAT(' CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO]))) <=',@FECHA_FIN_N,' AND ')

ELSE SET @QUERY_WHERE_RANGO_FECHAS = ' 1=1 AND '


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------




  DECLARE @QUERY_PRINCIPAL NVARCHAR(MAX)=
          CONCAT(
          'SELECT 
                 [NUMERO_GUIA]
                ,[ID_CLIENTE]
                ,[NOMBRE_CLIENTE]
                ,[FECHA_GENERACION] = CONVERT(varchar, ([FECHA_GENERACION]),20)
                ,[FECHA_ENTREGA] = CONVERT(varchar, ([FECHA_GENERACION]),20)
                ,[FECHA_RECOLECCION] = CONVERT(varchar, ([FECHA_GENERACION]),20)
                ,[FECHA_ULTIMO_MOVIMIENTO] = CONVERT(varchar, ([FECHA_GENERACION]),20)
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
            WHERE ',
            @QUERY_WHERE_RANGO_FECHAS,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL)

-- SELECT  @QUERY_PRINCIPAL
 EXEC SP_EXECUTESQL @QUERY_PRINCIPAL


  END 









--------
GO

