
USE SIG_LOGISTICA_DM;

SELECT
F.GR_ESTADO_RECAUDO,
F.G_NUMERO_GUIA,CONVERT(DATETIME,F.SE_ID_FECHA_SZU) FECHA,
F.GR_TIPO_COBRO,
F.GRIR_VALOR_RECAUDADO,
F.GRIR_VALOR_X_RECAUDAR,
IIF(F.GR_ESTADO_RECAUDO='SI' OR GRIR_VALOR_X_RECAUDAR = F.GRIR_VALOR_RECAUDADO,GRIR_VALOR_X_RECAUDAR,
(GRIR_VALOR_X_RECAUDAR - F.GRIR_VALOR_RECAUDADO)) AS VALOR_TOTAL,
FECHA_EXTRACCION_DM
FROM [FAC].[EMPRESARIOS] F  WITH (NOLOCK) 
WHERE F.D_ID_GEOGRAFIA_EMP='1-480-5'
AND CONVERT(DATETIME,F.SE_ID_FECHA_SZU) BETWEEN '2023-05-01' AND '2023-05-09' 
----AND F.G_NUMERO_GUIA=9157150408
AND F.GR_TIPO_COBRO IS NOT NULL
--SELECT CONVERT(INT,CONVERT(DATETIME,'2023-05-01'))



USE SIG_LOGISTICA_DM;

SELECT
*
FROM [FAC].[EMPRESARIOS] F  WITH (NOLOCK) 
WHERE F.G_NUMERO_GUIA=9157150408







