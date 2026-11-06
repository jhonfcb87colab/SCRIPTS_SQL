USE SSISDB

SELECT * FROM SSISDB.catalog.operations (nolock) 
WHERE operation_id IN (10984117,10954149); 	
SELECT * FROM SSISDB.catalog.operation_messages (nolock) 
WHERE operation_id IN (10984117,10954149);


/*
PROCESO DIMENSIONES ZONAS GEO:Error: Errors in the metadata manager. Either the 
database with the ID of 'SIG_COL_LOGISTICA_ZONAS' does not exist in the server with the ID of 'SERV-DBI01', or the user does not have permissions to access the object.
*/


