
"
USE [tmp_borrar]
	SET NOCOUNT ON;
	DECLARE @FECHA_INICIAL DATETIME
	DECLARE @FECHA_FINAL DATETIME
	----SET @FECHA_INICIAL=	CONVERT(DATETIME,'20261008')					
	----SET @FECHA_FINAL  =	CONVERT(DATETIME,'20261010')					
	SET @FECHA_INICIAL=	CONVERT(DATETIME,'"+@[User::STR_01_FECHA_INICIAL]+"')	------------			'20250101 00:00:00'
	SET @FECHA_FINAL=	CONVERT(DATETIME,'"+@[User::STR_02_FECHA_FINAL]+"')		------------		GETDATE()
	IF OBJECT_ID(N'dbo.TMP_DW_CDS_SIN_PPES_BI', N'U') IS NULL
	BEGIN
	CREATE TABLE [dbo].[TMP_DW_CDS_SIN_PPES_BI] (
	[AÑO_MES] NVARCHAR(62) NULL,
	[FECHA] VARCHAR(19) NULL,
	[NUMERO_GUIA] BIGINT NOT NULL,
	[DEPARTAMENTO_CDS] VARCHAR(40) NULL,
	[NOMBRE_CIUDAD_CDS] VARCHAR(40) NULL,
	[CODIGO_CDS] CHAR(10) NULL,
	[NOMBRE_CDS] VARCHAR(40) NULL,
	[CODIGO_DANE_CIUDAD_CDS] CHAR(11) NULL,
	[TIPO_CANAL_recoleccion] VARCHAR(40) NULL,
	[KeyComisiones_Tabla] VARCHAR(36) NOT NULL,
	[TIPO_COMISION] VARCHAR(12) NOT NULL,
	[NUMERO_PIEZAS] INT NOT NULL
	);
	END;

	DROP TABLE IF EXISTS  #PIEZAS_GUIAS;


	SELECT 
	PIE.ShippingId,
	COUNT(PIE.ShippingId) AS Pieces
	,CAST(AVG(PIE.[Length])AS DECIMAL(8,2)) AS [Length]
	,CAST(AVG(PIE.[Width]) AS DECIMAL(8,2)) AS [Width]
	,CAST(AVG(PIE.Height) AS DECIMAL(8,2)) AS [Height]
	,CAST(AVG(PIE.PhysicalWeight) AS DECIMAL(8,2)) AS PhysicalWeight
	,AVG(PIE.[DeclaredValue]) AS [DeclaredValue_piece]
	,COUNT(PIE.ShippingId)*(SUM(PIE.[DeclaredValue])/COUNT(PIE.ShippingId)) AS [Full_DeclaredValue_piece]
	,CAST(COUNT(PIE.ShippingId)*(SUM(PIE.PhysicalWeight)/COUNT(PIE.ShippingId))AS DECIMAL(10,2)) AS [Full_PhysicalWeight]
	,CASE WHEN MAX(ID.ProductId)=6 THEN
		CAST(((AVG(PIE.[Length]) * AVG(PIE.[Width]) * AVG(PIE.Height) * 400)/1000000) AS DECIMAL(10,2)) 
		ELSE CAST(((AVG(PIE.[Length]) * AVG(PIE.[Width]) * AVG(PIE.Height) * 222)/1000000) AS DECIMAL(10,2)) END as [VolumWeight]
	,CASE WHEN MAX(ID.ProductId)=6 THEN
		CAST(((AVG(PIE.[Length]) * AVG(PIE.[Width]) * AVG(PIE.Height) * 222)/1000000)*COUNT(PIE.ShippingId)AS DECIMAL(10,2)) 
		ELSE CAST(((AVG(PIE.[Length]) * AVG(PIE.[Width]) * AVG(PIE.Height) * 222)/1000000)*COUNT(PIE.ShippingId)AS DECIMAL(10,2)) END as [Full_VolumWeight]
	INTO #PIEZAS_GUIAS
	FROM [RetailWebR4].[dbo].INVOICE AS I WITH(NOLOCK)
	INNER JOIN [RetailWebR4].[dbo].InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
	INNER JOIN [RetailWebR4].[dbo].Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
	INNER JOIN [RetailWebR4].[dbo].Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
	inner join [RetailWebR4].[dbo].[Piece] AS PIE WITH(NOLOCK) ON PIE.[ShippingId]=S.Id
	WHERE I.INVOICEDATE>=@FECHA_INICIAL AND I.INVOICEDATE<=@FECHA_FINAL
	and ID.PaymentFormId!=2 and I.[state]=1 AND S.[ReceiverCountryId] = 1
	GROUP BY PIE.ShippingId 
	ORDER BY PIE.ShippingId ASC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #DATOS_MINTIC_PASO01_RECOLECCIONES; 
