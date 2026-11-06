USE [SIG_COL_LOGISTICA_DW]
GO

/****** Object:  StoredProcedure [FAC].[PRTEMP_Reporte_Diario_TBL03]    Script Date: 11/8/2022 8:09:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   CREATE  PROCEDURE [FAC].[PRTEMP_Reporte_Diario_TBL03]

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

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247860]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CPL_VEJEZ6247860]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247860(CPL_VEJEZ varchar(20));

IF LEN(@CPL_VEJEZ) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247860 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@CPL_VEJEZ,',') 
ELSE	SET @QUERY_WHERE_CPL_VEJEZ =  ' ';

IF LEN(@CPL_VEJEZ) > 1  SET @QUERY_WHERE_CPL_VEJEZ = ' AND [BODEGA_ID_INTERNO] IN (SELECT CPL_VEJEZ FROM #LOCAL_TABLEVARIABLE_CPL_VEJEZ6247860) '



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: NUMERO DE GUIA-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_NUMERO_GUIA NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247860]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_NUMERO_GUIA6247860]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247860(NUMERO_GUIA varchar(20));


IF LEN(@NUMERO_GUIA) > 1  
		INSERT INTO #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247860 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@NUMERO_GUIA,',') 
ELSE	SET @QUERY_WHERE_NUMERO_GUIA =  ' ';

IF LEN(@NUMERO_GUIA) > 1  SET @QUERY_WHERE_NUMERO_GUIA = 'AND NUMERO_GUIA IN (SELECT NUMERO_GUIA FROM #LOCAL_TABLEVARIABLE_NUMERO_GUIA6247860) '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------PARAMETRO: REGIONAL-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @QUERY_WHERE_REGIONAL NVARCHAR(MAX);

IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_REGIONAL6247860]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_REGIONAL6247860]
  END

CREATE TABLE #LOCAL_TABLEVARIABLE_REGIONAL6247860 (REGIONAL INT);


IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0' 
		INSERT INTO #LOCAL_TABLEVARIABLE_REGIONAL6247860 
		SELECT DISTINCT value AS VALOR FROM STRING_SPLIT(@REGIONAL,',') 
ELSE	SET @QUERY_WHERE_REGIONAL =  ' ';

IF LEN(@REGIONAL) >= 1 AND @REGIONAL <> '0'   SET @QUERY_WHERE_REGIONAL = 'AND [REGIONA_ID_INTERNO] IN (SELECT REGIONAL FROM #LOCAL_TABLEVARIABLE_REGIONAL6247860) '

-------------------------------------------------------------------------------------------------------------------------------------------------------------------



  DECLARE @QUERY_PRINCIPAL NVARCHAR(MAX)=
          CONCAT(
          'SELECT 
                 [NUMERO_GUIA]
                ,[ID_CLIENTE]
                ,[NOMBRE_CLIENTE]
                ,[FECHA_GENERACION] = CONVERT(varchar, [FECHA_GENERACION],20)
                ,[FECHA_ENTREGA] = CONVERT(varchar, [FECHA_ENTREGA],20)
                ,[FECHA_RECOLECCION] = CONVERT(varchar, [FECHA_RECOLECCION],20)
                ,[FECHA_ULTIMO_MOVIMIENTO] = CONVERT(varchar, [FECHA_ULTIMO_MOVIMIENTO],20)
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
            WHERE CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,[FECHA_ULTIMO_MOVIMIENTO])))>= ',
            @FECHA_VARIABLE,@QUERY_WHERE_CPL_VEJEZ,@QUERY_WHERE_NUMERO_GUIA,@QUERY_WHERE_REGIONAL,' ORDER BY [FECHA_ULTIMO_MOVIMIENTO] DESC')

--SELECT  @QUERY_PRINCIPAL
 EXEC SP_EXECUTESQL @QUERY_PRINCIPAL


 END 









GO

