

PRINT '1. Creando el esquema BI';
GO

CREATE SCHEMA BI;
GO

PRINT 'Esquema BI creado.';

/* ------- CREACION DE LAS FUNCIONES ------- */
CREATE FUNCTION BI.getCuatrimestre (@fecha DATE)
RETURNS SMALLINT
AS BEGIN
	DECLARE @cuatrimestre SMALLINT

	SET @cuatrimestre =
		CASE 
			WHEN MONTH(@fecha) BETWEEN 1 AND 4 THEN 1
			WHEN MONTH(@fecha) BETWEEN 5 AND 8 THEN 2
			WHEN MONTH(@fecha) BETWEEN 9 AND 12 THEN 3
		END

	RETURN @cuatrimestre
END
GO



CREATE FUNCTION BI.getRangoEtario (@fechaNacimiento DATE)
RETURNS NVARCHAR(6)
AS
BEGIN
	DECLARE @EdadActual INT
	DECLARE @rango NVARCHAR(6) 

	SET @EdadActual = CAST(DATEDIFF(DAY, @fechaNacimiento, GETDATE()) / 365.25 AS INT)

	SET @rango =
		CASE 
			WHEN @EdadActual < 25 THEN '<25'
			WHEN @EdadActual >= 25 AND @EdadActual < 35 THEN '25-35'
			WHEN @EdadActual >= 35 AND @EdadActual < 50 THEN '35-50'
			WHEN @EdadActual >= 50 THEN '>50'
		END

	RETURN @rango
END
GO

CREATE FUNCTION BI.getTurnoVenta (@fechaHora DATETIME)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @hora INT
    DECLARE @turno NVARCHAR(20)

    SET @hora = DATEPART(HOUR, @fechaHora)

    SET @turno = 
        CASE 
            WHEN @hora >= 8 AND @hora < 14 THEN '08:00-14:00'
            WHEN @hora >= 14 AND @hora < 20 THEN '14:00-20:00'
            ELSE 'Fuera de turno'
        END

    RETURN @turno
END
GO

---------------DIMENSIONES--------------------

--------------------create dimensiones-------------------------

--UBICACIÓN
CREATE TABLE BI.dm_ubicacion (
    id_ubicacion INT IDENTITY(1,1) PRIMARY KEY,
    localidad NVARCHAR(100),
    provincia NVARCHAR(100)
);
GO
--cliente
CREATE TABLE BI.dm_cliente (
    id_cliente INT PRIMARY KEY,
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    fecha_nacimiento DATE,
    direccion NVARCHAR(150),
    telefono NVARCHAR(20),
    mail NVARCHAR(100),
    edad INT,
    rango_etario NVARCHAR(6),
    id_ubicacion INT,
    CONSTRAINT FK_dm_cliente_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES BI.dm_ubicacion(id_ubicacion)
);
GO
--proveedor
CREATE TABLE BI.dm_proveedor (
    id_proveedor INT PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion NVARCHAR(150),
    telefono NVARCHAR(20),
    mail NVARCHAR(100),
    id_ubicacion INT,
    CONSTRAINT FK_dm_proveedor_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES BI.dm_ubicacion(id_ubicacion)
);
GO


--sucursal
CREATE TABLE BI.dm_sucursal (
    id_sucursal INT PRIMARY KEY,
    direccion NVARCHAR(150),
    telefono NVARCHAR(20),
    id_ubicacion INT,
    CONSTRAINT FK_dm_sucursal_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES BI.dm_ubicacion(id_ubicacion)
);
GO
--tiempo
CREATE TABLE BI.dm_tiempo (
    id_tiempo INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    anio INT,
    cuatrimestre INT,
    mes INT
);
GO
--turno
CREATE TABLE BI.dm_turno (
    id_turno INT IDENTITY(1,1) PRIMARY KEY,
    descripcion_turno NVARCHAR(20)
);
GO
--estadopedido
CREATE TABLE BI.dm_estado_pedido (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    estado NVARCHAR(255)
);
GO
--material
CREATE TABLE BI.dm_material (
    id_material INT PRIMARY KEY,
    tipo_material NVARCHAR(50),
    descripcion NVARCHAR(100),
    precio DECIMAL(10,2),
    uso_material NVARCHAR(20)  
);
GO
--modelo
CREATE TABLE BI.dm_modelo (
    id_modelo INT PRIMARY KEY,
    modelo_nombre NVARCHAR(100),
    modelo_descripcion NVARCHAR(255),
    modelo_precio DECIMAL(10, 2)
);
GO

