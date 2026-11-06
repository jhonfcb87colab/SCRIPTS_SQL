       --FUNCIONES MAS IMPORTANTES EN SQL Y SQLSERVER        

 
 select * from [FAC].[MOV_POR_PROCESO_PRODUCTO]
----BUSCAR JOB (SQL) 
--[PRF].[PREFACTURAS]

----DETALLES_MOVIMIENTOS_PDTE_COBRAR
DECLARE  @TABLA VARCHAR(100) = 'CATEGORIA_ZONA_URBANA';  
DECLARE @TABLA_QDINAM NVARCHAR(MAX);  
SET @TABLA_QDINAM = CONCAT('%',@TABLA,'%')   
SELECT  
     --JOB.JOB_ID,  
     --NOTIFY_LEVEL_EMAIL,  
     NAME,  
     --ENABLED,  
    -- DESCRIPTION,  
STEP_ID AS ORDEN_EJECUCION,  
     STEP_NAME,  
     COMMAND  
     --SERVER,  
     --DATABASE_NAME  
FROM  
    MSDB.DBO.SYSJOBS JOB  
INNER JOIN  
    MSDB.DBO.SYSJOBSTEPS STEPS          
ON  
    JOB.JOB_ID = STEPS.JOB_ID  
WHERE  
JOB.ENABLED = 1 AND  
(NAME                LIKE @TABLA_QDINAM OR  
COMMAND        LIKE @TABLA_QDINAM OR  
STEP_NAME  LIKE @TABLA_QDINAM )  
ORDER BY NAME  


--------BUSCAR JOB (SQL) 

SELECT   
     NAME,   
STEP_ID AS ORDEN_EJECUCION,   
     STEP_NAME,   
     COMMAND   
FROM   
    MSDB.DBO.SYSJOBS JOB   
INNER JOIN   
    MSDB.DBO.SYSJOBSTEPS STEPS           
ON   
    JOB.JOB_ID = STEPS.JOB_ID   
WHERE  
JOB.ENABLED = 1 AND   
(NAME                LIKE '%DIM_TESORERIA_PROVEEDOR%' OR   
COMMAND        LIKE '%DIM_TESORERIA_PROVEEDOR%' OR   
STEP_NAME  LIKE '%DIM_TESORERIA_PROVEEDOR%' )   
ORDER BY NAME  

 

 
 select [dbo].[GetDiasLaborales] ('2025-01-01','2025-01-06')
 

----VER BLOQUEOS PROCESOS QUE SE ESTE CORRIENDO 

----SP_WHO3  

 

 

 

----APLICAR FILTROS A PARTIR UNA LISTA  COMPARATIVA  

--SELECT TOP 4 * FROM [FAC].[MOV_POR_PROCESO_PRODUCTO] WITH (NOLOCK)  

--where ID_TIPO_COBRO in (1,2)  

 

 

 

----------------APLICAR CONDICIONALES A COLUMANAS  

SELECT OrderID, Quantity, 
CASE 
    WHEN Quantity > 30 THEN 'The quantity is greater than 30' 
    WHEN Quantity = 30 THEN 'The quantity is 30' 
    ELSE 'The quantity is under 30' 
END AS QuantityText 
FROM OrderDetails; 

 

 

--------------CAST DE FECHAS CONVERSION 

select * from usuarios  
where  
cast(getdate() as date)=cast(ultima_estrada as date)  
order by ultima_estrada desc 

 

select * from trafico_usuarios where 
cast(getdate()-1 as date)=cast(FECHA_VISITA as date)  
order by id desc 

 

 

------DISCOS DUROS 

--------fsutil fsinfo ntfsinfo [your drive] 

wmic logicaldisk 

SELECT * FROM sys.syslogins where sysadmin=1 

 

    ------PARAMETROS     

DECLARE @password varchar(30), @cedula varchar(30) 
SET @password='123'  
SET @cedula = '80931531' 
SELECT * FROM usuarios s1 WHERE  s1.cedula=@cedula AND s1.password=@password 

 

 

 

   

 

 

 

 

 

 

 

 

   BUSCAR ESQUEMAS DE LA TABLA       

 

select s.name as schema_name, s.schema_id, u.name as schema_owner from sys.schemas s inner join sys.sysusers u on u.uid = s.principal_id order by s.name 

 

 

 

 

 

 

 

 

 

            CREAR TABLA SI             

 

USE SIG_COLOMBIA_DW ; DROP TABLE IF EXISTS [TMP].[ALMC_VOLUMES]; 

 

 

 

 

             AÑADIR COLUMNA               

 

ALTER TABLE table_name 
ADD column_name datatype; 

 

ALTER TABLE Customers 
ADD Email varchar(255); 

 

 

ALTER TABLE table_name 
DROP COLUMN column_name; 

 

ALTER TABLE table_name 
ALTER COLUMN column_name datatype; 

 

 

ALTER TABLE table_name 
MODIFY COLUMN column_name datatype; 

 

 

ALTER TABLE table_name 
MODIFY column_name datatype; 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

--------------------------------------------------------------------------------------- 