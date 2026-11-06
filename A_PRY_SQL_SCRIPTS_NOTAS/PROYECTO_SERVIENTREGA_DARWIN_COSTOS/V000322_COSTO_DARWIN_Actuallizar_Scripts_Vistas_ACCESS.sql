--USE [ACCES_DARWIN]
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE VIEW [dbo].[VW_B_OP_PromedioPreliminar_PorPlaca]
--AS
----B_OP_PromedioPreliminar_PorPlaca:
---- Nueva vista  requerimientos de darwin 202608926
--SELECT CO_OP.Placa, 
--Avg(CO_OP.[Val Facturado Remesa]) AS PromPrelim
--FROM [dbo].[CO_SOURCING_OPERATIVOS] CO_OP
--WHERE (((Year([Fecha Manifiesto]))=(SELECT Max(Year([Fecha Manifiesto])) FROM [dbo].[CO_SOURCING_OPERATIVOS])))
--GROUP BY CO_OP.Placa;
--GO


--USE [ACCES_DARWIN]
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE VIEW [dbo].[VW_2C_OP_Excepciones_A_Revisar]
--AS
----2C_OP_Excepciones_A_Revisar:
---- Nueva vista  requerimientos de darwin 202608926
--SELECT 
--D.Placa, 
--D.[Fecha Manifiesto], 
--D.[Val Facturado Remesa], 
--P.PromPrelim, 
--Round(D.[Val Facturado Remesa]/P.PromPrelim,1) AS VecesSobrePromedio
--FROM [dbo].[CO_SOURCING_OPERATIVOS] AS D 
--INNER JOIN [dbo].[VW_B_OP_PromedioPreliminar_PorPlaca] AS P ON D.Placa = P.Placa
--WHERE (((D.[Val Facturado Remesa])>3*[P].[PromPrelim]) 
--AND ((Year([D].[Fecha Manifiesto]))=(
--                                        SELECT Max(Year([Fecha Manifiesto])) FROM [dbo].[CO_SOURCING_OPERATIVOS]
--                                        )));
--GO

/*
--[dbo].[VW_COSOURCING2C_Costos_Fletes_Operativos_Por_Placa]
---> AJUSTE requerido por darwin se reduce el numero de registros y se agrega una nueva columna 
SELECT D.Placa, 
Round(Avg(D.[Val Facturado Remesa]),0) AS [Costo_Co-Sourcing_Operativos], 
Count(1) AS [Registros Usados]
FROM [dbo].[CO_SOURCING_OPERATIVOS] AS D 
LEFT JOIN [dbo].[VW_2C_OP_Excepciones_A_Revisar] AS E 
ON (D.Placa = E.Placa) AND (D.[Fecha Manifiesto] = E.[Fecha Manifiesto]) 
AND (D.[Val Facturado Remesa] = E.[Val Facturado Remesa])
WHERE (((E.Placa) Is Null) 
AND ((Year([D].[Fecha Manifiesto]))=(
                                    SELECT Max(Year([Fecha Manifiesto])) FROM [dbo].[CO_SOURCING_OPERATIVOS]))
                                    )
GROUP BY D.Placa;
--SELECT * FROM [dbo].[VW_COSOURCING2C_Costos_Fletes_Operativos_Por_Placa]
*/




----select * from [dbo].[VW_COSOURCING3C_Costos_Por_Mes_Zonas]
-----> ajuste solicitado por darwin 20260826
--SELECT 
----CONCAT(MONTH([FECHA 1]),'-',FORMAT([FECHA 1], 'MMMM', 'es-ES')) AS Mes, 
--MONTH([FECHA 1]) AS Mes, 
--Year([FECHA 1]) AS anio, 
--CO_ZN.PLACA, 
--Avg(CO_ZN.TARIFA) AS Promedio_Zonas, 
--Min(CO_ZN.TARIFA) AS Min_Zonas, 
--Max(CO_ZN.TARIFA) AS Max_Zonas, 
--StDev(CO_ZN.TARIFA) AS Desv_Zonas
--FROM [dbo].[CO_SOURCING_ZONAS] CO_ZN
--WHERE (((CO_ZN.[FECHA 1])>='2024-01-01'))
--GROUP BY MONTH([FECHA 1]), 
--Year([FECHA 1]), CO_ZN.PLACA;