/*

USE SIG_LOGISTICA_DM;

DECLARE @SE_FECHA_FINAL DATETIME SET @SE_FECHA_FINAL = '2023-05-01'-----GETDATE();
DECLARE @SE_FECHA_INICIAL DATETIME SET @SE_FECHA_INICIAL = '2023-05-08'  ----DATEADD(day, -45, @SE_FECHA_FINAL)


SELECT 
        T.[G_ID_CIUDAD_DESTINO] AS PRUEBA_DESTINO,
		T.*,(S.[YEAR]*100) + S.ID_MES ID_AÑO_MES
       ,CONVERT(VARCHAR,S.[YEAR]) +' - ' +S.MES AÑO_MES
                   ,CASE WHEN S.FECHA >= CONVERT(DATETIME,CONVERT(VARCHAR,YEAR(DATEADD(MONTH,-3,GETDATE()))) + '-' + CONVERT(VARCHAR,MONTH(DATEADD(MONTH,-3,GETDATE()))) + '-01') THEN 1 ELSE 0 END AÑO_MES_FILTRO
                   ,S.DIA,S.ID_MES,S.MES 
       ,(CASE WHEN P_ID_PERIODO_LIQU = -888  THEN -888 ELSE (
                   SELECT MIN(ID_PERIODO_LIQUIDADOR) FROM [DIM].[PERIODOS_LIQUIDADOR_EMP] WITH (NOLOCK) 
        WHERE SE_FECHA_HORA_SZU >= [FECHA_INICIAL_PERIODO] AND SE_FECHA_HORA_SZU <= [FECHA_FINAL_PERIODO]) END) ID_PERIODO 
       ,(CASE WHEN  P_ID_PERIODO_LIQU = -888 THEN 'SIN PERIODO' ELSE (SELECT ISNULL(MIN(PERIODO),'SIN PERIODO') FROM [DIM].[PERIODOS_LIQUIDADOR_EMP] WITH (NOLOCK) 
        WHERE P_ID_PERIODO_LIQU = ID_PERIODO_LIQUIDADOR ) END) PERIODO 
		,GR_TIPO_COBRO			--CAMPOS NUEVO
        ,EF_VALOR				--CAMPOS NUEVO
        ,GR_ESTADO_LEGALIZADO	--CAMPOS NUEVO
        ,GRIR_VALOR_X_RECAUDAR	--CAMPOS NUEVO
        ,GRIR_VALOR_RECAUDADO	--CAMPOS NUEVO
        ,GRIR_VALOR_SALDO		--CAMPOS NUEVO
        ,GR_ESTADO_RECAUDO		--CAMPOS NUEVO
       
      
FROM
                (
                               SELECT
                                F.[G_NUMERO_GUIA]
                                ,F.[SE_ID_FECHA_SZU]
                                 ,F.[SE_ID_HORA_SZU]
                                 ,F.[D_ID_GEOGRAFIA_EMP]
                                 ,F.[SE_ID_PROCESO_SZU]
                                 ,F.[SE_ID_PROCESO_RD]
                                 ,F.[SE_ID_PROCESO_ULT]
                                 ,F.[SE_ID_PROCESO_CONF]
                                 ,F.[SE_ID_FECHA_EZU]
                                 ,F.[SE_ID_HORA_EZU]
                                 ,F.[SE_ID_FECHA_RTW]
                                 ,F.[SE_ID_HORA_RTW]
                                 ,F.[SE_ID_FECHA_RVO]
                                 ,F.[SE_ID_FECHA_RE]
                                 ,F.[SE_ID_FECHA_RD]
                                 ,F.[SE_ID_HORA_RD]
                                 ,F.[SE_ID_FECHA_SR]
                                 ,F.[SE_ID_HORA_SR]
                                 ,F.[SE_ID_FECHA_ER]
                                 ,F.[SE_ID_HORA_ER]
                                 ,F.[PE_ID_FECHA_DIGDO]
                                 ,F.[PE_ID_FECHA_CMI]
                                 ,F.[R_ID_FECHA_PE]
                                 ,F.[SE_ID_FECHA_CONF]
                                 ,F.[R_ID_FECHA_DESP]
                                 ,F.[D_ID_FECHA_SZU_APER]
                                 ,F.[D_ID_HORA_SZU_APER]
                                 ,F.[D_ID_FECHA_SZU_CIERRE]
                                 ,F.[D_ID_HORA_SZU_CIERRE]
                                 ,F.[G_ID_FECHA_ENVIO]
                                 ,F.[C_ID_FECHA_IMPR_GUIA]
                                 ,F.[SE_ID_FECHA_ULT]
                                 ,F.[G_ID_PRODUCTO]
                                 ,F.[GIA_ID_TIPO_LOGISTICA]
                                 ,F.[SE_ID_VEJEZ_EMP]
                                 ,F.[P_ID_ESQ_LIQU_EMP]
                                 ,F.[SE_ID_ESTADO_RTW]
                                 ,F.[SE_ID_ESTADO_RTW_HOY]
                                 ,F.[SE_ID_ESTADO_RVO]
                                 ,F.[SE_ID_ESTADO_RE]
                                 ,F.[SE_ID_ESTADO_RD]
                                 ,F.[SE_ID_ESTADO_SR]
                                 ,F.[SE_ID_ESTADO_ER]
                                 ,F.[GR_ID_ESTADO_PDTE_RECDO]
                                 ,F.[SE_ID_ESTADO_RE_HOY]
                                 ,F.[SE_ID_ESTADO_PDTE_GEST]
                                 ,F.[SE_ID_ESTADO_PDTE_CICLO]
                                 ,F.[P_ID_ESTADO_DIGDO]
                                 ,F.[P_ID_ESTADO_CMI]
                                 ,F.[P_ID_ESTADO_PE]
                                 ,F.[SE_ID_ESTADO_CONF]
                                 ,F.[R_ID_ESTADO_DESP]
                                 ,F.[SE_ID_ESTADO_DEVREMT]
                                 ,F.[P_ID_ESTADO_LIMT_ENTRE]
                                 ,F.[P_ID_ESTADO_LIMT_DIGDO]
                                 ,F.[P_ID_ESTADO_LIMT_CMI]
                                 ,F.[P_ID_ESTADO_LIMT_PE]
                                ,F.[P_ID_ESTADO_LIMT_RD]
                                 ,F.[P_ID_ESTADO_LIMT_CONF]
                                 ,F.[P_ID_ESTADO_LIMT_DESP]
                                 ,F.[D_ID_ESTADO_SZU_CIERRE]
                                 ,F.[P_ID_ESTADO_LIQDO]
                                 ,F.[P_ID_ESTADO_DESP]
                                 ,F.[P_ID_ESTADO_PENA]
                                 ,F.[P_ID_ESTADO_PAGA]
                                 ,CONCAT (F.[P_ID_ESTADO_LIQDO],'-',F.[P_ID_ESTADO_DESP],'-',F.[P_ID_ESTADO_PENA],'-',F.[P_ID_ESTADO_PAGA]) AS P_ID_ESTADO_LIQDO_DESP_PENA_PAGA
                                 ,F.[P_ID_ESTADO_NOVEDAD]
                                 ,F.[G_ID_ESTADO_RECA_COBRAR]
                                 ,F.[G_ID_ESTADO_RECA_COBRADO]
                                 ,F.[G_ID_BODEGA]
                                 ,F.[G_ID_MEDTRANS]
                                 ,F.[G_ID_TIEMPO_ENTREGA]
                                 ,F.[G_ID_CIUDAD_ORIGEN]
                                 ,F.[G_ID_CIUDAD_DESTINO]
                                 --,dbo.UFN_SEPARATES_COLUMNS(F.[D_ID_GEOGRAFIA_EMP], 2, '-') AS [G_ID_CIUDAD_DESTINO]
                                 ,F.[G_ID_CIUDAD_ULT]
                                 ,F.[SE_ID_SOLUCION_CONF]
                                 ,F.[G_ID_TIPOTRAYECTO]
                                 ,F.[SE_ID_ZONAURBAN]
                                 ,F.[G_ID_CLIENTE]
                                 ,F.[G_ID_ESTADOENVIO]
                                 ,F.[G_CANTIDAD_PIEZAS]
                                 ,F.[SE_CANTIDAD_SZU]
                                 ,F.[SE_CANTIDAD_RVO]
                                 ,F.[GIA_VALOR_RECAUDAR]
                                 ,F.GR_VALOR_PDTE_RECDO
                                 ,F.[P_VALOR_UNIT_TECN]
                                 ,F.[P_VALOR_COSTO_ADIC]
                                 ,F.[P_VALOR_LIQUIDADO]
                                 ,F.[P_VALOR_FINAL_LIQU]
                                 ,F.[D_NUMERO_MANIFIESTO]
                                 ,F.[G_ID_REMITE]
                                 ,F.[G_NOMBRE_REMITE_GUIA]
                                 ,F.[G_APELLIDO_REMITE_GUIA]
                                 ,RTRIM(F.[G_ID_REMITE]) + ' - ' + F.[G_NOMBRE_REMITE_GUIA] + ' - ' + F.[G_APELLIDO_REMITE_GUIA] AS G_ID_NOMBRE_APELLIDO_REMITE
                                 ,F.[G_DIRECCION_REMITE_GUIA]
                                 ,F.[G_TELEFONO_REMITE_GUIA]
                                 ,F.[G_ID_DESTINA]
                                 ,F.[G_NOMBRE_DESTINA_GUIA]
                                 ,F.[G_APELLIDO_DESTINA_GUIA]
                                 ,RTRIM(F.[G_ID_DESTINA]) + ' - ' + F.[G_NOMBRE_DESTINA_GUIA] + ' - ' + F.[G_APELLIDO_DESTINA_GUIA] AS G_ID_NOMBRE_APELLIDO_DESTINA
                                 ,F.[G_DIRECCION_DESTINA_GUIA]
                                 ,F.[G_TELEFONO_DESTINA_GUIA]
                                 ,F.[P_COSTO_ADIC_OBSE]
                                 ,F.[SE_FECHA_HORA_SZU]
                                 ,F.[SE_FECHA_HORA_EZU]
                                 ,F.[SE_FECHA_HORA_RTW]
                                 ,F.[SE_FECHA_HORA_RVO]
                                 ,F.[SE_FECHA_HORA_RE]
                                 ,F.[SE_FECHA_HORA_RD]
                                 ,F.[SE_FECHA_HORA_SR]
                                 ,F.[SE_FECHA_HORA_ER]
                                 ,F.[SE_FECHA_HORA_EJECDO]
                                 ,F.[PE_FECHA_HORA_DIGDO]
                                 ,F.[PE_FECHA_HORA_CMI]
                                 ,F.[R_FECHA_HORA_PE]
                                 ,F.[SE_FECHA_HORA_CONF]
                                 ,F.[R_FECHA_HORA_DESP]
                                 ,F.[D_FECHA_HORA_SZU_APER]
                                 ,F.[D_FECHA_HORA_SZU_CIERRE]
                                 ,F.[G_FECHA_HORA_ENVIO]
                                 ,F.[C_FECHA_HORA_IMPR_GUIA]
                                 ,F.[SE_FECHA_HORA_ULT]
                                 ,F.[P_TIEMPO_HRS_RED]
                                 ,F.[G_TIEMPO_HRS_EJECDO]
                                 ,F.[G_TIEMPO_HRS_DIGDO]
                                 ,F.[PE_TIEMPO_HRS_CMI]
                                 ,F.[R_TIEMPO_HRS_PE]
                                 ,F.[SE_TIEMPO_HRS_RD]
                                 ,F.[SE_TIEMPO_HRS_CONF]
                                 ,F.[SE_TIEMPO_HRS_DESP]
                                 ,F.[P_HORA_LIMT_ENTREGA]
                                 ,F.[P_HORA_LIMT_DIGDO]
                                 ,F.[P_HORA_LIMT_CMI]
                                 ,F.[P_HORA_LIMT_PE]
                                 ,F.[P_HORA_LIMT_RD]
                                 ,F.[P_HORA_LIMT_CONF]
                                 ,F.[P_HORA_LIMT_DESP]
                                 ,F.ID_PERIODO_LIQUIDADOR AS P_ID_PERIODO_LIQU
                                 ,F.[FECHA_EXTRACCION_DM]
								 ,F.GR_TIPO_COBRO			-- NUEVO CAMPO
								 ,F.EF_VALOR				-- NUEVO CAMPO
								 ,CASE WHEN F.GR_ESTADO_LEGALIZADO	='SI' THEN 'LEGALIZADO' ELSE ' NO LEGALIZADO' END GR_ESTADO_LEGALIZADO-- NUEVO CAMPO
								 ,CASE WHEN F.GRIR_VALOR_X_RECAUDAR = 0 THEN F.GRIR_VALOR_RECAUDADO ELSE F.GRIR_VALOR_X_RECAUDAR END AS GRIR_VALOR_X_RECAUDAR	-- NUEVO CAMPO
								 

								 -------------------->velidar ya que solo se calcula el valor  de recaudo
								 ,F.GRIR_VALOR_RECAUDADO	-- NUEVO CAMPO
								 -------------------------------------------------------------------------------------
								 
								 
								 ,F.GRIR_VALOR_SALDO		-- NUEVO CAMPO
								 ,CASE WHEN F.GR_ESTADO_RECAUDO	='SI' THEN 'RECAUDADO' ELSE 'NO RECAUDADO' END GR_ESTADO_RECAUDO		-- NUEVO CAMPO
                                 ,'GUIAS' TIPO_VALOR
                                 ,1 VALOR
                                 ,CASE WHEN F.P_ID_ESTADO_PENA =  1 THEN 'PENALIZADO' 
                                                               WHEN F.P_ID_ESTADO_DESP = 1 THEN 'DESPENALIZADO' 
                                  ELSE 'NO DISPONIBLE' END MC_IND_PENDESP
                                 ,CASE WHEN F.P_ID_ESTADO_PENA = 1 THEN F.P_VALOR_LIQUIDADO 
                                  ELSE F.P_VALOR_FINAL_LIQU END MC_IND_VALOR_PENDESP
                               ,CASE WHEN F.SE_CANTIDAD_RVO = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RVO,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RVO
                               ,CASE WHEN F.SE_ID_ESTADO_RTW = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RTW,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RTW
                               ,CASE WHEN F.SE_ID_ESTADO_RE = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RE,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RE_EV
                               ,CASE WHEN F.SE_ID_ESTADO_RD = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RD,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RD
                               ,CASE WHEN F.SE_ID_ESTADO_RE = 0 AND F.SE_ID_ESTADO_RTW = 1 THEN 1 ELSE 0 END SE_ID_EN_PROCES
                               ,F.P_ID_PRODUCTO
                               FROM 
                                               [FAC].[EMPRESARIOS] F  WITH (NOLOCK)
                               WHERE 
							    CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,SE_FECHA_HORA_SZU)))
								>=
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@SE_FECHA_INICIAL)))
								AND 
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,SE_FECHA_HORA_SZU)))
								<=
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@SE_FECHA_FINAL)))
								 

                UNION ALL
                SELECT           F.[G_NUMERO_GUIA]
                                 ,F.[SE_ID_FECHA_SZU]
                                 ,F.[SE_ID_HORA_SZU]
                                 ,F.[D_ID_GEOGRAFIA_EMP]
                                 ,F.[SE_ID_PROCESO_SZU]
                                 ,F.[SE_ID_PROCESO_RD]
                                 ,F.[SE_ID_PROCESO_ULT]
                                 ,F.[SE_ID_PROCESO_CONF]
                                 ,F.[SE_ID_FECHA_EZU]
                                 ,F.[SE_ID_HORA_EZU]
                                 ,F.[SE_ID_FECHA_RTW]
                                 ,F.[SE_ID_HORA_RTW]
                                 ,F.[SE_ID_FECHA_RVO]
                                 ,F.[SE_ID_FECHA_RE]
                                 ,F.[SE_ID_FECHA_RD]
                                 ,F.[SE_ID_HORA_RD]
                                 ,F.[SE_ID_FECHA_SR]
                                 ,F.[SE_ID_HORA_SR]
                                 ,F.[SE_ID_FECHA_ER]
                                 ,F.[SE_ID_HORA_ER]
                                 ,F.[PE_ID_FECHA_DIGDO]
                                 ,F.[PE_ID_FECHA_CMI]
                                 ,F.[R_ID_FECHA_PE]
                                 ,F.[SE_ID_FECHA_CONF]
                                 ,F.[R_ID_FECHA_DESP]
                                 ,F.[D_ID_FECHA_SZU_APER]
                                 ,F.[D_ID_HORA_SZU_APER]
                                 ,F.[D_ID_FECHA_SZU_CIERRE]
                                 ,F.[D_ID_HORA_SZU_CIERRE]
                                 ,F.[G_ID_FECHA_ENVIO]
                                 ,F.[C_ID_FECHA_IMPR_GUIA]
                                 ,F.[SE_ID_FECHA_ULT]
                                 ,F.[G_ID_PRODUCTO]
                                 ,F.[GIA_ID_TIPO_LOGISTICA]
                                 ,F.[SE_ID_VEJEZ_EMP]
                                 ,F.[P_ID_ESQ_LIQU_EMP]
                                 ,F.[SE_ID_ESTADO_RTW]
                                 ,F.[SE_ID_ESTADO_RTW_HOY]
                                 ,F.[SE_ID_ESTADO_RVO]
                                 ,F.[SE_ID_ESTADO_RE]
                                 ,F.[SE_ID_ESTADO_RD]
                                 ,F.[SE_ID_ESTADO_SR]
                                 ,F.[SE_ID_ESTADO_ER]
                                 ,F.GR_ID_ESTADO_PDTE_RECDO
                                 ,F.[SE_ID_ESTADO_RE_HOY]
                                 ,F.[SE_ID_ESTADO_PDTE_GEST]
                                 ,F.[SE_ID_ESTADO_PDTE_CICLO]
                                 ,F.[P_ID_ESTADO_DIGDO]
                                 ,F.[P_ID_ESTADO_CMI]
                                 ,F.[P_ID_ESTADO_PE]
                                 ,F.[SE_ID_ESTADO_CONF]
                                 ,F.[R_ID_ESTADO_DESP]
                                 ,F.[SE_ID_ESTADO_DEVREMT]
                                 ,F.[P_ID_ESTADO_LIMT_ENTRE]
                                 ,F.[P_ID_ESTADO_LIMT_DIGDO]
                                 ,F.[P_ID_ESTADO_LIMT_CMI]
                                 ,F.[P_ID_ESTADO_LIMT_PE]
                                 ,F.[P_ID_ESTADO_LIMT_RD]
                                 ,F.[P_ID_ESTADO_LIMT_CONF]
                                 ,F.[P_ID_ESTADO_LIMT_DESP]
                                 ,F.[D_ID_ESTADO_SZU_CIERRE]
                                 ,F.[P_ID_ESTADO_LIQDO]
                                 ,F.[P_ID_ESTADO_DESP]
                                 ,F.[P_ID_ESTADO_PENA]
                                 ,F.[P_ID_ESTADO_PAGA]
                                 ,CONCAT (F.[P_ID_ESTADO_LIQDO],'-',F.[P_ID_ESTADO_DESP],'-',F.[P_ID_ESTADO_PENA],'-',F.[P_ID_ESTADO_PAGA]) AS P_ID_ESTADO_LIQDO_DESP_PENA_PAGA
                                 ,F.[P_ID_ESTADO_NOVEDAD]
                                 ,F.[G_ID_ESTADO_RECA_COBRAR]
                                 ,F.[G_ID_ESTADO_RECA_COBRADO]
                                 ,F.[G_ID_BODEGA]
                                 ,F.[G_ID_MEDTRANS]
                                 ,F.[G_ID_TIEMPO_ENTREGA]
                                 ,F.[G_ID_CIUDAD_ORIGEN]
                                 ,F.[G_ID_CIUDAD_DESTINO]
                                 --,dbo.UFN_SEPARATES_COLUMNS(F.[D_ID_GEOGRAFIA_EMP], 2, '-') AS [G_ID_CIUDAD_DESTINO]
                                 ,F.[G_ID_CIUDAD_ULT]
                                 ,F.[SE_ID_SOLUCION_CONF]
                                 ,F.[G_ID_TIPOTRAYECTO]
                                 ,F.[SE_ID_ZONAURBAN]
                                 ,F.[G_ID_CLIENTE]
                                 ,F.[G_ID_ESTADOENVIO]
                                 ,F.[G_CANTIDAD_PIEZAS]
                                 ,F.[SE_CANTIDAD_SZU]
                                 ,F.[SE_CANTIDAD_RVO]
                                 ,F.[GIA_VALOR_RECAUDAR]
                                 ,F.[GR_VALOR_PDTE_RECDO]
                                 ,F.[P_VALOR_UNIT_TECN]
                                 ,F.[P_VALOR_COSTO_ADIC]
                                 ,F.[P_VALOR_LIQUIDADO]
                                 ,F.[P_VALOR_FINAL_LIQU]
                                 ,F.[D_NUMERO_MANIFIESTO]
                                 ,F.[G_ID_REMITE]
                                 ,F.[G_NOMBRE_REMITE_GUIA]
                                 ,F.[G_APELLIDO_REMITE_GUIA]
                                 ,RTRIM (F.[G_ID_REMITE]) + ' - ' + F.[G_NOMBRE_REMITE_GUIA] + ' - ' + [G_APELLIDO_REMITE_GUIA] AS G_ID_NOMBRE_APELLIDO
                                 ,F.[G_DIRECCION_REMITE_GUIA]
                                 ,F.[G_TELEFONO_REMITE_GUIA]
                                 ,F.[G_ID_DESTINA]
                                 ,F.[G_NOMBRE_DESTINA_GUIA]
                                 ,F.[G_APELLIDO_DESTINA_GUIA]
                                 ,RTRIM(F.[G_ID_DESTINA]) + ' - ' + F.[G_NOMBRE_DESTINA_GUIA] + ' - ' + F.[G_APELLIDO_DESTINA_GUIA] AS G_ID_NOMBRE_APELLIDO_DESTINA
                                 ,F.[G_DIRECCION_DESTINA_GUIA]
                                 ,F.[G_TELEFONO_DESTINA_GUIA]
                                 ,F.[P_COSTO_ADIC_OBSE]
                                 ,F.[SE_FECHA_HORA_SZU]
                                 ,F.[SE_FECHA_HORA_EZU]
                                 ,F.[SE_FECHA_HORA_RTW]
                                 ,F.[SE_FECHA_HORA_RVO]
                                 ,F.[SE_FECHA_HORA_RE]
                                 ,F.[SE_FECHA_HORA_RD]
                                 ,F.[SE_FECHA_HORA_SR]
                                 ,F.[SE_FECHA_HORA_ER]
                                 ,F.[SE_FECHA_HORA_EJECDO]
                                 ,F.[PE_FECHA_HORA_DIGDO]
                                 ,F.[PE_FECHA_HORA_CMI]
                                 ,F.[R_FECHA_HORA_PE]
                                 ,F.[SE_FECHA_HORA_CONF]
                                 ,F.[R_FECHA_HORA_DESP]
                                 ,F.[D_FECHA_HORA_SZU_APER]
                                 ,F.[D_FECHA_HORA_SZU_CIERRE]
                                 ,F.[G_FECHA_HORA_ENVIO]
                                 ,F.[C_FECHA_HORA_IMPR_GUIA]
                                 ,F.[SE_FECHA_HORA_ULT]
                                 ,F.[P_TIEMPO_HRS_RED]
                                 ,F.[G_TIEMPO_HRS_EJECDO]
                                 ,F.[G_TIEMPO_HRS_DIGDO]
                                 ,F.[PE_TIEMPO_HRS_CMI]
                                 ,F.[R_TIEMPO_HRS_PE]
                                 ,F.[SE_TIEMPO_HRS_RD]
                                 ,F.[SE_TIEMPO_HRS_CONF]
                                 ,F.[SE_TIEMPO_HRS_DESP]
                                 ,F.[P_HORA_LIMT_ENTREGA]
                                 ,F.[P_HORA_LIMT_DIGDO]
                                 ,F.[P_HORA_LIMT_CMI]
                                 ,F.[P_HORA_LIMT_PE]
                                 ,F.[P_HORA_LIMT_RD]
                                 ,F.[P_HORA_LIMT_CONF]
                                 ,F.[P_HORA_LIMT_DESP]
                                 ,F.ID_PERIODO_LIQUIDADOR AS P_ID_PERIODO_LIQU
                                 ,F.[FECHA_EXTRACCION_DM]
								 ,F.GR_TIPO_COBRO			-- NUEVO CAMPO
								 ,F.EF_VALOR				-- NUEVO CAMPO
								 ,CASE WHEN F.GR_ESTADO_LEGALIZADO	='SI' THEN 'LEGALIZADO' ELSE ' NO LEGALIZADO' END GR_ESTADO_LEGALIZADO-- NUEVO CAMPO
								 ,CASE WHEN F.GRIR_VALOR_X_RECAUDAR = 0 THEN F.GRIR_VALOR_RECAUDADO ELSE F.GRIR_VALOR_X_RECAUDAR END AS GRIR_VALOR_X_RECAUDAR	-- NUEVO CAMPO
								 ,F.GRIR_VALOR_RECAUDADO	-- NUEVO CAMPO
								 ,F.GRIR_VALOR_SALDO		-- NUEVO CAMPO
								 ,CASE WHEN F.GR_ESTADO_RECAUDO	='SI' THEN 'RECAUDADO' ELSE 'NO RECAUDADO' END GR_ESTADO_RECAUDO		-- NUEVO CAMPO
                                 ,'PIEZAS' TIPO_VALOR
                                 ,F.[G_CANTIDAD_PIEZAS]  VALOR
                                 ,CASE WHEN F.P_ID_ESTADO_PENA =  1 THEN 'PENALIZADO' 
                                                               WHEN F.P_ID_ESTADO_DESP = 1 THEN 'DESPENALIZADO' 
                                  ELSE 'NO DISPONIBLE' END MC_IND_PENDESP
                                 ,CASE WHEN F.P_ID_ESTADO_PENA = 1 THEN F.P_VALOR_LIQUIDADO 
                                  ELSE F.P_VALOR_FINAL_LIQU END MC_IND_VALOR_PENDESP
                               ,CASE WHEN F.SE_CANTIDAD_RVO = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RVO,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RVO
                               ,CASE WHEN F.SE_ID_ESTADO_RTW = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RTW,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RTW
                               ,CASE WHEN F.SE_ID_ESTADO_RE = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RE,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RE_EV
                               ,CASE WHEN F.SE_ID_ESTADO_RD = 1 THEN CONVERT(VARCHAR,F.SE_FECHA_HORA_RD,121) ELSE 'NO DISPONIBLE' END FECHA_HORA_RD
                               ,CASE WHEN F.SE_ID_ESTADO_RE = 0 AND F.SE_ID_ESTADO_RTW = 1 THEN 1 ELSE 0 END SE_ID_EN_PROCES
                               ,F.P_ID_PRODUCTO
                  FROM [FAC].[EMPRESARIOS] F  WITH (NOLOCK)

                  WHERE 
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,SE_FECHA_HORA_SZU)))
								>=
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@SE_FECHA_INICIAL)))
								AND 
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,SE_FECHA_HORA_SZU)))
								<=
								CONVERT(INT,CONVERT(DATETIME,CONVERT(DATE,@SE_FECHA_FINAL)))



				  --SE_FECHA_HORA_SZU >='2019-02-04 00:00:00.000' AND SE_FECHA_HORA_SZU<'2019-02-08 18:38:37.567' AND GR_TIPO_COBRO<>'-888'--FILTRO PARA PRUEBAS DEL DESARROLLO ACTUAL
				
				
				  --(SE_FECHA_HORA_SZU >= (SELECT 
      --                                                                                                                                                       [FECHA_INICIAL_PERIODO]      
      --                                                                                                                          FROM [DIM].[PERIODOS_LIQUIDADOR_EMP]
      --                                                                                                                          WHERE PERIODO = LEFT(CONVERT(VARCHAR,DATEADD(MONTH,-3,GETDATE()),112),6)) OR ID_PERIODO_LIQUIDADOR >= (SELECT MIN(ID_PERIODO_LIQUIDADOR) FROM [DIM].[PERIODOS_LIQUIDADOR_EMP]
      --                                                                                                                          WHERE PERIODO = LEFT(CONVERT(VARCHAR,DATEADD(MONTH,-3,GETDATE()),112),6)))
               )T
LEFT JOIN
                (
                               SELECT
                                               [DATE] FECHA,
                                               [TIME_ID],
                                               [YEAR],  
                                               [MONTH_OF_YEAR] ID_MES,
                                               CASE WHEN [MONTH_OF_YEAR] = 1 THEN 'Enero'
                                                               WHEN [MONTH_OF_YEAR] = 2 THEN 'Febrero'
                                                               WHEN [MONTH_OF_YEAR] = 3 THEN 'Marzo'
                                                               WHEN [MONTH_OF_YEAR] = 4 THEN 'Abril'
                                                               WHEN [MONTH_OF_YEAR] = 5 THEN 'Mayo'
                                                               WHEN [MONTH_OF_YEAR] = 6 THEN 'Junio'
                                                               WHEN [MONTH_OF_YEAR] = 7 THEN 'Julio'
                                                               WHEN [MONTH_OF_YEAR] = 8 THEN 'Agosto'
                                                               WHEN [MONTH_OF_YEAR] = 9 THEN 'Septiembre'
                                                               WHEN [MONTH_OF_YEAR] = 10 THEN 'Octubre'
                                                               WHEN [MONTH_OF_YEAR] = 11 THEN 'Noviembre'
                                                               WHEN [MONTH_OF_YEAR] = 12 THEN 'Diciembre' 
                                                END MES,
                                               [TMP].[DAY_OF_MONTH] DIA
                               FROM 
                                               DIM.TIEMPO TMP WITH (NOLOCK)
                )S
ON  
                T.SE_ID_FECHA_SZU = S.TIME_ID
--WHERE T.[G_ID_CIUDAD_DESTINO]=407



*/