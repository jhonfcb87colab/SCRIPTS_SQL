EXEC sp_MSforeachdb '
USE [?];
IF DB_ID() NOT IN (1,2,3,4) -- Excluye master, tempdb, model, msdb
BEGIN
    PRINT ''Base de datos: [?]'';
    SELECT 
        DB_NAME() AS DatabaseName,
        s.name AS SchemaName,
        t.name AS TableName,
        p.rows AS RowCounts,
        CAST((SUM(a.total_pages) * 8.0 / 1024) AS DECIMAL(18,2)) AS TotalMB,
        CAST((SUM(a.used_pages) * 8.0 / 1024) AS DECIMAL(18,2)) AS UsedMB,
        CAST((SUM(a.data_pages) * 8.0 / 1024) AS DECIMAL(18,2)) AS DataMB
    FROM 
        sys.tables t
    INNER JOIN      
        sys.indexes i ON t.object_id = i.object_id
    INNER JOIN 
        sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN 
        sys.allocation_units a ON p.partition_id = a.container_id
    INNER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        t.is_ms_shipped = 0
    GROUP BY 
        t.name, s.name, p.rows
    ORDER BY 
        TotalMB DESC;
END
'