DROP TABLE IF EXISTS #DATOS_MINTIC_PASO01_DISTRIBUCIONES; 


SET LANGUAGE spanish
	SELECT TOP 2000
	'RETAIL' AS CANAL
	,CAST(year(i.invoicedate) AS nvarchar) +'-'+ CASE WHEN LEN(MONTH(i.invoicedate)) = 1 THEN '0'+ CAST(MONTH(i.invoicedate) AS nvarchar) ELSE CAST(MONTH(i.invoicedate) AS nvarchar) END as AÑO_MES_ENVIO
	,CONVERT(VARCHAR(19), i.invoicedate, 120) AS FECHA_ENVIO
	,DATENAME(MONTH,i.invoicedate) MES
	,g.number as NUMERO_GUIA
	,CC.ID_PAIS AS ID_PAIS_CDS
	,RC.NOMBRE_REGIONAL AS REGIONAL_CDS_recoleccion
	,DC.NOMBRE_DEPARTAMENTO AS DEPARTAMENTO_CDS_recoleccion
	,DIV.CODIGO_ACTUAL AS CODIGO_CDS_recoleccion
	,CC.ID_CIUDAD AS ID_CIUDAD_CDS_recoleccion
	,CC.NOMBRE_CIUDAD as NOMBRE_CIUDAD_CDS_recoleccion
	,CC.CODIGO_DANE AS CODIGO_DANE_CIUDAD_CDS_recoleccion
	,DIV.ID_DIVISION AS ID_DIVISION_CDS_recoleccion
	,DIV.NOMBRE_DIVISION AS NOMBRE_CDS_recoleccion
	,CO.ID_CIUDAD AS ID_CIUDAD_ORIGEN_ENVIO_recoleccion
	,CTCAN.[NOMBRE_CLASE_TIPO_CANAL] as TIPO_CANAL_recoleccion
	,RTRIM(LTRIM(CO.NOMBRE_CIUDAD)) AS CIUDAD_ORIGEN_ENVIO_recoleccion
	,CASE WHEN ISNULL(PIE.Pieces,0) >0 THEN ISNULL(PIE.Pieces,0) ELSE 1 END AS PIEZAS
	INTO #DATOS_MINTIC_PASO01_RECOLECCIONES
FROM [RetailWebR4].[dbo].INVOICE AS I WITH(NOLOCK)
	INNER JOIN [RetailWebR4].[dbo].InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
	INNER JOIN [RetailWebR4].[dbo].Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
	INNER JOIN [RetailWebR4].[dbo].Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
