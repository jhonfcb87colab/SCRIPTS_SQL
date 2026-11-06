
/*
USE RetailWebR4;
USE RetailWebHistorico;
*/
DECLARE @ANIOMES AS INT = 202307;
SELECT 
g.number,id.ProductId, count(pie.ShippingId) as Cantidad_Piezas
FROM INVOICE AS I WITH(NOLOCK)
INNER JOIN InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
INNER JOIN Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
INNER JOIN [dbo].[Customer] AS C WITH(NOLOCK) ON C.ID=S.SenderCustomerId
INNER JOIN [dbo].[Piece] AS pie WITH(NOLOCK) ON pie.ShippingId=s.id
WHERE 
year(I.INVOICEDATE)*100+month(I.INVOICEDATE)=@ANIOMES 
group by g.number,id.ProductId

GO

DECLARE @ANIOMES AS INT = 202307;
SELECT 
g.number,id.ProductId, count(pie.ShippingId) as Cantidad_Piezas
FROM INVOICE AS I WITH(NOLOCK)
INNER JOIN InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
INNER JOIN Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
INNER JOIN Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
INNER JOIN [dbo].[Customer] AS C WITH(NOLOCK) ON C.ID=S.SenderCustomerId
INNER JOIN [dbo].[Piece] AS pie WITH(NOLOCK) ON pie.ShippingId=s.id
WHERE 
year(I.INVOICEDATE)*100+month(I.INVOICEDATE)=@ANIOMES 
group by g.number,id.ProductId