USE ignix_core;
GO

SELECT 
    u.PK_Id_Usuario AS ID_Empleado,
    u.Nombre AS Empleado,
    u.Correo,
    ISNULL(c.Nombre, 'Sin Cargo') AS Cargo,
    ISNULL(r.Nombre_Rol, 'Sin Rol Asignado') AS Rol_Sistema,
    ISNULL(s.Nombre, 'Sin Sucursal') AS Sucursal_Asignada
FROM Usuario u
LEFT JOIN Cargo c ON u.FK_Id_Cargo = c.PK_Id_Cargo
LEFT JOIN Roles r ON u.FK_Id_Rol = r.PK_Id_Rol
LEFT JOIN Sucursal s ON u.FK_Id_Sucursal = s.PK_Id_Sucursal
ORDER BY u.Nombre ASC;
GO