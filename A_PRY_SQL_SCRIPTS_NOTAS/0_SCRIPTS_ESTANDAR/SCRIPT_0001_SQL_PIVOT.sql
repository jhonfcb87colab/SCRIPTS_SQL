

SELECT Employee, [2024], [2025]
FROM 
    (SELECT Employee, Year, Amount FROM #Sales) AS SourceData
PIVOT
(
    SUM(Amount)
    FOR Year IN ([2024], [2025])
) AS PivotResult;