------------------------------------------------------------------------
	LEFT JOIN [RetailWebR4].[dbo].[CashRegister] CR (nolock) on CR.Id=I.CashRegisterId
	LEFT JOIN [RetailWebR4].[dbo].SolutionCenter SO (nolock) on SO.[Id]=CR.[SolutionCenterId]
	LEFT JOIN [Mece_Logistico].[dbo].[CANALES_CO] CAN (NOLOCK) ON CAN.id_pais=SO.[CountryId] and CAN.id_ciudad=SO.[CityId] and CAN.[ID_DIVISION]=SO.[SolutionCenterId]
	LEFT JOIN PARAMETROS.DBO.DIVISIONES DIV (NOLOCK)  on DIV.ID_PAIS=CAN.ID_PAIS AND DIV.ID_CIUDAD=CAN.ID_CIUDAD AND DIV.ID_DIVISION=CAN.ID_DIVISION 
	LEFT JOIN PARAMETROS.DBO.CIUDADES CC WITH (NOLOCK) ON CC.ID_PAIS=CAN.ID_PAIS and CC.ID_CIUDAD=CAN.ID_CIUDAD
	LEFT JOIN [PARAMETROS].[dbo].[REGIONALES_PAIS] RC WITH (NOLOCK) ON RC.ID_PAIS=CC.ID_PAIS AND RC.ID_REGIONAL=CC.ID_REGIONAL
	LEFT JOIN [PARAMETROS_MDM].[dbo].DEPARTAMENTOS DC (NOLOCK) ON DC.ID_PAIS=CC.ID_PAIS AND DC.ID_DEPARTAMENTO=CC.ID_DEPARTAMENTO
	LEFT JOIN [Mece_Logistico].[dbo].[TIPOS_CANAL] TCAN (NOLOCK) ON TCAN.ID_TIPO_CANAL=CAN.ID_TIPO_CANAL AND TCAN.ID_EST_TIPO_CANAL=1
------------------------------------------------------------------------	
	INNER JOIN PARAMETROS.[dbo].[CLASE_TIPO_CANAL] CTCAN (NOLOCK) ON CTCAN.ID_CLASE_TIPO_CANAL=TCAN.CLASE_TIPO_CANAL
	INNER JOIN PARAMETROS.DBO.CIUDADES CO WITH (NOLOCK) ON CO.ID_PAIS=S.[SenderCountryId] and CO.ID_CIUDAD=S.[SenderCityId]
	INNER JOIN PARAMETROS.DBO.CIUDADES CD WITH (NOLOCK) ON CD.ID_PAIS=S.[ReceiverCountryId] and CD.ID_CIUDAD=S.[ReceiverCityId]
	INNER JOIN [PARAMETROS].[dbo].[REGIONALES_PAIS] RD WITH (NOLOCK) ON RD.ID_PAIS=CD.ID_PAIS AND RD.ID_REGIONAL=CD.ID_REGIONAL
	INNER JOIN [PARAMETROS_MDM].[dbo].DEPARTAMENTOS DD (NOLOCK) ON DD.ID_PAIS=CD.ID_PAIS AND DD.ID_DEPARTAMENTO=CD.ID_DEPARTAMENTO
------------------------------------------------------------------------
    LEFT JOIN #PIEZAS_GUIAS PIE (NOLOCK) ON PIE.ShippingId=S.Id 
------------------------------------------------------------------------	
	WHERE I.INVOICEDATE>=@FECHA_INICIAL AND I.INVOICEDATE<=@FECHA_FINAL
	and ID.PaymentFormId!=2 and I.[state]=1 AND S.[ReceiverCountryId] = 1
	--order by I.INVOICEDATE desc



SET LANGUAGE spanish
	SELECT TOP 2000
	'RETAIL' AS CANAL
	,CAST(year(i.invoicedate) AS nvarchar) +'-'+ CASE WHEN LEN(MONTH(i.invoicedate)) = 1 THEN '0'+ CAST(MONTH(i.invoicedate) AS nvarchar) ELSE CAST(MONTH(i.invoicedate) AS nvarchar) END as AÑO_MES_ENVIO
	,CONVERT(VARCHAR(19), i.invoicedate, 120) AS FECHA_ENVIO
	,DATENAME(MONTH,i.invoicedate) MES
	,g.number as NUMERO_GUIA
	,CC.ID_PAIS AS ID_PAIS_CDS
	,RC.NOMBRE_REGIONAL AS REGIONAL_CDS_distribucion
	,DC.NOMBRE_DEPARTAMENTO AS DEPARTAMENTO_CDS_distribucion
	,DIV.CODIGO_ACTUAL AS CODIGO_CDS_distribucion
	,CC.ID_CIUDAD AS ID_CIUDAD_CDS_distribucion
	,CC.NOMBRE_CIUDAD as NOMBRE_CIUDAD_CDS_distribucion
	,CC.CODIGO_DANE AS CODIGO_DANE_CIUDAD_CDS_distribucion
	,DIV.ID_DIVISION AS ID_DIVISION_CDS_distribucion
	,DIV.NOMBRE_DIVISION AS NOMBRE_CDS_distribucion
	,CO.ID_CIUDAD AS ID_CIUDAD_ORIGEN_ENVIO_distribucion
	,CTCAN.[NOMBRE_CLASE_TIPO_CANAL] as TIPO_CANAL_distribucion
	,RTRIM(LTRIM(CO.NOMBRE_CIUDAD)) AS CIUDAD_ORIGEN_ENVIO_distribucion
	,CASE WHEN ISNULL(PIE.Pieces,0) >0 THEN ISNULL(PIE.Pieces,0) ELSE 1 END AS PIEZAS
	INTO #DATOS_MINTIC_PASO01_DISTRIBUCIONES
