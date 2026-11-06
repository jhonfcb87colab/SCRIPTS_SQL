USE SIG_COL_SAP_DW;




DECLARE @FechaInicio datetime
DECLARE @FechaFin datetime
---SET @FechaInicio = '2022-01-01'
SET @FechaInicio =  (SELECT  dateadd(day,1,MAX([DATE])) FROM SIG_COL_SAP_DW.DIM.TIEMPO WITH(NOLOCK))
--SET @FechaFin = '2022-10-15'
SET @FechaFin =	DATEADD(ms,0,DATEADD(yy,2,DATEADD(yy,DATEDIFF(yy,0,GETDATE()),-1)))					---GETDATE()+10				--
DECLARE @FechaCiclo datetime
SET @FechaCiclo = @FechaInicio
SELECT @FechaFin,@FechaInicio



--SELECT DIA_DEL_MES,COUNT(1) FROM DIM.CALENDARIO T WITH(NOLOCK)
--WHERE ANIO=2025 AND MES=12
--GROUP BY DIA_DEL_MES
--ORDER BY 1 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------CALENDARIO -------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------
 
 	

DROP TABLE IF EXISTS #LOCAL_TABLE_VARIABLE_CALENDARIO_DIM_tiempo_sig_col_sap
 
CREATE TABLE #LOCAL_TABLE_VARIABLE_CALENDARIO_DIM_tiempo_sig_col_sap
(
	[TIME_ID] [int] NOT NULL,
	[DATE] [datetime] NOT NULL
);
 
--DECLARE @FECHA_RUEBA DATETIME = '2025-12-24 11:00:00.000'
--SELECT  (((YEAR(@FECHA_PRUEBA)*100)+MONTH(@FECHA_PRUEBA))*100+DAY(@FECHA_PRUEBA))*100+DATEPART(HOUR,@FECHA_PRUEBA)



WHILE @FechaCiclo <= @FechaFin
BEGIN 
----PRINT(@FechaCiclo)
INSERT INTO #LOCAL_TABLE_VARIABLE_CALENDARIO_DIM_tiempo_sig_col_sap VALUES
(
convert(int,convert(datetime,convert(date,convert(datetime,@FechaCiclo)))),
CONVERT(DATETIME,@FechaCiclo)
)
SET @FechaCiclo = DATEADD(day, 1, @FechaCiclo);
END


--INSERT INTO SIG_COL_SAP_DW.DIM.TIEMPO
select 
[TIME_ID]
,[DATE] 
,[DAY] = CASE
					WHEN DATEPART(dw,[DATE] )=1 THEN 'Domingo'     
					WHEN DATEPART(dw,[DATE] )=2 THEN 'Lunes' 
					WHEN DATEPART(dw,[DATE] )=3 THEN  'Martes'
					WHEN DATEPART(dw,[DATE] )=4 THEN  'Miercoles'
					WHEN DATEPART(dw,[DATE] )=5 THEN  'Jueves'
					WHEN DATEPART(dw,[DATE] )=6 THEN  'Viernes'
					WHEN DATEPART(dw,[DATE] )=7 THEN  'Sabado'
					ELSE NULL 
				END
,[MONTH]	= CASE 
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=1 THEN 'Enero'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=2 THEN 'Febrero'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=3 THEN 'Marzo'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=4 THEN 'Abril'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=5 THEN 'Mayo'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=6 THEN 'Junio'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=7 THEN 'Julio'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=8 THEN 'Agosto'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=9 THEN 'Septiembre'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=10 THEN 'Octubre'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=11 THEN 'Noviembre'
					WHEN MONTH(CONVERT(DATETIME,[DATE]))=12 THEN 'Diciembre'
					ELSE NULL
				END
,[YEAR]	= year([DATE])
,[DAY_OF_MONTH]	= day([DATE])
,[WEEK_OF_YEAR]	= DATEPART(WEEK, [DATE])
,[MONTH_OF_YEAR]	= month([DATE])
,[QUARTER_OF_YEAR] = CASE   WHEN month([DATE]) BETWEEN 1 AND 4 THEN 1
							WHEN month([DATE]) BETWEEN 5 AND 8 THEN 2
							WHEN month([DATE]) BETWEEN 9 AND 12 THEN 3
							----WHEN month([DATE]) BETWEEN 10 AND 12 THEN 4
							END
from #LOCAL_TABLE_VARIABLE_CALENDARIO_DIM_tiempo_sig_col_sap
 ----where year([DATE]) = 2026 and month([DATE])=12

----select * FROM SIG_COL_SAP_DW.DIM.TIEMPO WITH(NOLOCK) where YEAR = 2025 and MONTH_OF_YEAR=12










SELECT  * FROM DIM.TIEMPO T WITH(NOLOCK) ---WHERE ANIO=2025 AND MES=12
WHERE YEAR=2026



