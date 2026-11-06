/****** Script SISCLINET  ******/

WITH CTE AS (------------------------------------>CAMPOS EN DESARROLLO 
		SELECT 
		ROW_NUMBER ( )   OVER ( PARTITION BY SCN.[Num_Guia] order by SCN.[fecha_reimpresion] desc )  ROWid, 
			  SCN.[Num_Guia]
			  ,SCN.[Id_formato_impresion]
			  ,SCN.[Id_formato_reimpresion]
			  ,SCN.[fecha_reimpresion]
		  FROM [SIG_COLOMBIA_DW].[SCN].[SERT_ENVIO] SCN WITH(NOLOCK)
		  INNER JOIN SIG_COL_LOGISTICA_DW.TMP.ENVIOS_MOV EV WITH (NOLOCK)
		  ON EV.NUMERO_GUIA=SCN.Num_Guia
)
SELECT 
	Num_Guia AS NUMERO_GUIA
	,ID_TIPO_FORMATO_IMPRESION =
	CASE 
	WHEN Id_formato_reimpresion IS NULL AND Id_formato_impresion IS NULL THEN 0
	WHEN fecha_reimpresion IS NULL THEN Id_formato_reimpresion
	WHEN fecha_reimpresion IS NULL THEN Id_formato_impresion
	WHEN Id_formato_impresion IS NULL THEN Id_formato_reimpresion
	WHEN Id_formato_reimpresion IS NULL THEN Id_formato_impresion
	ELSE 0 END
	--,Id_formato_impresion	
	--,Id_formato_reimpresion	
	--,fecha_reimpresion
FROM CTE WHERE ROWid=1



/****** Script RETAIL  ******/


SELECT 
EV.NUMERO_GUIA,
I.DocumentRetailTypeId AS ID_TIPO_FORMATO_IMPRESION
FROM SIG_COL_LOGISTICA_DW.TMP.ENVIOS_MOV EV WITH (NOLOCK)
INNER JOIN SIG_COLOMBIA_DW.[RTW].[GUIDE] G WITH(NOLOCK) ON EV.NUMERO_GUIA=G.NUMBER
INNER JOIN SIG_COLOMBIA_DW.[RTW].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
INNER JOIN SIG_COLOMBIA_DW.[RTW].[InvoiceDetail] ID WITH(NOLOCK) ON G.InvoiceDetailId=ID.InvoiceId
INNER JOIN SIG_COLOMBIA_DW.[RTW].Invoice I WITH(NOLOCK) ON I.Id=ID.InvoiceId

