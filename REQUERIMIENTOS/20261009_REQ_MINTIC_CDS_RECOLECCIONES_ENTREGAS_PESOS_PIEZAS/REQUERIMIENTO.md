
## REQUERIMIENTO DE DARWIN AGREGAR NUEVA TABLA A AL DASHBOARD DE MINTIC `Informe MINTIC - Análisis Comportamiento`
* https://app.powerbi.com/groups/3edfecdb-c7f7-45f8-9afd-757086e67b5e/reports/1c5e0cb2-ea3d-49b7-8264-a55bdf8cd2e0/097669e727ccb6b20d20?experience=power-bi
* Quiero tener en esa tabla el radas de las operaciones de recolección y de distribución de los CDS directos e indirectos (que no les pagamos PPES), creerpia que esto ultimo no existe
* Busco una tabla con una estructura muy similar a la de PPES
 
#### **CDS_Comision_Distri_Recol**
 
# Se solicta tabla similar a esta:

| AÑO_MES | DEPARTAMENTO_CDS | CODIGO_CDS | NOMBRE_CIUDAD_CDS | CODIGO_DANE_CIUDAD_CDS | NOMBRE_CDS      | NUMERO_GUIA | FECHA           | FECHA_LIQUIDACION | VALOR_COMISION | TIPO_COMISION | DESCRIPCION_COMISION           | TIPO_CANAL | KeyComisiones_Tabla | NUMERO_PIEZAS |
| ------- | ---------------- | ---------- | ----------------- | ---------------------- | --------------- | ----------- | --------------- | ----------------- | -------------: | ------------- | ------------------------------ | ---------- | ------------------- | ------------: |
| 2026-06 | CUNDINAMARCA     | 398008     | GACHANCIPA        | 25295000               | GACHANCIPA CL 5 | 2291348473  | 16/06/2026 9:07 | 26/06/2026 7:11   |           2000 | DISTRIBUCION  | DISTRIBUCION ENTREGA DOMICILIO | INDIRECTO  | 2026-06-398008      |             1 |

###### ---> quiero todos los CDS que no están en `PPES`, es decir a los que les pagamos por `recoger y entregar`
###### ----> esa tabla nueva debe ser idéntica a esta pero con los CDS que hacen RO y no se les paga por hacer eso. `principalmente son los CDS directos` 
###### -----> ponga el CDS de avenida sexta que supongo recoge y entrega. (no es venta del punto), recoge de terceros y entrega de terceros


* NO es duplicar la tabla que ya existe, es decir si en la tabla actual aparece el cds 123 pues ese no puede aparecer en la tabla nueva. o es la una o es la otra pero no en ambas
* No, agregue la tabla, al PBI actual. yo la relaciono y ajustos unas medidas y unos visuales y le aviso para que me ayude a cargar nuevamente