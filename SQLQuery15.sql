CREATE TABLE Roles (
    PK_Id_Rol   INT          NOT NULL IDENTITY(1,1),
    Nombre_Rol  VARCHAR(50)  NOT NULL,
    Descripcion VARCHAR(150) NULL,
    CONSTRAINT PK_Roles PRIMARY KEY (PK_Id_Rol)
);
GO
 

CREATE TABLE Cargo (
    PK_Id_Cargo INT          NOT NULL IDENTITY(1,1),
    Nombre      VARCHAR(60)  NOT NULL,
    Descripcion VARCHAR(150) NULL,
    CONSTRAINT PK_Cargo PRIMARY KEY (PK_Id_Cargo)
);
GO
 

CREATE TABLE Sucursal (
    PK_Id_Sucursal INT          NOT NULL IDENTITY(1,1),
    Nombre         VARCHAR(80)  NOT NULL,
    Direccion      VARCHAR(120) NOT NULL,
    Ciudad         VARCHAR(60)  NOT NULL,
    Telefono       BIGINT       NOT NULL,
    Estado         VARCHAR(10)  NOT NULL DEFAULT 'Activa'
                   CONSTRAINT CHK_Suc_Estado CHECK (Estado IN ('Activa','Inactiva')),
    CONSTRAINT PK_Sucursal PRIMARY KEY (PK_Id_Sucursal)
);
GO
 
CREATE TABLE Usuario (
    PK_Id_Usuario  INT          NOT NULL IDENTITY(1,1),
    Nombre         VARCHAR(100) NOT NULL,
    Telefono       BIGINT       NULL,
    Direccion      VARCHAR(120) NULL,
    Correo         VARCHAR(100) NOT NULL,
    Contrasena     VARCHAR(100) NOT NULL,
    Fecha_Registro DATE         NOT NULL,
    FK_Id_Cargo    INT          NULL,
    FK_Id_Rol      INT          NULL,
    FK_Id_Sucursal INT          NULL,
    CONSTRAINT PK_Usuario    PRIMARY KEY (PK_Id_Usuario),
    CONSTRAINT UQ_Correo     UNIQUE (Correo),
    CONSTRAINT FK_Usr_Cargo  FOREIGN KEY (FK_Id_Cargo)    REFERENCES Cargo    (PK_Id_Cargo),
    CONSTRAINT FK_Usr_Rol    FOREIGN KEY (FK_Id_Rol)      REFERENCES Roles    (PK_Id_Rol),
    CONSTRAINT FK_Usr_Suc    FOREIGN KEY (FK_Id_Sucursal) REFERENCES Sucursal (PK_Id_Sucursal)
);
GO
 
CREATE TABLE Caja (
    PK_Id_Caja     INT           NOT NULL IDENTITY(1,1),
    Monto_Inicial  DECIMAL(12,2) NOT NULL,
    Fecha_Apertura DATE          NOT NULL,
    Fecha_Cierre   DATE          NULL,
    Estado         VARCHAR(10)   NOT NULL DEFAULT 'Abierta'
                   CONSTRAINT CHK_Caja_Estado CHECK (Estado IN ('Abierta','Cerrada')),
    FK_Id_Cajero   INT           NOT NULL,
    CONSTRAINT PK_Caja     PRIMARY KEY (PK_Id_Caja),
    CONSTRAINT FK_Caja_Usr FOREIGN KEY (FK_Id_Cajero) REFERENCES Usuario (PK_Id_Usuario)
);
GO
 
CREATE TABLE Mesas (
    PK_Id_Mesa     INT          NOT NULL IDENTITY(1,1),
    Numero_Mesa    INT          NOT NULL,
    Capacidad      INT          NOT NULL,
    Ubicacion      VARCHAR(80)  NULL,
    Estado         VARCHAR(20)  NOT NULL DEFAULT 'Disponible'
                   CONSTRAINT CHK_Mesa_Estado CHECK (Estado IN ('Disponible','Ocupada','Reservada','Mantenimiento')),
    FK_Id_Sucursal INT          NOT NULL,
    CONSTRAINT PK_Mesas    PRIMARY KEY (PK_Id_Mesa),
    CONSTRAINT FK_Mesa_Suc FOREIGN KEY (FK_Id_Sucursal) REFERENCES Sucursal (PK_Id_Sucursal)
);
GO
 
CREATE TABLE Asignacion (
    PK_Id_Asignacion INT  NOT NULL IDENTITY(1,1),
    Fecha_Asignacion DATE NOT NULL,
    FK_Id_Mesa       INT  NOT NULL,
    FK_Id_Usuario    INT  NOT NULL,
    CONSTRAINT PK_Asignacion PRIMARY KEY (PK_Id_Asignacion),
    CONSTRAINT FK_Asig_Mesa  FOREIGN KEY (FK_Id_Mesa)    REFERENCES Mesas   (PK_Id_Mesa),
    CONSTRAINT FK_Asig_Usr   FOREIGN KEY (FK_Id_Usuario) REFERENCES Usuario (PK_Id_Usuario)
);
GO
 
CREATE TABLE Cliente (
    PK_Id_Cliente INT          NOT NULL IDENTITY(1,1),
    Nombre        VARCHAR(100) NOT NULL,
    Telefono      BIGINT       NULL,
    Direccion     VARCHAR(120) NULL,
    Ciudad        VARCHAR(60)  NULL,
    Correo        VARCHAR(100) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (PK_Id_Cliente)
);
GO
 
CREATE TABLE Reserva (
    PK_Id_Reserva   INT         NOT NULL IDENTITY(1,1),
    Fecha           DATE        NOT NULL,
    Hora            TIME(0)     NOT NULL,
    Numero_Personas INT         NOT NULL,
    Estado          VARCHAR(15) NOT NULL DEFAULT 'Pendiente'
                    CONSTRAINT CHK_Res_Estado CHECK (Estado IN ('Confirmada','Cancelada','Pendiente')),
    FK_Id_Mesa      INT         NOT NULL,
    FK_Id_Cliente   INT         NOT NULL,
    CONSTRAINT PK_Reserva     PRIMARY KEY (PK_Id_Reserva),
    CONSTRAINT FK_Res_Mesa    FOREIGN KEY (FK_Id_Mesa)    REFERENCES Mesas   (PK_Id_Mesa),
    CONSTRAINT FK_Res_Cliente FOREIGN KEY (FK_Id_Cliente) REFERENCES Cliente (PK_Id_Cliente)
);
GO
 
