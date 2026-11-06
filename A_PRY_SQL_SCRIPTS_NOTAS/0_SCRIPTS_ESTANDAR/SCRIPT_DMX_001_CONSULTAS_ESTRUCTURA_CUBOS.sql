
/*

SE DEBE EJECUTAR EN DMX  EN ANALYSIS SERVICE

*/

SELECT 
    [CATALOG_NAME],
    [CUBE_NAME],
    [LAST_DATA_UPDATE],
    [LAST_SCHEMA_UPDATE]
FROM $system.MDSCHEMA_CUBES
 
SELECT 
[base_cube_name] as [Base],
    [CATALOG_NAME] AS [Nombre del Catálogo],
    [CUBE_NAME] AS [Nombre del Cubo],
    [LAST_DATA_UPDATE] AS [Última Actualización de Datos],*
FROM $system.MDSCHEMA_CUBES
 
 
select * from $system.MDSCHEMA_DIMENSIONS
 
select * from $system.MDSCHEMA_DIMENSIONS
select * from $system.MDSCHEMA_HIERARCHIES
select * from $system.MDSCHEMA_MEASURES
select * from $system.MDSCHEMA_MEMBERS
select * from $system.MDSCHEMA_LEVELS
select * from $system.MDSCHEMA_SETS
select * from $system.MDSCHEMA_FUNCTIONS