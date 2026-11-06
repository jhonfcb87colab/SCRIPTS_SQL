USE [SIG_CCM_DM]
GO
/**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [FAC].[REPORTE_DIGITALIZACION_GUIAS_V05]
     @TIPO_CONSULTA       INT
    ,@ID_TIPO_ENTREGA      NVARCHAR(MAX)
    ,@REGIONAL_ORIGEN      NVARCHAR(MAX)
    ,@REGIONAL_DESTINO     NVARCHAR(MAX)
    ,@PROCESO              NVARCHAR(MAX)
    ,@ESTADO_GUIA          NVARCHAR(MAX)
    ,@ESTADO_DIGITALIZADA  NVARCHAR(MAX)
    ,@TIPO_CLIENTE         NVARCHAR(MAX)
    ,@CIUDAD_ORIGEN        NVARCHAR(MAX)
    ,@CIUDAD_DESTINO       NVARCHAR(MAX)
    ,@REP_FECHA_INICIAL    DATETIME
    ,@REP_FECHA_FINAL      DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    SET FMTONLY OFF;
 



    -- ==========================================
    -- 0. PARAMETROS DE PRUEBAS
    -- ==========================================


  /* 
 	DECLARE @TIPO_CONSULTA INT = 1
	DECLARE @ID_TIPO_ENTREGA NVARCHAR(MAX) = '0'---1,2,
	DECLARE @REGIONAL_ORIGEN NVARCHAR(MAX) = '1,0'
	DECLARE @REGIONAL_DESTINO NVARCHAR(MAX) = '1,0'
	DECLARE @PROCESO NVARCHAR(MAX) = '0'--24,11,
	DECLARE @ESTADO_GUIA NVARCHAR(MAX) = '1,2,3,4,5,6,7,8,9,10,11,0'
	DECLARE @ESTADO_DIGITALIZADA NVARCHAR(MAX) = '2'
	DECLARE @TIPO_CLIENTE NVARCHAR(MAX) = '1,2,0'
	DECLARE @CIUDAD_ORIGEN NVARCHAR(MAX) = '10'
	DECLARE @CIUDAD_DESTINO NVARCHAR(MAX) = '10'
	DECLARE @REP_FECHA_INICIAL DATETIME = '2026-05-01'
	DECLARE @REP_FECHA_FINAL DATETIME = '2026-06-02'

*/

    -- ==========================================
    -- 1. CÁLCULO DE FECHAS EFECTIVAS
    --    Una sola lógica, sin bloques IF que se pisan.
    --    Regla de negocio consolidada:
    --      · Tipo 1 + solo "NO DIGITALIZADA"  → máximo 180 días
    --      · Cualquier otro caso              → máximo 31 días
    -- ==========================================
    DECLARE @DIAS            INT  = DATEDIFF(DAY, @REP_FECHA_INICIAL, @REP_FECHA_FINAL);
    DECLARE @SOLO_NO_DIG     BIT  = 0;
    DECLARE @MAX_RANGO       INT  = 31;
    DECLARE @FECHA_INI_EFE   VARCHAR(8);
    DECLARE @FECHA_FIN_EFE   VARCHAR(8) = CONVERT(VARCHAR(8), @REP_FECHA_FINAL, 112);

    -- Detectar si el filtro de digitalización es EXCLUSIVAMENTE "NO DIGITALIZADA" (valor 2)
    -- STRING_SPLIT seguro: si el único valor entero pasado es 2 → @SOLO_NO_DIG = 1
    IF NOT EXISTS (
        SELECT 1 FROM STRING_SPLIT(@ESTADO_DIGITALIZADA, ',')
        WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) <> 2
          AND TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL
    )
    AND EXISTS (
        SELECT 1 FROM STRING_SPLIT(@ESTADO_DIGITALIZADA, ',')
        WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) = 2
    )
        SET @SOLO_NO_DIG = 1;

    IF @TIPO_CONSULTA = 1 AND @SOLO_NO_DIG = 1
        SET @MAX_RANGO = 180;

    IF @DIAS > @MAX_RANGO
        SET @FECHA_INI_EFE = CONVERT(VARCHAR(8), DATEADD(DAY, -@MAX_RANGO, @REP_FECHA_FINAL), 112);
    ELSE
        SET @FECHA_INI_EFE = CONVERT(VARCHAR(8), @REP_FECHA_INICIAL, 112);

    -- ==========================================
    -- 2. RESOLUCIÓN DE FILTROS COMO VARIABLES
    --    Se convierten los parámetros multi-valor a strings
    --    normalizados para usarlos en el WHERE sin tablas temp.
    --    Se usan directamente en CTEs dentro del query final.
    -- ==========================================

    -- Banderas de "traer todo" (cuando se pasa 0 = sin filtro)
    DECLARE @ALL_TIPO_ENTREGA    BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@ID_TIPO_ENTREGA,   ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_ESTADO_GUIA     BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@ESTADO_GUIA,       ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_REG_ORIGEN      BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@REGIONAL_ORIGEN,   ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_REG_DESTINO     BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@REGIONAL_DESTINO,  ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_PROCESO         BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@PROCESO,           ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_TIPO_CLIENTE    BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@TIPO_CLIENTE,      ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_CD_ORIGEN       BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@CIUDAD_ORIGEN,     ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;
    DECLARE @ALL_CD_DESTINO      BIT = CASE WHEN EXISTS(SELECT 1 FROM STRING_SPLIT(@CIUDAD_DESTINO,    ',') WHERE LTRIM(RTRIM(value))='0') THEN 1 ELSE 0 END;

    -- ==========================================
    -- 3. QUERY ÚNICO — SIN SQL DINÁMICO
    --    CTEs reemplazan todas las tablas temporales de filtro.
    --    Se desduplicA con ROW_NUMBER directamente en el CTE base.
    -- ==========================================
    ;WITH

    -- 3.1 Filtros de listas (reemplazan las tablas #ID_*)
    CTE_TIPO_ENTREGA    AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@ID_TIPO_ENTREGA,  ',')),
    CTE_ESTADO_GUIA     AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@ESTADO_GUIA,      ',')),
    CTE_REG_ORIGEN      AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@REGIONAL_ORIGEN,  ',')),
    CTE_REG_DESTINO     AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@REGIONAL_DESTINO, ',')),
    CTE_REG_ALL         AS (SELECT IDS FROM CTE_REG_ORIGEN UNION SELECT IDS FROM CTE_REG_DESTINO),
    CTE_PROCESO         AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@PROCESO,          ',')),
    CTE_TIPO_CLIENTE    AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) IDS FROM STRING_SPLIT(@TIPO_CLIENTE,     ',')),
    CTE_CD_ORIGEN       AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) CD  FROM STRING_SPLIT(@CIUDAD_ORIGEN,    ',')),
    CTE_CD_DESTINO      AS (SELECT DISTINCT CAST(LTRIM(RTRIM(value)) AS INT) CD  FROM STRING_SPLIT(@CIUDAD_DESTINO,   ',')),
    CTE_CD_ALL          AS (SELECT CD FROM CTE_CD_ORIGEN UNION SELECT CD FROM CTE_CD_DESTINO),

    CTE_ESTADO_DIG AS (
        SELECT DISTINCT
            CASE WHEN CAST(LTRIM(RTRIM(value)) AS INT) = 1 THEN 'DIGITALIZADA' ELSE 'NO DIGITALIZADA' END AS IDS
        FROM STRING_SPLIT(@ESTADO_DIGITALIZADA, ',')
    ),

    -- 3.2 Datos base con deduplicación inline (reemplaza la tabla temporal principal + el DELETE duplicados)
    CTE_BASE AS (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY NUMERO_GUIA ORDER BY FECHA_EXTRACCION_DW DESC) AS _RN
        FROM [SIG_CCM_DM].[FAC].[DIGGUICCM_DIGITALIZACION_FINAL_ULTIMO_PROCESO_LOG] WITH (NOLOCK)
        WHERE
            -- Filtro de fecha según tipo de consulta
            (
                (@TIPO_CONSULTA = 1 AND FECHA_HORA_MOVIMIENTO_EZ_EP >= @FECHA_INI_EFE AND FECHA_HORA_MOVIMIENTO_EZ_EP <= @FECHA_FIN_EFE)
             OR (@TIPO_CONSULTA = 2 AND G_FECHA_ENVIO             >= @FECHA_INI_EFE AND G_FECHA_ENVIO             <= @FECHA_FIN_EFE)
             OR (@TIPO_CONSULTA = 3 AND UBIC_FECHA_HORA_MOVIMI    >= @FECHA_INI_EFE AND UBIC_FECHA_HORA_MOVIMI    <= @FECHA_FIN_EFE)
            )
            -- Filtro estado digitalizada
            AND ISNULL(ESTADO_DIGLIAIZADA, 'NO DIGITALIZADA') COLLATE SQL_Latin1_General_CP850_CI_AI
                IN (SELECT IDS COLLATE SQL_Latin1_General_CP850_CI_AI FROM CTE_ESTADO_DIG)
            -- Filtro tipo cliente
            AND (@ALL_TIPO_CLIENTE = 1 OR ISNULL(ID_TIPO_CLIENTE, 0) IN (SELECT IDS FROM CTE_TIPO_CLIENTE))
            -- Filtro tipo entrega
            AND (@ALL_TIPO_ENTREGA = 1 OR ISNULL(ID_TIPO_ENTREGA, 0)  IN (SELECT IDS FROM CTE_TIPO_ENTREGA))
            -- Filtro estado guia
            AND (@ALL_ESTADO_GUIA  = 1 OR ISNULL(ID_ESTADOGUIA, 1)    IN (SELECT IDS FROM CTE_ESTADO_GUIA))
    ),

    CTE_SIN_DUPS AS (
        SELECT * FROM CTE_BASE WHERE _RN = 1
    )

    -- ==========================================
    -- 4. SELECT FINAL — resultado directo al reporte
    -- ==========================================
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
        ,@FECHA_INI_EFE                                                 AS [FECHA_INICIAL]
        ,@FECHA_FIN_EFE                                                 AS [FECHA_FINAL]

    FROM CTE_SIN_DUPS ULT

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
    LEFT JOIN [DIM].[PRODUCTO]       PR   WITH (NOLOCK) ON ULT.G_ID_PRODUCTO   = PR.ID_PRODUCTO

    WHERE 1=1

        -- ── FILTRO REGIONAL según tipo de consulta ──────────────────────────
        AND (
            (@TIPO_CONSULTA = 1 AND (@ALL_REG_ORIGEN = 1 AND @ALL_REG_DESTINO = 1 OR ISNULL(RD_EZU.ID_REGIONAL, 0) IN (SELECT IDS FROM CTE_REG_ALL)))
         OR (@TIPO_CONSULTA = 2 AND (@ALL_REG_DESTINO = 1 OR ISNULL(RD.ID_REGIONAL,     0) IN (SELECT IDS FROM CTE_REG_DESTINO)))
         OR (@TIPO_CONSULTA = 3 AND (@ALL_REG_ORIGEN  = 1 AND @ALL_REG_DESTINO = 1 OR ISNULL(RD_UBIC.ID_REGIONAL, 0) IN (SELECT IDS FROM CTE_REG_ALL)))
        )

        -- ── FILTRO CIUDAD DESTINO según tipo de consulta ─────────────────────
        AND (
            @ALL_CD_DESTINO = 1
         OR (@TIPO_CONSULTA = 1 AND ISNULL(ULT.EZU_EPS_DOC_ID_CIUDAD_DESTINO, 0) IN (SELECT CD FROM CTE_CD_DESTINO))
         OR (@TIPO_CONSULTA = 2 AND ISNULL(ULT.G_ID_CIUDAD_DESTINO,            0) IN (SELECT CD FROM CTE_CD_DESTINO))
         OR (@TIPO_CONSULTA = 3 AND ISNULL(ULT.UBIC_ID_CIUDAD_UBICACION,       0) IN (SELECT CD FROM CTE_CD_ALL))
        )

        -- ── FILTRO CIUDAD ORIGEN según tipo de consulta ──────────────────────
        AND (
            @ALL_CD_ORIGEN = 1
         OR (@TIPO_CONSULTA = 1 AND ISNULL(ULT.EZU_EPS_DOC_ID_CIUDAD_DESTINO, 0) IN (SELECT CD FROM CTE_CD_ORIGEN))
         OR (@TIPO_CONSULTA = 2 AND ISNULL(ULT.G_ID_CIUDAD_ORIGEN,             0) IN (SELECT CD FROM CTE_CD_ORIGEN))
         OR (@TIPO_CONSULTA = 3 AND ISNULL(ULT.UBIC_ID_CIUDAD_UBICACION,       0) IN (SELECT CD FROM CTE_CD_ALL))
        )

        -- ── FILTRO PROCESO según tipo de consulta ────────────────────────────
        AND (
            @ALL_PROCESO = 1
         OR (@TIPO_CONSULTA = 1 AND ISNULL(ULT.ID_PROCESO,       0) IN (SELECT IDS FROM CTE_PROCESO))
         OR (@TIPO_CONSULTA IN (2,3) AND ISNULL(ULT.UBIC_ID_PROCESO, 0) IN (SELECT IDS FROM CTE_PROCESO))
        )

    OPTION (RECOMPILE);  -- Evita planes de ejecución cacheados con parámetros subóptimos


/* */
    SET NOCOUNT OFF;
END
GO


