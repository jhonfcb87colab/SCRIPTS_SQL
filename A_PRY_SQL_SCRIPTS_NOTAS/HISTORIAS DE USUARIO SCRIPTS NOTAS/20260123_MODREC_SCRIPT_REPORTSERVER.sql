
USE SIG_LOGISTICA_DM;

DECLARE @FECH_ENV_INI VARCHAR(19) = CONVERT(VARCHAR(19),'20260101') 
DECLARE @FECH_ENV_FIN VARCHAR(19) = CONVERT(VARCHAR(19),'20260201')
DECLARE @FECH_MOV_INI_ULT_MOV VARCHAR(19) = CONVERT(VARCHAR(19),'20260101') 
DECLARE @FECH_MOV_FIN_ULT_MOV VARCHAR(19) = CONVERT(VARCHAR(19),'20260201')
DECLARE @CIUDAD_DESTINO NVARCHAR(MAX) = '10,69,92,776,777,875,880,882'
DECLARE @CIUDAD_ORIGEN NVARCHAR(MAX) = '2,9,14,40,43,64'
DECLARE @REGIONAL_DESTINO NVARCHAR(MAX) = '1,2'
DECLARE @REGIONAL_ORIGEN NVARCHAR(MAX) = '1,2'
DECLARE @FORMA_DE_PAGO NVARCHAR(MAX) = ''		---'0,1,2,3'
DECLARE @CLIENTES NVARCHAR(MAX) =  '901358770,901411985,900469230,901508804,901521629,901505661,900595261' 


DROP TABLE IF EXISTS #CLIENTES_MODREC;
SELECT value as CLIENTES 
INTO #CLIENTES_MODREC
FROM STRING_SPLIT(@CLIENTES, ',');

--FROM STRING_SPLIT(REPLACE(@CLIENTES, ',', ';'), ',');

---PRINT len(@FORMA_DE_PAGO)

SELECT * FROM #CLIENTES_MODREC

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


/****************************		QUERY DINAMICO DE CIUDADES (CIUDAD ORIGEN   /  CIUDAD DESTINO DEL ENVIO  IDS TABLA GUIAS)	***********************************/
DECLARE @WHERE_CIUDAD_ORIGEN NVARCHAR(MAX) = ' AND 1=1';
IF LEN(@CIUDAD_DESTINO)>=1 AND LEN(@CIUDAD_ORIGEN)>=1
	SET  	@WHERE_CIUDAD_ORIGEN = ' AND G_ID_CIUDAD_ORIGEN IN ('+@CIUDAD_ORIGEN+') '
DECLARE @WHERE_CIUDAD_DESTINO NVARCHAR(MAX) = 'AND 1=1';
IF LEN(@CIUDAD_DESTINO)>=1 AND LEN(@CIUDAD_ORIGEN)>=1
	SET  	@WHERE_CIUDAD_DESTINO = ' AND G_ID_CIUDAD_DESTINO IN ('+@CIUDAD_DESTINO+') '


/****************************		QUERY DINAMICO DE REGIONALES (REGIONAL ORIGEN   /  REGIONAL DESTINO DEL ENVIO  IDS TABLA GUIAS)	***********************************/
DECLARE @WHERE_REGIONALES_ORIGEN NVARCHAR(MAX) = ' AND 1=1';
IF LEN(@REGIONAL_DESTINO)>=1 AND LEN(@REGIONAL_ORIGEN)>=1
	SET  	@WHERE_REGIONALES_ORIGEN = ' AND G_ID_REGIONAL_ORIGEN IN ('+@REGIONAL_ORIGEN+') '

DECLARE @WHERE_REGIONALES_DESTINO NVARCHAR(MAX) = ' AND 1=1';
IF LEN(@REGIONAL_DESTINO)>=1 AND LEN(@CIUDAD_ORIGEN)>=1
	SET  	@WHERE_REGIONALES_DESTINO = ' AND G_ID_REGIONAL_DESTINO IN ('+@REGIONAL_DESTINO+') '


