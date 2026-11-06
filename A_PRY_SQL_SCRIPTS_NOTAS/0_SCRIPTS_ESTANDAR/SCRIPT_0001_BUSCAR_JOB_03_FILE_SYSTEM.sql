-- List of all the SQL Jobs on a server with steps
SELECT
     ----job.job_id,
     ----notify_level_email,
     enabled,     
	 name,
     --description,
	 steps.step_id,
     step_name,
     command
     --server,
     --database_name
FROM
    msdb.dbo.sysjobs job
INNER JOIN 
    msdb.dbo.sysjobsteps steps        
ON
    job.job_id = steps.job_id
WHERE 1=1
and command like '%/FILE%'
    AND job.enabled = 1 -- uncomment this to see enabled SQL Jobs
order by name
