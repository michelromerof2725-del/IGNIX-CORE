USE ignix_core;
GO

SELECT 
    p.PK_Id_Pedido,
    p.Tipo_Pedido,
    p.Fecha,
    STRING_AGG(CONCAT(rec.Nombre_Plato, ' (x', dp.Cantidad, ')'), ', ') AS Platos_Solicitados,
    SUM(dp.Subtotal) AS Total_Pedido
FROM Pedido p
INNER JOIN Detalle_Pedido dp ON p.PK_Id_Pedido = dp.FK_Id_Pedido
INNER JOIN Receta rec ON dp.FK_Id_Receta = rec.PK_Id_Receta
GROUP BY p.PK_Id_Pedido, p.Tipo_Pedido, p.Fecha
ORDER BY Total_Pedido DESC;
GO