DECLARE @WHERE_FORMA_PAGO NVARCHAR(MAX) = ' AND 1=1 '
IF LEN(@FORMA_DE_PAGO)>=1 
	SET  	@WHERE_FORMA_PAGO = ' AND FORMA_PAGO IN (SELECT FORMA_PAGO FROM #TABLE_FORMA_PAGO WHERE ID IN ('+@FORMA_DE_PAGO+') )'

--print len(@FORMA_DE_PAGO)
--print @WHERE_FORMA_PAGO


 /*
OK•	Fecha generación envío Desde
OK•	Fecha generación envío Hasta
OK•	Fecha del último movimiento del envío Desde
OK•	Fecha del último movimiento del envío Hasta

OK•	Regional origen: Lista desplegable, incluyendo opción Todos
OK•	Regional destino: Lista desplegable, incluyendo opción Todos
OK•	Regional último movimiento: Lista desplegable, incluyendo opción Todos
OK•	Ciudad origen: Lista desplegable que se habilita cuando se selecciona la Regional origen y que correspondan a dicha regional.
OK•	Ciudad destino: Lista desplegable que se habilita cuando se selecciona la Regional destino y que correspondan a dicha regional.
OK•	Ciudad último movimiento: Lista desplegable que se habilita cuando se selecciona la Regional último movimiento y que correspondan a dicha regional.

•	Reporte Pendiente (check): Al marcar este check, trae la información de lo que se encuentre por fuera de los conceptos en la HU LOGISC-BI-HU01-Dashboard control de envíos de LPC y COD, REQ1.0

•	Empresario Satélite (check): Al marcar este check, trae la información asociada a un empresario satélite, es decir, todos los pendientes cargados específicamente a un empresario satélite
•	Reporte Histórico (check): Este check trae la información de los envíos pendientes y no pendientes. Adicional, si se marca este check, deben ser obligatorios los siguientes campos: Fecha generación envío Desde, Fecha generación envío Hasta y se debe permitir la consulta 30 días de diferencia entre las fechas.


•	Cliente: Lista desplegable que muestra los clientes marcados en WBS como LPC o clientes que movilizan el producto contra entrega Ecommerce Retail
OK•	Tipos de recaudo (COD, LPC (Contraentrega Ecommerce), Todas)
 */






