USE SIG_COLOMBIA_DW;
DECLARE @FechaInicio datetime
DECLARE @FechaFin datetime
---SET @FechaInicio = '2022-01-01'
SET @FechaInicio =  (SELECT MAX(DATEADD(DAY,1,T.DATE)) FROM DIM.TIEMPO T WITH(NOLOCK))
--SET @FechaFin = '2022-10-15'
SET @FechaFin = DATEADD(ms,0,DATEADD(yy,2,DATEADD(yy,DATEDIFF(yy,0,GETDATE()),-1)))
DECLARE @FechaCiclo datetime
SET @FechaCiclo = @FechaInicio

-----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------CALENDARIO -------------------------------------------------------------------------------------------------------------------------
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
	[MONTH] [varchar](10) NULL,
	[YEAR] [int] NULL,
	[DAY_OF_MONTH] [int] NULL,
	[WEEK_OF_YEAR] [int] NULL,
	[MONTH_OF_YEAR] [int] NULL,
	[QUARTER_OF_YEAR] [int] NULL
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
CASE 
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=1 THEN 'Enero'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=2 THEN 'Febrero'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=3 THEN 'Marzo'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=4 THEN 'Abril'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=5 THEN 'Mayo'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=6 THEN 'Junio'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=7 THEN 'Julio'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=8 THEN 'Agosto'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=9 THEN 'Septiembre'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=10 THEN 'Octubre'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=11 THEN 'Noviembre'
		WHEN MONTH(CONVERT(DATETIME,@FechaCiclo))=12 THEN 'Diciembre'
		ELSE NULL
	END,
YEAR(CONVERT(DATETIME,@FechaCiclo)),
DAY(CONVERT(DATETIME,@FechaCiclo)),
DATEPART(wk, CONVERT(DATETIME,@FechaCiclo)),
MONTH(CONVERT(DATETIME,@FechaCiclo)),---numero
CASE
		WHEN Month(@FechaCiclo) IN (1, 2, 3, 4) THEN 1
		WHEN Month(@FechaCiclo) IN (5, 6, 7, 8) THEN 2
		WHEN Month(@FechaCiclo) IN (9, 10, 11, 12) THEN 3
	END
)
SET @FechaCiclo = DATEADD(DAY, 1, @FechaCiclo);
END
 
DROP TABLE IF EXISTS #LOCAL_TABLEVARIABLE_CALENDARIO;
SELECT *
,SEMESTER_OF_YEAR = 	CASE WHEN MONTH_OF_YEAR BETWEEN 1 AND 6 THEN 1
						WHEN MONTH_OF_YEAR BETWEEN 7 AND 12 THEN 2
						ELSE 0 END

,SEMESTER =  CONCAT([YEAR],' Sem ',	(CASE WHEN MONTH_OF_YEAR BETWEEN 1 AND 6 THEN 1
						WHEN MONTH_OF_YEAR BETWEEN 7 AND 12 THEN 2
						ELSE 0 END))
INTO #LOCAL_TABLEVARIABLE_CALENDARIO
FROM #LOCAL_TABLEVARIABLE_CALENDARIO_20221115_1129

SELECT * FROM #LOCAL_TABLEVARIABLE_CALENDARIO

SELECT top 10 * FROM DIM.TIEMPO WITH(NOLOCK)



