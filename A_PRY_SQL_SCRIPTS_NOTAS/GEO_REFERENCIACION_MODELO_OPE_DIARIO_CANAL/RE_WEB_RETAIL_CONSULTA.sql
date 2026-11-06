
---MEPVSVWSSRET02\SQL03
USE [RetailWebR4]

SELECT TOP 10000
G.NUMBER,S.Zone,FilialId,ProductId,ByProductId,
CASE WHEN (FilialId IS NULL OR FilialId <> 1 OR ProductId IS NULL OR ByProductId IS NULL) THEN '-888' ELSE (CONVERT(VARCHAR,ProductId)+'-'+CONVERT(VARCHAR,ByProductId)) END AS ID_UEN_PROD_SUBP
 FROM [dbo].[GUIDE] G 
LEFT JOIN [dbo].[Shipping] S ON s.guideid=G.Id
LEFT JOIN [dbo].[InvoiceDetail] I  ON G.InvoiceDetailId=I.InvoiceId
WHERE 
---G.NUMBER=2141115296 AND
S.Zone is NOT null --AND LEN(S.Zone)>0





--and g.dat
---G.Number in(9138875958,20850844897)
--9147284424



SELECT TOP 10 * FROM [dbo].[GUIDE] G 
SELECT TOP 10 * FROM [dbo].[InvoiceDetail] D ----WHERE D.InvoiceId=
SELECT TOP 10 * FROM [dbo].[Shipping] S ---WHERE ---S.ID





