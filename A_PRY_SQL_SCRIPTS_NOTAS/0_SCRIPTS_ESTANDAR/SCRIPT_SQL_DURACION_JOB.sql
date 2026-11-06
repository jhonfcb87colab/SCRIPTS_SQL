;WITH UltimaEjecucion AS
(
SELECT
j.name AS JobName,
h.run_date,
h.run_time,
h.run_duration,
ROW_NUMBER() OVER (
PARTITION BY j.job_id
ORDER BY h.run_date DESC, h.run_time DESC
) AS RN
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobhistory h
ON j.job_id = h.job_id
WHERE h.step_id = 0
)
SELECT
JobName,
msdb.dbo.agent_datetime(run_date, run_time) AS FechaUltimaEjecucion,
CONCAT(
run_duration / 10000, 'h ',
((run_duration % 10000) / 100), 'm ',
(run_duration % 100), 's'
) AS Duracion,
(run_duration / 10000) * 3600 +
((run_duration % 10000) / 100) * 60 +
(run_duration % 100) AS DuracionSegundos
FROM UltimaEjecucion
WHERE RN = 1
ORDER BY DuracionSegundos DESC;