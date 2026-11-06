/*

SERVER RETAILWEB: LSTSSRET\SQL03 
SERVER SISCLINET: LSTSSSIS\SQL05

*/


----------------------------------------------------------------------------------------------------------------
---------------------------------------AJUSTES DEL 2022/10/22 --------------------------------------------------
----------------------------------------------------------------------------------------------------------------



/*


SELECT TOP 100 
NUMERO_GUIA,
NUMERO_PIEZAS,
ID_ESTADOGUIA,
PESO_FACTURADO,
PESO_FISICO_GUIA,
PESO_FISICO_OPERA,---ADICIONAR
PESO_GUIA,
PESO_VOLU_GUIA,
PESO_VOLU_OPERA
 FROM LOG.GUIAS WITH(NOLOCK)
*/

/*


EL RPODUCTO  ID_PRODUCTO = 6,54 ES EL UNICO QUE TIENE MAS DE UNA PIEZA 



 SISCLINET ---MERFINGRESO
  -- PESO FACTURADO
  
  --- (PESO VOLUMETRICO OPERA  / PESO FISICO OPERA)  APLICA LA MISMA REGLA DE RETAIL -----> TABLA GUIAS DG


RETAIL
---NO SE TRAE POR QUE ES EL MISMO PESO FACTURADO Y EL PESO CLIENTE
-- TRAER PESO FISICO OPERA
-- TRAER PESO VOLUMETRICO OPERA
*/



/*
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [GUIA]
      ,[ID_PRODUCTO]
      ,[PRODUCTO]
      ,[TIME_ID]
      ,[FECHA_ENVIO]
      ,[ID_TRAYECTO]
      ,[NOMBRE_TRAYECTO]
      ,[TIPO_PESO]
      ,[PESO_CONSOLIDADO]
      ,[PESO_VOLUMETRICO]
      ,[PESO_FISICO]
      ,[ID_REGIONAL_ORIGEN]
      ,[REGIONAL_ORIGEN]
      ,[ID_CIUDAD_ORIGEN]
      ,[CIUDAD_ORIGEN]
      ,[ID_REGIONAL_DESTINO]
      ,[REGIONAL_DESTINO]
      ,[ID_CIUDAD_DESTINO]
      ,[CIUDAD_DESTINO]
      ,[CANAL]
      ,[FECHA_EXTRACCION]
      ,[TOTAL_VALOR_FACTURADO]
      ,[NUMERO_PIEZAS]
  FROM [SIG_COL_LOGISTICA_DW].[FAC].[MOBIPETARIF_TOTALES_TIPO_PESO_MES]
  */


  USE [SIG_COL_LOGISTICA_DW]

SELECT [GUIA]
      ,[FECHA_ENVIO]     
  FROM [FAC].[MOBIPETARIF_GUIAS]
WHERE 
[FECHA_ENVIO] BETWEEN 
 '20220101' AND '20220115'
AND [CANAL]='SISCLINET'
