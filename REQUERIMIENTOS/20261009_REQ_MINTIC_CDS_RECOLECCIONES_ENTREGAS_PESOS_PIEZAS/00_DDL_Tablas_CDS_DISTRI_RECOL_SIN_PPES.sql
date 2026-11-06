/****************************************************************************************************
 REQUERIMIENTO : MINTIC - Informe MINTIC - Análisis Comportamiento (Darwin)
 OBJETIVO      : Nueva tabla CDS_Distri_Recol_Sin_PPES (gemela de CDS_Comision_Distri_Recol)
                 con las recolecciones (RO) y distribuciones de los CDS a los que NO se les paga por PPES
                 (principalmente CDS DIRECTOS). Un CDS está en la tabla PPES o en esta, nunca en ambas.
 FECHA         : 20261009

 FLUJO PROPUESTO (paquete PS02_Informe MINTIC - Análisis Comportamiento.dtsx)
 ---------------------------------------------------------------------------------------------------
  [1_2] MEPVSVWSSDGN01\DBDG001  : 01_DG_Extraccion_CDS_Distri_Recol_Sin_PPES.sql
                                  -> [tmp_borrar_local].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI
  [DF ] Data Flow DG -> Retail  : select * FROM [tmp_borrar_local].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI
                                  -> LSTSSRET,9960 [Tmp_Borrar].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI
  [2_5] LSTSSRET,9960           : 02_Retail_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI.sql  (después de 2_4)
                                  -> [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI
  [DF ] Data Flow Retail -> SIG : SELECT * FROM [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI
                                  -> SIG_COLOMBIA_DW.[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]
  [SQL] SIG                     : DELETE/INSERT por AÑO_MES hacia
                                  SIG_LOGISTICA_DM.[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]
****************************************************************************************************/


/*==================================================================================================
 1. STAGING EN DG  (MEPVSVWSSDGN01\DBDG001)
==================================================================================================*/
USE [tmp_borrar_local]
GO

IF OBJECT_ID('[tmp_borrar_local].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI') IS NULL
CREATE TABLE [tmp_borrar_local].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI
(
	 NUMERO_GUIA				BIGINT			NOT NULL
	,ID_PAIS_CDS				INT				NOT NULL
	,ID_CIUDAD_CDS				INT				NOT NULL
	,ID_DIVISION_CDS			INT				NOT NULL
	,FECHA						DATETIME		NOT NULL
	,TIPO_COMISION				VARCHAR(20)		NOT NULL	-- DISTRIBUCION / RECOLECCION
	,DESCRIPCION_COMISION		VARCHAR(150)	NULL
	,ID_PROCESO					INT				NOT NULL
	,ID_CONCEPTO				INT				NULL
	,NUMERO_PIEZAS				INT				NOT NULL
	,PESO_FISICO				DECIMAL(10,2)	NOT NULL
	,PESO_LIQUIDADO				DECIMAL(10,2)	NOT NULL
)
GO


/*==================================================================================================
 2. STAGING EN RETAIL  (LSTSSRET,9960) - destino del Data Flow desde DG
==================================================================================================*/
USE [Tmp_Borrar]
GO

IF OBJECT_ID('[Tmp_Borrar].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI') IS NULL
CREATE TABLE [Tmp_Borrar].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI
(
	 NUMERO_GUIA				BIGINT			NOT NULL
	,ID_PAIS_CDS				INT				NOT NULL
	,ID_CIUDAD_CDS				INT				NOT NULL
	,ID_DIVISION_CDS			INT				NOT NULL
	,FECHA						DATETIME		NOT NULL
	,TIPO_COMISION				VARCHAR(20)		NOT NULL
	,DESCRIPCION_COMISION		VARCHAR(150)	NULL
	,ID_PROCESO					INT				NOT NULL
	,ID_CONCEPTO				INT				NULL
	,NUMERO_PIEZAS				INT				NOT NULL
	,PESO_FISICO				DECIMAL(10,2)	NOT NULL
	,PESO_LIQUIDADO				DECIMAL(10,2)	NOT NULL
)
GO

-- Agregar al task "TRUNCAR PPES COMISIONES  RETAIL TEMP BORRAR":
-- TRUNCATE TABLE [TMP_BORRAR].[DBO].[MECE_LOGISTICO_CDS_DISTRI_RECOL_BI]


/*==================================================================================================
 3. TABLAS EN SIG  (TMP = carga, FAC = histórico que consume el PBI)
    Las primeras 14 columnas tienen el MISMO nombre y orden que DRW_MINTIC_TMP_DW_COMISION_DISTRI_RECOL_BI
    para poder hacer UNION / relacionar en el PBI. Las 4 últimas son adicionales (pesos y trazabilidad).
==================================================================================================*/
USE [SIG_COLOMBIA_DW]
GO

