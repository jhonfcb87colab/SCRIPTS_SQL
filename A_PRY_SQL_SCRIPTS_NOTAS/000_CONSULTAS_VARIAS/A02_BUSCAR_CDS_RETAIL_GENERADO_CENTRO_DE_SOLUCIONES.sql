
---> quien genera el envio
use RetailWebR4;
select 
	 g.Number AS NUMERO_GUIA
	,SC.SOLUTIONCENTERID AS ID_DIVISION	
	,sc.cityid AS ID_CIUDAD
	,DIV.CODIGO_ACTUAL AS CODIGO_ACTUAL_CDS
	,DIV.NOMBRE_DIVISION
	,CDS_GREENMOBILE = 'CDS'
	,i.InvoiceDate
FROM RetailWebR4..guide g WITH(NOLOCK) ---ON TMP.NUMERO_GUIA=g.Number
inner join RetailWebR4..invoicedetail id WITH(NOLOCK) on g.InvoiceDetailId=id.id
inner join RetailWebR4..invoice i WITH(NOLOCK) on id.invoiceid=i.id
inner join RetailWebR4..cashregister cr WITH(NOLOCK) on cr.id=i.cashregisterid
inner join RetailWebR4..solutioncenter sc WITH(NOLOCK) on sc.id=cr.solutioncenterid
left JOIN PARAMETROS..DIVISIONES DIV WITH(NOLOCK)
ON  SC.CityId=DIV.ID_CIUDAD AND DIV.ID_PAIS=1
  AND  SC.SolutionCenterId = DIV.ID_DIVISION
where  g.Number  = 9184501964
UNION ALL
select 
	 g.Number AS NUMERO_GUIA
	,SC.SOLUTIONCENTERID AS ID_DIVISION	
	,sc.cityid AS ID_CIUDAD
	,DIV.CODIGO_ACTUAL AS CODIGO_ACTUAL_CDS
	,DIV.NOMBRE_DIVISION
	,CDS_GREENMOBILE = 'CDS'
	,i.InvoiceDate
FROM RetailWebHistorico..guide g WITH(NOLOCK) ---ON TMP.NUMERO_GUIA=g.Number
inner join RetailWebHistorico..invoicedetail id WITH(NOLOCK) on g.InvoiceDetailId=id.id
inner join RetailWebHistorico..invoice i WITH(NOLOCK) on id.invoiceid=i.id
inner join RetailWebHistorico..cashregister cr WITH(NOLOCK) on cr.id=i.cashregisterid
inner join RetailWebHistorico..solutioncenter sc WITH(NOLOCK) on sc.id=cr.solutioncenterid
left JOIN PARAMETROS..DIVISIONES DIV WITH(NOLOCK)
ON  SC.CityId=DIV.ID_CIUDAD AND DIV.ID_PAIS=1
  AND  SC.SolutionCenterId = DIV.ID_DIVISION
where  g.Number  = 9184501964

----> quien recibe para distribucion el envio
SELECT TOP 100 
	 DELV.DocumentRetailNumber AS NUMERO_GUIA
	,SLTCTR.SolutionCenterId AS ID_DIVISION	
	,SLTCTR.CityId AS ID_CIUDAD
	,DIV.CODIGO_ACTUAL AS CODIGO_ACTUAL_CDS
	,DIV.NOMBRE_DIVISION
	,CDS_GREENMOBILE = 'CDS'
	,DELV.DeliveryDate
  FROM  [RetailWebR4].[dbo].[OfficeDelivery] DELV WITH(NOLOCK)
  INNER JOIN [RetailWebR4].[dbo].[SolutionCenter] SLTCTR WITH(NOLOCK)
    ON DELV.SOLUTIONCENTERID=SLTCTR.ID
  left JOIN PARAMETROS..DIVISIONES DIV WITH(NOLOCK)
  ON SLTCTR.CityId=DIV.ID_CIUDAD
  AND SLTCTR.SolutionCenterId = DIV.ID_DIVISION
  where 
  DELV.DocumentRetailNumber = 9160551582



  select top 100 * FROM  [RetailWebR4].[dbo].[OfficeDelivery] DELV WITH(NOLOCK)
  select top 100 * FROM  RetailWebHistorico..cashregister cr WITH(NOLOCK)

