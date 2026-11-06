--DROP TABLE IF EXISTS [TMP_BORRAR].[DBO].[SERT_ENVIO_SCN_PIVOT_GUIA_EMPRESARIOS_20230502];
--CREATE TABLE [dbo].[SERT_ENVIO_SCN_PIVOT_GUIA_EMPRESARIOS_20230502](
--	[CONSECUTIVO] [int] IDENTITY(1,1) NOT NULL,
--	[G_NUMERO_GUIA] [numeric](20, 0) NOT NULL
--)



--USE SIG_COLOMBIA_DW;

--SELECT 
--	 E.CONSECUTIVO
--	,E.G_NUMERO_GUIA
--	,ISNULL(S.Fec_ImpresionEnvio,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
--	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(S.Fec_ImpresionEnvio,'1900-01-01')))))C_ID_FECHA_IMPR_GUIA
--FROM 
--	SCN.SERT_ENVIO S WITH(NOLOCK)
--INNER JOIN
--	TMP.EMPRESARIOS E WITH(NOLOCK)
--ON
--	E.G_NUMERO_GUIA = S.Num_Guia
--UNION
--SELECT 
--	 E.CONSECUTIVO
--	,E.G_NUMERO_GUIA
--	,ISNULL(I.InvoiceDate,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
--	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(I.InvoiceDate,'1900-01-01'))))) C_ID_FECHA_IMPR_GUIA
--FROM 
--	RTW.INVOICE I WITH(NOLOCK)
--INNER JOIN
--	TMP.EMPRESARIOS E WITH(NOLOCK)
--ON
--	E.G_NUMERO_GUIA = I.Number



--SELECT Num_Guia,COUNT(Num_Guia) TT FROM SCN.SERT_ENVIO WITH(NOLOCK)
--GROUP BY Num_Guia	HAVING COUNT(Num_Guia)>1
--	ORDER BY 2 DESC 	




--WITH CTE_ENVIO AS (
--SELECT  
--ROW_NUMBER () OVER (PARTITION BY S.Num_Guia ORDER BY S.FECHA_EXTRACCION_DW  DESC ) AS #ROWS, 
--S.Num_Guia, 
--S.Fec_ImpresionEnvio
--FROM SCN.SERT_ENVIO S WITH(NOLOCK, INDEX = [IX_NUM_GUIA_SERT_ENVIO])  --- = [IX_NUM_GUIA_SERT_ENVIO]
--INNER JOIN TMP.EMPRESARIOS E WITH(NOLOCK)
--ON E.G_NUMERO_GUIA=S.Num_Guia
--WHERE S.Fec_Envio>=DATEADD(MONTH,-8,GETDATE())
----WHERE Num_Guia in (SELECT DISTINCT E.G_NUMERO_GUIA FROM TMP.EMPRESARIOS E WITH(NOLOCK))
--)
--SELECT * FROM CTE_ENVIO 
--WHERE #ROWS=1



--SELECT 
--	 E.CONSECUTIVO
--	,E.G_NUMERO_GUIA
--	,ISNULL(S.Fec_ImpresionEnvio,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
--	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(S.Fec_ImpresionEnvio,'1900-01-01')))))C_ID_FECHA_IMPR_GUIA
--FROM 
--	CTE_ENVIO S WITH(NOLOCK)
--INNER JOIN
--	TMP.EMPRESARIOS E WITH(NOLOCK)
--ON
--	E.G_NUMERO_GUIA = S.Num_Guia
--WHERE S.#ROWS=1


--SELECT * 
--INTO #SIG_COLOMBIA_DW_TMP_EMPRESARIOS_PRUEBAS_20230502
--FROM SIG_COLOMBIA_DW.TMP.EMPRESARIOS WITH(NOLOCK)

SELECT * FROM #SIG_COLOMBIA_DW_TMP_EMPRESARIOS_PRUEBAS_20230502

SELECT F_EM.* FROM FAC.EMPRESARIOS F_EM WITH(NOLOCK)
INNER JOIN #SIG_COLOMBIA_DW_TMP_EMPRESARIOS_PRUEBAS_20230502 T_EM
ON T_EM.G_NUMERO_GUIA=F_EM.G_NUMERO_GUIA









