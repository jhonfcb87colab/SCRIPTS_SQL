
USE SIG_COLOMBIA_DW; 
GO

SELECT * from sys.database_files
WHERE physical_name LIKE '%F:\%'

DECLARE @FilegroupName SYSNAME = 'PRIMARY'; 

-- Obtener tablas e índices asociados al filegroup, junto con el espacio utilizado
SELECT 
    s.name AS Esquema,
    o.name AS Tabla,
    i.name AS NombreIndice,
    i.type_desc AS TipoIndice,
    fg.name AS Filegroup,
    ds.name AS DataSpace,
    CASE 
        WHEN i.index_id <= 1 THEN 'Datos base (HEAP o CLUSTERED)'
        ELSE 'Índice secundario'
    END AS Uso,
    SUM(au.total_pages) * 8 / 1024.0 AS Espacio_MB
FROM 
    sys.indexes i
    INNER JOIN sys.objects o ON i.object_id = o.object_id
    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
    INNER JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
    INNER JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units au ON p.partition_id = au.container_id
WHERE 
    fg.name = @FilegroupName
    AND o.type = 'U' -- Tablas de usuario
GROUP BY 
    s.name, o.name, i.name, i.type_desc, fg.name, ds.name, i.index_id
ORDER BY 
    Espacio_MB DESC;