IF OBJECT_ID('[SIG_COLOMBIA_DW].[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]') IS NULL
CREATE TABLE [SIG_COLOMBIA_DW].[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]
(
	 [AÑO_MES]					NVARCHAR(7)		NOT NULL	-- yyyy-MM de FECHA (no hay liquidación)
	,DEPARTAMENTO_CDS			NVARCHAR(100)	NULL
	,CODIGO_CDS					NVARCHAR(20)	NOT NULL
	,NOMBRE_CIUDAD_CDS			NVARCHAR(100)	NULL
	,CODIGO_DANE_CIUDAD_CDS		NVARCHAR(20)	NULL
	,NOMBRE_CDS					NVARCHAR(150)	NULL
	,TIPO_CANAL					NVARCHAR(50)	NULL		-- DIRECTO / INDIRECTO
	,NUMERO_GUIA				BIGINT			NOT NULL
	,NUMERO_PIEZAS				INT				NOT NULL
	,FECHA						DATETIME		NOT NULL	-- fecha del movimiento (salida a zona / entrada de zona)
	,FECHA_LIQUIDACION			DATETIME		NULL		-- = FECHA (no hay liquidación PPES)
	,VALOR_COMISION				DECIMAL(18,2)	NOT NULL	-- siempre 0: a estos CDS no se les paga RO
	,TIPO_COMISION				VARCHAR(20)		NOT NULL	-- DISTRIBUCION / RECOLECCION
	,DESCRIPCION_COMISION		VARCHAR(150)	NULL
	----------------------------- columnas adicionales -----------------------------
	,PESO_FISICO				DECIMAL(10,2)	NOT NULL
	,PESO_LIQUIDADO				DECIMAL(10,2)	NOT NULL
	,ID_PROCESO					INT				NOT NULL	-- 9 salida a zona / 6 entrada de zona
	,FUENTE						VARCHAR(30)		NOT NULL	-- 'MECE_LOGISTICO SIN PPES'
)
GO


USE [SIG_LOGISTICA_DM]
GO

IF OBJECT_ID('[SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]') IS NULL
BEGIN
	CREATE TABLE [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]
	(
		 [AÑO_MES]					NVARCHAR(7)		NOT NULL
		,DEPARTAMENTO_CDS			NVARCHAR(100)	NULL
		,CODIGO_CDS					NVARCHAR(20)	NOT NULL
		,NOMBRE_CIUDAD_CDS			NVARCHAR(100)	NULL
		,CODIGO_DANE_CIUDAD_CDS		NVARCHAR(20)	NULL
		,NOMBRE_CDS					NVARCHAR(150)	NULL
		,TIPO_CANAL					NVARCHAR(50)	NULL
		,NUMERO_GUIA				BIGINT			NOT NULL
		,NUMERO_PIEZAS				INT				NOT NULL
		,FECHA						DATETIME		NOT NULL
		,FECHA_LIQUIDACION			DATETIME		NULL
		,VALOR_COMISION				DECIMAL(18,2)	NOT NULL
		,TIPO_COMISION				VARCHAR(20)		NOT NULL
		,DESCRIPCION_COMISION		VARCHAR(150)	NULL
		,PESO_FISICO				DECIMAL(10,2)	NOT NULL
		,PESO_LIQUIDADO				DECIMAL(10,2)	NOT NULL
		,ID_PROCESO					INT				NOT NULL
		,FUENTE						VARCHAR(30)		NOT NULL
	)

	CREATE NONCLUSTERED INDEX IX_ANIO_MES_CODIGO_CDS
	ON [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI] ([AÑO_MES],[CODIGO_CDS])
END
GO


/*==================================================================================================
 4. TASKS SIG PARA EL PAQUETE (agregar a los existentes)
==================================================================================================*/

-- 4.1 Agregar al task "truncado Tablas" (SIG_COLOMBIA_DW):
-- TRUNCATE TABLE SIG_COLOMBIA_DW.[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]

-- 4.2 Nuevo Execute SQL Task "CDS_DISTRI_RECOL_SIN_PPES_BI" (igual a COMISION_DISTRI_RECOL_BI):
DELETE [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI] WHERE [AÑO_MES] IN
(SELECT DISTINCT [AÑO_MES] FROM [SIG_COLOMBIA_DW].[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI] WITH(NOLOCK))

INSERT INTO [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI]
SELECT * FROM [SIG_COLOMBIA_DW].[TMP].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI] WITH(NOLOCK)

-- 4.3 Validación de exclusividad (debe devolver 0 filas): ningún CDS en ambas tablas
SELECT N.CODIGO_CDS
FROM [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI] N WITH(NOLOCK)
INNER JOIN [SIG_LOGISTICA_DM].[FAC].[DRW_MINTIC_TMP_DW_COMISION_DISTRI_RECOL_BI] P WITH(NOLOCK) ON P.CODIGO_CDS = N.CODIGO_CDS
GROUP BY N.CODIGO_CDS
