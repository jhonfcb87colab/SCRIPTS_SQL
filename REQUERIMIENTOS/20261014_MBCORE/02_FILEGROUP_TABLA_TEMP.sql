


-- 1. Añadir el Filegroup a la base de datos
ALTER DATABASE SIG_COLOMBIA_DW
ADD FILEGROUP FG_SIG_COLOMBIA_ODS_TEMPORAL;
GO

-- 2. Añadir un archivo físico asociado a ese Filegroup
ALTER DATABASE SIG_COLOMBIA_DW
ADD FILE (
    NAME = 'DatosSIG_COLOMBIA_ODS_TEMPORAL',
    FILENAME = 'E:\PM_CW_5\MSSQL_DATA\MBCORE_SIG_COLOMBIA_ODS_TEMPORAL.ndf',
    SIZE = 10MB,              -- Tamaño inicial
    MAXSIZE = UNLIMITED,       -- Crecimiento máximo
    FILEGROWTH = 50MB          -- Tasa de crecimiento automático
)
TO FILEGROUP FG_SIG_COLOMBIA_ODS_TEMPORAL;
GO

CREATE TABLE [TMP].[MBCORE_GUIAS_01] (
    [NUMERO_GUIA] numeric(20,0),
    [NUMERO_PIEZAS] smallint,
    [FECHA_ENVIO] datetime,
    [ID_TIEMPO] tinyint,
    [ID_PRODUCTO] smallint,
    [DIRECCION_DESTINA_GUIA] varchar(400),
    [ID_CLIENTE] varchar(20),
    [ID_CIUDAD_ORIGEN] int,
    [ID_CIUDAD_DESTINO] int,
    [ID_PAIS_UBICACION] smallint,
    [ID_CIUDAD_UBICACION] int,
    [ID_DIVISION_UBICACION] int,
    [VALOR_DECLARADO_GUIA] numeric(11,2),
    [FECHA_EXTRACCION_DW] datetime,
    [CR_ID_APLICA_COMPENSACIONES] int,
    [G_NOMBRE_REMITENTE] varchar(100),
    [G_TELEFONO_REMITE_GUIA] varchar(20),
    [G_ID_REMITE] varchar(20),
    [ID_ESTADOGUIA] tinyint,
    [ID_ESTADOENVIO] tinyint,
    [ID_PROCESO] smallint,
    [CONSECUT_MOVIMI] numeric(7,0),
    [NUMERO_MOVIMI] varchar(30),
    [FECHA_HORA_MOVIMIENTO] datetime
) ON FG_SIG_COLOMBIA_ODS_TEMPORAL; -- <-- Aquí se indica el Filegroup

CREATE TABLE [TMP].[MBCORE_GUIAS_01_AUX] (
    [NUMERO_GUIA] numeric(20,0),
    [NUMERO_PIEZAS] smallint,
    [FECHA_ENVIO] datetime,
    [ID_TIEMPO] tinyint,
    [ID_PRODUCTO] smallint,
    [DIRECCION_DESTINA_GUIA] varchar(400),
    [ID_CLIENTE] varchar(20),
    [ID_CIUDAD_ORIGEN] int,
    [ID_CIUDAD_DESTINO] int,
    [ID_PAIS_UBICACION] smallint,
    [ID_CIUDAD_UBICACION] int,
    [ID_DIVISION_UBICACION] int,
    [VALOR_DECLARADO_GUIA] numeric(11,2),
    [FECHA_EXTRACCION_DW] datetime,
    [CR_ID_APLICA_COMPENSACIONES] int,
    [G_NOMBRE_REMITENTE] varchar(100),
    [G_TELEFONO_REMITE_GUIA] varchar(20),
    [G_ID_REMITE] varchar(20),
    [ID_ESTADOGUIA] tinyint,
    [ID_ESTADOENVIO] tinyint,
    [ID_PROCESO] smallint,
    [CONSECUT_MOVIMI] numeric(7,0),
    [NUMERO_MOVIMI] varchar(30),
    [FECHA_HORA_MOVIMIENTO] datetime
) ON FG_SIG_COLOMBIA_ODS_TEMPORAL; -- <-- Aquí se indica el Filegroup




