USE SIG_LOGISTICA_DM;


DECLARE @FECH_ENV_INI_RPT DATETIME = @Zr_FECH_ENV_INI_RPT; 
DECLARE @FECH_ENV_FIN_RPT DATETIME = @Zr_FECH_ENV_FIN_RPT;
DECLARE @FECH_MOV_INI_ULT_MOV_RPT DATETIME = @Zr_FECH_MOV_INI_ULT_MOV_RPT;
DECLARE @FECH_MOV_FIN_ULT_MOV_RPT DATETIME = @Zr_FECH_MOV_FIN_ULT_MOV_RPT;

/*
DECLARE @FECH_ENV_INI_RPT DATETIME = '2025-01-01'; 
DECLARE @FECH_ENV_FIN_RPT DATETIME = '2026-01-01';
DECLARE @FECH_MOV_INI_ULT_MOV_RPT DATETIME = '2025-01-01';
DECLARE @FECH_MOV_FIN_ULT_MOV_RPT DATETIME = '2026-01-01';
DECLARE @CIUDAD_DESTINO NVARCHAR(MAX) = '10,69,92,776,777,875,880,882'
DECLARE @CIUDAD_ORIGEN NVARCHAR(MAX) = '2,9,14,40,43,64'
DECLARE @REGIONAL_DESTINO NVARCHAR(MAX) = '1,2'
DECLARE @REGIONAL_ORIGEN NVARCHAR(MAX) = '1,2'
DECLARE @FORMA_DE_PAGO NVARCHAR(MAX) = '0,1,2,3'		---'0,1,2,3'
DECLARE @CLIENTES NVARCHAR(MAX);
*/


DECLARE @FECH_ENV_INI VARCHAR(19) = CONVERT(varchar,@FECH_ENV_INI_RPT,112) ---CONVERT(VARCHAR(19),@FECH_ENV_INI_RPT) 
DECLARE @FECH_ENV_FIN VARCHAR(19) = CONVERT(varchar,@FECH_ENV_FIN_RPT,112) ---CONVERT(VARCHAR(19),@FECH_ENV_FIN_RPT)
DECLARE @FECH_MOV_INI_ULT_MOV VARCHAR(19) = CONVERT(varchar,@FECH_MOV_INI_ULT_MOV_RPT,112) ---CONVERT(VARCHAR(19),@FECH_MOV_INI_ULT_MOV_RPT) 
DECLARE @FECH_MOV_FIN_ULT_MOV VARCHAR(19) = CONVERT(varchar,@FECH_MOV_FIN_ULT_MOV_RPT,112) ---CONVERT(VARCHAR(19),@FECH_MOV_FIN_ULT_MOV_RPT)



/******************************			ESTRUCTURALES								*************************************/
DECLARE @SQL_SCRIPT_PRINCIPAL NVARCHAR(MAX);
DECLARE @SIN_VALOR_A_RECAUDAR VARCHAR(50) = '''SIN VALOR A RECAUDAR'''
DECLARE @RECAUDADO  VARCHAR(50) = '''RECAUDADO'''
DECLARE @RECAUDO_PENDIENTE  VARCHAR(50) = '''RECAUDO PENDIENTE'''
DECLARE @NO_DISPONIBLE  VARCHAR(50) = '''NO DISPONIBLE'''

DROP TABLE IF EXISTS #TABLE_FORMA_PAGO;
CREATE TABLE #TABLE_FORMA_PAGO(ID INT, FORMA_PAGO VARCHAR(50))
INSERT INTO #TABLE_FORMA_PAGO VALUES
 (0,'NO DISPONIBLE')
,(1,'C.O.D.')
,(2,'LPC')
,(3,'CONTRAENTREGA ECOMMERCE')