CREATE TABLE Pedido (
    PK_Id_Pedido INT         NOT NULL IDENTITY(1,1),
    Tipo_Pedido  VARCHAR(15) NOT NULL
                 CONSTRAINT CHK_Ped_Tipo CHECK (Tipo_Pedido IN ('Para llevar','Domicilio','En mesa')),
    Fecha        DATE        NOT NULL,
    FK_Id_Mesa   INT         NULL,  -- NULL en domicilio / para llevar
    CONSTRAINT PK_Pedido    PRIMARY KEY (PK_Id_Pedido),
    CONSTRAINT FK_Ped_Mesa  FOREIGN KEY (FK_Id_Mesa) REFERENCES Mesas (PK_Id_Mesa)
);
GO

CREATE TABLE Insumos (
    PK_Id_Insumo  INT           NOT NULL IDENTITY(1,1),
    Nombre        VARCHAR(80)   NOT NULL,
    Unidad_Medida VARCHAR(20)   NOT NULL,
    Stock_Actual  DECIMAL(10,3) NOT NULL DEFAULT 0,
    Stock_Minimo  DECIMAL(10,3) NOT NULL DEFAULT 0,
    Estado        VARCHAR(15)   NOT NULL DEFAULT 'Disponible'
                  CONSTRAINT CHK_Ins_Estado CHECK (Estado IN ('Disponible','Agotado','Suspendido')),
    CONSTRAINT PK_Insumos PRIMARY KEY (PK_Id_Insumo)
);
GO
 
CREATE TABLE Receta (
    PK_Id_Receta INT          NOT NULL IDENTITY(1,1),
    Nombre_Plato VARCHAR(100) NOT NULL,
    Descripcion  NVARCHAR(MAX) NULL,
    CONSTRAINT PK_Receta PRIMARY KEY (PK_Id_Receta)
);
GO
 
CREATE TABLE Detalle_Receta (
    PK_Id_Detalle INT           NOT NULL IDENTITY(1,1),
    Cantidad      DECIMAL(10,3) NOT NULL,
    FK_Id_Receta  INT           NOT NULL,
    FK_Id_Insumo  INT           NOT NULL,
    CONSTRAINT PK_Det_Receta PRIMARY KEY (PK_Id_Detalle),
    CONSTRAINT FK_DR_Receta  FOREIGN KEY (FK_Id_Receta) REFERENCES Receta  (PK_Id_Receta),
    CONSTRAINT FK_DR_Insumo  FOREIGN KEY (FK_Id_Insumo) REFERENCES Insumos (PK_Id_Insumo)
);
GO
 
CREATE TABLE Detalle_Pedido (
    PK_Id_Detalle_Pedido INT           NOT NULL IDENTITY(1,1),
    Cantidad             INT           NOT NULL,
    Subtotal             DECIMAL(12,2) NOT NULL,
    Preferencias         VARCHAR(200)  NULL,
    FK_Id_Pedido         INT           NOT NULL,
    FK_Id_Receta         INT           NOT NULL,
    CONSTRAINT PK_Det_Pedido PRIMARY KEY (PK_Id_Detalle_Pedido),
    CONSTRAINT FK_DP_Pedido  FOREIGN KEY (FK_Id_Pedido) REFERENCES Pedido  (PK_Id_Pedido),
    CONSTRAINT FK_DP_Receta  FOREIGN KEY (FK_Id_Receta) REFERENCES Receta  (PK_Id_Receta)
);
GO
 
CREATE TABLE Ventas (
    PK_Id_Venta  INT  NOT NULL IDENTITY(1,1),
    Fecha        DATE NOT NULL,
    FK_Id_Pedido INT  NOT NULL,
    CONSTRAINT PK_Ventas     PRIMARY KEY (PK_Id_Venta),
    CONSTRAINT FK_Ven_Pedido FOREIGN KEY (FK_Id_Pedido) REFERENCES Pedido (PK_Id_Pedido)
);
GO
 
CREATE TABLE Mermas (
    PK_Id_Merma  INT           NOT NULL IDENTITY(1,1),
    Cantidad     DECIMAL(10,3) NOT NULL,
    Motivo       VARCHAR(150)  NULL,
    Fecha        DATE          NOT NULL,
    FK_Id_Insumo INT           NOT NULL,
    CONSTRAINT PK_Mermas     PRIMARY KEY (PK_Id_Merma),
    CONSTRAINT FK_Mer_Insumo FOREIGN KEY (FK_Id_Insumo) REFERENCES Insumos (PK_Id_Insumo)
);
GO
 

SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (PK_Id_Rol, Nombre_Rol, Descripcion) VALUES
(1,'Administrador','Administra el sistema'),
(2,'Cajero',       'Gestiona las ventas de la caja'),
(3,'Mesero',       'Gestiona mesas y pedidos'),
(4,'Planchero',    'Prepara platos a la plancha'),
(5,'Hornero',      'Encargado del horneado de pollo'),
(6,'Aseo',         'Encargado de la limpieza'),
(7,'Freidero',     'Prepara platos freídos');
SET IDENTITY_INSERT Roles OFF;
GO
 
SET IDENTITY_INSERT Cargo ON;
INSERT INTO Cargo (PK_Id_Cargo, Nombre, Descripcion) VALUES
(1,'Administrador',     'Encargado del establecimiento'),
(2,'Cajero',            'Maneja caja y ventas'),
(3,'Mesero',            'Atiende clientes'),
(4,'Cocinero',          'Prepara platos'),
(5,'Auxiliar de cocina','Apoya al cocinero'),
(6,'Domiciliario',      'Entrega platos a domicilio');
SET IDENTITY_INSERT Cargo OFF;
GO
 