CREATE TABLE [TMP].[MBCORE_GUIAS_02](
	[NUMERO_GUIA] [numeric](20, 0) NOT NULL,
	[NUMERO_PIEZAS] [int] NULL,
	[ID_TIEMPO] [int] NULL,
	[ID_PRODUCTO] [int] NULL,
	[ID_CLIENTE] [char](20) NULL,
	[ID_ESTADOENVIO] [int] NULL,
	[ID_CIUDAD_ORIGEN] [int] NULL,
	[ID_CIUDAD_DESTINO] [int] NULL,
	[FECHA_ENVIO] [datetime] NULL,
	[DIRECCION_DESTINA_GUIA] [varchar](400) NULL,
	[ID_PAIS_UBICACION] [int] NULL,
	[ID_CIUDAD_UBICACION] [int] NULL,
	[ID_DIVISION_UBICACION] [int] NULL,
	[VALOR_DECLARADO_GUIA] [numeric](11, 2) NULL,
	[CR_ID_APLICA_COMPENSACIONES] [int] NULL,
	[G_NOMBRE_REMITENTE] [varchar](101) NULL,
	[G_TELEFONO_REMITE_GUIA] [varchar](20) NULL,
	[G_ID_REMITE] [char](20) NULL
) ON FG_SIG_COLOMBIA_ODS_TEMPORAL
GO