----USE [ACCES_DARWIN]
----GO
----SET QUOTED_IDENTIFIER ON
----GO
----CREATE VIEW [dbo].[VW_4B_ZO_PromedioPreliminar_PorPlaca]
----AS
------4B_ZO_PromedioPreliminar_PorPlaca:
-------- Nueva vista  requerimientos de darwin 202608926
----SELECT 
----CO_ZN.PLACA, 
----Avg(CO_ZN.TARIFA) AS PromPrelim
----FROM [dbo].[CO_SOURCING_ZONAS] CO_ZN
----GROUP BY CO_ZN.PLACA;
----GO





--USE [ACCES_DARWIN]
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE VIEW [dbo].[VW_4C_ZO_Excepciones_A_Revisar]
--AS
----4C_ZO_Excepciones_A_Revisar:
------ Nueva vista  requerimientos de darwin 202608926
--SELECT 
--D.PLACA, D.[FECHA 1], 
--D.TARIFA, P.PromPrelim, 
--Round(D.TARIFA/P.PromPrelim,1) AS VecesSobrePromedio
--FROM [dbo].[CO_SOURCING_ZONAS] AS D 
--INNER JOIN [dbo].[VW_4B_ZO_PromedioPreliminar_PorPlaca] AS P 
--ON D.PLACA = P.PLACA
--WHERE ((CONVERT(INT,D.TARIFA)>3*[P].[PromPrelim]));
--GO

--SELECT * FROM [dbo].[CO_SOURCING_ZONAS]


-------> ajuste solicitado por darwin 20260826 / se agrega columna de registros usados
---- SELECT * FROM [dbo].[VW_COSOURCING4C_Costos_Fletes_Zonas_Por_Placa]
--SELECT 
--D.PLACA, 
--Round(Avg(D.TARIFA),0) AS [Costo_Co-Sourcing_Zonas], 
--Count(*) AS [Registros Usados]
--FROM [dbo].[CO_SOURCING_ZONAS] AS D 
--LEFT JOIN [dbo].[VW_4C_ZO_Excepciones_A_Revisar] AS E 
--ON (D.PLACA = E.PLACA) 
--AND (D.[FECHA 1] = E.[FECHA 1]) 
--AND (D.TARIFA = E.TARIFA)
--WHERE (((E.PLACA) Is Null))
--GROUP BY D.PLACA;

/*
-- AJUSTE consultas solicitado por darwin 20260826
--select * from [dbo].[VW_1C_Datos_Consolidado_Por_Mes_V2]
SELECT 
HFLV2.PLACA, 
HFLV2.MES2 AS Mes, 
HFLV2.AÑO, 
Sum(HFLV2.ValorFlete) AS [Total Fletes], 
Count(HFLV2.ValorFlete) AS [Total Servicios], 
Avg(HFLV2.ValorFlete) AS [Promedio Flete], 
Min(HFLV2.ValorFlete) AS [Min Flete], 
Max(HFLV2.ValorFlete) AS [Max Flete], 
StDev(HFLV2.ValorFlete) AS [Desv Flete]
FROM [dbo].[HISTORICO_FLETES_V2] HFLV2
WHERE (((HFLV2.ValorFlete)>0))
GROUP BY 
HFLV2.PLACA, 
HFLV2.MES2, 
HFLV2.AÑO;
*/