/****************************		QUERY DINAMICO DE FECHAS  (FECHA ENVIO  /  FECHA ULTIMO MOVIMIENTO LOGISTICO)								***********************************/
DECLARE @WHERE_FECHA_ENVIO NVARCHAR(MAX) = ' AND 1=1 ';
IF CONVERT(DATETIME,@FECH_ENV_INI) >= '1900-12-12'	 AND   CONVERT(DATETIME,@FECH_ENV_FIN) >= '1900-12-12'
	SET  	@WHERE_FECHA_ENVIO = ' AND FECHA_ENVIO BETWEEN convert(datetime, '''+@FECH_ENV_INI+''') AND convert(datetime,'''+@FECH_ENV_FIN+''') '
DECLARE @WHERE_FECHA_ULT_MOV NVARCHAR(MAX) = ' AND 1=1 ';
IF CONVERT(DATETIME,@FECH_MOV_INI_ULT_MOV) >= '1900-12-12'	 AND   CONVERT(DATETIME,@FECH_MOV_FIN_ULT_MOV) >= '1900-12-12'
	SET  	@WHERE_FECHA_ULT_MOV = ' AND FECHA_ULTIMO_MOV BETWEEN convert(datetime, '''+@FECH_MOV_INI_ULT_MOV+''') AND convert(datetime,'''+@FECH_MOV_FIN_ULT_MOV+''') '



 /*
OK?	Fecha generaci?n env?o Desde
OK?	Fecha generaci?n env?o Hasta
OK?	Fecha del ?ltimo movimiento del env?o Desde
OK?	Fecha del ?ltimo movimiento del env?o Hasta

OK?	Regional origen: Lista desplegable, incluyendo opci?n Todos
OK?	Regional destino: Lista desplegable, incluyendo opci?n Todos
OK?	Regional ?ltimo movimiento: Lista desplegable, incluyendo opci?n Todos
OK?	Ciudad origen: Lista desplegable que se habilita cuando se selecciona la Regional origen y que correspondan a dicha regional.
OK?	Ciudad destino: Lista desplegable que se habilita cuando se selecciona la Regional destino y que correspondan a dicha regional.
OK?	Ciudad ?ltimo movimiento: Lista desplegable que se habilita cuando se selecciona la Regional ?ltimo movimiento y que correspondan a dicha regional.

?	Reporte Pendiente (check): Al marcar este check, trae la informaci?n de lo que se encuentre por fuera de los conceptos en la HU LOGISC-BI-HU01-Dashboard control de env?os de LPC y COD, REQ1.0

?	Empresario Sat?lite (check): Al marcar este check, trae la informaci?n asociada a un empresario sat?lite, es decir, todos los pendientes cargados espec?ficamente a un empresario sat?lite
?	Reporte Hist?rico (check): Este check trae la informaci?n de los env?os pendientes y no pendientes. Adicional, si se marca este check, deben ser obligatorios los siguientes campos: Fecha generaci?n env?o Desde, Fecha generaci?n env?o Hasta y se debe permitir la consulta 30 d?as de diferencia entre las fechas.


?	Cliente: Lista desplegable que muestra los clientes marcados en WBS como LPC o clientes que movilizan el producto contra entrega Ecommerce Retail
OK?	Tipos de recaudo (COD, LPC (Contraentrega Ecommerce), Todas)
 */




SET
@SQL_SCRIPT_PRINCIPAL = '
SELECT 
		--?	N?mero de Gu?a
		NUMERO_GUIA
		-----* FECHA ENVIO
		,FECHA_ENVIO
		--?	Nombre del Centro de Soluciones
		,NOMBRE_CDS_ULT_MOV
		--?	Nombre del CPL
		,CPL_ULT_MOV
		--?	Modalidad de pago
		,FORMA_PAGO
		--?	Fecha en la que asume el estado SALIDA A ZONA URBANA
		,FECHA_HORA_MOVIMI_ULT_MOV_SZU
		--?	Estado de entrega: que identifica si est? a tiempo o vencido
		,ESTADO_ENTREGA
		--?	Zona donde est? asignado el env?o
		,ZONA_URBANA_ULTIMO_MOV
		--?	?ltimo movimiento log?stico asignado al env?o
		,PROCESO_LOG_ULTIMO_MOV
		--?	Valor a recaudar, tomarlo del tablero de control
		,VALOR_A_RECAUDAR
		--?	Valor recaudado, tomarlo del tablero de control
		,VALOR_RECAUDADO
		--?	Saldo, tomarlo del tablero de control
		,SALDO = VALOR_A_RECAUDAR-VALOR_RECAUDADO
		--?	Fecha de recaudo: corresponde al campo EFECTY_FECHA RECAUDO del tablero de control de contados
		,FECHA_RECAUDO
		--?	N?mero Orden de Servicio, tomarlo del tablero de control
		,NUMERO_ORDEN_SERVICIO
		--?	Estado del recaudo: debe mostrar ?RECAUDADO? cuando el saldo sea igual a cero o RECAUDO PENDIENTE cuando el saldo sea mayor a cero.
		,ESTADO_DEL_RECAUDO = CASE	
									WHEN VALOR_A_RECAUDAR<=0 AND VALOR_RECAUDADO <= 0 THEN '+@SIN_VALOR_A_RECAUDAR+'
									WHEN VALOR_A_RECAUDAR-VALOR_RECAUDADO <=0 THEN '+@RECAUDADO+'
									WHEN VALOR_A_RECAUDAR-VALOR_RECAUDADO > 0 THEN '+@RECAUDO_PENDIENTE+'
									ELSE '+@NO_DISPONIBLE+'
									END
		--?	Cantidad de tareas asociadas al env?o desde Servicio al cliente
		,NUMERO_TAREAS_ASOCIADAS = NUMERO_TAREAS
		--?	Nombre del Auxiliar y Conductor, el cual se debe tomar de Procesamiento de env?os, en el caso de no tener datos, deja el campo en blanco
		--?	N?mero de C?dula de Auxiliar y Conductor, el cual se debe tomar de Procesamiento de env?os
		,ID_CONDUCTOR_ULT_MOV
		,CONDUCTOR_ULT_MOV
		,ID_AUXILIAR_ULT_MOV
		,AUXILIAR_ULT_MOV
FROM [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK)
WHERE 
1=1
AND FORMA_PAGO IN (SELECT FORMA_PAGO FROM #TABLE_FORMA_PAGO WHERE ID IN ('+@FORMA_DE_PAGO+'))
'







----->		'+@WHERE_CIUDAD_ORIGEN+'
----->		'+@WHERE_CIUDAD_DESTINO+'
----->		'+@WHERE_REGIONALES_ORIGEN+'
----->		'+@WHERE_REGIONALES_DESTINO+'
----->		'+@WHERE_FORMA_PAGO+'
----->		'+@WHERE_CLIENTES+'


--print(@SQL_SCRIPT_PRINCIPAL)
EXEC(@SQL_SCRIPT_PRINCIPAL)







'+@WHERE_FECHA_ENVIO+'
'+@WHERE_FECHA_ULT_MOV+'
AND G_ID_CIUDAD_ORIGEN IN ('+@CIUDAD_ORIGEN+')
AND G_ID_CIUDAD_DESTINO IN ('+@CIUDAD_DESTINO+')
AND G_ID_REGIONAL_ORIGEN IN ('+@REGIONAL_ORIGEN+')
AND G_ID_REGIONAL_DESTINO IN ('+@REGIONAL_DESTINO+')
AND ID_CLIENTE IN ('+@CLIENTES+')