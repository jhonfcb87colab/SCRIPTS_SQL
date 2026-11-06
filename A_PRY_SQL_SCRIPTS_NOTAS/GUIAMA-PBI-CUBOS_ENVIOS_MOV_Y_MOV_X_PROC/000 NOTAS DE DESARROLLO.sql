/*

HISTORIAS DE USUARIO 
236567-GUIAMA-CUBOS-HU247-Ajuste a cubo mov_por_proceso_vehiculos
236568-GUIAMA-CUBOS-HU248-Ajuste a cubo mov_por_proceso_logisticos
236569-GUIAMA-CUBOS-HU249-Ajuste a cubo Movilizados
238291-GUIAMA-POWEBI-HU252-Report Server Auditoria Pruebas Entrega

*/


/*

********************************************************************
*******************IMPRESION IMPRESION  SISCLINET*******************
********************************************************************

BASE DE DATOS DE PRUEBAS DE SISCLINET
INSTANCIA 10.140.2.34
User ID = Usrsisclinet
Password = $$12clinet19??

SELECT * FROM SISCLINET.DBO.SERT_ENVIO WITH(NOLOCK)
ID_FORMATO_IMPRESION:
SELECT * FROM SISCLINET.DBO.SERT_FORMATOSIMPRESIONGUIA WITH(NOLOCK)


****************************************************************************
*******************IMPRESION IMPRESION  RETAIL (CONTADOS)*******************
****************************************************************************


BASE DE DATOS DE PRDUCCION  DE RETAIL(CONTADOS)
LSTSSRET\SQL03

BUSCAR CAMPO DocumentRetailTypeId

SELECT * FROM DBO.reportSetting R with(NOLOCK) Where R.filial=1
and R.DocumentRetailTypeId in(62,42)

La tabla Invoice campo DocumentRetailTypeId
Se realiza join con guido, invoicedetail, invoice

Retail
INVOICE I INNER JOIN TIPOS_GUIAS_PARAMETROS P
ID_TYPE_GUIA=(I.DOCUMENT_RETAIL_TYPEID)




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




AUDITORIA DE GUIAS 
HISTORIA DE USUARIO 
GUIAMA-POWEBI-HU252-Report Server Auditoria Pruebas Entrega
https://servientrega365.sharepoint.com/:w:/s/PR-GUIAMA-GUAMADRE/EZmZkOEnIBVHgYxKXbT9NnABgdB7xto7ZLOWLSyai3yn8Q?e=UFZ6Tg

FUENTE DE DATOS
SERVIDOR: T_SERV-DBDEV02\SQL2016_1
USUARIO: sismileniocentral
PASSSWORD: sismileniocentral





*/