FROM [RetailWebR4].[dbo].INVOICE AS I WITH(NOLOCK)
	INNER JOIN [RetailWebR4].[dbo].InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
	INNER JOIN [RetailWebR4].[dbo].Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
	INNER JOIN [RetailWebR4].[dbo].Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
------------------------------------------------------------------------
	INNER JOIN [RetailWebR4].[dbo].[OfficeDelivery] DELV WITH(NOLOCK) ON DELV.DocumentRetailNumber=G.Number
	LEFT JOIN [RetailWebR4].[dbo].SolutionCenter SO (nolock) on SO.[Id]=DELV.[SolutionCenterId]
	LEFT JOIN [Mece_Logistico].[dbo].[CANALES_CO] CAN (NOLOCK) ON CAN.id_pais=SO.[CountryId] and CAN.id_ciudad=SO.[CityId] and CAN.[ID_DIVISION]=SO.[SolutionCenterId]
	LEFT JOIN PARAMETROS.DBO.DIVISIONES DIV (NOLOCK)  on DIV.ID_PAIS=CAN.ID_PAIS AND DIV.ID_CIUDAD=CAN.ID_CIUDAD AND DIV.ID_DIVISION=CAN.ID_DIVISION 
	LEFT JOIN PARAMETROS.DBO.CIUDADES CC WITH (NOLOCK) ON CC.ID_PAIS=CAN.ID_PAIS and CC.ID_CIUDAD=CAN.ID_CIUDAD
	LEFT JOIN [PARAMETROS].[dbo].[REGIONALES_PAIS] RC WITH (NOLOCK) ON RC.ID_PAIS=CC.ID_PAIS AND RC.ID_REGIONAL=CC.ID_REGIONAL
	LEFT JOIN [PARAMETROS_MDM].[dbo].DEPARTAMENTOS DC (NOLOCK) ON DC.ID_PAIS=CC.ID_PAIS AND DC.ID_DEPARTAMENTO=CC.ID_DEPARTAMENTO
	LEFT JOIN [Mece_Logistico].[dbo].[TIPOS_CANAL] TCAN (NOLOCK) ON TCAN.ID_TIPO_CANAL=CAN.ID_TIPO_CANAL AND TCAN.ID_EST_TIPO_CANAL=1
------------------------------------------------------------------------	
	INNER JOIN PARAMETROS.[dbo].[CLASE_TIPO_CANAL] CTCAN (NOLOCK) ON CTCAN.ID_CLASE_TIPO_CANAL=TCAN.CLASE_TIPO_CANAL
	INNER JOIN PARAMETROS.DBO.CIUDADES CO WITH (NOLOCK) ON CO.ID_PAIS=S.[SenderCountryId] and CO.ID_CIUDAD=S.[SenderCityId]
	INNER JOIN PARAMETROS.DBO.CIUDADES CD WITH (NOLOCK) ON CD.ID_PAIS=S.[ReceiverCountryId] and CD.ID_CIUDAD=S.[ReceiverCityId]
	INNER JOIN [PARAMETROS].[dbo].[REGIONALES_PAIS] RD WITH (NOLOCK) ON RD.ID_PAIS=CD.ID_PAIS AND RD.ID_REGIONAL=CD.ID_REGIONAL
	INNER JOIN [PARAMETROS_MDM].[dbo].DEPARTAMENTOS DD (NOLOCK) ON DD.ID_PAIS=CD.ID_PAIS AND DD.ID_DEPARTAMENTO=CD.ID_DEPARTAMENTO
