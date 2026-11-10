

-- Parámetros: fecha de inicio y fecha fin (hoy)
DECLARE @FECHA     DATETIME = '2026-01-01'
DECLARE @FECHA_FIN DATETIME = CAST(GETDATE() AS DATE)
DECLARE @FECHA_NX  DATETIME


-- Dimensión de producto (se carga una sola vez fuera del bucle)
DROP TABLE IF EXISTS #DIM_PRODUCTO
SELECT
     ID_PRODUCTO
    ,PRODUCTO
INTO #DIM_PRODUCTO
FROM [DIM].[PRODUCTO] PR WITH (NOLOCK)
GROUP BY
     ID_PRODUCTO
    ,PRODUCTO


DROP TABLE IF EXISTS #GUIAS_SOLICITADAS_YADIRA

CREATE TABLE #GUIAS_SOLICITADAS_YADIRA(
	[G01_NUMERO_GUIA]                                   [numeric](20, 0) NULL,
	[G02_ID_CLIENTE]                                    [varchar](20)    NULL,
	[G03_ID_TIPO_CLIENTE]                               [int]            NULL,
	[G04_TIPO_CLIENTE]                                  [varchar](13)    NULL,
	[G05_ID_TIEMPO]                                     [tinyint]        NULL,
	[G06_ID_MEDTRANS]                                   [tinyint]        NULL,
	[G07_ID_REMITE]                                     [varchar](20)    NULL,
	[G08_NOMBRE_REMITE_GUIA]                            [varchar](101)   NULL,
	[G09_ID_DESTINATARIO]                               [varchar](20)    NULL,
	[G10_NOMBRE_DESTINANTARIO_GUIA]                     [varchar](101)   NULL,
	[G11_ID_ESTADOGUIA]                                 [tinyint]        NULL,
	[G12_NOMBRE_ESTADOGUIA]                             [varchar](40)    NULL,
	[G13_ID_ESTADOENVIO]                                [tinyint]        NULL,
	[G14_NOMBRE_ESTADOENVIO]                            [varchar](40)    NULL,
	[G15_ID_PRODUCTO]                                   [smallint]       NULL,
	[G16_PRODUCTO]                                      [varchar](40)    NULL,
	[G17_CIUDAD_DESTINO]                                [varchar](40)    NULL,
	[G18_ID_CIUDAD_DESTINO]                             [int]            NULL,
	[G19_ID_REGIONAL_DESTINO]                           [tinyint]        NULL,
	[G20_REGIONAL_DESTINO]                              [varchar](40)    NULL,
	[G21_ID_DEPARTAMENTO_DESTINO]                       [tinyint]        NULL,
	[G22_DEPARTAMENTO_DESTINO]                          [varchar](40)    NULL,
	[G23_ID_PAIS_DESTINO]                               [smallint]       NULL,
	[G24_ID_CIUDAD_ORIGEN]                              [int]            NULL,
	[G25_CIUDAD_ORIGEN]                                 [varchar](40)    NULL,
	[G26_ID_REGIONAL_ORIGEN]                            [tinyint]        NULL,
	[G27_REGIONAL_ORIGEN]                               [varchar](40)    NULL,
	[G28_ID_DEPARTAMENTO_ORIGEN]                        [tinyint]        NULL,
	[G29_DEPARTAMENTO_ORIGEN]                           [varchar](40)    NULL,
	[G30_FECHA_CREACION]                                [datetime]       NULL,
	[G31_FECHA_ENVIO]                                   [datetime]       NULL,
	[EZU01_FECHA_HORA_MOVIMIENTO_EZ_EP]                 [datetime]       NULL,
	[EZU02_DOC_NOMBRE_CIUDAD_DESTINO]                   [varchar](40)    NULL,
	[EZU03_DOC_ID_CIUDAD_DESTINO]                       [int]            NULL,
	[EZU04_DOC_ID_REGIONAL_DESTINO]                     [tinyint]        NULL,
	[EZU05_DOC_NOMBRE_REGIONAL_DESTINO]                 [varchar](40)    NULL,
	[PE01_FECHA_DIGITALIZACION]                         [datetime]       NULL,
	[PE02_ESTADO_DIGLIAIZADA]                           [varchar](15)    NULL,
	[PE03_IMAGEN_GUIA]                                  [varchar](500)   NULL,
	[PE04_ID_TIPO_ENTREGA]                              [tinyint]        NULL,
	[PE05_CIUDAD_REPORTADA_PRUEBAS_ENTREGA]             [int]            NULL,
	[PE06_TIPO_ENTREGA]                                 [varchar](13)    NULL,
	[PE07_CAJA]                                         [bigint]         NULL,
	[PE08_PAQUETE]                                      [smallint]       NULL,
	[PE09_ID_ESTADO_AUDITADO]                           [int]            NULL,
	[PE11_ESTADO_PAQUETE_AUDITADO]                      [varchar](20)    NULL,
	[PE12_FECHA_DIGITALIZACION_VS_FECHA_CREACION]       [int]            NULL,
	[PE13_FECHA_HORA_MOVIMIENTO_VS_FECHA_CREACION]      [int]            NULL,
	[PE14_FECHA_HORA_MOVIMIENTO_VS_FECHA_DIGITALIZACION][int]            NULL,
	[CROSS01_NUMERO_MOVIMI]                             [varchar](30)    NULL,
	[CROSS02_CONSECUT_MOVIMI]                           [numeric](7, 0)  NULL,
	[CROSS03_ID_PROCESO]                                [smallint]       NULL,
	[CROSS04_NOMBRE_PROCESO_LOG]                        [varchar](40)    NOT NULL,
	[CROSS05_FECHA_HORA_MOVIMIENTO]                     [datetime]       NULL,
	[CROSS06_DOC_NOMBRE_CIUDAD_ORIGEN]                  [varchar](40)    NULL,
	[CROSS07__DOC_ID_CENTRO_LOGISTICO_ORIGEN]           [int]            NULL,
	[CROSS08_DOC_NOMBRE_CIUDAD_DESTINO]                 [varchar](40)    NULL,
	[CROSS09_DOC_ID_CIUDAD_DESTINO]                     [int]            NULL,
	[CROSS10_DOC_ID_ZONA_URBA]                          [smallint]       NULL,
	[CROSS11_DOC_ID_CIUDAD_ZONA_URBA]                   [int]            NULL,
	[CROSS12_DOC_ID_TIPO_ZONA_URBA]                     [tinyint]        NULL,
	[CROSS13_DOC_NOMBRE_ZONA_URBANA]                    [varchar](8000)  NULL,
	[ULT01_UBIC_ID_PROCESO]                             [smallint]       NULL,
	[ULT02_UBIC_NOMBRE_PROCESO_LOG]                     [varchar](40)    NULL,
	[ULT03_UBIC_FECHA_HORA_MOVIMI]                      [datetime]       NULL,
	[ULT04_UBIC_ID_BODEGA_UBICACION]                    [int]            NULL,
	[ULT05_UBIC_BODEGA_UBICACION]                       [varchar](40)    NULL,
	[ULT06_UBIC_ID_CIUDAD_UBICACION]                    [int]            NULL,
	[ULT07_UBIC_CIUDAD_UBICACION]                       [varchar](40)    NULL,
	[ULT08_UBIC_CPL]                                    [varchar](50)    NULL,
	[ULT09_UBIC_ID_REGIONAL_UBICACION]                  [tinyint]        NULL,
	[ULT10_UBIC_NOMBRE_REGIONAL_UBICACION]              [varchar](40)    NULL,
	[ULT11_UBIC_SEG_NUMERO_PIEZAS]                      [smallint]       NULL,
	[ULT12_UBIC_ID_ZONA_URBA]                           [smallint]       NULL,
	[ULT13_UBIC_ID_CIUDAD_ZONA_URBA]                    [int]            NULL,
	[ULT14_UBIC_ID_TIPO_ZONA_URBA]                      [tinyint]        NULL,
	[ULT15_UBIC_NOMBRE_ZONA_URBA]                       [varchar](8000)  NULL,
	[CRTL01_FECHA_EXTRACCION_DW]                        [datetime]       NULL,
	[FECHA_INICIAL]                                     [varchar](10)    NOT NULL,
	[FECHA_FINAL]                                       [varchar](10)    NOT NULL
)