----DECLARE @WHERE_FECHA_ENVIO NVARCHAR(MAX)= 'AND FECHA_ENVIO BETWEEN  convert(datetime,'''+ @FECH_ENV_INI+''') AND convert(datetime,'''+@FECH_ENV_FIN+''')'




	--IF((SELECT COUNT(*) FROM @TMP) = 0)
	--	BEGIN	
	--	SET @ErrorMessage = REPLACE('1.3 la guía consultada no existe','','') 
	--	RAISERROR (@ErrorMessage,16,1)
	--END




SET
@SQL_SCRIPT_PRINCIPAL = '
SELECT 
		--•	Número de Guía
		NUMERO_GUIA
		-----* FECHA ENVIO
		,FECHA_ENVIO
		--•	Nombre del Centro de Soluciones
		,NOMBRE_CDS_ULT_MOV
		--•	Nombre del CPL
		,CPL_ULT_MOV
		--•	Modalidad de pago
		,FORMA_PAGO
		--•	Fecha en la que asume el estado SALIDA A ZONA URBANA
		,FECHA_HORA_MOVIMI_ULT_MOV_SZU
		--•	Estado de entrega: que identifica si está a tiempo o vencido
		,ESTADO_ENTREGA
		--•	Zona donde está asignado el envío
		,ZONA_URBANA_ULTIMO_MOV
		--•	Último movimiento logístico asignado al envío
		,PROCESO_LOG_ULTIMO_MOV
		--•	Valor a recaudar, tomarlo del tablero de control
		,VALOR_A_RECAUDAR
		--•	Valor recaudado, tomarlo del tablero de control
		,VALOR_RECAUDADO
		--•	Saldo, tomarlo del tablero de control
		,SALDO = VALOR_A_RECAUDAR-VALOR_RECAUDADO
		--•	Fecha de recaudo: corresponde al campo EFECTY_FECHA RECAUDO del tablero de control de contados
		,FECHA_RECAUDO
		--•	Número Orden de Servicio, tomarlo del tablero de control
		,NUMERO_ORDEN_SERVICIO
		--•	Estado del recaudo: debe mostrar “RECAUDADO” cuando el saldo sea igual a cero o RECAUDO PENDIENTE cuando el saldo sea mayor a cero.
		,ESTADO_DEL_RECAUDO = CASE	
									WHEN VALOR_A_RECAUDAR<=0 AND VALOR_RECAUDADO <= 0 THEN '+@SIN_VALOR_A_RECAUDAR+'
									WHEN VALOR_A_RECAUDAR-VALOR_RECAUDADO <=0 THEN '+@RECAUDADO+'
									WHEN VALOR_A_RECAUDAR-VALOR_RECAUDADO > 0 THEN '+@RECAUDO_PENDIENTE+'
									ELSE '+@NO_DISPONIBLE+'
									END
		--•	Cantidad de tareas asociadas al envío desde Servicio al cliente
		,NUMERO_TAREAS_ASOCIADAS = NUMERO_TAREAS
		--•	Nombre del Auxiliar y Conductor, el cual se debe tomar de Procesamiento de envíos, en el caso de no tener datos, deja el campo en blanco
		--•	Número de Cédula de Auxiliar y Conductor, el cual se debe tomar de Procesamiento de envíos
		,ID_CONDUCTOR_ULT_MOV
		,CONDUCTOR_ULT_MOV
		,ID_AUXILIAR_ULT_MOV
		,AUXILIAR_ULT_MOV
FROM [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK)
WHERE 
1=1
'+@WHERE_FECHA_ENVIO+'
'+@WHERE_FECHA_ULT_MOV+'
'+@WHERE_CIUDAD_ORIGEN+'
'+@WHERE_CIUDAD_DESTINO+'
'+@WHERE_REGIONALES_ORIGEN+'
'+@WHERE_REGIONALES_DESTINO+'
'+@WHERE_FORMA_PAGO+'
'
--print(@SQL_SCRIPT_PRINCIPAL)
EXEC(@SQL_SCRIPT_PRINCIPAL)




--SELECT ID_CLIENTE FROM  [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK) WHERE ISNULL(NUMERO_ORDEN_SERVICIO,0) <> 0





/*

SELECT
FORMA_PAGO 
FROM [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK)
group by FORMA_PAGO 

DECLARE @TABLE_FORMA_PAGO AS TABLE(ID INT, FORMA_PAGO VARCHAR(50))
INSERT INTO @TABLE_FORMA_PAGO VALUES
 (0,'NO DISPONIBLE')
,(1,'C.O.D.')
,(2,'LPC')
,(3,'CONTRAENTREGA ECOMMERCE')


SELECT * FROM @TABLE_FORMA_PAGO


*/

/*
SELECT LTRIM(RTRIM(ID_CLIENTE)) CLIENTE,COUNT(1) TT 
FROM  [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK) 
GROUP BY LTRIM(RTRIM(ID_CLIENTE))
ORDER BY COUNT(1) DESC
901358770
901411985
900469230
901508804
901521629
901505661
900595261
*/
/*
ID_REGIONAL
2
1
*/


/*
ID_REGIONAL=1
ID_CIUDAD
10
69
92
776
777
875
880
882

ID_REGIONAL=2
ID_CIUDAD
2
9
14
40
43
64


*/


--SELECT * FROM SIG_COLOMBIA_DW.PAR.CIUDADES WHERE ID_REGIONAL IN(1,2) ORDER BY ID_REGIONAL,ID_CIUDAD
--SELECT TOP 1000 * FROM [FAC].[MODREC_LPC_COD_GUIAS] WITH(NOLOCK)