SET IDENTITY_INSERT Sucursal ON;
INSERT INTO Sucursal (PK_Id_Sucursal, Nombre, Direccion, Ciudad, Telefono, Estado) VALUES
(1,'El Candelazo',        'Calle 57A #79A-08 Sur',  'Bogotá',3138377166,'Activa'),
(2,'Mil Llamitas de Oro', 'Carrera 78 #56B-12',      'Bogotá',3216344647,'Activa'),
(3,'Líder Pollo',         'Carrera 78P #56B-08 Sur', 'Bogotá',3138556220,'Activa');
SET IDENTITY_INSERT Sucursal OFF;
GO
 
SET IDENTITY_INSERT Usuario ON;
INSERT INTO Usuario (PK_Id_Usuario,Nombre,Telefono,Direccion,Correo,Contrasena,Fecha_Registro,FK_Id_Cargo,FK_Id_Rol,FK_Id_Sucursal) VALUES
(1, 'Carlos Rodríguez',  3004567891,'Cra. 15 #23-45',    'carlos.rodriguez@gmail.com','Carlos123', '2026-08-27',2,2,1),
(2, 'Laura Martínez',    3105678923,'Calle 42 #18-20',   'laura.martinez@gmail.com',  'Laura456',  '2026-08-15',2,2,2),
(3, 'Andrés Gómez',      3156789034,'Cra. 8 #56-12',     'andres.gomez@gmail.com',    'Andres789', '2026-04-06',2,2,3),
(4, 'Valentina Pérez',   3207890145,'Calle 25 #10-33',   'valentina.perez@gmail.com', 'Vale321',   '2025-05-01',3,3,3),
(5, 'Juan David López',  3018901256,'Cra. 32 #14-08',    'juandavid.lopez@gmail.com', 'Juan654',   '2026-01-26',3,3,2),
(6, 'Daniela Torres',    3189012367,'Calle 67 #21-19',   'daniela.torres@gmail.com',  'Daniela987','2026-04-12',3,3,1),
(7, 'Miguel Herrera',    3001234567,'Cra. 45 #30-16',    'miguel.herrera@gmail.com',  'Miguel147', '2026-02-21',3,3,2),
(8, 'Camila Sánchez',    3122345678,'Calle 12 #38-25',   'camila.sanchez@gmail.com',  'Camila258', '2026-03-07',5,4,2),
(9, 'Sebastián Ramírez', 3163456789,'Cra. 20 #51-40',    'sebastian.ramirez@gmail.com','Sebas369', '2026-01-17',4,NULL,3),
(10,'David Jiménez',     3125286634,'Calle 75 #16-52',   'davcas@gmail.com',           'David375', '2026-01-14',1,1,1),
(11,'Wilmer Torres',     3227500602,'Calle 67 #21-19',   'wiltor@gmail.com',            'Wilmer1345','2022-08-27',6,NULL,3);
SET IDENTITY_INSERT Usuario OFF;
GO
 
SET IDENTITY_INSERT Caja ON;
INSERT INTO Caja (PK_Id_Caja,Monto_Inicial,Fecha_Apertura,Fecha_Cierre,Estado,FK_Id_Cajero) VALUES
(1,500000.00,'2026-08-27','2026-08-27','Cerrada',1),
(2,400000.00,'2026-08-27',NULL,        'Abierta', 2);
SET IDENTITY_INSERT Caja OFF;
GO
 
SET IDENTITY_INSERT Mesas ON;
INSERT INTO Mesas (PK_Id_Mesa,Numero_Mesa,Capacidad,Ubicacion,Estado,FK_Id_Sucursal) VALUES
(1,1,4,'Segundo piso','Disponible',1),
(2,2,4,'Primer piso', 'Ocupada',   3),
(3,3,6,'Primer piso', 'Disponible',1),
(4,1,4,'Segundo piso','Disponible',2),
(5,2,6,'Primer piso', 'Ocupada',   2);
SET IDENTITY_INSERT Mesas OFF;
GO
 
SET IDENTITY_INSERT Asignacion ON;
INSERT INTO Asignacion (PK_Id_Asignacion,Fecha_Asignacion,FK_Id_Mesa,FK_Id_Usuario) VALUES
(1,'2026-08-27',1,4),
(2,'2026-08-27',2,5),
(3,'2026-08-27',3,6),
(4,'2026-08-27',4,7);
SET IDENTITY_INSERT Asignacion OFF;
GO
 
SET IDENTITY_INSERT Cliente ON;
INSERT INTO Cliente (PK_Id_Cliente,Nombre,Telefono,Direccion,Ciudad,Correo) VALUES
(1, 'Ulises León',     3054675598,'Calle 73 #99-28',  'Bogotá','ulisleon@gmail.com'),
(2, 'Clara Pérez',     3028756784,'Calle 28 #44-23',  'Bogotá','clape@gmail.com'),
(3, 'León Méndez',     3009875674,'Calle 57 #94-11',  'Bogotá','leome@gmail.com'),
(4, 'Carolina Páez',   3046574836,'Calle 115 #05-70', 'Bogotá','cape@gmail.com'),
(5, 'Andrés Guerrero', 3027200098,'Calle 3 #48-63',   'Bogotá','angu@gmail.com'),
(6, 'Rafael López',    3000007485,'Calle 90 #21-12',  'Bogotá','ralo@gmail.com'),
(7, 'Emily Romero',    3015469284,'Calle 29 #22-11',  'Bogotá','emilrom@gmail.com'),
(8, 'Brayan Quintero', 3046764983,'Calle 99 #88-77',  'Bogotá','braqui@gmail.com'),
(9, 'Matías Gómez',    3058752937,'Calle 23 #47-91',  'Bogotá','mago@gmail.com'),
(10,'Chris Pinzón',    3044281233,'Calle 129 #18-48', 'Bogotá','chripi@gmail.com');
SET IDENTITY_INSERT Cliente OFF;
GO
 
SET IDENTITY_INSERT Reserva ON;
INSERT INTO Reserva (PK_Id_Reserva,Fecha,Hora,Numero_Personas,Estado,FK_Id_Mesa,FK_Id_Cliente) VALUES
(1,'2026-08-27','13:00:00',4,'Confirmada',2,1),
(2,'2026-08-28','14:00:00',3,'Confirmada',3,2),
(3,'2026-08-27','19:00:00',2,'Cancelada', 1,3);
SET IDENTITY_INSERT Reserva OFF;
GO
 
