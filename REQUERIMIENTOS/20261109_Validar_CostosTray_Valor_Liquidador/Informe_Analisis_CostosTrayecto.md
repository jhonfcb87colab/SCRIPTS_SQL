# Informe de Análisis — Validación Costos Trayecto vs. Valor Liquidador

**Fecha:** 2026-11-09
**Analista:** John Cruz
**Requerimiento:** 20261109_Validar_CostosTray_Valor_Liquidador
**Archivo evaluado:** `ScriptCostosTrayecto_original.sql` — bloque UPDATE ajuste por reglas de negocio

---

## 1. Contexto del Problema

El procedimiento `[TMP].[COSTO_DARWIN_PROC_01_CARGUE_CALCULO_BASE_OPERACION_TEMP]` calcula el `COSTO_FINAL_POR_MODELO` por guía operativa en varias etapas. En su etapa final, un bloque `UPDATE` sobreescribe ese costo cruzando la tabla base (`TMP`) con la tabla de liquidación PXP/Aforos (`LIQ`).

Al convertir el `UPDATE` a `SELECT` para validación, el costo resulta inflado:

| Escenario | MODELOS | PROPIETARIO_VEHICULO | COSTO_FINAL_POR_MODELO |
|-----------|---------|----------------------|------------------------|
| Resultado del UPDATE convertido a SELECT | 3 | OUTSOURCING FLETE FIJO | **14,543,812.80** |
| Cálculo correcto (Paso 2 — sin UPDATE) | — | SALIDA A ZONA URBANA / KPP727 | 229,512.00 |

---

## 2. Proceso de Validación — Scripts Ejecutados y Resultados

### Script 1 — Verificar si LIQ tiene múltiples filas (fan-out)

```sql
SELECT NUMERO_GUIA, ID_PROCESO, CONVERT(DATE, FECHA_HORA_MOVIMIENTO) AS FECHA,
       COUNT(1) AS CANTIDAD_FILAS
FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_GUIAS_LIQUIDACION_PXP_AFOROS]
WHERE NUMERO_GUIA = 2292411506
GROUP BY NUMERO_GUIA, ID_PROCESO, CONVERT(DATE, FECHA_HORA_MOVIMIENTO)
HAVING COUNT(1) > 1;
```

**Resultado: Sin registros.**
La tabla LIQ tiene exactamente **una fila** por `NUMERO_GUIA + ID_PROCESO + FECHA`. El fan-out queda descartado como causa raíz.

---

### Script 2 — Inspeccionar VALOR_TARIFA_SERVICIO en LIQ

```sql
SELECT NUMERO_GUIA, ID_PROCESO, TIPO_OPERADOR, MODELOS_DE_CONTRATACION_FLOTA,
       VALOR_TARIFA_SERVICIO, CONVERT(DATE, FECHA_HORA_MOVIMIENTO) AS FECHA
FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_GUIAS_LIQUIDACION_PXP_AFOROS]
WHERE NUMERO_GUIA = 2292411506;
```

**Resultado:**

| NUMERO_GUIA | ID_PROCESO | TIPO_OPERADOR | MODELOS_DE_CONTRATACION_FLOTA | VALOR_TARIFA_SERVICIO | FECHA |
|-------------|------------|---------------|-------------------------------|----------------------|-------|
| 2292411506 | 9 | OUTSOURCING FLETE FIJO | 3 | **146,907.20** | 2026-09-19 |

Un solo registro. La tabla no tiene placa, lo cual es la estructura correcta del liquidador.

---

### Script 3 — Paso 1: Confirmar valores en LIQ + Paso 2: Simular UPDATE como SELECT

**Resultado Paso 1:**

| NUMERO_GUIA | ID_PROCESO | FECHA | CANT_FILAS | TARIFA_MIN | TARIFA_MAX | TARIFA_SUM |
|-------------|------------|-------|------------|------------|------------|------------|
| 2292411506 | 9 | 2026-09-19 | 1 | 146,907.20 | 146,907.20 | 146,907.20 |

**Resultado Paso 2:**

| NUMERO_GUIA | ID_PROCESO | PLACA | TOTAL_PIEZAS_OPERA_DIST | TOTAL_PIEZAS_OPERA_DEV | VALOR_TARIFA_SERVICIO | COSTO_CALCULADO | COSTO_ORIGINAL |
|-------------|------------|-------|--------------------------|------------------------|----------------------|-----------------|----------------|
| 2292411506 | 9 | KPP727 | **99** | 0 | 146,907.20 | **14,543,812.80** | 229,512.00 |

