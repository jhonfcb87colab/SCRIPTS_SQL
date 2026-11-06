
--DECLARE @FECHA_INI DATETIME=  convert(datetime, '20230524' );
--DECLARE @FECHA_FIN DATETIME= convert(datetime, '20230609' );
--SELECT
--G.Number
--,S.PhysicalWeight AS PESO_FISICO
--,S.VolumetricWeight AS PESO_VOLUMETRICO
--,S.SenderCityId AS ID_CIUDAD_REMITENTE
--,S.ReceiverCityId AS ID_CIUDAD_DESTINO
--FROM Guide AS G WITH(NOLOCK)
--INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = G.Id
--WHERE DeliveryDate BETWEEN @FECHA_INI AND   @FECHA_FIN





--SELECT 
--I.Id
--,I.InvoiceDate
--,ID.ProductId
--,G.Number
--,G.RouteTypeId
-- FROM [dbo].[Invoice] I (NOLOCK)
--INNER JOIN INVOICEDETAIL ID (NOLOCK)
--ON ID.INVOICEID = I.ID
--INNER JOIN Guide G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
--WHERE  I.State=1 AND
--[InvoiceDate]  BETWEEN @FECHA_INI AND   @FECHA_FIN

DECLARE @FECHA_INI DATETIME=  convert(datetime, '20230101' );
DECLARE @FECHA_FIN DATETIME= convert(datetime, '20230531' );
WITH CTE AS(
SELECT 
YEAR(I.[InvoiceDate])*100+ MONTH(I.[InvoiceDate]) ID_MES,
COUNT(G.Number) AS CT_GUIAS
 FROM [RetailWebR4].[dbo].[Invoice] I (NOLOCK)
INNER JOIN [RetailWebR4].[dbo].INVOICEDETAIL ID (NOLOCK)
ON ID.INVOICEID = I.ID
INNER JOIN [RetailWebR4].[dbo].Guide G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
WHERE  I.State=1 AND
--[InvoiceDate]  BETWEEN @FECHA_INI AND   @FECHA_FIN
g.Number =2110909199
AND ID.ProductId=2
GROUP BY YEAR(I.[InvoiceDate])*100+ MONTH(I.[InvoiceDate])
UNION ALL
SELECT 
YEAR(I.[InvoiceDate])*100+ MONTH(I.[InvoiceDate]) ID_MES,
COUNT(G.Number) AS CT_GUIAS
 FROM [RetailWebHistorico].[dbo].[Invoice] I (NOLOCK)
INNER JOIN [RetailWebHistorico].[dbo].INVOICEDETAIL ID (NOLOCK)
ON ID.INVOICEID = I.ID
INNER JOIN [RetailWebHistorico].[dbo].Guide G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
WHERE  I.State=1 AND
--[InvoiceDate]  BETWEEN @FECHA_INI AND   @FECHA_FIN
g.Number =2110909199
AND ID.ProductId=2
GROUP BY YEAR(I.[InvoiceDate])*100+ MONTH(I.[InvoiceDate])
)
SELECT ID_MES,SUM(CT_GUIAS) CT_GUIAS FROM CTE
GROUP BY ID_MES
order by 1 asc