SET IDENTITY_INSERT Pedido ON;
INSERT INTO Pedido (PK_Id_Pedido,Tipo_Pedido,Fecha,FK_Id_Mesa) VALUES
(1,'Para llevar','2026-08-27',2),
(2,'Domicilio',  '2026-08-27',3),
(3,'Domicilio',  '2026-08-27',1);
SET IDENTITY_INSERT Pedido OFF;
GO
 
SET IDENTITY_INSERT Insumos ON;
INSERT INTO Insumos (PK_Id_Insumo,Nombre,Unidad_Medida,Stock_Actual,Stock_Minimo,Estado) VALUES
(1, 'Pollo Crudo',             'und',35,  10,'Disponible'),
(2, 'Menudencia',              'kg', 12,   4,'Disponible'),
(3, 'Pierna Pernil',           'kg', 18,   6,'Disponible'),
(4, 'Pechugas',                'kg', 25,   8,'Disponible'),
(5, 'Alitas',                  'kg', 15,   5,'Disponible'),
(6, 'Mondongo',                'kg', 10,   3,'Disponible'),
(7, 'Carne Ejecutiva',         'kg', 20,   6,'Disponible'),
(8, 'Carne Sp',                'kg', 15,   5,'Disponible'),
(9, 'Churrascos',              'kg', 18,   6,'Disponible'),
(10,'Lomos',                   'kg', 12,   4,'Disponible'),
(11,'Chuleta',                 'kg', 15,   5,'Disponible'),
(12,'Sobrebarriga',            'kg', 14,   4,'Disponible'),
(13,'Lengua',                  'kg',  8,   3,'Disponible'),
(14,'Carne Hamburguesa',       'kg', 12,   4,'Disponible'),
(15,'Costillas',               'kg', 18,   6,'Disponible'),
(16,'Mojarra Sp',              'und',20,   6,'Disponible'),
(17,'Mojarra Ejecutiva',       'und',15,   5,'Disponible'),
(18,'Bagre',                   'kg', 12,   4,'Disponible'),
(19,'Cachama',                 'und',15,   5,'Disponible'),
(20,'Cazuela',                 'und',10,   3,'Disponible'),
(21,'Trucha',                  'und',12,   4,'Disponible'),
(22,'Camarón',                 'kg',  8,   3,'Disponible'),
(23,'Salchicha',               'und',40,  15,'Disponible'),
(24,'Chorizo',                 'und',35,  12,'Disponible'),
(25,'Frijol',                  'kg', 20,   7,'Disponible'),
(26,'Papa Francesa',           'kg', 15,   5,'Disponible'),
(27,'Yuca',                    'kg', 25,   8,'Disponible'),
(28,'Patacón',                 'und',50,  15,'Disponible'),
(29,'Arepa Boyacense',         'und',30,  10,'Disponible'),
(30,'Arroz',                   'und',20,   6,'Disponible'),
(31,'Gaseosa 350ml Coca-Cola', 'und',48,  15,'Disponible'),
(32,'Gaseosa 250ml Coca-Cola', 'und',36,  12,'Disponible'),
(33,'Gaseosa 1.5L Coca-Cola',  'und',45,  14,'Disponible'),
(34,'Gaseosa 350ml Postobón',  'und',36,  10,'Disponible'),
(35,'Gaseosa 250ml Postobón',  'und',50,  13,'Disponible'),
(36,'Gaseosa 1.5L Postobón',   'und',24,   8,'Disponible'),
(37,'Cerveza',                 'und',48,  15,'Disponible'),
(38,'Cola y Pola',             'und',24,   8,'Disponible'),
(39,'Jugo Hit 350ml',          'und',30,  10,'Disponible'),
(40,'Jugo Hit 250ml',          'und',24,   8,'Disponible'),
(41,'Agua',                    'und',36,  12,'Disponible');
SET IDENTITY_INSERT Insumos OFF;
GO
 
