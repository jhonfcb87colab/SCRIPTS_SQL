

ALTER DATABASE ACCCES_DARWIN SET RECOVERY SIMPLE;
GO

-- Truncar el log
DBCC SHRINKFILE (ACCES_DARWIN_log, 1); -- Asegúrate de usar el nombre lógico correcto

-- Luego, si lo necesitas, vuelve a FULL
ALTER DATABASE ACCCES_DARWIN SET RECOVERY FULL;

