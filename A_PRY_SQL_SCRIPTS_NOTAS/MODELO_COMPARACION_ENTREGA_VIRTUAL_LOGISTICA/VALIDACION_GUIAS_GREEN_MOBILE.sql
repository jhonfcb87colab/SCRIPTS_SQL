USE Pruebas_Entrega_Nacional;



/*
SEGUINDO QUERY
Sql.Database("SERV-DBSERVI01\SQL04", "Pruebas_Entrega_Nacional"
************************************************************************************************
************************Guías Reportado Entregado Virtual************************
************************************************************************************************
*/

SELECT * FROM Pruebas_Entrega_Nacional..PRUEBAS_ENTREGA (NOLOCK) WHERE FECHA_DIGITALIZACION >'2022-11-27'





/*
TERCER QUERY
Sql.Database("SERV-DBSERVI01\SQL04", "Pruebas_Entrega_Nacional", 
************************************************************************************************
************************Guías Sin Procesar************************
************************************************************************************************
*/

SELECT *
FROM Pruebas_Entrega_Nacional..PRUEBAS_ENTREGA_VIRTUAL_TMP (NOLOCK) WHERE FECHA_CREACION>'2022-11-27'
AND GENERO_PRUEBA = 0


