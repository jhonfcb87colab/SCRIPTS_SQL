
USE RetailWebR4;
SELECT  I.DocumentRetailTypeId,PR.NOMBRE_TIPOGUIA,COUNT(1) CANTIDAD_GUIAS
FROM Invoice I WITH(NOLOCK) 
inner join [dbo].[InvoiceDetail] I_D WITH(NOLOCK) ON I.Id=I_D.InvoiceId
INNER JOIN [dbo].[GUIDE] G WITH(NOLOCK) ON G.InvoiceDetailId=I_D.InvoiceId
inner join PARAMETROS..TIPOGUIA PR with(nolock) 
on I.DocumentRetailTypeId=PR.ID_TIPOGUIA AND PR.id_pais=1
INNER JOIN [dbo].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
WHERE I.DocumentRetailTypeId IS not NULL 
---AND I.DocumentRetailTypeId NOT IN(41,62)
group by I.DocumentRetailTypeId,PR.NOMBRE_TIPOGUIA
ORDER BY 1;


SELECT TOP 10000
G.NUMBER,
I.DocumentRetailTypeId
FROM [dbo].[GUIDE] G WITH(NOLOCK)
INNER JOIN [dbo].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
INNER JOIN [dbo].[InvoiceDetail] I WITH(NOLOCK) ON G.InvoiceDetailId=I.InvoiceId


SELECT COUNT(1) CANTIDAD_GUIAS
FROM Invoice I WITH(NOLOCK) 

----------------------------		parametrica tipos de impresion


SELECT        
		Id 
		,CountryId
		,FilialId
		,ReportTypeId
		,DocumentRetailTypeId
		,Url
		,Name
		,Description
		,State
		,Preprinted
		,Event
		,IsDocument
		,PromotionId
		,JointReport
		,MessageRequired
		,ReportPdf
FROM            ReportSetting AS R WITH (NOLOCK)
WHERE     DocumentRetailTypeId = 41
and   (IsDocument = 1) AND (State = 1)
ORDER BY DocumentRetailTypeId

--DocumentRetailTypeId
--Description



SELECT * FROM 
PARAMETROS..TIPOGUIA R WITH(NOLOCK)
WHERE R.id_pais=1 AND R.ID_TIPOGUIA in (41,62,52)
1











USE RetailWebR4;
SELECT  I.DocumentRetailTypeId,PR.NOMBRE_TIPOGUIA,COUNT(1) CANTIDAD_GUIAS
FROM Invoice I WITH(NOLOCK) 
inner join [dbo].[InvoiceDetail] I_D WITH(NOLOCK) ON I.Id=I_D.InvoiceId
INNER JOIN [dbo].[GUIDE] G WITH(NOLOCK) ON G.InvoiceDetailId=I_D.InvoiceId
inner join PARAMETROS..TIPOGUIA PR with(nolock) 
on I.DocumentRetailTypeId=PR.ID_TIPOGUIA AND PR.id_pais=1
INNER JOIN [dbo].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
WHERE I.DocumentRetailTypeId IS not NULL 
---AND I.DocumentRetailTypeId NOT IN(41,62)
group by I.DocumentRetailTypeId,PR.NOMBRE_TIPOGUIA
ORDER BY 1;




SELECT  TOP 100 
g.NUMBER,s.PhysicalWeight,VolumetricWeight
FROM Invoice I WITH(NOLOCK) 
inner join [dbo].[InvoiceDetail] I_D WITH(NOLOCK) ON I.Id=I_D.InvoiceId
INNER JOIN [dbo].[GUIDE] G WITH(NOLOCK) ON G.InvoiceDetailId=I_D.Id
INNER JOIN [dbo].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
WHERE I_D.ProductId=2
AND VolumetricWeight IS NULL AND s.PhysicalWeight IS NULL
I.
--inner join PARAMETROS..TIPOGUIA PR with(nolock) 
--on I.DocumentRetailTypeId=PR.ID_TIPOGUIA AND PR.id_pais=1
USE RetailWebR4;
SELECT top 100
G.NUMBER,S.PhysicalWeight,VolumetricWeight 
FROM [dbo].[GUIDE] G WITH(NOLOCK) 
INNER JOIN [dbo].[InvoiceDetail] I_D WITH(NOLOCK) ON (G.InvoiceDetailId=I_D.Id AND I_D.ProductId=2)
INNER JOIN [dbo].[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
WHERE S.VolumetricWeight IS NULL AND s.PhysicalWeight IS NULL






USE RetailWebR4;


SELECT 
G.Number,
I.DocumentRetailTypeId AS ID_TIPO_FORMATO_IMPRESION
FROM .[GUIDE] G WITH(NOLOCK) 
INNER JOIN .[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
INNER JOIN .[InvoiceDetail] ID WITH(NOLOCK) ON G.InvoiceDetailId=ID.InvoiceId
INNER JOIN .Invoice I WITH(NOLOCK) ON I.Id=ID.InvoiceId
WHERE G.Number IN (
2198644697
,2188911073
,2194261103
,2198421828
,2203745331
,2198432167
,2196472295
,2203388452
,2198427845
,2198430035
,2189718285
,2198429805
,2198432753
,2198429539
,2187941483
,2187964587
)





USE RetailWebR4;
SELECT 
G.Number,
I.DocumentRetailTypeId AS ID_TIPO_FORMATO_IMPRESION
FROM .[GUIDE] G WITH(NOLOCK) 
INNER JOIN .[Shipping] S WITH(NOLOCK) ON s.guideid=G.Id
INNER JOIN .[InvoiceDetail] ID WITH(NOLOCK) ON G.InvoiceDetailId=ID.InvoiceId
INNER JOIN .Invoice I WITH(NOLOCK) ON I.Id=ID.InvoiceId
WHERE G.Number IN (
2198429805
,2188911073
,2187964587
,2203745331
)