SELECT 
	 E.CONSECUTIVO
	,E.G_NUMERO_GUIA
	,ISNULL(S.Fec_ImpresionEnvio,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(S.Fec_ImpresionEnvio,'1900-01-01')))))C_ID_FECHA_IMPR_GUIA
FROM 
	SCN.SERT_ENVIO S WITH(NOLOCK)
INNER JOIN
	TMP.EMPRESARIOS E WITH(NOLOCK)
ON
	E.G_NUMERO_GUIA = S.Num_Guia


UNION

SELECT 
	 E.CONSECUTIVO
	,E.G_NUMERO_GUIA
	,ISNULL(I.InvoiceDate,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(I.InvoiceDate,'1900-01-01'))))) C_ID_FECHA_IMPR_GUIA
FROM 
	RTW.INVOICE I WITH(NOLOCK)
INNER JOIN
	TMP.EMPRESARIOS E WITH(NOLOCK)
ON
	E.G_NUMERO_GUIA = I.Number







--WITH CTE_ENVIO_RETAIL AS (
--SELECT 
--ROW_NUMBER () OVER (PARTITION BY I.Number ORDER BY I.FECHA_EXTRACCION_DW  DESC ) AS #ROWS, 
--E.CONSECUTIVO
--	,E.G_NUMERO_GUIA
--	,ISNULL(I.InvoiceDate,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
--	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(I.InvoiceDate,'1900-01-01'))))) C_ID_FECHA_IMPR_GUIA
--FROM 
--	RTW.INVOICE I WITH(NOLOCK)
--INNER JOIN
--	TMP.EMPRESARIOS E WITH(NOLOCK)
--ON
--	E.G_NUMERO_GUIA = I.Number
--WHERE G_NUMERO_GUIA IN (SELECT DISTINCT ET.G_NUMERO_GUIA FROM TMP.EMPRESARIOS ET WITH(NOLOCK))
--)
--SELECT * FROM CTE_ENVIO_RETAIL WHERE #ROWS=1





-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------




--WITH CTE_ENVIO AS (
--SELECT  
--ROW_NUMBER () OVER (PARTITION BY S.Num_Guia ORDER BY S.FECHA_EXTRACCION_DW  DESC ) AS #ROWS, 
--S.Num_Guia, 
--S.Fec_ImpresionEnvio
--FROM SCN.SERT_ENVIO S WITH(NOLOCK)  --- = [IX_NUM_GUIA_SERT_ENVIO]
--INNER JOIN TMP.EMPRESARIOS E WITH(NOLOCK)
--ON E.G_NUMERO_GUIA=S.Num_Guia
--WHERE Num_Guia in (SELECT DISTINCT E.G_NUMERO_GUIA FROM TMP.EMPRESARIOS E WITH(NOLOCK))
--)
--SELECT * FROM CTE_ENVIO 
--WHERE #ROWS=1




-------------------------------------------------------------------------------------------------------------
--------------------------------------------------VARIOS ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------




	 
----------------------	-- 2110698120 --PQR
----------------------	-- ,9163121625
----------------------	--,9161869839
----------------------	--,2146086202
----------------------	--,2183230965
----------------------	--,2181432524
----------------------	--,2181147070
----------------------	--,2170049753
----------------------	 ----)

----------------------)
----------------------SELECT * FROM CTE_MODELO_EMPRESARIOS_SATELITE
------------------------WHERE ID IN (1)
----------------------WHERE ID_PROCESO=11 AND ID_CONCEPTO IN (3)
----------------------order by FECHA_HORA_MOVIMIENTO desc




----------------------SELECT * FROM DIM.PROCESOCONCEPTO WHERE ID_CONCEPTO IN (1,7,8,9) AND ID_PROCESO=9


