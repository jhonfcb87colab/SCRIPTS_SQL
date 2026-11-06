
USE [tmp_borrar]
GO
/****************************************************************************************************
 PASO 2_5 - SERVIDOR LSTSSRET,9960  (ejecutar DESPUÉS de "2_4 COMISION_CDS_DISTR_RECOL")
 Genera [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI con la misma estructura de
 TMP_DW_COMISION_DISTRI_RECOL_BI, sólo para CDS a los que NO se les paga RO por PPES.

 Regla de exclusividad (REQUERIMIENTO.md): un CDS está en la tabla PPES o en esta, nunca en ambas.
   1. Se excluye todo CODIGO_CDS que aparezca en PPES_COMISION_DISTRIBUCION o PPES_COMISION_RECOLECCION.
   2. Se excluye toda guía/tipo ya liquidada en PPES (evita contar dos veces la misma operación).

 Insumos:
   [tmp_borrar].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI  (Data Flow desde DG, paso 1_2)
   [tmp_borrar].dbo.PPES_COMISION_DISTRIBUCION / PPES_COMISION_RECOLECCION (task CARGAR PPES)
****************************************************************************************************/

--alter PROCEDURE [dbo].[RTW_CDS_DISTRIBUCION_RECOLECCION_SIN_PPES_BI]
--AS
--BEGIN

	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TMP_CDS_PPES') IS NOT NULL
		DROP TABLE #TMP_CDS_PPES

	IF OBJECT_ID('tempdb..#TMP_GUIAS_PPES') IS NOT NULL
		DROP TABLE #TMP_GUIAS_PPES

	IF OBJECT_ID('[Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI') IS NOT NULL
		DROP TABLE [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI

	/*------------------------------------------------------------------------------------------
	  CDS que ya liquidan en PPES (universo de la tabla actual CDS_Comision_Distri_Recol)
	------------------------------------------------------------------------------------------*/
	SELECT CODIGO_CDS
	INTO #TMP_CDS_PPES
	FROM
	(
		SELECT CODIGO_CDS_PPES_DISTRIBUCION AS CODIGO_CDS FROM [tmp_borrar].[dbo].PPES_COMISION_DISTRIBUCION (NOLOCK)
		UNION
		SELECT CODIGO_CDS_PPES_RECOLECCION  AS CODIGO_CDS FROM [tmp_borrar].[dbo].PPES_COMISION_RECOLECCION (NOLOCK)
	) AS T
	WHERE ISNULL(CODIGO_CDS,'') <> ''

	CREATE CLUSTERED INDEX IX_CODIGO_CDS ON #TMP_CDS_PPES (CODIGO_CDS)

	/*------------------------------------------------------------------------------------------
	  Guías ya liquidadas en PPES por tipo de operación
	------------------------------------------------------------------------------------------*/
	SELECT NUMERO_GUIA, TIPO_COMISION
	INTO #TMP_GUIAS_PPES
	FROM
	(
		SELECT TRY_CAST(NUMERO_GUIA AS BIGINT) AS NUMERO_GUIA, 'DISTRIBUCION' AS TIPO_COMISION FROM [tmp_borrar].[dbo].PPES_COMISION_DISTRIBUCION (NOLOCK)
		UNION
		SELECT TRY_CAST(NUMERO_GUIA AS BIGINT) AS NUMERO_GUIA, 'RECOLECCION'  AS TIPO_COMISION FROM [tmp_borrar].[dbo].PPES_COMISION_RECOLECCION (NOLOCK)
	) AS T
	WHERE NUMERO_GUIA IS NOT NULL

	CREATE CLUSTERED INDEX IX_NUMERO_GUIA ON #TMP_GUIAS_PPES (NUMERO_GUIA, TIPO_COMISION)

	/*------------------------------------------------------------------------------------------
	  Tabla final - mismas 14 columnas y orden que TMP_DW_COMISION_DISTRI_RECOL_BI + adicionales
	------------------------------------------------------------------------------------------*/
	SELECT
	 CONVERT(NVARCHAR(7), OP.FECHA, 120) AS AÑO_MES
	,DC.NOMBRE_DEPARTAMENTO AS DEPARTAMENTO_CDS
	,DIV.CODIGO_ACTUAL AS CODIGO_CDS
	,CC.NOMBRE_CIUDAD as NOMBRE_CIUDAD_CDS
	,CC.CODIGO_DANE AS CODIGO_DANE_CIUDAD_CDS
	,DIV.NOMBRE_DIVISION AS NOMBRE_CDS
	,CTCAN.[NOMBRE_CLASE_TIPO_CANAL] as TIPO_CANAL
	,OP.NUMERO_GUIA
	,OP.NUMERO_PIEZAS
	,OP.FECHA
	,OP.FECHA AS FECHA_LIQUIDACION								-- no hay liquidación: se usa la fecha de la operación
	,CAST(0 AS DECIMAL(18,2)) AS VALOR_COMISION					-- no se paga RO a estos CDS
	,OP.TIPO_COMISION
	,OP.DESCRIPCION_COMISION
	------------------------------ adicionales ------------------------------
	,OP.PESO_FISICO
	,OP.PESO_LIQUIDADO
	,OP.ID_PROCESO
	,CAST('MECE_LOGISTICO SIN PPES' AS VARCHAR(30)) AS FUENTE
	INTO [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI
	FROM [tmp_borrar].dbo.MECE_LOGISTICO_CDS_DISTRI_RECOL_BI OP (NOLOCK)
	INNER JOIN PARAMETROS.DBO.DIVISIONES DIV (NOLOCK) ON DIV.ID_PAIS=OP.ID_PAIS_CDS AND DIV.ID_CIUDAD=OP.ID_CIUDAD_CDS AND DIV.ID_DIVISION=OP.ID_DIVISION_CDS
	INNER JOIN [Mece_Logistico].[dbo].[CANALES_CO] CAN (NOLOCK) ON CAN.ID_PAIS=DIV.ID_PAIS AND CAN.ID_CIUDAD=DIV.ID_CIUDAD AND CAN.ID_DIVISION=DIV.ID_DIVISION
	INNER JOIN PARAMETROS.DBO.CIUDADES CC WITH (NOLOCK) ON CC.ID_PAIS=DIV.ID_PAIS and CC.ID_CIUDAD=CAN.ID_CIUDAD
	INNER JOIN [PARAMETROS_MDM].[dbo].DEPARTAMENTOS DC (NOLOCK) ON DC.ID_PAIS=CC.ID_PAIS AND DC.ID_DEPARTAMENTO=CC.ID_DEPARTAMENTO
	INNER JOIN [Mece_Logistico].[dbo].[TIPOS_CANAL] TCAN (NOLOCK) ON TCAN.ID_TIPO_CANAL=CAN.ID_TIPO_CANAL AND TCAN.ID_EST_TIPO_CANAL=1
	INNER JOIN PARAMETROS.[dbo].[CLASE_TIPO_CANAL] CTCAN (NOLOCK) ON CTCAN.ID_CLASE_TIPO_CANAL=TCAN.CLASE_TIPO_CANAL
	LEFT JOIN #TMP_CDS_PPES PPES ON PPES.CODIGO_CDS = DIV.CODIGO_ACTUAL
	LEFT JOIN #TMP_GUIAS_PPES GPP ON GPP.NUMERO_GUIA = OP.NUMERO_GUIA AND GPP.TIPO_COMISION = OP.TIPO_COMISION
	WHERE ISNULL(DIV.CODIGO_ACTUAL,'') <> ''
	AND PPES.CODIGO_CDS IS NULL									-- CDS no PPES
	AND GPP.NUMERO_GUIA IS NULL									-- operación no liquidada en PPES

	CREATE NONCLUSTERED INDEX [IX_NUMERO_GUIA] ON [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI ([NUMERO_GUIA] ASC)

--END


/*==================================================================================================
 VALIDACIONES
==================================================================================================*/

---- Resumen por tipo de canal / operación
--SELECT AÑO_MES, TIPO_CANAL, TIPO_COMISION, COUNT(DISTINCT CODIGO_CDS) AS CDS, COUNT(1) AS GUIAS
--,SUM(NUMERO_PIEZAS) AS PIEZAS, SUM(PESO_FISICO) AS PESO_FISICO
--FROM [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI (NOLOCK)
--GROUP BY AÑO_MES, TIPO_CANAL, TIPO_COMISION
--ORDER BY AÑO_MES, TIPO_CANAL, TIPO_COMISION

---- Exclusividad contra la tabla PPES (debe devolver 0 filas)
--SELECT DISTINCT N.CODIGO_CDS
--FROM [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI N (NOLOCK)
--INNER JOIN [Tmp_Borrar].dbo.TMP_DW_COMISION_DISTRI_RECOL_BI P (NOLOCK) ON P.CODIGO_CDS = N.CODIGO_CDS

---- CDS Avenida Sexta (caso pedido por Darwin)
--SELECT AÑO_MES, CODIGO_CDS, NOMBRE_CDS, TIPO_CANAL, TIPO_COMISION, COUNT(1) AS GUIAS, SUM(NUMERO_PIEZAS) AS PIEZAS
--FROM [Tmp_Borrar].dbo.TMP_DW_CDS_DISTRI_RECOL_SIN_PPES_BI (NOLOCK)
--WHERE NOMBRE_CDS LIKE '%SEXTA%'
--GROUP BY AÑO_MES, CODIGO_CDS, NOMBRE_CDS, TIPO_CANAL, TIPO_COMISION
