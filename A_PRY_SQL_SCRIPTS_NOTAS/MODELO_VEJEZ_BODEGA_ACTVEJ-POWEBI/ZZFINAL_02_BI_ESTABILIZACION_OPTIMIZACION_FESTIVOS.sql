USE SIG_COLOMBIA_DW;
DECLARE @FechaInicio datetime
DECLARE @FechaFin datetime
SET @FechaInicio =  DATEADD(yy,-3,DATEADD(yy,DATEDIFF(yy,0,GETDATE()),0))
SET @FechaFin = CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()))) ---------------DATEADD(ms,-3,DATEADD(yy,0,DATEADD(yy,DATEDIFF(yy,0,GETDATE())+1,0)))
DECLARE @FechaCiclo datetime
SET @FechaCiclo = @FechaInicio

-----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------CALENDARIO CONTEO  FESTIVOS-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
IF object_id('tempdb..[#LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129]') < 0 
  BEGIN
    DROP TABLE [#LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129]
  END
 
CREATE TABLE #LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129
(
	[TIME_ID] [int] NOT NULL,
	[DATE] [datetime] NULL,
	[DAY] [varchar](10) NULL,
	[DIAS_FESTIVOS_DOMINICALES_TO_HOY] [int] NULL,
	[DIAS_HABILES_TO_HOY] [int] NULL,
);
 
WHILE @FechaCiclo <= @FechaFin
BEGIN 
----PRINT(@FechaCiclo)
INSERT INTO #LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129 VALUES
(
CONVERT(int,CONVERT(DATETIME,@FechaCiclo)),
CONVERT(DATETIME,@FechaCiclo),
CASE
		WHEN DATEPART(dw,@FechaCiclo )=1 THEN 'Domingo'
		WHEN DATEPART(dw,@FechaCiclo )=2 THEN 'Lunes'
		WHEN DATEPART(dw,@FechaCiclo )=3 THEN 'Martes'
		WHEN DATEPART(dw,@FechaCiclo )=4 THEN 'Miercoles'
		WHEN DATEPART(dw,@FechaCiclo )=5 THEN 'Jueves'
		WHEN DATEPART(dw,@FechaCiclo )=6 THEN 'Viernes'
		WHEN DATEPART(dw,@FechaCiclo )=7 THEN 'Sabado'
		ELSE NULL 
	END,
	1,
	1

)
SET @FechaCiclo = DATEADD(DAY, 1, @FechaCiclo);
END;

TRUNCATE TABLE [SIG_COLOMBIA_DW].[TMP].[VEJEZ_BODEGAS_03_02_FESTIVOS_DOMINICALES_HABILES];

INSERT INTO [SIG_COLOMBIA_DW].[TMP].[VEJEZ_BODEGAS_03_02_FESTIVOS_DOMINICALES_HABILES] 
SELECT 
[TIME_ID]	
,[DATE]
,[HOY] = CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE())))
,[DAY]	
,[DIAS_FESTIVOS_DOMINICALES_TO_HOY]	= LOG.UFN_COUNT_DAYS_RANGE([DATE],convert(datetime,convert(date,GETDATE())),'DIA HABIL')
,[DIAS_HABILES_TO_HOY]= LOG.UFN_COUNT_DAYS_RANGE([DATE],convert(datetime,convert(date,GETDATE())),'DIA DOMINICAL,DIA FESTIVO')	
,[GENERAL_DIAS] = DATEDIFF(DAY,[DATE],CONVERT(DATETIME,CONVERT(DATE,GETDATE()+1)))  --DATEIFF([DATE]
FROM #LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129


---SELECT DATEDIFF(DAY,'2023-11-01',GETDATE())
----43931	2020-04-12 00:00:00.000	Domingo	247	1060
/*

CASE WHEN CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,[DATE])))=CONVERT(DATETIME,CONVERT(DATE,CONVERT(DATETIME,GETDATE()))) THEN 0
		ELSE LOG.UFN_COUNT_DAYS_RANGE([DATE],convert(datetime,convert(date,GETDATE()+1)),'DIA DOMINICAL,DIA FESTIVO')
		END
SELECT * FROM [SIG_COLOMBIA_DW].[TMP].[VEJEZ_BODEGAS_03_02_FESTIVOS_DOMINICALES_HABILES];
*/