SET IDENTITY_INSERT Receta ON;
INSERT INTO Receta (PK_Id_Receta,Nombre_Plato,Descripcion) VALUES
(1, 'Bandeja con carne',                       'Carne de res asada, papa cocida, ensalada fresca y patacón.'),
(2, 'Bandeja con pollo broaster',              'Pollo broaster, arepa frita, papa a la francesa.'),
(3, 'Bandeja con alitas',                      'Alitas de pollo fritas, papas a la francesa, ensalada y salsa BBQ.'),
(4, 'Bandeja con pollo (Pierna pernil)',        'Pierna pernil asada, ensalada, papa cocida y arepa.'),
(5, 'Bandeja con pollo (Pechuga ala)',          'Pechuga de pollo a la plancha, ensalada y papa cocida.'),
(6, 'Plato ejecutivo',                         'Menú del día, sopa, jugo.'),
(7, 'Combo infantil',                          'Nuggets de pollo, papas a la francesa, jugo de caja y helado.'),
(8, 'Ajiaco especial sanrafereño',             'Ajiaco con pierna pernil, papa criolla, mazorca, arroz blanco, aguacate y crema de leche.'),
(9, 'Ajiaquito',                               'Ajiaco tradicional con pollo desmechado, papa criolla y arroz blanco.'),
(10,'Mondongo',                                'Mondongo con callo de cerdo, papa, yuca, arroz, aguacate.'),
(11,'Mondonguito',                             'Porción pequeña de mondongo con arroz blanco y aguacate.'),
(12,'Menudencias',                             'Sopa de menudencias con arroz blanco, papa cocida y ensalada.'),
(13,'Cazuela de frijoles',                     'Frijoles, chicharrón, arroz blanco, aguacate, arepa y plátano maduro.'),
(14,'Lomo de cerdo',                           'Lomo de cerdo a la plancha, papa francesa y ensalada.'),
(15,'Chuleta de cerdo',                        'Chuleta de cerdo apanada, papas a la francesa y ensalada.'),
(16,'Chuleta valluna',                         'Chuleta valluna apanada, papas a la francesa y ensalada fresca.'),
(17,'Costillas B.B.Q',                         'Costillas de cerdo en salsa BBQ, papa francesa, ensalada, patacón y yuca frita.'),
(18,'Salmón marinero',                         'Salmón a la parrilla con salsa marinera, arroz con verduras y ensalada.'),
(19,'Bagre en salsa marinera',                 'Bagre en salsa marinera con arroz con coco, patacón y ensalada.'),
(20,'Bagre frito',                             'Bagre frito con arroz blanco, patacón y ensalada.'),
(21,'Trucha marinera',                         'Trucha fresca en salsa marinera, arroz con verduras, ensalada y patacón.'),
(22,'Arroz con camarones',                     'Arroz salteado con camarones, verduras, ajo, cebolla, pimentón y especias.'),
(23,'Mojarra frita',                           'Mojarra frita, arroz con coco, patacón, ensalada y limón.'),
(24,'Bagre a la plancha',                      'Filete de bagre a la plancha con arroz blanco, ensalada y patacón.'),
(25,'Cachama',                                 'Cachama frita, arroz blanco, patacón, ensalada y limón.'),
(26,'Salmón a la plancha',                     'Salmón a la plancha con arroz con verduras, ensalada y salsa de mantequilla.'),
(27,'Salmón gratinado',                        'Salmón gratinado con queso mozzarella, arroz blanco y ensalada fresca.'),
(28,'Pechuga hawaiana',                        'Pechuga de pollo con jamón, piña y queso gratinado, con ensalada.'),
(29,'Pechuga gratinada',                       'Pechuga de pollo gratinada con queso mozzarella y ensalada.'),
(30,'Pechuga ranchera',                        'Pechuga de pollo en salsa ranchera, papa francesa y ensalada.'),
(31,'Pechuga en salsa de champiñones',         'Pechuga de pollo en salsa cremosa de champiñones y ensalada.'),
(32,'Pechuga BBQ',                             'Pechuga de pollo en salsa BBQ, papa francesa y ensalada.'),
(33,'Pechuga a la plancha',                    'Pechuga de pollo a la plancha, ensalada y papa cocida.'),
(34,'Arroz con pollo',                         'Arroz con pollo, verduras, arvejas, zanahoria y papa francesa.'),
(35,'Pechuga napolitana',                      'Pechuga con salsa napolitana, jamón y queso gratinado, arroz y ensalada.'),
(36,'Punta de anca',                           'Punta de anca a la parrilla, papa francesa, ensalada, yuca y patacón frito.'),
(37,'Sobrebarriga en salsa',                   'Sobrebarriga cocida en salsa criolla, papa cocida y ensalada.'),
(38,'Lengua en salsa',                         'Lengua de res en salsa criolla, papa cocida y ensalada.'),
(39,'Churrasco',                               'Churrasco a la parrilla con papa francesa, ensalada, yuca y patacón frito.'),
(40,'Churrasco gratinado',                     'Churrasco gratinado con queso mozzarella, papa francesa, ensalada, yuca y patacón frito.'),
(41,'Parrillada',                              'Parrillada con carne de res, cerdo, pollo, chorizo, papa, arepa, ensalada, yuca y patacón.'),
(42,'Tabla mixta',                             'Tabla mixta con carne, pollo, cerdo, chorizo, yuca frita, papa francesa y arepas.'),
(43,'Carne asada',                             'Carne de res asada, papa a la francesa y ensalada fresca.'),
(44,'Sobrebarriga a la plancha',               'Sobrebarriga a la plancha, papa francesa y ensalada.'),
(45,'Bandeja paisa',                           'Frijoles, arroz, carne molida, chicharrón, chorizo, huevo frito, arepa, aguacate y plátano.'),
(46,'Pollo asado',                             'Pollo asado entero marinado con especias, papa salada y arepas.'),
(47,'1/2 Pollo asado',                         'Medio pollo asado con papa salada, arepa y salsa de la casa.'),
(48,'1/4 Pollo asado (Pechuga y ala)',         'Cuarto de pollo asado (pechuga y ala), papa salada y arepa.'),
(49,'1/4 Pollo asado (Pierna pernil)',         'Cuarto de pollo asado (pierna pernil), papa salada y arepa.'),
(50,'Pollo frito',                             'Pollo frito entero con papa francesa y arepas.'),
(51,'1/2 Pollo frito',                         'Medio pollo frito con papa francesa y arepa.'),
(52,'1/4 Pollo frito (Pechuga)',               'Cuarto de pollo frito (pechuga), papa francesa y arepa.'),
(53,'1/4 Pollo frito (Pierna pernil)',         'Cuarto de pollo frito (pierna pernil), papa francesa y arepa.'),
(54,'Pollo broaster',                          'Pollo broaster entero, papa francesa y arepas.'),
(55,'1/2 Pollo broaster',                      'Medio pollo broaster con papa francesa y arepa.'),
(56,'1/4 Pollo broaster (Pechuga)',            'Cuarto de pollo broaster (pechuga), papa francesa y arepa.'),
(57,'1/4 Pollo broaster (Pierna pernil)',      'Cuarto de pollo broaster (pierna pernil), papa francesa y arepa.'),
(58,'Combo 1: 1 pollo asado',                  'Pollo asado entero, papas saladas, arepas y gaseosa familiar.'),
(59,'Combo 2: 1 pollo y medio asado',          'Pollo y medio asado, papas saladas, arepas y gaseosa familiar.'),
(60,'Combo 3: 2 pollos asados',                'Dos pollos asados, papas saladas, arepas y gaseosa familiar.'),
(61,'Combo 4: Pollo broaster',                 'Pollo broaster entero, papa francesa, arepas y gaseosa familiar.'),
(62,'Combo 5: Pollo asado y medio broaster',   'Pollo asado y medio pollo broaster, papa francesa, arepas y gaseosa familiar.'),
(63,'Combo mixto: Medio asado y medio broaster','Medio pollo asado y medio pollo broaster, papa francesa y arepas.');
SET IDENTITY_INSERT Receta OFF;
GO
 