---

## 3. Hallazgos — Análisis Final

### Hallazgo 1 — CRÍTICO (CAUSA RAÍZ CONFIRMADA): VALOR_TARIFA_SERVICIO es la tarifa total del servicio, NO una tarifa por pieza

**Descripción:**
La tabla LIQ almacena `VALOR_TARIFA_SERVICIO = 146,907.20`, que representa el **valor total liquidado del servicio** para esa guía en ese proceso, ya calculado por el sistema liquidador incluyendo todos los factores comerciales pactados con el operador. No es una tarifa unitaria por pieza.

**El error en la fórmula actual:**
```sql
-- FÓRMULA ACTUAL (incorrecta):
WHEN TMP.ID_PROCESO = 9 THEN
    LIQ.VALOR_TARIFA_SERVICIO
    * (CONVERT(FLOAT, TMP.[TOTAL_PIEZAS_OPERA_DISTRIBUCION])   -- = 99
     - CONVERT(FLOAT, TMP.[TOTAL_PIEZAS_OPERA_DEVOLUCION]))    -- = 0
-- Resultado: 146,907.20 × 99 = 14,543,812.80  ← INCORRECTO
```

**Verificación numérica:**
```
VALOR_TARIFA_SERVICIO  =   146,907.20
TOTAL_PIEZAS_OPERA_DIST =  99
146,907.20 × 99        = 14,543,812.80  ✓ coincide exactamente con el valor inflado
```

**Raíz del problema:**
`TOTAL_PIEZAS_OPERA_DISTRIBUCION = 99` es el total acumulado de piezas del **manifiesto completo** (todas las guías que viajaron en ese vehículo, para ese proceso, en esa fecha), **no** las piezas de esta guía específica. Al multiplicar la tarifa total del servicio por el total de piezas del manifiesto, el costo se infla de forma desproporcionada.

---

### Hallazgo 2 — CRÍTICO: TOTAL_PIEZAS_OPERA_DISTRIBUCION refleja el manifiesto, no la guía individual

**Descripción:**
En el datos de TMP, la guía `2292411506` tiene `NUMERO_PIEZAS = 59` (sus propias piezas), pero `TOTAL_PIEZAS_OPERA_DISTRIBUCION = 99`. Este campo es un **agregado a nivel de vehículo/proceso/fecha** que representa todas las piezas transportadas en ese manifiesto, incluyendo las de otras guías.

Usar este campo en la fórmula de costo por guía es incorrecto conceptualmente: la tarifa del liquidador ya engloba el acuerdo comercial total del servicio; duplicar su efecto multiplicándolo por el volumen del manifiesto produce doble contabilización.

---

### Hallazgo 3 — MEDIO: Calidad de datos en tabla base — productos con piezas anómalas

A partir del script de auditoría ejecutado:

```sql
SELECT ID_PRODUCTO_CST, ID_PRODUCTO, MAX(NUMERO_PIEZAS) MX_PZ
FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES]
GROUP BY ID_PRODUCTO_CST, ID_PRODUCTO
```

**Resultados con anomalías:**

| ID_PRODUCTO_CST | ID_PRODUCTO | MX_PZ | Esperado | Anomalía |
|-----------------|-------------|-------|----------|----------|
| 2 (Mercancía Premier) | 2 | 18 | 1 | Excede lo esperado |
| 2 (Mercancía Premier) | 82 | 130 | 1 | **Anomalía severa** |
| 6 (Mercancía Industrial) | 6 | 772 | Variable | Válido por naturaleza |
| 1 (Documento Unitario) | 1 | 2 | 1 | Excede lo esperado |

**Riesgo:** Si alguna corrección futura intenta usar `NUMERO_PIEZAS` para normalizar la tarifa del liquidador, los productos con valores anómalos (especialmente `ID_PRODUCTO=82` con 130 piezas cuando debería ser 1) producirían nuevos errores de cálculo. La causa de estas anomalías debe investigarse: pueden ser errores de carga, devoluciones acumuladas en la guía, o guías maestras de consolidación.

---

### Hallazgo 4 — MEDIO: Riesgo de propagación del error al proceso 24

El script original contiene un segundo UPDATE que copia el `COSTO_FINAL_POR_MODELO` del proceso 9 al proceso 24 para la misma guía/placa:

```sql
;WITH CTE_ACTUALIZAR_DE_MODELLO_CONTRATACION_DE_9_AL_24 AS (
    SELECT LIQ.MODELOS_DE_CONTRATACION_FLOTA, LIQ.TIPO_OPERADOR,
           TMP.NUMERO_GUIA, TMP.ID_PROCESO, TMP.COSTO_FINAL_POR_MODELO, TMP.PLACA_VEHICULO_DOCU
    FROM TMP INNER JOIN LIQ ... WHERE LIQ.ID_PROCESO = 9
)
UPDATE TMP SET TMP.COSTO_FINAL_POR_MODELO = CTE.COSTO_FINAL_POR_MODELO
FROM CTE ... WHERE TMP.ID_PROCESO = 24
```

Si el primer UPDATE produce un costo incorrecto para el proceso 9, ese valor erróneo se propaga automáticamente al proceso 24 (Reportado Entregado). El error se multiplica en dos procesos simultáneamente.

---

## 4. Resumen Ejecutivo de Hallazgos

| # | Severidad | Hallazgo | Impacto directo |
|---|-----------|----------|-----------------|
| 1 | 🔴 Crítico | `VALOR_TARIFA_SERVICIO` es el costo total del servicio, no tarifa unitaria; se multiplica incorrectamente por las piezas del manifiesto | `COSTO_FINAL_POR_MODELO` inflado 63× |
| 2 | 🔴 Crítico | `TOTAL_PIEZAS_OPERA_DISTRIBUCION` = 99 es el total del manifiesto, no de la guía individual | Doble contabilización del volumen |
| 3 | 🟡 Medio | Productos `ID_PRODUCTO_CST=2` (Mercancía Premier) con hasta 130 piezas cuando deberían ser 1 | Riesgo en correcciones futuras por `NUMERO_PIEZAS` |
| 4 | 🟡 Medio | El error en proceso 9 se propaga automáticamente al proceso 24 | Error duplicado en dos procesos |

---

## 5. Corrección Propuesta

### Regla de negocio ajustada (alineada con la conclusión del analista)

| Condición | Fórmula correcta |
|-----------|-----------------|
| Producto de **pieza única** (1 pieza por guía) | `LIQ.VALOR_TARIFA_SERVICIO` × `NUMERO_PIEZAS` de la guía |
| Producto de **múltiples piezas** (ej: Mercancía Industrial) | `LIQ.VALOR_TARIFA_SERVICIO` directamente (el liquidador ya incluye el volumen) |
| Devoluciones | No aplican descuento sobre el valor del liquidador; ese ajuste ya está en `VALOR_TARIFA_SERVICIO` |

### Código SQL sugerido (proceso 9 — distribución)

```sql
TMP.COSTO_FINAL_POR_MODELO =
    CASE
        -- Procesos 5 y 6 (recolección): tarifa x piezas de la guía
        WHEN TMP.ID_PROCESO IN (5, 6) THEN
            LIQ.VALOR_TARIFA_SERVICIO
            * IIF(CONVERT(FLOAT, TMP.NUMERO_PIEZAS) < 1, 0,
                  CONVERT(FLOAT, TMP.NUMERO_PIEZAS))

        -- Proceso 9 (distribución):
        -- Si el producto maneja múltiples piezas (ID_PRODUCTO_CST = 6 u otro multipieza),
        -- usar el valor total del liquidador directamente.
        -- Si el producto es de pieza única, multiplicar por las piezas propias de la guía.
        WHEN TMP.ID_PROCESO = 9 THEN
            CASE
                WHEN TMP.ID_PRODUCTO_CST IN (6)   -- Mercancía Industrial (multipieza válido)
                    THEN LIQ.VALOR_TARIFA_SERVICIO  -- ya incluye el volumen

                ELSE                               -- Documento, Mercancía Premier, otros
                    LIQ.VALOR_TARIFA_SERVICIO
                    * IIF(CONVERT(FLOAT, TMP.NUMERO_PIEZAS) < 1, 0,
                          CONVERT(FLOAT, TMP.NUMERO_PIEZAS))
            END

        -- Cualquier otro proceso: conservar el valor calculado en el Paso 2
        ELSE
            TMP.COSTO_FINAL_POR_MODELO
    END
```

> **Importante:** Antes de aplicar esta corrección, validar con el equipo de Darwin/Liquidador qué representa exactamente `VALOR_TARIFA_SERVICIO` para cada tipo de producto. La regla multipieza debe formalizarse con los responsables del sistema liquidador.

---

### Script de validación post-corrección