CREATE TABLE [TMP].[MBCORE_GUIAS](
	[G_NUMERO_GUIA] [numeric](20, 0) NULL,
	[G_ID_FECHA] [datetime] NULL,
	[G_FECHA] [varchar](30) NULL,
	[G_NUMERO_PIEZAS] [int] NULL,
	[G_ID_TIEMPO_ENTREGA] [int] NULL,
	[G_TIEMPO_ENTREGA] [varchar](50) NULL,
	[G_ID_PRODUCTO] [int] NULL,
	[G_PRODUCTO] [varchar](50) NULL,
	[G_DIRE_DESTINO] [varchar](400) NULL,
	[G_ID_CIUDAD_ORIGEN] [int] NULL,
	[G_CIUDAD_ORIGEN] [varchar](50) NULL,
	[G_DEPARTAMENTO_ORIGEN] [varchar](50) NULL,
	[G_REGIONAL_ORIGEN] [varchar](50) NULL,
	[G_ID_CIUDAD_DESTINO] [int] NULL,
	[G_CIUDAD_DESTINO] [varchar](50) NULL,
	[G_DEPARTAMENTO_DESTINO] [varchar](50) NULL,
	[G_REGIONAL_DESTINO] [varchar](50) NULL,
	[G_ID_CLIENTE] [varchar](20) NULL,
	[G_CLIENTE] [varchar](100) NULL,
	[G_ID_ESTADO_ENVIO] [int] NULL,
	[G_ESTADO_ENVIO] [varchar](50) NULL,
	[G_ID_PAIS_UBICACION] [int] NULL,
	[G_ID_CIUDAD_UBICACION] [int] NULL,
	[G_ID_DIVISION_UBICACION] [int] NULL,
	[G_VALOR_DECLARADO] [float] NULL,
	[G_ID_BODEGA_ULTM_MOVI] [varchar](100) NULL,
	[GR_TIPO_COBRO] [varchar](50) NULL,
	[GRIR_NUMERO_ORDEN_SERVICIO] [varchar](50) NULL,
	[GRIR_VALOR_RECAUDAR] [float] NULL,
	[TC_PROCESO] [numeric](20, 0) NULL,
	[GR_ESTADO_RECAUDO] [varchar](20) NULL,
	[G_CANAL] [varchar](50) NULL,
	[G_ID_CIUDAD_CANAL_ORIGEN] [int] NULL,
	[G_CIUDAD_CANAL_ORIGEN] [varchar](50) NULL,
	[G_DEPARTAMENTO_CANAL_ORIGEN] [varchar](50) NULL,
	[G_REGIONAL_CANAL_ORIGEN] [varchar](50) NULL,
	[G_ID_CIUDAD_CANAL_DESTINO] [int] NULL,
	[G_CIUDAD_CANAL_DESTINO] [varchar](50) NULL,
	[G_DEPARTAMENTO_CANAL_DESTINO] [varchar](50) NULL,
	[G_REGIONAL_CANAL_DESTINO] [varchar](50) NULL,
	[SE_ID_FECHA_EZU] [datetime] NULL,
	[SE_FECHA_EZU] [varchar](30) NULL,
	[SE_ID_FECHA_ULTI_MOVI] [datetime] NULL,
	[SE_FECHA_ULTI_MOVI] [varchar](30) NULL,
	[SE_CANT_SZU] [int] NULL,
	[SE_ID_FECHA_SZU] [datetime] NULL,
	[SE_FECHA_SZU] [varchar](30) NULL,
	[SE_ID_CONC_SZU] [int] NULL,
	[SE_CONC_SZU] [varchar](50) NULL,
	[SE_ID_CANT_DZU] [int] NULL,
	[SE_ID_ULTI] [int] NULL,
	[SE_ID_SZU] [varchar](2) NULL,
	[DOC_ID_CIUDAD_ULTI_MOVI] [int] NULL,
	[DOC_CIUDAD_ULTI_MOVI] [varchar](50) NULL,
	[DOC_DEPT_ULTI_MOVI] [varchar](50) NULL,
	[DOC_REGIONAL_ULTI_MOVI] [varchar](50) NULL,
	[DOC_ID_ZONA] [varchar](20) NULL,
	[SE_PROC_ULTI_MOVI] [varchar](50) NULL,
	[SE_CONC_ULTI_MOVI] [varchar](50) NULL,
	[SE_ID_DIGI] [varchar](20) NULL,
	[SE_ID_FECHA_DIGI] [datetime] NULL,
	[SE_FECHA_DIGI] [varchar](30) NULL,
	[DOC_ZONA] [varchar](50) NULL,
	[G_BODEGA_ULTM_MOVI] [varchar](50) NULL,
	[G_ID_TIPO_TRAYECTO] [varchar](50) NULL,
	[G_TIPO_TRAYECTO] [varchar](50) NULL,
	[CNF_ID_CONFIRMACION] [varchar](20) NULL,
	[CNF_CANT_CONFIRMACION] [int] NULL,
	[CNF_ID_SOLUCION_1] [int] NULL,
	[CNF_SOLUCION_1] [varchar](150) NULL,
	[CNF_ID_SOLUCION_2] [int] NULL,
	[CNF_SOLUCION_2] [varchar](150) NULL,
	[CNF_ID_SOLUCION_3] [int] NULL,
	[CNF_SOLUCION_3] [varchar](150) NULL,
	[SE_ID_CONP_DZU_1] [int] NULL,
	[SE_CONP_DZU_1] [varchar](50) NULL,
	[SE_ID_CONP_DZU_2] [int] NULL,
	[SE_CONP_DZU_2] [varchar](50) NULL,
	[SE_ID_CONP_DZU_3] [int] NULL,
	[SE_CONP_DZU_3] [varchar](50) NULL,
	[SE_NOVD_OPERATIVA_1] [varchar](150) NULL,
	[SE_NOVD_OPERATIVA_2] [varchar](150) NULL,
	[SE_NOVD_OPERATIVA_3] [varchar](150) NULL,
	[MPE_ENVI_PQR] [varchar](20) NULL,
	[MPE_ESTADO_PQR] [varchar](50) NULL,
	[TAR_ENVI_TAREA] [varchar](20) NULL,
	[TAR_ID_ESTADO_TAREA] [int] NULL,
	[TAR_ESTADO_TAREA] [varchar](50) NULL,
	[SE_ID_PROC_ULTI_MOVI] [int] NULL,
	[SE_ID_CONC_ULTI_MOVI] [int] NULL,
	[MPE_ID_ESTADO_PQR] [int] NULL,
	[NUMERO_RECOLECCION] [int] NULL,
	[T_ENTREGA_EJE] [decimal](18, 0) NULL,
	[ID_ESTA_RECOLECCION] [int] NULL,
	[ESTA_RECOLECCION] [varchar](100) NULL,
	[R_ID_MOTIVO_RECHAZO] [int] NULL,
	[R_MOTIVO_RECHAZO] [varchar](40) NULL,
	[PESO_FISICO_R] [numeric](18, 0) NULL,
	[DIMENSIONES_R] [varchar](40) NULL,
	[FECHA_RECOLECCION] [datetime] NULL,
	[PESO_FISICO_E] [numeric](18, 0) NULL,
	[DIMENSIONES_E] [varchar](40) NULL,
	[GRIR_ESTADO_RECAUDO] [varchar](40) NULL,
	[EVIDEN_DISTRI] [varchar](10) NULL,
	[EVIDEN_RECO] [varchar](10) NULL,
	[GRIR_VALOR_RECAUDADO] [numeric](18, 0) NULL,
	[ID_EMPRESARIO] [int] NULL,
	[EMPRESARIO] [varchar](40) NULL,
	[RTW_INGRESO] [varchar](20) NULL,
	[FECHA_RTW_INGRESO] [datetime] NULL,
	[REC_ENV_CRD_CDS] [varchar](10) NULL,
	[CUMPLE_TE_DEPURADA] [varchar](10) NULL,
	[CUMPLE_TE_ACIDA] [varchar](10) NULL,
	[RES_INCU] [varchar](10) NULL,
	[FECHA_REC_ENV_CRD_CDS] [datetime] NULL,
	[SE_FECHA_ENTREGA] [datetime] NULL,
	[G_CANT_SD] [int] NULL,
	[FECHA_RTW_INGRESO_MOV] [datetime] NULL,
	[G_CANT_F] [int] NULL,
	[TELEFONO_DESTINATARIO] [varchar](20) NULL,
	[REGIMEN] [varchar](20) NULL,
	[ESTADOFISICO] [varchar](40) NULL,
	[FECHA_BOD_Rezagos] [datetime] NULL,
	[FECHA_BOD_Compensaciones] [datetime] NULL,
	[Numero_veces_compensaicones] [int] NULL,
	[Numero_veces_rezagos] [int] NULL,
	[Numero_piezas_rezagos] [int] NULL,
	[Numero_piezas_compensacion] [int] NULL,
	[ID_ESTADO_INDEMNIZACION] [int] NULL,
	[ESTADO_INDEMNIZACION] [varchar](100) NULL,
	[DURACION_COMPENSACIONES] [float] NULL,
	[DURACION_REZAGOS] [float] NULL,
	[CUN] [numeric](20, 0) NULL,
	[Nombre_destinatario] [varchar](60) NULL,
	[FECHA_DIGITALIZACION] [datetime] NULL,
	[ID_ESTADOGUIA_DIGITALIZACION] [int] NULL,
	[ESTADO_GUIA_DITALIZACION] [varchar](40) NULL,
	[ID_CLIENTE_PROVISION] [varchar](100) NULL,
	[NOMBRE_CLIENTE_PROVISION] [varchar](200) NULL,
	[CR_BODEGA_UBICACION] [varchar](50) NULL,
	[CR_REGIONAL_UBICACION] [varchar](50) NULL,
	[VALOR_FLETES_GUIAS] [numeric](11, 2) NULL,
	[CR_ID_APLICA_COMPENSACIONES] [int] NULL,
	[TAR_PROM_TIEMPO_RESPUESTA] [numeric](38, 6) NULL,
	[TAR_PROM_TIEMPO_CORRIDO] [numeric](38, 6) NULL,
	[TAR_PROM_TIEMPO_TOTAL] [numeric](38, 6) NULL,
	[TAR_NUM_TAREAS] [numeric](38, 0) NULL,
	[TAR_NUM_TAREAS_CERRADA] [numeric](38, 0) NULL,
	[TAR_NUM_TAREAS_PENDIENTE] [numeric](38, 0) NULL,
	[G_NOMBRE_REMITENTE] [varchar](101) NULL,
	[G_TELEFONO_REMITE_GUIA] [varchar](20) NULL,
	[G_ID_REMITE] [char](20) NULL
) ON FG_SIG_COLOMBIA_ODS_TEMPORAL
GO

ALTER TABLE [TMP].[MBCORE_GUIAS] ADD  DEFAULT ('1900-01-01') FOR [FECHA_RTW_INGRESO]
GO




CREATE NONCLUSTERED INDEX [IX_NUMERO_GUIA_MBCORE] ON [TMP].[MBCORE_GUIAS]
(
    [G_NUMERO_GUIA] ASC
)
WITH (
    PAD_INDEX = OFF, 
    STATISTICS_NORECOMPUTE = OFF, 
    SORT_IN_TEMPDB = ON,       -- <--- Cambiado a ON: Usa tempdb para ordenar, aliviando la BD principal
    DROP_EXISTING = OFF, 
    ONLINE = ON,               -- <--- Cambiado a ON (si tu edición lo soporta): Evita bloquear la tabla en producción
    ALLOW_ROW_LOCKS = ON, 
    ALLOW_PAGE_LOCKS = ON, 
    FILLFACTOR = 80            -- <--- ¡Muy bien aquí! Vital para entornos con muchos updates
) ON FG_SIG_COLOMBIA_ODS_TEMPORAL
GO