SET IDENTITY_INSERT Detalle_Receta ON;
INSERT INTO Detalle_Receta (PK_Id_Detalle,Cantidad,FK_Id_Receta,FK_Id_Insumo) VALUES
(1, 0.200,1, 10),(2, 0.150,2,  2),(3, 0.200,3,  7),(4, 0.250,4,  5),
(5, 0.250,5,  6),(6, 0.200,6,  9),(7, 0.080,7, 16),(8, 0.250,8,  5),
(9, 0.150,9,  3),(10,0.250,10, 8),(11,0.150,11, 8),(12,0.200,12, 4),
(13,0.150,13,27),(14,0.200,14,12),(15,0.200,15,13),(16,0.200,16,13),
(17,0.250,17,17),(18,0.200,18,23),(19,0.200,19,20),(20,0.200,20,20),
(21,0.200,21,23),(22,0.150,22,24),(23,0.200,23,18),(24,0.200,24,20),
(25,0.250,25,21),(26,0.200,26, 3),(27,0.200,27, 3),(28,0.200,28, 6),
(29,0.200,29, 6),(30,0.200,30, 6),(31,0.200,31, 6),(32,0.200,32, 6),
(33,0.200,33, 6),(34,0.200,34,32),(35,0.200,35, 6),(36,0.250,36,10),
(37,0.250,37,14),(38,0.200,38,15),(39,0.250,39,11),(40,0.250,40,11),
(41,0.150,41,10),(42,0.150,42,10),(43,0.200,43,10),(44,0.250,44,14),
(45,0.150,45,10),(46,1.000,46, 1),(47,0.500,47, 1),(48,0.250,48, 6),
(49,0.250,49, 5),(50,1.000,50, 1),(51,0.500,51, 1),(52,0.250,52, 6),
(53,0.250,53, 5),(54,1.000,54, 2),(55,0.500,55, 2),(56,0.250,56, 6),
(57,0.250,57, 5),(58,1.000,58, 3),(59,1.500,59, 3),(60,2.000,60, 3),
(61,1.000,61, 2),(62,1.000,62, 3),(63,0.500,62, 2),(64,0.500,63, 3),
(65,0.500,63, 2);
SET IDENTITY_INSERT Detalle_Receta OFF;
GO
 
SET IDENTITY_INSERT Detalle_Pedido ON;
INSERT INTO Detalle_Pedido (PK_Id_Detalle_Pedido,Cantidad,Subtotal,Preferencias,FK_Id_Pedido,FK_Id_Receta) VALUES
(1,2,30000.00,'N/A',                       1,1),
(2,2,24000.00,'N/A',                       1,2),
(3,1,18000.00,'Intolerancia a la lactosa', 2,3),
(4,1,15000.00,'Sin tomate',                3,1);
SET IDENTITY_INSERT Detalle_Pedido OFF;
GO
 
SET IDENTITY_INSERT Ventas ON;
INSERT INTO Ventas (PK_Id_Venta,Fecha,FK_Id_Pedido) VALUES
(1,'2026-08-27',1),
(2,'2026-08-27',2);
SET IDENTITY_INSERT Ventas OFF;
GO
 
SET IDENTITY_INSERT Mermas ON;
INSERT INTO Mermas (PK_Id_Merma,Cantidad,Motivo,Fecha,FK_Id_Insumo) VALUES
(1,2.0,'Producto vencido',   '2026-08-26',4),
(2,1.0,'Producto dañado',    '2026-08-27',1),
(3,0.5,'Mala manipulación',  '2026-08-25',5),
(4,5.0,'Producto perdido',   '2026-08-04',3);
SET IDENTITY_INSERT Mermas OFF;
GO
 

SELECT u.PK_Id_Usuario,
       u.Nombre                    AS Empleado,
       c.Nombre                    AS Cargo,
       r.Nombre_Rol                AS Rol,
       s.Nombre                    AS Sucursal
FROM   Usuario u
LEFT JOIN Cargo    c ON u.FK_Id_Cargo    = c.PK_Id_Cargo
LEFT JOIN Roles    r ON u.FK_Id_Rol      = r.PK_Id_Rol
LEFT JOIN Sucursal s ON u.FK_Id_Sucursal = s.PK_Id_Sucursal
ORDER BY u.PK_Id_Usuario;
GO
 

SELECT Nombre, Unidad_Medida, Stock_Actual, Stock_Minimo,
       (Stock_Minimo - Stock_Actual) AS Unidades_Faltantes
FROM   Insumos
WHERE  Stock_Actual < Stock_Minimo;
GO
 
SELECT p.PK_Id_Pedido, p.Tipo_Pedido, p.Fecha,
       SUM(dp.Subtotal) AS Total_Pedido
FROM   Pedido p
JOIN   Detalle_Pedido dp ON dp.FK_Id_Pedido = p.PK_Id_Pedido
GROUP BY p.PK_Id_Pedido, p.Tipo_Pedido, p.Fecha;
GO
 
SELECT r.PK_Id_Reserva, r.Fecha, r.Hora, r.Numero_Personas,
       cl.Nombre AS Cliente,
       m.Numero_Mesa,
       s.Nombre  AS Sucursal
FROM   Reserva  r
JOIN   Cliente  cl ON r.FK_Id_Cliente  = cl.PK_Id_Cliente
JOIN   Mesas    m  ON r.FK_Id_Mesa     = m.PK_Id_Mesa
JOIN   Sucursal s  ON m.FK_Id_Sucursal = s.PK_Id_Sucursal
WHERE  r.Estado = 'Confirmada';
GO
 
SELECT rec.PK_Id_Receta, rec.Nombre_Plato,
       i.Nombre  AS Insumo_Principal,
       dr.Cantidad, i.Unidad_Medida
FROM   Receta      rec
JOIN   Detalle_Receta dr ON dr.FK_Id_Receta = rec.PK_Id_Receta
JOIN   Insumos     i   ON dr.FK_Id_Insumo  = i.PK_Id_Insumo
ORDER BY rec.PK_Id_Receta;
GO
 
UPDATE Caja
SET    Estado = 'Cerrada', Fecha_Cierre = CAST(GETDATE() AS DATE)
WHERE  PK_Id_Caja = 2;
GO
 
