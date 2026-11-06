----VEJEZ_BODEGAS

DECLARE  @TABLA VARCHAR(100) = 'VEJEZ_BODEGAS';  
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



/*
BODEGAS PRIMARIAS:			(9311,9314,9406,9304,9711,9310,9308,9710)
BODEGAS SECUNDARIAS:		(9312,9765,9364,9364,9764,9363,9377,9377,9319,9367,9368,9374,9373)


Primarias												Secundarias
Documentos=   (9311,9314,9406)								mercancía Empaque y Embalaje=9312
Hoy mismo documentos = (9304,)								Confirmaciones Documentos=9365
Valores documentos= 9711									Confirmaciones Valores Documentos=9765
Mercancía Premier = 9310									Confirmaciones Mercancías=9364
Hoy mismo carga = 9308										Confirmaciones Valores Carga=9764
Valores mercancía = 9710									Confirmaciones Almacenes de Cadena=(9363,9377)
															Confirmaciones merc. Industrial=9377
															Novedades=9319
															Por procesar Carga=9367
															Por procesar Documentos=9368
															Vacaciones Documentos=9374
															Vacaciones Carga=9373




*/