-----------inserts dimensiones-------
--UBICACION
INSERT INTO BI.dm_ubicacion (localidad, provincia)
SELECT DISTINCT
    l.localidad_descripcion,
    p.provincia_descripcion
FROM Localidad l
JOIN Provincia p ON l.localidad_provincia = p.provincia_id;
GO


--CLIENTE
INSERT INTO BI.dm_cliente (
    id_cliente, nombre, apellido, fecha_nacimiento, direccion,
    telefono, mail, edad, rango_etario, id_ubicacion
)
SELECT
    c.cliente_id,
    c.cliente_nombre,
    c.cliente_apellido,
    c.cliente_fechanacimiento,
    c.cliente_direccion,
    c.cliente_telefono,
    c.cliente_mail,
    DATEDIFF(YEAR, c.cliente_fechanacimiento, GETDATE()),
    DB.getRangoEtario(c.cliente_fechanacimiento),
    u.id_ubicacion
FROM Cliente c
JOIN Localidad l ON c.cliente_localidad = l.localidad_id
JOIN Provincia p ON l.localidad_provincia = p.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = p.provincia_descripcion;
GO

-- PROVEEDOR


INSERT INTO BI.dm_proveedor (
    id_proveedor, nombre, direccion, telefono, mail, id_ubicacion
)
SELECT
    p.proveedor_id,
    p.proveedor_nombre,
    p.proveedor_direccion,
    p.proveedor_telefono,
    p.proveedor_mail,
    u.id_ubicacion
FROM Proveedor p
JOIN Localidad l ON p.proveedor_localidad = l.localidad_id
JOIN Provincia pr ON l.localidad_provincia = pr.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = pr.provincia_descripcion;
GO


--SUCURSAL


INSERT INTO BI.dm_sucursal (
    id_sucursal, direccion, telefono, id_ubicacion
)
SELECT
    s.sucursal_id,
    s.sucursal_direccion,
    s.sucursal_telefono,
    u.id_ubicacion
FROM Sucursal s
JOIN Localidad l ON s.sucursal_localidad = l.localidad_id
JOIN Provincia pr ON l.localidad_provincia = pr.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = pr.provincia_descripcion;
GO


-- tiempo

INSERT INTO BI.dm_tiempo (fecha, anio, cuatrimestre, mes)
SELECT DISTINCT
    f.fecha,
    YEAR(f.fecha),
    BI.getCuatrimestre(f.fecha),
    MONTH(f.fecha)
FROM (
    SELECT pedido_fecha AS fecha FROM Pedido
    UNION
    SELECT factura_fecha FROM Factura
) AS f;
GO

--TURNO
INSERT INTO BI.dm_turno (descripcion_turno)
SELECT DISTINCT
    BI.getTurnoVenta(f.fecha_hora)
FROM (
    SELECT CAST(pedido_fecha AS DATETIME) AS fecha_hora FROM Pedido
    UNION
    SELECT CAST(factura_fecha AS DATETIME) FROM Factura
) AS f;
GO


-- ESTADO PEDIDO
INSERT INTO BI.dm_estado_pedido (estado)
SELECT DISTINCT pedido_estado FROM Pedido;
GO




