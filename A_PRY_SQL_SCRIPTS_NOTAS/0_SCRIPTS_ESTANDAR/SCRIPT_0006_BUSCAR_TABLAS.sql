USE SIG_COLOMBIA_DW;
DECLARE  @TABLA VARCHAR(100) = 'GUIAS';  
DECLARE @TABLA_QDINAM NVARCHAR(MAX);  
SET @TABLA_QDINAM = CONCAT('%',@TABLA,'%')   
 SELECT s.name as schema_name, t.name as table_name, c.* FROM sys.columns AS c 
INNER JOIN sys.tables AS t ON t.object_id = c.object_id 
INNER JOIN sys.schemas AS s ON s.schema_id = t.schema_id 
WHERE t.name LIKE @TABLA_QDINAM --AND s.name = 'fac'; 

GO

USE SIG_COLOMBIA_DW;
DECLARE  @TABLA VARCHAR(100) = 'GUI';  
DECLARE @TABLA_QDINAM NVARCHAR(MAX);  
SET @TABLA_QDINAM = CONCAT('%',@TABLA,'%')   
 SELECT s.name as schema_name, t.name as table_name, c.* FROM sys.columns AS c 
 INNER JOIN sys.tables AS t ON t.object_id = c.object_id 
 INNER JOIN sys.schemas AS s ON s.schema_id = t.schema_id 
 WHERE t.name LIKE @TABLA_QDINAM --AND s.name = 'fac'; 


GO

USE SIG_COLOMBIA_DW;
DECLARE  @COLUMNA VARCHAR(100) = '%TIPO%ENV%';  
DECLARE @COLUMNA_QDINAM NVARCHAR(MAX);  
SET @COLUMNA_QDINAM = CONCAT('%',@COLUMNA,'%')   
SELECT *
    --sysobjects.name AS table_name,
    --syscolumns.name AS column_name,
    --systypes.name AS datatype,
    --syscolumns.LENGTH AS LENGTH
FROM
    sysobjects
    INNER JOIN syscolumns ON sysobjects.id = syscolumns.id
    INNER JOIN systypes ON syscolumns.xtype = systypes.xtype
WHERE
    (sysobjects.xtype = 'U')
    and (
        UPPER(syscolumns.name) like upper(@COLUMNA_QDINAM)
    )
ORDER BY
    sysobjects.name,
    syscolumns.colid