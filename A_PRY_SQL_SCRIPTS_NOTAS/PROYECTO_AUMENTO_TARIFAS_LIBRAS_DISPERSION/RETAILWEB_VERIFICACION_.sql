-----NO ESTAN EN SERV-DBI01
--SELECT * FROM RetailWebHistorico..Invoice
--WHERE Id IN(
--149551218
--,149099114
--,148384388
--,149384028
--,148769969
--,148665126
--,148818376
--)
--SELECT * FROM RetailWebR3..Invoice
--WHERE Id IN(
--149551218
--,149099114
--,148384388
--,149384028
--,148769969
--,148665126
--,148818376
--)
-----SI ESTAN EN SERV-DBI01
--SELECT * FROM RetailWebHistorico..Invoice
--WHERE Id IN(
--145787307
--,145787324
--,145787326
--,145787341
--,145787343
--,145787375
--,145787377
--)
--SELECT * FROM RetailWebR4..Invoice
--WHERE Id IN(
--145787307
--,145787324
--,145787326
--,145787341
--,145787343
--,145787375
--,145787377
--)








--USE RetailWebHistorico;

"
DECLARE @FECHA_INI DATETIME=  convert(datetime, '"+  @[User::AUX_FINI] +"' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '"+ @[User::AUX_FFIN]  +"' );
SELECT 
I.Id
,I.InvoiceDate
,ID.ProductId
,G.Number
,G.RouteTypeId
 FROM [dbo].[Invoice] I (NOLOCK)
INNER JOIN INVOICEDETAIL ID (NOLOCK)
ON ID.INVOICEID = I.ID
INNER JOIN Guide G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
WHERE  I.State=1 AND
[InvoiceDate]  @FECHA_INI AND   @FECHA_FIN
"
 



"
DECLARE @FECHA_INI DATETIME=  convert(datetime, '"+  @[User::AUX_FINI] +"' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '"+ @[User::AUX_FFIN]  +"' );
SELECT
G.Number
,S.PhysicalWeight AS PESO_FISICO
,S.VolumetricWeight AS PESO_VOLUMETRICO
,S.SenderCityId AS ID_CIUDAD_REMITENTE
,S.ReceiverCityId AS ID_CIUDAD_DESTINO
FROM Guide AS G WITH(NOLOCK)
INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = G.Id
WHERE DeliveryDate BETWEEN @FECHA_INI AND   @FECHA_FIN
"





"
DECLARE @FECHA_INI DATETIME=  convert(datetime, '"+  @[User::AUX_FINI] +"' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '"+ @[User::AUX_FFIN]  +"' );
SELECT 
I.Id
,I.InvoiceDate
,ID.ProductId
,G.Number
,G.RouteTypeId
 FROM [dbo].[Invoice] I (NOLOCK)
INNER JOIN INVOICEDETAIL ID (NOLOCK)
ON ID.INVOICEID = I.ID
INNER JOIN Guide G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
WHERE  I.State=1 AND
[InvoiceDate] BETWEEN @FECHA_INI AND @FECHA_FIN
"


"
DECLARE @FECHA_INI DATETIME=  convert(datetime, '"+  @[User::AUX_FINI] +"' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '"+ @[User::AUX_FFIN]  +"' );
SELECT
G.Number
,S.PhysicalWeight AS PESO_FISICO
,S.VolumetricWeight AS PESO_VOLUMETRICO
,S.SenderCityId AS ID_CIUDAD_REMITENTE
,S.ReceiverCityId AS ID_CIUDAD_DESTINO
FROM Guide AS G WITH(NOLOCK)
INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = G.Id
WHERE DeliveryDate BETWEEN @FECHA_INI AND @FECHA_FIN
"







SELECT Top 100 * FROM Guide (NOLOCK)
SELECT Top 100 * FROM INVOICEDETAIL ID (NOLOCK)
SELECT Top 100 * FROM [dbo].[Invoice] I (NOLOCK)






DECLARE @FECHA_INI DATETIME=  convert(datetime, '20220929' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '20221004' );
SELECT
G.Number
,S.PhysicalWeight AS PESO_FISICO
,S.VolumetricWeight AS PESO_VOLUMETRICO
,S.SenderCityId AS ID_CIUDAD_REMITENTE
,S.ReceiverCityId AS ID_CIUDAD_DESTINO
FROM Guide AS G WITH(NOLOCK)
INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = G.Id
WHERE DeliveryDate BETWEEN @FECHA_INI AND @FECHA_FIN
