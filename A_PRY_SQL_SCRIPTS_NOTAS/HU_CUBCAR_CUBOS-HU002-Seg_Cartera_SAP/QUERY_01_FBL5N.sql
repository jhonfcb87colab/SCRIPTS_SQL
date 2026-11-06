USE SIG_COLOMBIA_DW;
---------TMP.FAC_CUBCAR_FBL5N_PRINCIPAL
SELECT 
ID_FBL5N = ROW_NUMBER() OVER(PARTITION BY 1 ORDER BY CONVERT(DATETIME,[Base p# plazo pago]))
,TIME_ID_PLAZO_PAGO = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,[Base p# plazo pago]))))
,TIME_ID_CONTABILIZACION = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,[Fe#contabilización])))) 	
,TIME_ID_FPAGO = CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,[Fecha de pago]))))	
,ID_CLAVE_REFERENCIA_1_3 = ISNULL([Clave referencia 1],'-888')
FROM [SIG_COLOMBIA_DW].[TMP].[CUBCAR_FBL5N_P02] (NOLOCK)


---------TMP.DIM_CUBCAR_FBL5N_PRINCIPAL
SELECT 
	ID_FBL5N = ROW_NUMBER() OVER(PARTITION BY 1 ORDER BY CONVERT(DATETIME,[Base p# plazo pago]))
	,[Clave referencia 1]
	,[Clave referencia 3]	
	,[Doc#facturación]
	,[Referencia a factura]
	,[Nº documento]
	,[Base p# plazo pago]
	,[Importe en moneda local]
	,[Clase de documento]
	,[Doc#compensación]
	,[Fe#contabilización]
	,[Clave de reclamación]
	,[Condiciones de pago]
	,[Fecha de pago]
FROM [SIG_COLOMBIA_DW].[TMP].[CUBCAR_FBL5N_P02] (NOLOCK)


---------TMP.DIM_CUBCAR_FBL5N_TEMPORAL_CLAVE_REFERENCIA_1_3
;WITH CTE AS (
SELECT '-888' AS [Clave referencia 1],'NO DISPONIBLE' AS [Clave referencia 3]
UNION ALL
SELECT DISTINCT
[Clave referencia 1],
[Clave referencia 3]
  FROM [SIG_COLOMBIA_DW].[TMP].[CUBCAR_FBL5N_P02] (NOLOCK)
)SELECT * FROM CTE







SELECT * FROM TMP.CUBCAR_FBL5N_P02

SELECT * FROM [TMP].[CUBCAR_FBL5N_PRINCIPAL_FACT];
SELECT * FROM [TMP].[CUBCAR_FBL5N_PRINCIPAL_DIM];
SELECT * FROM [TMP].[CUBCAR_FBL5N_CLAVE_REFERENCIA_1_3_DIM];



--alter table [TMP].[CUBCAR_FBL5N_PRINCIPAL_FACT] add [Importe en moneda local] [float] NULL

--alter table [TMP].[CUBCAR_FBL5N_PRINCIPAL_DIM] drop column [Importe en moneda local]


SELECT 
	 [ID_FBL5N] AS [ID_FBL5N]
	,IIF(LEN([Clave referencia 1])=0,'-888',[Clave referencia 1]) AS [Clave_referencia_1]
	,IIF(LEN([Clave referencia 3])=0,'NO DISPONIBLE',[Clave referencia 3]) AS [Clave_referencia_3]
	,IIF(LEN([Doc#facturación])=0,'NO DISPONIBLE',[Doc#facturación]) AS [Doc_facturación]
	,IIF(LEN([Nº documento])=0,'NO DISPONIBLE',[Nº documento]) AS [N_documento]
	,[Base p# plazo pago] AS [Base_p_plazo_pago]
	,[Clase de documento] AS [Clase_documento]
	,IIF(LEN([Doc#compensación])=0,'NO DISPONIBLE',[Doc#compensación]) AS [Doc_compensación]
	,[Fe#contabilización] AS [Fe_contabilización]
	,IIF(LEN([Clave de reclamación])=0,'-888',[Clave de reclamación]) AS [Clave_reclamación]
	,IIF(LEN([Condiciones de pago])=0,'-888',[Condiciones de pago]) AS [Condiciones_pago]
	,[Fecha de pago] AS [Fecha_pago] 
	,[FECHA_EXTRACCION] AS [FECHA_EXTRACCION]
FROM [TMP].[CUBCAR_FBL5N_PRINCIPAL_DIM] (NOLOCK)