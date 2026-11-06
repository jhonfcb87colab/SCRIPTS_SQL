
/*

FORMATO DE FECHAS 

*/

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,20) as [YYYY-MM-DD HH:MM:SS] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,14) as [HH:MM:SS:MMM] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,21) as [YYYY-MM-DD HH:MM:SS.mmm] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,22) as [mm/dd/yy hh:mm:ss (AM/PM)] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,23) as [yyyy-mm-dd] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,24) as [hh:mm:ss] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,27) as [mm-dd-yyyy hh:mm:ss.mmm] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,100) as [MMM DD YYYY HH:SS (AM/PM)] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,101) as [MM/DD/YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,102) as [YYYY.MM.DD] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,103) as [DD/MM/YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,104) as [DD/MM/YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,105) as [DD/MM/YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,106) as [DD MMM YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,107) as [MMM DD,YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,108) as [HH:MM:SS] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,109) as [MMM DD YYYY hh:mm:ss:mmm(AM/PM)] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,110) as [MM-DD-YYYY] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,111) as [YYYY/MM/DD] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,112) as [YYYYMMDD] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,113) as [DD MMM YYYY HH:MM:SS:MMM] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,114) as [DD MMM YYYY HH:MM:SS:MMM] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,120) as [YYYY-MM-DD HH:MM:SS] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,121) as [YYYY-MM-DD HH:MM:SS.mmm] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,126) as [yyyy-mm-ddThh:mi:ss.mmm] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,130) as [dd mon yyyy hh:mi:ss:mmm(AM/PM)] 

declare @Existingdate datetime 
Set @Existingdate=GETDATE() 
Select CONVERT(varchar,@Existingdate,1) as [MM/DD/YY] 

 

SELECT 	CONCAT(
		LEFT(CONVERT(varchar,CONVERT(DATE,CONVERT(DATETIME,'2026-9-01')),112),4),'-',
		RIGHT(LEFT(CONVERT(varchar,CONVERT(DATE,CONVERT(DATETIME,'2026-9-01')),112),6),2)
		)
	
	