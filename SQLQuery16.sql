USE ignix_core;
GO

SELECT 
    PK_Id_Insumo,
    Nombre AS Insumo,
    Unidad_Medida,
    Stock_Actual,
    Stock_Minimo,
    (Stock_Minimo - Stock_Actual) AS Unidades_Faltantes,
    Estado
FROM Insumos
WHERE Stock_Actual <= Stock_Minimo
ORDER BY Stock_Actual ASC;
GO