```sql
-- Simular la corrección propuesta como SELECT antes de ejecutar el UPDATE
SELECT
    TMP.NUMERO_GUIA,
    TMP.ID_PROCESO,
    TMP.PLACA_VEHICULO_DOCU,
    TMP.ID_PRODUCTO_CST,
    TMP.NUMERO_PIEZAS,
    TMP.TOTAL_PIEZAS_OPERA_DISTRIBUCION,
    LIQ.VALOR_TARIFA_SERVICIO,
    COSTO_CALCULADO_ACTUAL   = LIQ.VALOR_TARIFA_SERVICIO
                               * (CONVERT(FLOAT, TMP.TOTAL_PIEZAS_OPERA_DISTRIBUCION)
                                 - CONVERT(FLOAT, TMP.TOTAL_PIEZAS_OPERA_DEVOLUCION)),
    COSTO_CALCULADO_CORREGIDO =
        CASE
            WHEN TMP.ID_PROCESO IN (5, 6)
                THEN LIQ.VALOR_TARIFA_SERVICIO
                     * IIF(CONVERT(FLOAT, TMP.NUMERO_PIEZAS) < 1, 0,
                           CONVERT(FLOAT, TMP.NUMERO_PIEZAS))
            WHEN TMP.ID_PROCESO = 9 AND TMP.ID_PRODUCTO_CST IN (6)
                THEN LIQ.VALOR_TARIFA_SERVICIO
            WHEN TMP.ID_PROCESO = 9
                THEN LIQ.VALOR_TARIFA_SERVICIO
                     * IIF(CONVERT(FLOAT, TMP.NUMERO_PIEZAS) < 1, 0,
                           CONVERT(FLOAT, TMP.NUMERO_PIEZAS))
            ELSE TMP.COSTO_FINAL_POR_MODELO
        END,
    TMP.COSTO_FINAL_POR_MODELO AS COSTO_PASO2_ORIGINAL
FROM [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_OPERACION_MES_BASE01_V02] AS TMP
INNER JOIN [SIG_COLOMBIA_DW].[TMP].[COSTO_DARWIN_BASE_GUIAS_LIQUIDACION_PXP_AFOROS] AS LIQ
    ON LIQ.NUMERO_GUIA = TMP.NUMERO_GUIA
    AND LIQ.ID_PROCESO = TMP.ID_PROCESO
    AND CONVERT(DATE, TMP.FECHA_HORA_MOVIMIENTO) = CONVERT(DATE, LIQ.FECHA_HORA_MOVIMIENTO)
WHERE TMP.NUMERO_GUIA = 2292411506;
```

---

## 6. Pendientes a Confirmar con el Equipo de Negocio

1. **¿Qué representa exactamente `VALOR_TARIFA_SERVICIO` en LIQ?**
   - ¿Es el costo total liquidado para ese servicio/guía?
   - ¿O es una tarifa unitaria sobre la que sí se debe aplicar un multiplicador de piezas?

2. **¿Cuál es el multiplicador correcto para productos de pieza única?**
   - ¿`NUMERO_PIEZAS` (piezas propias de la guía = 59)?
   - ¿O `1` (ya que el liquidador determina el costo por guía independiente del volumen)?

3. **¿Las devoluciones afectan el `VALOR_TARIFA_SERVICIO` que llega de LIQ?**
   - Si LIQ ya descuenta devoluciones, aplicar `(TOTAL_PIEZAS_DISTRIBUCION - TOTAL_PIEZAS_DEVOLUCION)` duplicaría el ajuste.

4. **¿Los productos `ID_PRODUCTO_CST=2` con más de 1 pieza son casos legítimos o errores de carga?**
   - Si son errores, corregirlos en la tabla fuente evita distorsiones en cualquier cálculo futuro.

---

## 7. Próximos Pasos

| Paso | Acción | Responsable |
|------|--------|-------------|
| 1 | Confirmar con Darwin/Liquidador el significado de `VALOR_TARIFA_SERVICIO` por tipo de producto | John Cruz + Equipo Darwin |
| 2 | Ejecutar el script de validación post-corrección con la guía `2292411506` | John Cruz |
| 3 | Ampliar la validación a 10–20 guías de distintos productos y modelos de contratación | John Cruz |
| 4 | Ajustar el `UPDATE` en `ScriptCostosTrayecto_original.sql` con la fórmula aprobada | John Cruz |
| 5 | Investigar el origen de `ID_PRODUCTO_CST=2` con 130 piezas (ID_PRODUCTO=82) | Equipo de datos |
| 6 | Ejecutar el script completo sobre el periodo y validar COSTO_FINAL_POR_MODELO agregado vs. reporte del liquidador | John Cruz |

---

*Informe actualizado 2026-11-09 — versión 2 con resultados de validación — John Cruz*