UPDATE Mesas
SET    Estado = 'Disponible'
WHERE  PK_Id_Mesa = 2;
GO
 
UPDATE Usuario SET FK_Id_Rol = 4 WHERE PK_Id_Usuario = 9;
GO
 
UPDATE Usuario SET FK_Id_Rol = 6 WHERE PK_Id_Usuario = 11;
GO
 
UPDATE Insumos
SET    Stock_Actual = Stock_Actual + 20
WHERE  PK_Id_Insumo = 1;
GO
 
 
UPDATE Reserva SET Estado = 'Cancelada' WHERE PK_Id_Reserva = 3;
GO
 
DELETE FROM Mermas WHERE PK_Id_Merma = 4;
GO
 
 
 
BEGIN TRANSACTION;
BEGIN TRY

    INSERT INTO Pedido (Tipo_Pedido, Fecha, FK_Id_Mesa)
    VALUES ('En mesa', CAST(GETDATE() AS DATE), 1);
 
    DECLARE @nuevo_pedido INT = SCOPE_IDENTITY();
 
    INSERT INTO Detalle_Pedido (Cantidad, Subtotal, Preferencias, FK_Id_Pedido, FK_Id_Receta)
    VALUES (1, 22000.00, 'Sin cebolla', @nuevo_pedido, 5);
 
    UPDATE Insumos
    SET    Stock_Actual = Stock_Actual - 0.25
    WHERE  PK_Id_Insumo = 6;
 
    INSERT INTO Ventas (Fecha, FK_Id_Pedido)
    VALUES (CAST(GETDATE() AS DATE), @nuevo_pedido);
 
    COMMIT TRANSACTION;
    PRINT 'Transacción completada correctamente.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
GO
 
 
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'admin_candelazo')
    CREATE LOGIN admin_candelazo WITH PASSWORD = 'Admin@Candelazo2026!';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'admin_candelazo')
    CREATE USER admin_candelazo FOR LOGIN admin_candelazo;
GO

ALTER ROLE db_owner ADD MEMBER admin_candelazo;
GO
 

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'cajero_app')
    CREATE LOGIN cajero_app WITH PASSWORD = 'Cajero@2026!';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'cajero_app')
    CREATE USER cajero_app FOR LOGIN cajero_app;
GO

ALTER ROLE db_datareader ADD MEMBER cajero_app;
GRANT INSERT, UPDATE ON Ventas        TO cajero_app;
GRANT INSERT, UPDATE ON Pedido        TO cajero_app;
GRANT INSERT, UPDATE ON Detalle_Pedido TO cajero_app;
GRANT UPDATE         ON Caja          TO cajero_app;
GO
 

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'mesero_app')
    CREATE LOGIN mesero_app WITH PASSWORD = 'Mesero@2026!';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'mesero_app')
    CREATE USER mesero_app FOR LOGIN mesero_app;
GO
GRANT SELECT         ON Mesas          TO mesero_app;
GRANT SELECT         ON Receta         TO mesero_app;
GRANT SELECT         ON Reserva        TO mesero_app;
GRANT INSERT, UPDATE ON Pedido         TO mesero_app;
GRANT INSERT         ON Detalle_Pedido TO mesero_app;
GO
 
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'cocina_app')
    CREATE LOGIN cocina_app WITH PASSWORD = 'Cocina@2026!';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'cocina_app')
    CREATE USER cocina_app FOR LOGIN cocina_app;
GO
GRANT SELECT         ON Pedido         TO cocina_app;
GRANT SELECT         ON Detalle_Pedido TO cocina_app;
GRANT SELECT         ON Receta         TO cocina_app;
GRANT SELECT         ON Detalle_Receta TO cocina_app;
GRANT SELECT, UPDATE ON Insumos        TO cocina_app;
GRANT INSERT         ON Mermas         TO cocina_app;
GO
 

CREATE OR ALTER PROCEDURE sp_registrar_pedido
    @p_tipo      VARCHAR(15),
    @p_fecha     DATE,
    @p_mesa      INT,
    @p_id_pedido INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Pedido (Tipo_Pedido, Fecha, FK_Id_Mesa)
    VALUES (@p_tipo, @p_fecha, @p_mesa);
    SET @p_id_pedido = SCOPE_IDENTITY();
END;
GO

CREATE OR ALTER PROCEDURE sp_agregar_detalle_pedido
    @p_id_pedido INT,
    @p_id_receta INT,
    @p_cantidad  INT,
    @p_subtotal  DECIMAL(12,2),
    @p_pref      VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @v_id_insumo  INT;
    DECLARE @v_cant_ins   DECIMAL(10,3);
    DECLARE @v_stock      DECIMAL(10,3);
 
    SELECT TOP 1 @v_id_insumo = FK_Id_Insumo, @v_cant_ins = Cantidad
    FROM   Detalle_Receta
    WHERE  FK_Id_Receta = @p_id_receta;
 
    SELECT @v_stock = Stock_Actual
    FROM   Insumos
    WHERE  PK_Id_Insumo = @v_id_insumo;
 
    IF @v_stock < (@v_cant_ins * @p_cantidad)
    BEGIN
        RAISERROR ('Stock insuficiente para preparar el plato solicitado.', 16, 1);
        RETURN;
    END
 
    INSERT INTO Detalle_Pedido (Cantidad, Subtotal, Preferencias, FK_Id_Pedido, FK_Id_Receta)
    VALUES (@p_cantidad, @p_subtotal, @p_pref, @p_id_pedido, @p_id_receta);
 
    UPDATE Insumos
    SET    Stock_Actual = Stock_Actual - (@v_cant_ins * @p_cantidad)
    WHERE  PK_Id_Insumo = @v_id_insumo;
END;
GO
 

CREATE OR ALTER PROCEDURE sp_generar_venta
    @p_id_pedido INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Ventas (Fecha, FK_Id_Pedido)
    VALUES (CAST(GETDATE() AS DATE), @p_id_pedido);
    SELECT SCOPE_IDENTITY() AS id_venta_generada;
END;
GO
 

