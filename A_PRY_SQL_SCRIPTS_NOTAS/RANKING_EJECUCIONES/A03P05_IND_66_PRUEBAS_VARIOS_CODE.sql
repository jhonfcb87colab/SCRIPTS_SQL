SELECT * FROM [dbo].[TRSF_FACT_INDICADORES_RANKING_PASO2] WITH(NOLOCK) WHERE id_indicador=42 AND Id_Regional=8

SELECT * FROM   TRSF_PQR_COMPENSACIONES A  WITH(NOLOCK) WHERE A.id_regional IN(8,9)
SELECT * FROM   PRM_INDICADORES B WITH(NOLOCK) WHERE B.id_indicador=42 
SELECT * FROM   EXTR_IND_METAS_LIMITES C  WITH(NOLOCK) WHERE C.ID_INDICADOR=42 


SELECT * FROM DBO.FACT_INDICADORES_RANKING_BK_FULL_13ABRIL2023 WHERE id_indicador=42 AND Id_Mes IN (202208,202209) AND Id_Regional=8

SELECT * FROM DBO.FACT_INDICADORES_RANKING WHERE id_indicador=42 AND Id_Mes IN (202301) AND Id_Regional=8


-----------------------------------------------------------------------------------------------------------------------------------------------------------



/*

SELECT 
'SELECT A.Id_Mes, A.Id_Regional, B.id_indicador,B.Nombre_Indicador,C.VALOR_META as meta, '
+ rtrim(ltrim(Operador1))
--+ ' - ' 
--+ rtrim(ltrim(Operador2))
+ ' as VREAL, '
+ rtrim(ltrim(Operador2))
+ ' as Valor_ant, case when B.Marca_Meta = 1 then (convert(float,'
+ rtrim(ltrim(Operador1)) + ') /convert(float,c.VALOR_META)) else ' 
+ rtrim(ltrim(Operador1)) + ' end' 
+ ' as Valor, B.Puntos,[dbo].[FN_CALCULO_VALOR] (B.Tipo_Medicion, B.Tipo_Calculo, B.Puntos, c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR, ' 
+ rtrim(ltrim(Operador1))
+', ' 
+ rtrim(ltrim(Operador2))
+ ', B.Umbral_Alto, B.Umbral_Bajo, B.Marca_Meta, c.VALOR_META, B.Marca_Calc_Cumpl) as valor_cumplimiento, B.Puntos * B.Umbral_Alto / 100 as Valor_objetivo, ((B.Umbral_Alto - B.Umbral_Bajo)/B.Umbral_Alto) as Valor_tolerancia,  '
--+'[dbo].[FN_CALCULO_PUNTAJE] (B.Tipo_Medicion, B.Puntos, c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR,'
--+ rtrim(ltrim(Operador1))
--+', ' 
--+ rtrim(ltrim(Operador2))
--+ ', c.VALOR_META, valor_cumplimiento, B.Marca_Puntaje) as puntaje_mes, '
+'c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR, B.Marca_Puntaje, '
+'0 as valor_mes,  '
+'0 as Variacion,  '
+' GETDATE() as fec_actu FROM '
+ rtrim(ltrim(Tabla_Extraccion)) 
+ ' A, PRM_INDICADORES B , EXTR_IND_METAS_LIMITES C '
+ ' where b.id_indicador = c.ID_INDICADOR' 
+ ' and ((C.MARCA_ANO = 1 and CONVERT(INTEGER,(a.ID_mes / 100)) = C.ANIO) or (C.MARCA_ANO = 0 and a.ID_mes = (C.ANIO * 100) + c.MES))'
+ ' and ((C.MARCA_REGIONAL = 1) or (C.MARCA_REGIONAL = 0 and a.Id_Regional = c.ID_REGIONAL_PAIS))'
+ ' and B.ID_INDICADOR = '
+ cast(id_indicador as varchar)
+ ' and '
+ Condicion_Consulta
as Consulta
FROM PRM_INDICADORES  
WHERE id_indicador = 42
--(
--SELECT MIN(id_indicador)
--FROM PRM_INDICADORES  
--WHERE ESTADO = 0
--and Puntos <> 0
--)

*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------



SELECT 
  A.Id_Mes, 
  A.Id_Regional, 
  B.id_indicador, 
  B.Nombre_Indicador, 
  C.VALOR_META as meta, 
  (
    A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
  ) as VREAL, 
  0 as Valor_ant, 
  case when B.Marca_Meta = 1 then (
    convert(
      float, 
      (
        A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
      )
    ) / convert(float, c.VALOR_META)
  ) else (
    A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
  ) end as Valor, 
  B.Puntos, 
  [dbo].[FN_CALCULO_VALOR] (
    B.Tipo_Medicion, 
    B.Tipo_Calculo, 
    B.Puntos, 
    c.VALOR_LIMITE_SUPERIOR, 
    c.VALOR_LIMITE_INFERIOR, 
    (
      A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
    ), 
    0, 
    B.Umbral_Alto, 
    B.Umbral_Bajo, 
    B.Marca_Meta, 
    c.VALOR_META, 
    B.Marca_Calc_Cumpl
  ) as valor_cumplimiento, 
  B.Puntos * B.Umbral_Alto / 100 as Valor_objetivo, 
  (
    (B.Umbral_Alto - B.Umbral_Bajo)/ B.Umbral_Alto
  ) as Valor_tolerancia, 
  c.VALOR_LIMITE_SUPERIOR, 
  c.VALOR_LIMITE_INFERIOR, 
  B.Marca_Puntaje, 
  0 as valor_mes, 
  0 as Variacion, 
  GETDATE() as fec_actu 
FROM 
  TRSF_PQR_COMPENSACIONES A, 
  PRM_INDICADORES B, 
  EXTR_IND_METAS_LIMITES C 
where 
  b.id_indicador = c.ID_INDICADOR 
  and (
    (
      C.MARCA_ANO = 1 
      and CONVERT(
        INTEGER, 
        (a.ID_mes / 100)
      ) = C.ANIO
    ) 
    or (
      C.MARCA_ANO = 0 
      and a.ID_mes = (C.ANIO * 100) + c.MES
    )
  ) 
  and (
    (C.MARCA_REGIONAL = 1) 
    or (
      C.MARCA_REGIONAL = 0 
      and a.Id_Regional = c.ID_REGIONAL_PAIS
    )
  ) 
  and B.ID_INDICADOR = 42 
  and 1 = 1 ---A.META_ESPOLIADOS <> 0


  -----------------------------------------------------------------------------------------------------------------------------------------------------------

  SELECT * FROM  
  TRSF_PQR_COMPENSACIONES A WHERE A.META_ESPOLIADOS = 0

    SELECT A.id_regional
      ,A.id_mes
      ,A.CANTIDAD_ENVIOS_PERDIDOS
      ,A.CANTIDAD_ENVIOS_ESPOLIADOS
      ,A.CANTIDAD_ENVIOS_AVERIADOS
      ,B.CANT_PIEZAS
	  ,((A.CANTIDAD_ENVIOS_PERDIDOS)/(B.CANT_PIEZAS/50000)) AS   META_PERDIDOS
	  ,((A.CANTIDAD_ENVIOS_ESPOLIADOS)/(B.CANT_PIEZAS/50000)) AS META_ESPOLIADOS
	  ,((A.CANTIDAD_ENVIOS_AVERIADOS)/(B.CANT_PIEZAS/50000)) AS  META_AVERIADOS
  FROM EXT_PQR_MOV_EST_FINAL_PQR AS A WITH(NOLOCK)
  INNER JOIN  EXTR_ENVIOS_MOV_DESTINO AS  B WITH(NOLOCK)
	ON A.id_mes = B.id_mes
	AND A.id_regional = B.id_regional

-----------------------------------------------------------------------------------------------------------------------------------------------------------


	SELECT 
'SELECT A.Id_Mes, A.Id_Regional, B.id_indicador,B.Nombre_Indicador,C.VALOR_META as meta, '
+ rtrim(ltrim(Operador1))
--+ ' - ' 
--+ rtrim(ltrim(Operador2))
+ ' as VREAL, '
+ rtrim(ltrim(Operador2))
+ ' as Valor_ant, case when B.Marca_Meta = 1 then (convert(float,'
+ rtrim(ltrim(Operador1)) + ') /convert(float,c.VALOR_META)) else ' 
+ rtrim(ltrim(Operador1)) + ' end' 
+ ' as Valor, B.Puntos,[dbo].[FN_CALCULO_VALOR] (B.Tipo_Medicion, B.Tipo_Calculo, B.Puntos, c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR, ' 
+ rtrim(ltrim(Operador1))
+', ' 
+ rtrim(ltrim(Operador2))
+ ', B.Umbral_Alto, B.Umbral_Bajo, B.Marca_Meta, c.VALOR_META, B.Marca_Calc_Cumpl) as valor_cumplimiento, B.Puntos * B.Umbral_Alto / 100 as Valor_objetivo, ((B.Umbral_Alto - B.Umbral_Bajo)/B.Umbral_Alto) as Valor_tolerancia,  '
--+'[dbo].[FN_CALCULO_PUNTAJE] (B.Tipo_Medicion, B.Puntos, c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR,'
--+ rtrim(ltrim(Operador1))
--+', ' 
--+ rtrim(ltrim(Operador2))
--+ ', c.VALOR_META, valor_cumplimiento, B.Marca_Puntaje) as puntaje_mes, '
+'c.VALOR_LIMITE_SUPERIOR, c.VALOR_LIMITE_INFERIOR, B.Marca_Puntaje, '
+'0 as valor_mes,  '
+'0 as Variacion,  '
+' GETDATE() as fec_actu FROM '
+ rtrim(ltrim(Tabla_Extraccion)) 
+ ' A, PRM_INDICADORES B , EXTR_IND_METAS_LIMITES C '
+ ' where b.id_indicador = c.ID_INDICADOR' 
+ ' and ((C.MARCA_ANO = 1 and CONVERT(INTEGER,(a.ID_mes / 100)) = C.ANIO) or (C.MARCA_ANO = 0 and a.ID_mes = (C.ANIO * 100) + c.MES))'
+ ' and ((C.MARCA_REGIONAL = 1) or (C.MARCA_REGIONAL = 0 and a.Id_Regional = c.ID_REGIONAL_PAIS))'
+ ' and B.ID_INDICADOR = '
+ cast(id_indicador as varchar)
+ ' and '
+ Condicion_Consulta
as Consulta
FROM PRM_INDICADORES  
WHERE id_indicador = 42
--(
--SELECT MIN(id_indicador)
--FROM PRM_INDICADORES  
--WHERE ESTADO = 0
--and Puntos <> 0
--)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Condicion_Consulta,* FROM PRM_INDICADORES  WHERE id_indicador IN(41,42)

1=1---A.META_ESPOLIADOS <> 0

-----------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT 
  A.Id_Mes, 
  A.Id_Regional, 
  B.id_indicador, 
  B.Nombre_Indicador, 
  C.VALOR_META as meta, 
  A.CE_ENTREGA_VERIFICADA /(
    A.CE_SALIDA_ZONA_URBANA - A.CE_REVERSION_PROCESO_OPERATIVO
  ) as VREAL, 
  0 as Valor_ant, 
  case when B.Marca_Meta = 1 then (
    convert(
      float, 
      A.CE_ENTREGA_VERIFICADA /(
        A.CE_SALIDA_ZONA_URBANA - A.CE_REVERSION_PROCESO_OPERATIVO
      )
    ) / convert(float, c.VALOR_META)
  ) else A.CE_ENTREGA_VERIFICADA /(
    A.CE_SALIDA_ZONA_URBANA - A.CE_REVERSION_PROCESO_OPERATIVO
  ) end as Valor, 
  B.Puntos, 
  [dbo].[FN_CALCULO_VALOR] (
    B.Tipo_Medicion, 
    B.Tipo_Calculo, 
    B.Puntos, 
    c.VALOR_LIMITE_SUPERIOR, 
    c.VALOR_LIMITE_INFERIOR, 
    A.CE_ENTREGA_VERIFICADA /(
      A.CE_SALIDA_ZONA_URBANA - A.CE_REVERSION_PROCESO_OPERATIVO
    ), 
    0, 
    B.Umbral_Alto, 
    B.Umbral_Bajo, 
    B.Marca_Meta, 
    c.VALOR_META, 
    B.Marca_Calc_Cumpl
  ) as valor_cumplimiento, 
  B.Puntos * B.Umbral_Alto / 100 as Valor_objetivo, 
  (
    (B.Umbral_Alto - B.Umbral_Bajo)/ B.Umbral_Alto
  ) as Valor_tolerancia, 
  c.VALOR_LIMITE_SUPERIOR, 
  c.VALOR_LIMITE_INFERIOR, 
  B.Marca_Puntaje, 
  0 as valor_mes, 
  0 as Variacion, 
  GETDATE() as fec_actu 
FROM 
  EXTR_MOV_POR_PROC_PROD A, 
  PRM_INDICADORES B, 
  EXTR_IND_METAS_LIMITES C 
where 
  b.id_indicador = c.ID_INDICADOR 
  and (
    (
      C.MARCA_ANO = 1 
      and CONVERT(
        INTEGER, 
        (a.ID_mes / 100)
      ) = C.ANIO
    ) 
    or (
      C.MARCA_ANO = 0 
      and a.ID_mes = (C.ANIO * 100) + c.MES
    )
  ) 
  and (
    (C.MARCA_REGIONAL = 1) 
    or (
      C.MARCA_REGIONAL = 0 
      and a.Id_Regional = c.ID_REGIONAL_PAIS
    )
  ) 
  and B.ID_INDICADOR = 23 
  and A.CE_SALIDA_ZONA_URBANA - A.CE_REVERSION_PROCESO_OPERATIVO <> 0




  -----------------------------------------------------------------------------------------------------------------------------------------------------------




  SELECT 
  A.Id_Mes, 
  A.Id_Regional, 
  B.id_indicador, 
  B.Nombre_Indicador, 
  C.VALOR_META as meta, 
  (
    A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
  ) as VREAL, 
  0 as Valor_ant, 
  case when B.Marca_Meta = 1 then (
    convert(
      float, 
      (
        A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
      )
    ) / convert(float, c.VALOR_META)
  ) else (
    A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
  ) end as Valor, 
  B.Puntos, 
  [dbo].[FN_CALCULO_VALOR] (
    B.Tipo_Medicion, 
    B.Tipo_Calculo, 
    B.Puntos, 
    c.VALOR_LIMITE_SUPERIOR, 
    c.VALOR_LIMITE_INFERIOR, 
    (
      A.CANTIDAD_ENVIOS_ESPOLIADOS /(A.CANT_PIEZAS / 50000)
    ), 
    0, 
    B.Umbral_Alto, 
    B.Umbral_Bajo, 
    B.Marca_Meta, 
    c.VALOR_META, 
    B.Marca_Calc_Cumpl
  ) as valor_cumplimiento, 
  B.Puntos * B.Umbral_Alto / 100 as Valor_objetivo, 
  (
    (B.Umbral_Alto - B.Umbral_Bajo)/ B.Umbral_Alto
  ) as Valor_tolerancia, 
  c.VALOR_LIMITE_SUPERIOR, 
  c.VALOR_LIMITE_INFERIOR, 
  B.Marca_Puntaje, 
  0 as valor_mes, 
  0 as Variacion, 
  GETDATE() as fec_actu 
FROM 
  TRSF_PQR_COMPENSACIONES A, 
  PRM_INDICADORES B, 
  EXTR_IND_METAS_LIMITES C 
where 
  b.id_indicador = c.ID_INDICADOR 
  and (
    (
      C.MARCA_ANO = 1 
      and CONVERT(
        INTEGER, 
        (a.ID_mes / 100)
      ) = C.ANIO
    ) 
    or (
      C.MARCA_ANO = 0 
      and a.ID_mes = (C.ANIO * 100) + c.MES
    )
  ) 
  and (
    (C.MARCA_REGIONAL = 1) 
    or (
      C.MARCA_REGIONAL = 0 
      and a.Id_Regional = c.ID_REGIONAL_PAIS
    )
  ) 
  and B.ID_INDICADOR = 42 
  --and A.META_ESPOLIADOS <> 0





  --select * from DIM_GEOGRAFIA_RANKING order by 2 







    -----------------------------------------------------------------------------------------------------------------------------------------------------------