-- material
-- para tela
INSERT INTO BI.dm_material (id_material, tipo_material, descripcion, precio, uso_material)
SELECT DISTINCT
    m.material_id,
    m.material_tipo,
    m.material_descripcion,
    m.material_precio,
    'Tela'
FROM Material m
JOIN Tela t ON t.tela_material = m.material_id;

-- para relleno
INSERT INTO BI.dm_material (id_material, tipo_material, descripcion, precio, uso_material)
SELECT DISTINCT
    m.material_id,
    m.material_tipo,
    m.material_descripcion,
    m.material_precio,
    'Relleno'
FROM Material m
JOIN Relleno r ON r.relleno_material = m.material_id
WHERE m.material_id NOT IN (SELECT tela_material FROM Tela); 

--para madera
INSERT INTO BI.dm_material (id_material, tipo_material, descripcion, precio, uso_material)
SELECT
    m.material_id,
    m.material_tipo,
    m.material_descripcion,
    m.material_precio,
    'Madera'
FROM Material m
WHERE m.material_tipo = 'Madera'
  AND m.material_id NOT IN (
        SELECT tela_material FROM Tela
        UNION
        SELECT relleno_material FROM Relleno
    );


--modelo
INSERT INTO BI.dm_modelo (id_modelo, modelo_nombre, modelo_descripcion, modelo_precio)
SELECT DISTINCT
    sm.sillon_modelo_codigo,
    sm.sillon_modelo,
    sm.sillon_modelo_descripcion,
    sm.sillon_modelo_precio
FROM Sillon_Modelo sm;

------------------TABLAS DE HECHOS -----------------------------------------
-- ENVIO
CREATE TABLE BI.ft_envio (
    id_tiempo INT,
    id_cliente INT,
    id_pedido INT,
    id_sucursal INT,
    fecha_envio_programada DATE,
    fecha_envio_real DATE,
    costo_envio DECIMAL(10,2),
    cumplimiento_en_tiempo BIT,
    PRIMARY KEY (id_tiempo, id_cliente, id_pedido, id_sucursal),
    FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal)
);
GO
--PEDIDO
CREATE TABLE BI.ft_pedido (
    id_cliente INT,
    id_pedido INT,
    id_modelo INT,
    id_tiempo INT,
    id_estado INT,
    id_turno INT,
    cantidad_pedida INT,
    PRIMARY KEY (id_cliente, id_pedido, id_modelo, id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (id_modelo) REFERENCES BI.dm_modelo(id_modelo),
    FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo),
    FOREIGN KEY (id_estado) REFERENCES BI.dm_estado_pedido(id_estado),
    FOREIGN KEY (id_turno) REFERENCES BI.dm_turno(id_turno)
);
GO
--FACTURA
CREATE TABLE BI.ft_factura (
    id_factura INT,
    id_cliente INT,
    id_pedido INT,
    id_sucursal INT,
    id_tiempo INT,
    total_facturado DECIMAL(10,2),
    tiempo_fabricacion INT,
    PRIMARY KEY (id_factura, id_cliente, id_pedido, id_sucursal, id_tiempo),
    FOREIGN KEY (id_factura) REFERENCES Factura(factura_numero),
    FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal),
    FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo)
);
GO

--COMPRA
CREATE TABLE BI.ft_compra (
    id_compra INT,
    id_proveedor INT,
    id_material INT,
    id_tiempo INT,
    monto_compra DECIMAL(10,2),
    cantidad_comprada INT,
    PRIMARY KEY (id_compra, id_proveedor, id_material, id_tiempo),
    FOREIGN KEY (id_compra) REFERENCES Compra(compra_numero),
    FOREIGN KEY (id_proveedor) REFERENCES BI.dm_proveedor(id_proveedor),
    FOREIGN KEY (id_material) REFERENCES BI.dm_material(id_material),
    FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo)
);
GO
--- INSERTS HECHOS-----------

----VISTAS------