-- Bucle día a día desde @FECHA hasta hoy
WHILE @FECHA <= @FECHA_FIN
BEGIN
    SET @FECHA_NX = DATEADD(DAY, 1, @FECHA)

    PRINT 'Procesando: ' + CONVERT(VARCHAR(10), @FECHA, 23)

    ;WITH CTE_BASE AS (
        SELECT
               *,
               ROW_NUMBER() OVER (PARTITION BY NUMERO_GUIA ORDER BY FECHA_EXTRACCION_DW DESC) AS _RN
        FROM [SIG_CCM_DM].[FAC].[DIGGUICCM_DIGITALIZACION_FINAL_ULTIMO_PROCESO_LOG] WITH (NOLOCK)
        WHERE UBIC_FECHA_HORA_MOVIMI >= @FECHA AND UBIC_FECHA_HORA_MOVIMI < @FECHA_NX
    )
    INSERT INTO #GUIAS_SOLICITADAS_YADIRA
    SELECT
         ULT.[NUMERO_GUIA]                                              AS [G01_NUMERO_GUIA]
        ,ULT.[G_ID_CLIENTE]                                             AS [G02_ID_CLIENTE]
        ,ULT.[ID_TIPO_CLIENTE]                                          AS [G03_ID_TIPO_CLIENTE]
        ,ULT.[TIPO_CLIENTE]                                             AS [G04_TIPO_CLIENTE]
        ,ULT.[G_ID_TIEMPO]                                              AS [G05_ID_TIEMPO]
        ,ULT.[G_ID_MEDTRANS]                                            AS [G06_ID_MEDTRANS]
        ,ULT.[G_ID_REMITE]                                              AS [G07_ID_REMITE]
        ,ULT.[G_NOMBRE_REMITE_GUIA]                                     AS [G08_NOMBRE_REMITE_GUIA]
        ,ULT.[G_ID_DESTINATARIO]                                        AS [G09_ID_DESTINATARIO]
        ,ULT.[G_NOMBRE_DESTINANTARIO_GUIA]                              AS [G10_NOMBRE_DESTINANTARIO_GUIA]
        ,ULT.[ID_ESTADOGUIA]                                            AS [G11_ID_ESTADOGUIA]
        ,SG.NOMBRE_ESTADOGUIA                                           AS [G12_NOMBRE_ESTADOGUIA]
        ,ULT.[ID_ESTADOENVIO]                                           AS [G13_ID_ESTADOENVIO]
        ,SE.NOMBRE_ESTADOENVIO                                          AS [G14_NOMBRE_ESTADOENVIO]
        ,ULT.[G_ID_PRODUCTO]                                            AS [G15_ID_PRODUCTO]
        ,PR.PRODUCTO                                                    AS [G16_PRODUCTO]
        ,RD.CIUDAD                                                      AS [G17_CIUDAD_DESTINO]
        ,ULT.[G_ID_CIUDAD_DESTINO]                                      AS [G18_ID_CIUDAD_DESTINO]
        ,RD.ID_REGIONAL                                                 AS [G19_ID_REGIONAL_DESTINO]
        ,RD.REGIONAL                                                    AS [G20_REGIONAL_DESTINO]
        ,RD.ID_DEPARTAMENTO                                             AS [G21_ID_DEPARTAMENTO_DESTINO]
        ,RD.DEPARTAMENTO                                                AS [G22_DEPARTAMENTO_DESTINO]
        ,ULT.[G_ID_PAIS_DESTINO]                                        AS [G23_ID_PAIS_DESTINO]
        ,ULT.[G_ID_CIUDAD_ORIGEN]                                       AS [G24_ID_CIUDAD_ORIGEN]
        ,RO.CIUDAD                                                      AS [G25_CIUDAD_ORIGEN]
        ,RO.ID_REGIONAL                                                 AS [G26_ID_REGIONAL_ORIGEN]
        ,RO.REGIONAL                                                    AS [G27_REGIONAL_ORIGEN]
        ,RO.ID_DEPARTAMENTO                                             AS [G28_ID_DEPARTAMENTO_ORIGEN]
        ,RO.DEPARTAMENTO                                                AS [G29_DEPARTAMENTO_ORIGEN]
        ,ULT.[FECHA_CREACION]                                           AS [G30_FECHA_CREACION]
        ,ULT.[G_FECHA_ENVIO]                                            AS [G31_FECHA_ENVIO]
        ,ULT.FECHA_HORA_MOVIMIENTO_EZ_EP                                AS [EZU01_FECHA_HORA_MOVIMIENTO_EZ_EP]
        ,RD_EZU.CIUDAD                                                  AS [EZU02_DOC_NOMBRE_CIUDAD_DESTINO]
        ,ULT.EZU_EPS_DOC_ID_CIUDAD_DESTINO                             AS [EZU03_DOC_ID_CIUDAD_DESTINO]
        ,RD_EZU.ID_REGIONAL                                             AS [EZU04_DOC_ID_REGIONAL_DESTINO]
        ,RD_EZU.REGIONAL                                                AS [EZU05_DOC_NOMBRE_REGIONAL_DESTINO]
        ,ULT.[FECHA_DIGITALIZACION]                                     AS [PE01_FECHA_DIGITALIZACION]
        ,ULT.[ESTADO_DIGLIAIZADA]                                       AS [PE02_ESTADO_DIGLIAIZADA]
        ,ULT.[IMAGEN_GUIA]                                              AS [PE03_IMAGEN_GUIA]
        ,ULT.[ID_TIPO_ENTREGA]                                          AS [PE04_ID_TIPO_ENTREGA]
        ,ULT.[CIUDAD_REPORTADA_PRUEBAS_ENTREGA]                         AS [PE05_CIUDAD_REPORTADA_PRUEBAS_ENTREGA]
        ,ULT.[TIPO_ENTREGA]                                             AS [PE06_TIPO_ENTREGA]
        ,ULT.[CAJA]                                                     AS [PE07_CAJA]
        ,ULT.[PAQUETE]                                                  AS [PE08_PAQUETE]
        ,ULT.[ID_ESTADO_AUDITADO]                                       AS [PE09_ID_ESTADO_AUDITADO]
        ,ULT.[ESTADO_PAQUETE_AUDITADO]                                  AS [PE11_ESTADO_PAQUETE_AUDITADO]
        ,ULT.[FECHA_DIGITALIZACION_VS_FECHA_CREACION]                   AS [PE12_FECHA_DIGITALIZACION_VS_FECHA_CREACION]
        ,ULT.[FECHA_HORA_MOVIMIENTO_VS_FECHA_CREACION]                  AS [PE13_FECHA_HORA_MOVIMIENTO_VS_FECHA_CREACION]
        ,ULT.[FECHA_HORA_MOVIMIENTO_VS_FECHA_DIGITALIZACION]            AS [PE14_FECHA_HORA_MOVIMIENTO_VS_FECHA_DIGITALIZACION]
        ,ULT.[NUMERO_MOVIMI]                                            AS [CROSS01_NUMERO_MOVIMI]
        ,ULT.[CONSECUT_MOVIMI]                                          AS [CROSS02_CONSECUT_MOVIMI]
        ,ULT.[ID_PROCESO]                                               AS [CROSS03_ID_PROCESO]
        ,ULT.[NOMBRE_PROCESO_LOG]                                       AS [CROSS04_NOMBRE_PROCESO_LOG]
        ,ULT.[FECHA_HORA_MOVIMIENTO]                                    AS [CROSS05_FECHA_HORA_MOVIMIENTO]
        ,CLO.CIUDAD                                                     AS [CROSS06_DOC_NOMBRE_CIUDAD_ORIGEN]
        ,ULT.DO_ID_CIUDAD_DIVISION_ORIGEN                               AS [CROSS07__DOC_ID_CENTRO_LOGISTICO_ORIGEN]
        ,CPD.CIUDAD                                                     AS [CROSS08_DOC_NOMBRE_CIUDAD_DESTINO]
        ,ULT.[DO_ID_CIUDAD_DESTINO]                                     AS [CROSS09_DOC_ID_CIUDAD_DESTINO]
        ,ULT.[DO_ID_ZONA_URBA]                                          AS [CROSS10_DOC_ID_ZONA_URBA]
        ,ULT.[DO_ID_CIUDAD_ZONA_URBA]                                   AS [CROSS11_DOC_ID_CIUDAD_ZONA_URBA]
        ,ULT.[DO_ID_TIPO_ZONA_URBA]                                     AS [CROSS12_DOC_ID_TIPO_ZONA_URBA]
        ,REPLACE(REPLACE(ULT.[NOMBRE_ZONA_URBANA], ';', ''), ',', '')  AS [CROSS13_DOC_NOMBRE_ZONA_URBANA]
        ,ULT.[UBIC_ID_PROCESO]                                          AS [ULT01_UBIC_ID_PROCESO]
        ,ULT.[UBIC_NOMBRE_PROCESO_LOG]                                  AS [ULT02_UBIC_NOMBRE_PROCESO_LOG]
        ,ULT.[UBIC_FECHA_HORA_MOVIMI]                                   AS [ULT03_UBIC_FECHA_HORA_MOVIMI]
        ,ULT.[UBIC_ID_DIV_BODEGA_UBICACION]                             AS [ULT04_UBIC_ID_BODEGA_UBICACION]
        ,ULT.[UBIC_BODEGA_UBICACION]                                    AS [ULT05_UBIC_BODEGA_UBICACION]
        ,ULT.[UBIC_ID_CIUDAD_UBICACION]                                 AS [ULT06_UBIC_ID_CIUDAD_UBICACION]
        ,ULT.[UBIC_CIUDAD_UBICACION]                                    AS [ULT07_UBIC_CIUDAD_UBICACION]
        ,ULT.[CPL]                                                      AS [ULT08_UBIC_CPL]
        ,ULT.[UBIC_ID_REGIONAL_UBICACION]                               AS [ULT09_UBIC_ID_REGIONAL_UBICACION]
        ,ULT.[UBIC_NOMBRE_REGIONAL_UBICACION]                           AS [ULT10_UBIC_NOMBRE_REGIONAL_UBICACION]
        ,ULT.[ULT_SEG_NUMERO_PIEZAS]                                    AS [ULT11_UBIC_SEG_NUMERO_PIEZAS]
        ,ULT.[ULT_ID_ZONA_URBA]                                         AS [ULT12_UBIC_ID_ZONA_URBA]
        ,ULT.[ULT_ID_CIUDAD_ZONA_URBA]                                  AS [ULT13_UBIC_ID_CIUDAD_ZONA_URBA]
        ,ULT.[ULT_ID_TIPO_ZONA_URBA]                                    AS [ULT14_UBIC_ID_TIPO_ZONA_URBA]
        ,REPLACE(REPLACE(ULT_UBIC_Z.ZONA_URBANA, ';', ''), ',', '')    AS [ULT15_UBIC_NOMBRE_ZONA_URBA]
        ,ULT.[FECHA_EXTRACCION_DW]                                      AS [CRTL01_FECHA_EXTRACCION_DW]
        ,CONVERT(VARCHAR(10), @FECHA,    23)                            AS [FECHA_INICIAL]
        ,CONVERT(VARCHAR(10), @FECHA_NX, 23)                            AS [FECHA_FINAL]
    FROM CTE_BASE ULT
    -- Joins de geografía
    LEFT JOIN DIM.GEOGRAFIA      RO        WITH (NOLOCK) ON ULT.G_ID_CIUDAD_ORIGEN                                           = RO.ID_CIUDAD
    LEFT JOIN DIM.GEOGRAFIA      CLO       WITH (NOLOCK) ON ISNULL(ULT.DO_ID_CIUDAD_DIVISION_ORIGEN, ULT.DO_ID_CIUDAD_ZONA_URBA) = CLO.ID_CIUDAD
    LEFT JOIN DIM.GEOGRAFIA      RD        WITH (NOLOCK) ON ULT.G_ID_CIUDAD_DESTINO                                          = RD.ID_CIUDAD
    LEFT JOIN DIM.GEOGRAFIA      CPD       WITH (NOLOCK) ON ULT.DO_ID_CIUDAD_DESTINO                                         = CPD.ID_CIUDAD
    LEFT JOIN DIM.GEOGRAFIA      RD_EZU    WITH (NOLOCK) ON ULT.EZU_EPS_DOC_ID_CIUDAD_DESTINO                                = RD_EZU.ID_CIUDAD
    LEFT JOIN DIM.GEOGRAFIA      RD_UBIC   WITH (NOLOCK) ON ULT.UBIC_ID_CIUDAD_UBICACION                                     = RD_UBIC.ID_CIUDAD

    -- Joins de zonas urbanas
    LEFT JOIN DIM.ZONAS_URBANAS  ULT_UBIC_Z WITH (NOLOCK)
        ON  ULT.[ULT_ID_TIPO_ZONA_URBA]  = ULT_UBIC_Z.ID_TIPO_ZONA_URBA
        AND ULT.[ULT_ID_ZONA_URBA]       = ULT_UBIC_Z.ID_ZONA_URBA
        AND ULT.[ULT_ID_CIUDAD_ZONA_URBA]= ULT_UBIC_Z.ID_CIUDAD
    LEFT JOIN DIM.ZONAS_URBANAS  Z         WITH (NOLOCK)
        ON  ULT.DO_ID_TIPO_ZONA_URBA     = Z.ID_TIPO_ZONA_URBA
        AND ULT.DO_ID_ZONA_URBA          = Z.ID_ZONA_URBA
        AND ULT.DO_ID_CIUDAD_ZONA_URBA   = Z.ID_CIUDAD

    -- Joins de dimensiones
    LEFT JOIN [DIM].[ESTADOS_ENVIO]  SE   WITH (NOLOCK) ON ULT.ID_ESTADOENVIO = SE.ID_ESTADOENVIO
    LEFT JOIN [DIM].[ESTADOS_GUIA]   SG   WITH (NOLOCK) ON ULT.ID_ESTADOGUIA  = SG.ID_ESTADOGUIA
    LEFT JOIN #DIM_PRODUCTO          PR   WITH (NOLOCK) ON ULT.G_ID_PRODUCTO   = PR.ID_PRODUCTO
    WHERE LEN(ULT.[NUMERO_GUIA])>7 AND ID_PROCESO IN(24,11,9) AND ([ESTADO_DIGLIAIZADA] IS NULL OR [ESTADO_DIGLIAIZADA] = 'NO DIGITALIZADA')

    SET @FECHA = DATEADD(DAY, 1, @FECHA)
END


-- Resultado final acumulado
SELECT * FROM #GUIAS_SOLICITADAS_YADIRA
