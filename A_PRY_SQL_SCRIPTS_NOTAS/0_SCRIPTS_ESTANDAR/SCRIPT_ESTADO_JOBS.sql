--SELECT * FROM msdb.dbo.sysjobs sj
--SELECT * FROM msdb.dbo.sysjobhistory sh
--SELECT 
--sh.run_date,sh.run_time,
----CONVERT(DATETIME,
--CONCAT(
--CONCAT(left(sh.run_date,4),'-',RIGHT(left(sh.run_date,6),2),'-',RIGHT(sh.run_date,2)),' ',
--LEFT(sh.run_time,2),':',RIGHT(left(sh.run_time,4),2),':',RIGHT(left(sh.run_time,6),2)
--)--)
--from msdb.dbo.sysjobhistory sh

;with cte as(
SELECT 
ROW_NUMBER() OVER(PARTITION BY SJ.name, SH.step_name
										ORDER BY 
												DATETIMEFROMPARTS(
													   LEFT(padded_run_date, 4),         -- year
													   SUBSTRING(padded_run_date, 5, 2), -- month
													   RIGHT(padded_run_date, 2),        -- day
													   LEFT(padded_run_time, 2),         -- hour
													   SUBSTRING(padded_run_time, 3, 2), -- minute
													   RIGHT(padded_run_time, 2),        -- second
													   0)
													   DESC) #row_id,
SJ.name as NOMBRE_JOB,
SH.step_id,
SH.step_name PASO_JOB,
SH.run_status,	
SH.run_date,
convert(datetime,
DATETIMEFROMPARTS(
       LEFT(padded_run_date, 4),         -- year
       SUBSTRING(padded_run_date, 5, 2), -- month
       RIGHT(padded_run_date, 2),        -- day
       LEFT(padded_run_time, 2),         -- hour
       SUBSTRING(padded_run_time, 3, 2), -- minute
       RIGHT(padded_run_time, 2),        -- second
       0)) AS [LastRunDateTime],
SH.run_time,	
SH.run_duration,  
CONCAT(
CONCAT(left(sh.run_date,4),'-',RIGHT(left(sh.run_date,6),2),'-',RIGHT(sh.run_date,2)),' ',
LEFT(sh.run_time,2),':',RIGHT(left(sh.run_time,4),2),':',RIGHT(left(sh.run_time,6),2)
) AS FECHA_EJECUCION
FROM msdb.dbo.sysjobs sj
INNER JOIN msdb.dbo.sysjobhistory sh
   ON sj.job_id = sh.job_id
CROSS APPLY (
   SELECT	RIGHT('000000' + CAST(sh.run_time AS VARCHAR(6)), 6),
			RIGHT('00000000' + CAST(sh.run_date AS VARCHAR(8)), 8)
   ) AS shp(padded_run_time, padded_run_date)
WHERE 
--SJ.name in( 
--				'Actualización FAC modelo operativo diario'
--				) AND 
SH.step_id>=1
--and SH.step_name <> '(Job outcome)'
				----LIKE '%ENVIO%MOVILIZA%'
)select 
NOMBRE_JOB	
,step_id
,PASO_JOB	
,[LastRunDateTime]
,run_status	
,run_date	
,run_time	
,run_duration
,FECHA_EJECUCION
from cte where #row_id in (1)
and run_status=0
order by [LastRunDateTime] DESC