--USE [ACCES_DARWIN]
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE VIEW [dbo].[VW_2B_OP_PromedioPreliminar_PorPlaca]
--AS
------2B_OP_PromedioPreliminar_PorPlaca:
-------- Nueva vista  requerimientos de darwin 202608926
--SELECT COOP.Placa, 
--Avg(COOP.[Val Facturado Remesa]) AS PromPrelim
--FROM [dbo].[CO_SOURCING_OPERATIVOS] COOP
--WHERE (((Year([Fecha Manifiesto]))=(SELECT Max(Year([Fecha Manifiesto])) FROM [dbo].[CO_SOURCING_OPERATIVOS])))
--GROUP BY COOP.Placa;
--GO






--2C_FleteMaximo_Consolidado_Por_Mes (V2)
-- SELECT * FROM [dbo].[VW_2C_FleteMaximo_Consolidado_Por_Mes_V2]
--SELECT 
--PLACA, 
--FechaDelServicio, 
--[AÑO], 
--Max(ValorFlete) AS FleteMaximoMes
--FROM [dbo].[HISTORICO_FLETES_V2]
--WHERE ValorFlete > 0
--GROUP BY PLACA, 
--FechaDelServicio, 
--[AÑO];


----USE [ACCES_DARWIN]
----GO
----SET QUOTED_IDENTIFIER ON
----GO
----CREATE VIEW [dbo].[VW_2D_PromedioPreliminar_PorPlaca]
----AS
------2D_PromedioPreliminar_PorPlaca
------------ Nueva vista  requerimientos de darwin 202608926
----SELECT 
----FLMXM.PLACA, 
----Avg(FLMXM.FleteMaximoMes) AS PromPrelim
----FROM [dbo].[VW_2C_FleteMaximo_Consolidado_Por_Mes_V2] FLMXM
----WHERE (((FLMXM.[AÑO])=(SELECT Max(AÑO) FROM [dbo].[HISTORICO_FLETES_V2])))
----GROUP BY FLMXM.PLACA;
----GO




----USE [ACCES_DARWIN]
----GO
----SET QUOTED_IDENTIFIER ON
----GO
----CREATE VIEW [dbo].[VW_2E_Excepciones_A_Revisar]
----AS
------2E_Excepciones_A_Revisar
---------------- Nueva vista  requerimientos de darwin 202608926
----SELECT 
----D.PLACA, 
----D.FechaDelServicio, 
----D.FleteMaximoMes, 
----P.PromPrelim, 
----Round(D.FleteMaximoMes/P.PromPrelim,1) AS VecesSobrePromedio
----FROM [dbo].[VW_2C_FleteMaximo_Consolidado_Por_Mes_V2] AS D 
----INNER JOIN [dbo].[VW_2D_PromedioPreliminar_PorPlaca] AS P ON D.PLACA = P.PLACA
----WHERE (((D.FleteMaximoMes)>3*[P].[PromPrelim]) 
----AND ((D.AÑO)=(SELECT Max(AÑO) FROM [dbo].[HISTORICO_FLETES_V2])));
----GO




/*
-- AJUSTE VISTAS solicitado por darwin 20260826 se agrega una nueva columna y se varian filtros
--select * from [dbo].[VW_3C_Costo_Flete_Por_Placa_Promedio_Año_Actual]
SELECT 
D.PLACA, 
Round(Avg(D.FleteMaximoMes),0) AS [Costo Promedio Flete Año Actual], 
Count(1) AS [Dias Usados]
FROM [dbo].[VW_2C_FleteMaximo_Consolidado_Por_Mes_V2] AS D 
LEFT JOIN [dbo].[VW_2E_Excepciones_A_Revisar] AS E 
    ON (D.PLACA = E.PLACA) 
    AND (D.FechaDelServicio = E.FechaDelServicio)
WHERE (((E.PLACA) Is Null) 
    AND ((D.AÑO)=(SELECT Max(AÑO) FROM [dbo].[HISTORICO_FLETES_V2])))
GROUP BY D.PLACA;
*/


