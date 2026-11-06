


/*
CORRECCIONES A REALIZAR

Revisar Guías que si tienen prueba de imagen digitalizada 2168686027, 2129036359
Guías procesadas: Guías avaladas sin digitalizar 
Agregar Tarjeta  comparativo Guías Con entrega verificada 
Corregir  la fecha digitalización 
Fecha que mira el cliente FECHA_HORA_MOVIMI
Organizar Tarjetas  de numero de GUIAS: 
----Total Guías entrega verificada 
----Guias Digitalizadas
----Guias 


Ajustar Grafico  de barras  fecha solo deja acumulado en un dia (Validar fecha que esta tomando)
Comparativo Guias entrega verificada Vs Guias Digitalizadas:

Aplicar DrillTrough en las tarjetas

*/



SELECT TOP 10 TIPO_PRUEBA_ENTREGA FROM MECE_LOGISTICO..SEGUIMIENTO_ENVIO_INF_ADICIONAL_MOVIL (NOLOCK)
 WHERE TIPO_PRUEBA_ENTREGA NOT IN (2,1,0)	