CREATE OR ALTER PROCEDURE sp_ventas_por_sucursal
    @p_fecha_inicio DATE,
    @p_fecha_fin    DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.Nombre          AS Sucursal,
           COUNT(v.PK_Id_Venta) AS Total_Ventas,
           SUM(dp.Subtotal)     AS Ingresos
    FROM   Ventas           v
    JOIN   Pedido           p  ON v.FK_Id_Pedido    = p.PK_Id_Pedido
    JOIN   Detalle_Pedido   dp ON dp.FK_Id_Pedido   = p.PK_Id_Pedido
    JOIN   Mesas            m  ON p.FK_Id_Mesa       = m.PK_Id_Mesa
    JOIN   Sucursal         s  ON m.FK_Id_Sucursal   = s.PK_Id_Sucursal
    WHERE  v.Fecha BETWEEN @p_fecha_inicio AND @p_fecha_fin
    GROUP BY s.Nombre
    ORDER BY Ingresos DESC;
END;
GO
 

CREATE OR ALTER FUNCTION fn_total_pedido (@p_id_pedido INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2);
    SELECT @total = ISNULL(SUM(Subtotal), 0)
    FROM   Detalle_Pedido
    WHERE  FK_Id_Pedido = @p_id_pedido;
    RETURN @total;
END;
GO
 

CREATE OR ALTER FUNCTION fn_insumo_bajo_stock (@p_id_insumo INT)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT = 0;
    IF EXISTS (
        SELECT 1 FROM Insumos
        WHERE PK_Id_Insumo = @p_id_insumo
          AND Stock_Actual <= Stock_Minimo
    )
        SET @resultado = 1;
    RETURN @resultado;
END;
GO

CREATE OR ALTER TRIGGER trg_estado_insumo
ON Insumos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
 

    UPDATE i
    SET    i.Estado = 'Agotado'
    FROM   Insumos i
    JOIN   inserted ins ON i.PK_Id_Insumo = ins.PK_Id_Insumo
    WHERE  ins.Stock_Actual <= 0;
 

    UPDATE i
    SET    i.Estado = 'Disponible'
    FROM   Insumos i
    JOIN   inserted ins ON i.PK_Id_Insumo = ins.PK_Id_Insumo
    WHERE  ins.Stock_Actual > 0 AND i.Estado = 'Agotado';
END;
GO

CREATE OR ALTER TRIGGER trg_mesa_ocupada
ON Asignacion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE m
    SET    m.Estado = 'Ocupada'
    FROM   Mesas m
    JOIN   inserted i ON m.PK_Id_Mesa = i.FK_Id_Mesa;
END;
GO
 

CREATE OR ALTER TRIGGER trg_prevenir_stock_negativo
ON Insumos
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO Mermas (Cantidad, Motivo, Fecha, FK_Id_Insumo)
    SELECT ABS(ins.Stock_Actual),
           'Descuento excedió stock disponible',
           CAST(GETDATE() AS DATE),
           ins.PK_Id_Insumo
    FROM   inserted ins
    WHERE  ins.Stock_Actual < 0;
 

    UPDATE i
    SET    i.Stock_Actual  = CASE WHEN ins.Stock_Actual < 0 THEN 0
                                  ELSE ins.Stock_Actual END,
           i.Stock_Minimo  = ins.Stock_Minimo,
           i.Estado        = ins.Estado,
           i.Nombre        = ins.Nombre,
           i.Unidad_Medida = ins.Unidad_Medida
    FROM   Insumos i
    JOIN   inserted ins ON i.PK_Id_Insumo = ins.PK_Id_Insumo;
END;
GO
 
 
 
CREATE INDEX idx_usuario_cargo    ON Usuario       (FK_Id_Cargo);
CREATE INDEX idx_usuario_rol      ON Usuario       (FK_Id_Rol);
CREATE INDEX idx_usuario_sucursal ON Usuario       (FK_Id_Sucursal);
CREATE INDEX idx_pedido_mesa      ON Pedido        (FK_Id_Mesa);
CREATE INDEX idx_detped_pedido    ON Detalle_Pedido(FK_Id_Pedido);
CREATE INDEX idx_detped_receta    ON Detalle_Pedido(FK_Id_Receta);
CREATE INDEX idx_venta_pedido     ON Ventas        (FK_Id_Pedido);
CREATE INDEX idx_venta_fecha      ON Ventas        (Fecha);
CREATE INDEX idx_reserva_fecha    ON Reserva       (Fecha);
CREATE INDEX idx_merma_insumo     ON Mermas        (FK_Id_Insumo);
CREATE INDEX idx_insumo_stock     ON Insumos       (Stock_Actual);
CREATE INDEX idx_mesa_sucursal    ON Mesas         (FK_Id_Sucursal);
GO
 

SET STATISTICS IO ON;
SELECT u.Nombre, c.Nombre AS Cargo
FROM   Usuario u
JOIN   Cargo c ON u.FK_Id_Cargo = c.PK_Id_Cargo;
SET STATISTICS IO OFF;
GO
 

CREATE OR ALTER VIEW v_empleados_sin_rol AS
    SELECT PK_Id_Usuario, Nombre, Correo
    FROM   Usuario
    WHERE  FK_Id_Rol IS NULL;
GO
 

CREATE OR ALTER VIEW v_insumos_bajo_minimo AS
    SELECT PK_Id_Insumo, Nombre, Stock_Actual, Stock_Minimo,
           (Stock_Minimo - Stock_Actual) AS Unidades_Faltantes
    FROM   Insumos
    WHERE  Stock_Actual < Stock_Minimo;
GO
 

CREATE OR ALTER VIEW v_ventas_diarias AS
    SELECT v.Fecha,
           COUNT(v.PK_Id_Venta)  AS Cantidad_Ventas,
           SUM(dp.Subtotal)       AS Total_Ingresos
    FROM   Ventas v
    JOIN   Detalle_Pedido dp ON dp.FK_Id_Pedido = v.FK_Id_Pedido
    GROUP BY v.Fecha;
GO
 
SELECT tc.TABLE_NAME, tc.CONSTRAINT_NAME, tc.CONSTRAINT_TYPE
FROM   INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
WHERE  tc.TABLE_CATALOG = 'ignix_core'
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;
GO