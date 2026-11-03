USE ignix_core;
GO

SELECT 
    s.Nombre AS Sucursal,
    r.PK_Id_Reserva AS No_Reserva,
    c.Nombre AS Cliente,
    c.Telefono AS Contacto_Cliente,
    m.Numero_Mesa,
    m.Ubicacion,
    r.Fecha,
    r.Hora,
    r.Numero_Personas,
    r.Estado AS Estado_Reserva
FROM Reserva r
INNER JOIN Cliente c ON r.FK_Id_Cliente = c.PK_Id_Cliente
INNER JOIN Mesas m ON r.FK_Id_Mesa = m.PK_Id_Mesa
INNER JOIN Sucursal s ON m.FK_Id_Sucursal = s.PK_Id_Sucursal
WHERE r.Estado = 'Confirmada'
ORDER BY r.Fecha DESC, r.Hora ASC;
GO