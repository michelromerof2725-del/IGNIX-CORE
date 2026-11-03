USE ignix_core;
GO

SELECT 
    m.PK_Id_Merma,
    m.Fecha,
    i.Nombre AS Insumo_Perdido,
    m.Cantidad,
    i.Unidad_Medida,
    m.Motivo
FROM Mermas m
INNER JOIN Insumos i ON m.FK_Id_Insumo = i.PK_Id_Insumo
ORDER BY m.Fecha DESC;
GO