------------------------------------------------------------------------
    LEFT JOIN #PIEZAS_GUIAS PIE (NOLOCK) ON PIE.ShippingId=S.Id 
------------------------------------------------------------------------	
	WHERE I.INVOICEDATE>=@FECHA_INICIAL AND I.INVOICEDATE<=@FECHA_FINAL
	and ID.PaymentFormId!=2 and I.[state]=1 AND S.[ReceiverCountryId] = 1
	--order by I.INVOICEDATE desc


	TRUNCATE TABLE [dbo].[TMP_DW_CDS_SIN_PPES_BI]	


	INSERT INTO [dbo].[TMP_DW_CDS_SIN_PPES_BI]
	SELECT 
			AÑO_MES = T01.AÑO_MES_ENVIO	
			,FECHA = T01.FECHA_ENVIO	
			,NUMERO_GUIA = T01.NUMERO_GUIA	
			,DEPARTAMENTO_CDS_recoleccion = T01.DEPARTAMENTO_CDS_recoleccion
		------------------------------------------------
			,NOMBRE_CIUDAD_CDS_recoleccion = NOMBRE_CIUDAD_CDS_recoleccion	
			,CODIGO_CDS_recoleccion = CODIGO_CDS_recoleccion	
			,NOMBRE_CDS_recoleccion = NOMBRE_CDS_recoleccion
			,CODIGO_DANE_CIUDAD_CDS_recoleccion = CODIGO_DANE_CIUDAD_CDS_recoleccion
			,TIPO_CANAL_recoleccion = T01.TIPO_CANAL_recoleccion	
			,KeyComisiones_Tabla_recoleccion = CONCAT( YEAR(T01.FECHA_ENVIO),'-',
																			IIF(LEN(MONTH(T01.FECHA_ENVIO))<2,
																			CONCAT('0',MONTH(T01.FECHA_ENVIO)),MONTH(T01.FECHA_ENVIO))
																			,'-',CODIGO_CDS_recoleccion
																			)	
			,TIPO_COMISION = 'RECOLECCION'
			,NUMERO_PIEZAS = T01.PIEZAS
	FROM #DATOS_MINTIC_PASO01_RECOLECCIONES T01



	INSERT INTO [dbo].[TMP_DW_CDS_SIN_PPES_BI]
	SELECT 
			AÑO_MES = T02.AÑO_MES_ENVIO	
			,FECHA = T02.FECHA_ENVIO	
			,NUMERO_GUIA = T02.NUMERO_GUIA	
			,DEPARTAMENTO_CDS_distribucion = T02.DEPARTAMENTO_CDS_distribucion
		------------------------------------------------
			,NOMBRE_CIUDAD_CDS_distribucion = T02.NOMBRE_CIUDAD_CDS_distribucion	
			,CODIGO_CDS_distribucion = T02.CODIGO_CDS_distribucion	
			,NOMBRE_CDS_distribucion = T02.NOMBRE_CDS_distribucion
			,CODIGO_DANE_CIUDAD_CDS_distribucion = T02.CODIGO_DANE_CIUDAD_CDS_distribucion
			,TIPO_CANAL_recoleccion = T02.TIPO_CANAL_distribucion	
			,KeyComisiones_Tabla_distribucion = CONCAT( YEAR(T02.FECHA_ENVIO),'-',
																			IIF(LEN(MONTH(T02.FECHA_ENVIO))<2,
																			CONCAT('0',MONTH(T02.FECHA_ENVIO)),MONTH(T02.FECHA_ENVIO))
																			,'-',T02.CODIGO_CDS_distribucion
																			)	
			,TIPO_COMISION = 'DISTRIBUCION'
			,NUMERO_PIEZAS = T02.PIEZAS
	FROM #DATOS_MINTIC_PASO01_DISTRIBUCIONES T02
"