----------------------/*

----------------------SELECT E.G_NUMERO_GUIA,E.NUMERO_MOVIMI,E.EF_ORDEN_SERVICIO,GRIR_NUMR_ORDE_SERVI,
----------------------E.FECHA_EXTRACCION_DM,E.EF_ID_FECHA_RECAUDO 
----------------------FROM  SIG_LOGISTICA_DM.FAC.EMPRESARIOS E WHERE 
----------------------	 E.G_NUMERO_GUIA IN 
----------------------	 (
----------------------	 9163121625
----------------------	,9161869839
----------------------	,2146086202
----------------------	,2183230965
----------------------	,2181432524
----------------------	,2181147070
----------------------	,2170049753
----------------------	 )

----------------------	 */



	 
------------------------	 SELECT *
--------------------------COUNT(1) AS TT
------------------------	 FROM TMP.EMPRESARIOS MODEEMP WITH(NOLOCK)
------------------------	 WHERE G_NUMERO_GUIA=2180877980


------------------------	 SELECT 
------------------------	 *
------------------------	 ,'1-1' D_ID_GEOGRAFIA_EMP

------------------------FROM
------------------------(
------------------------SELECT 
------------------------ROW_NUMBER() OVER(PARTITION BY NUMERO_GUIA
--------------------------,ID_PROCESO, NUMERO_MOVIMI, CONSECUT_MOVIMI,FECHA_HORA_MOVIMIENTO  
------------------------ORDER BY FECHA_HORA_MOVIMIENTO DESC) R
------------------------  , NUMERO_GUIA
------------------------   ,ID_PROCESO
------------------------   ,NUMERO_MOVIMI
------------------------   ,NUMERO_MOVIMI D_NUMERO_MANIFIESTO
------------------------   ,CONSECUT_MOVIMI
------------------------   ,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),FECHA_HORA_MOVIMIENTO))))   SE_ID_FECHA_SZU
------------------------   ,FECHA_HORA_MOVIMIENTO
------------------------   ,DATEPART(HOUR,FECHA_HORA_MOVIMIENTO) SE_ID_HORA_SZU
------------------------   ,CONVERT(VARCHAR,ID_PROCESO) + '-' + CONVERT(VARCHAR,ID_CONCEPTO) SE_ID_PROCESO_SZU
------------------------ FROM TMP.EMP_01 WITH (NOLOCK) ) T WHERE T.R = 1




----------------------SELECT 
----------------------	 E.CONSECUTIVO
----------------------	,E.G_NUMERO_GUIA
----------------------	,ISNULL(S.Fec_ImpresionEnvio,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
----------------------	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(S.Fec_ImpresionEnvio,'1900-01-01')))))C_ID_FECHA_IMPR_GUIA
----------------------FROM 
----------------------	SCN.SERT_ENVIO S WITH(NOLOCK)
----------------------INNER JOIN
----------------------	TMP.EMPRESARIOS E WITH(NOLOCK)
----------------------ON
----------------------	E.G_NUMERO_GUIA = S.Num_Guia
----------------------------------------------------UNION
----------------------USE  SIG_COLOMBIA_DW;
----------------------SELECT 
----------------------	 E.CONSECUTIVO
----------------------	,E.G_NUMERO_GUIA
----------------------	,ISNULL(I.InvoiceDate,'1900-01-01') C_FECHA_HORA_IMPR_GUIA
----------------------	,CONVERT(INT,CONVERT(NUMERIC,CONVERT(DATETIME,CONVERT(CHAR(11),ISNULL(I.InvoiceDate,'1900-01-01'))))) C_ID_FECHA_IMPR_GUIA
----------------------FROM 
----------------------	RTW.INVOICE I WITH(NOLOCK)
----------------------INNER JOIN
----------------------	TMP.EMPRESARIOS E WITH(NOLOCK)
----------------------ON
----------------------	E.G_NUMERO_GUIA = I.Number




----------------------SELECT G_NUMERO_GUIA,COUNT(G_NUMERO_GUIA) TT FROM TMP.EMPRESARIOS E WITH(NOLOCK)
----------------------GROUP BY G_NUMERO_GUIA	HAVING COUNT(G_NUMERO_GUIA)>1
----------------------	ORDER BY 2 DESC 	

----------------------SELECT Num_Guia,COUNT(Num_Guia) TT FROM SCN.SERT_ENVIO WITH(NOLOCK)
----------------------GROUP BY Num_Guia	HAVING COUNT(Num_Guia)>1
----------------------	ORDER BY 2 DESC 	


----------------------SELECT TOP 10 * FROM SCN.SERT_ENVIO WITH(NOLOCK)



----------------------SP_WHO3

