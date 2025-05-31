-- Eliminacion de objetos existentes

PRINT '1. Eliminando objetos existentes';
GO

-- Eliminar Foreign keys antes de las tablas para evitar errores de dependencia.
-- F -> FK

IF OBJECT_ID('LOS_GESTORES.FK_DetalleFactura_Factura', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Detalle_Factura DROP CONSTRAINT FK_DetalleFactura_Factura;
IF OBJECT_ID('LOS_GESTORES.FK_DetalleFactura_DetallePedido', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Detalle_Factura DROP CONSTRAINT FK_DetalleFactura_DetallePedido;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Envio_Factura', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Envio DROP CONSTRAINT FK_Envio_Factura;
GO

IF OBJECT_ID('LOS_GESTORES.FK_DetallePedido_Pedido', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Detalle_Pedido DROP CONSTRAINT FK_DetallePedido_Pedido;
IF OBJECT_ID('LOS_GESTORES.FK_DetallePedido_Sillon', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Detalle_Pedido DROP CONSTRAINT FK_DetallePedido_Sillon;
GO

IF OBJECT_ID('LOS_GESTORES.FK_DetalleCompra_Compra', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Detalle_Compra DROP CONSTRAINT FK_DetalleCompra_Compra;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Pedido_Cliente', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Pedido DROP CONSTRAINT FK_Pedido_Cliente;
IF OBJECT_ID('LOS_GESTORES.FK_Pedido_Sucursal', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Pedido DROP CONSTRAINT FK_Pedido_Sucursal;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Factura_Cliente', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Factura DROP CONSTRAINT FK_Factura_Cliente;
IF OBJECT_ID('LOS_GESTORES.FK_Factura_Sucursal', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Factura DROP CONSTRAINT FK_Factura_Sucursal;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Compra_Proveedor', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Compra DROP CONSTRAINT FK_Compra_Proveedor;
IF OBJECT_ID('LOS_GESTORES.FK_Compra_Sucursal', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Compra DROP CONSTRAINT FK_Compra_Sucursal;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Sillon_Modelo', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sillon DROP CONSTRAINT FK_Sillon_Modelo;
IF OBJECT_ID('LOS_GESTORES.FK_Sillon_Medida', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sillon DROP CONSTRAINT FK_Sillon_Medida;
IF OBJECT_ID('LOS_GESTORES.FK_Sillon_Madera', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sillon DROP CONSTRAINT FK_Sillon_Madera;
IF OBJECT_ID('LOS_GESTORES.FK_Sillon_Tela', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sillon DROP CONSTRAINT FK_Sillon_Tela;
IF OBJECT_ID('LOS_GESTORES.FK_Sillon_Relleno', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sillon DROP CONSTRAINT FK_Sillon_Relleno;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Cliente_Localidad', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Cliente DROP CONSTRAINT FK_Cliente_Localidad;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Sucursal_Localidad', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Sucursal DROP CONSTRAINT FK_Sucursal_Localidad;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Proveedor_Localidad', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Proveedor DROP CONSTRAINT FK_Proveedor_Localidad;
GO

IF OBJECT_ID('LOS_GESTORES.FK_Localidad_Provincia', 'F') IS NOT NULL ALTER TABLE LOS_GESTORES.Localidad DROP CONSTRAINT FK_Localidad_Provincia;
GO

-- Eliminar tablas 
-- U -> Tabla

IF OBJECT_ID('LOS_GESTORES.Detalle_Factura', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Detalle_Factura;
IF OBJECT_ID('LOS_GESTORES.Envio', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Envio;
IF OBJECT_ID('LOS_GESTORES.Detalle_Pedido', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Detalle_Pedido;
IF OBJECT_ID('LOS_GESTORES.Detalle_Compra', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Detalle_Compra;
IF OBJECT_ID('LOS_GESTORES.Pedido', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Pedido;
IF OBJECT_ID('LOS_GESTORES.Factura', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Factura;
IF OBJECT_ID('LOS_GESTORES.Compra', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Compra;
IF OBJECT_ID('LOS_GESTORES.Sillon', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Sillon;
IF OBJECT_ID('LOS_GESTORES.Tela', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Tela;
IF OBJECT_ID('LOS_GESTORES.Madera', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Madera;
IF OBJECT_ID('LOS_GESTORES.Relleno', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Relleno;
IF OBJECT_ID('LOS_GESTORES.Sillon_Medida', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Sillon_Medida;
IF OBJECT_ID('LOS_GESTORES.Sillon_Modelo', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Sillon_Modelo;
IF OBJECT_ID('LOS_GESTORES.Cliente', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Cliente;
IF OBJECT_ID('LOS_GESTORES.Proveedor', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Proveedor;
IF OBJECT_ID('LOS_GESTORES.Sucursal', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Sucursal;
IF OBJECT_ID('LOS_GESTORES.Localidad', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Localidad;
IF OBJECT_ID('LOS_GESTORES.Provincia', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.Provincia;
IF OBJECT_ID('LOS_GESTORES.LOS_GESTORES', 'U') IS NOT NULL DROP TABLE LOS_GESTORES.LOS_GESTORES; -- Tu tabla de grupo
GO

-- Eliminar Stored Procedures
-- P -> SP

IF OBJECT_ID('LOS_GESTORES.SP_PROVINCIA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_PROVINCIA;
IF OBJECT_ID('LOS_GESTORES.SP_LOCALIDAD', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_LOCALIDAD;
IF OBJECT_ID('LOS_GESTORES.SP_CLIENTE', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_CLIENTE;
IF OBJECT_ID('LOS_GESTORES.SP_SUCURSAL', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_SUCURSAL;
IF OBJECT_ID('LOS_GESTORES.SP_PROVEEDOR', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_PROVEEDOR;
IF OBJECT_ID('LOS_GESTORES.SP_RELLENO', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_RELLENO;
IF OBJECT_ID('LOS_GESTORES.SP_MADERA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_MADERA;
IF OBJECT_ID('LOS_GESTORES.SP_TELA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_TELA;
IF OBJECT_ID('LOS_GESTORES.SP_SILLON_MODELO', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_SILLON_MODELO;
IF OBJECT_ID('LOS_GESTORES.SP_SILLON_MEDIDA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_SILLON_MEDIDA;
IF OBJECT_ID('LOS_GESTORES.SP_SILLON', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_SILLON;
IF OBJECT_ID('LOS_GESTORES.SP_COMPRA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_COMPRA;
IF OBJECT_ID('LOS_GESTORES.SP_DETALLE_COMPRA', 'P') IS NOT NULL DROP PROCEDURE LOS_GESTORES.SP_DETALLE_COMPRA;
GO

-- Eliminar el esquema

IF SCHEMA_ID('LOS_GESTORES') IS NOT NULL
    DROP SCHEMA LOS_GESTORES;
GO

PRINT 'Objetos eliminados correctamente.';

-- Creacion del esquema

PRINT '2. Creando el esquema LOS_GESTORES';
GO

CREATE SCHEMA LOS_GESTORES;
GO

PRINT 'Esquema LOS_GESTORES creado.';

-- Creacion de tablas

PRINT '3. Creando tablas del modelo transaccional';
GO

CREATE TABLE LOS_GESTORES.Provincia (
	provincia_id BIGINT IDENTITY(1, 1),
	provincia_descripcion NVARCHAR(255),
	PRIMARY KEY(provincia_id)
);

CREATE TABLE LOS_GESTORES.Localidad (
	localidad_id BIGINT IDENTITY(1, 1),
	localidad_descripcion NVARCHAR(255),
	localidad_provincia BIGINT,
	PRIMARY KEY(localidad_id)
);

CREATE TABLE LOS_GESTORES.Relleno (
	relleno_id BIGINT IDENTITY(1, 1),
	relleno_densidad DECIMAL(38, 2),
	relleno_nombre NVARCHAR(255),
	relleno_precio DECIMAL(38, 2),
	relleno_descripcion NVARCHAR(255),
	PRIMARY KEY(relleno_id)
);

CREATE TABLE LOS_GESTORES.Madera (
	madera_id BIGINT IDENTITY(1, 1), -- madera_color + madera_dureza
	madera_color NVARCHAR(255),
	madera_dureza NVARCHAR(255),
	madera_nombre NVARCHAR(255),
	madera_precio DECIMAL(38, 2),
	madera_descripcion NVARCHAR(255),
	PRIMARY KEY(madera_id)
);

CREATE TABLE LOS_GESTORES.Tela (
	tela_id BIGINT IDENTITY(1, 1), -- tela_color + tela_textura
	tela_color NVARCHAR(255),
	tela_textura NVARCHAR(255),
	tela_nombre NVARCHAR(255),
	tela_precio DECIMAL(38, 2),
	tela_descripcion NVARCHAR(255),
	PRIMARY KEY(tela_id)
);

CREATE TABLE LOS_GESTORES.Sillon_Modelo (
	sillon_modelo_codigo BIGINT, 
	sillon_modelo NVARCHAR(255),
	sillon_modelo_descripcion NVARCHAR(255),
	sillon_modelo_precio DECIMAL(18, 2),
	PRIMARY KEY(sillon_modelo_codigo)
);

CREATE TABLE LOS_GESTORES.Sillon_Medida (
	sillon_medida_id BIGINT IDENTITY(1, 1), -- sillon_medida_alto + sillon_medida_ancho + sillon_medida_profundidad
	sillon_medida_alto DECIMAL(18, 2),
	sillon_medida_ancho DECIMAL(18, 2),
	sillon_medida_profundidad DECIMAL(18, 2),
	sillon_medida_precio DECIMAL(18, 2),
	PRIMARY KEY(sillon_medida_id)
);

CREATE TABLE LOS_GESTORES.Cliente (
    cliente_id BIGINT IDENTITY(1, 1), -- cliente_dni + cliente_nombre + cliente_apellido
    cliente_dni BIGINT,
    cliente_localidad NVARCHAR(255),
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2(6),
    cliente_mail NVARCHAR(255),
    cliente_direccion NVARCHAR(255),
    cliente_telefono NVARCHAR(255),
	PRIMARY KEY(cliente_id)
);

CREATE TABLE LOS_GESTORES.Sucursal (
	sucursal_nroSucursal BIGINT IDENTITY(1, 1),
	sucursal_localidad BIGINT,
	sucursal_direccion NVARCHAR(255),
	sucursal_telefono NVARCHAR(255),
	sucursal_mail NVARCHAR(255),
	PRIMARY KEY(sucursal_nroSucursal)
);

CREATE TABLE LOS_GESTORES.Proveedor (
	proveedor_id BIGINT IDENTITY(1, 1), -- proveedor_cuit + ...
	proveedor_cuit NVARCHAR(255),
	proveedor_localidad BIGINT,
	proveedor_razonSocial NVARCHAR(255),
	proveedor_direccion NVARCHAR(255),
	proveedor_telefono NVARCHAR(255),
	proveedor_mail NVARCHAR(255),
	PRIMARY KEY(proveedor_id)
);

CREATE TABLE LOS_GESTORES.Sillon (
	sillon_codigo BIGINT,
	sillon_modelo_codigo BIGINT, 
	sillon_medida_id BIGINT, 
	sillon_madera_id BIGINT, 
	sillon_tela_id BIGINT, 
	sillon_relleno_id BIGINT, 
	PRIMARY KEY(sillon_codigo)
);

CREATE TABLE LOS_GESTORES.Pedido (
	pedido_numero DECIMAL(18, 0),
	pedido_cliente_id BIGINT,
	pedido_sucursal_nroSucursal BIGINT,
	pedido_fecha DATETIME2(6),
	pedido_total DECIMAL(18, 2),
	pedido_estado NVARCHAR(255),
	pedido_cancelacion_fecha DATETIME2(6),
	pedido_cancelacion_motivo VARCHAR(255),
	PRIMARY KEY(pedido_numero)
);

CREATE TABLE LOS_GESTORES.Factura (
	factura_numero BIGINT,
	factura_cliente_id BIGINT,
	factura_sucursal_nroSucursal BIGINT,
	factura_fecha DATETIME2(6),
	factura_total DECIMAL(38, 2),
	PRIMARY KEY(factura_numero)
);

CREATE TABLE LOS_GESTORES.Compra (
	compra_numero DECIMAL(18, 0),
	compra_proveedor_id BIGINT, 
	compra_sucursal_nroSucursal BIGINT,
	compra_fecha DATETIME2(6),
	compra_total DECIMAL(18, 2),
	PRIMARY KEY(compra_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Pedido (
	detalle_pedido_id BIGINT IDENTITY(1, 1), -- detalle_pedido_numero + detalle_pedido_sillon_codigo
	detalle_pedido_numero DECIMAL(18, 0),
	detalle_pedido_sillon_codigo BIGINT,
	detalle_pedido_cantidad BIGINT,
	detalle_pedido_precio DECIMAL(18, 2),
	PRIMARY KEY(detalle_pedido_id)
);

CREATE TABLE LOS_GESTORES.Detalle_Factura (
	detalle_factura_id BIGINT IDENTITY(1, 1), -- detalle_factura_numero + detalle_factura_pedido_id
	detalle_factura_numero BIGINT,
	detalle_factura_pedido_id BIGINT, 
	detalle_factura_cantidad DECIMAL(18, 0),
	detalle_factura_precio DECIMAL(18, 2),
	PRIMARY KEY(detalle_factura_id)
);

CREATE TABLE LOS_GESTORES.Detalle_Compra (
	detalle_compra_id BIGINT IDENTITY(1, 1), -- detalle_compra_numero + detalle_compra_material_id
	detalle_compra_numero DECIMAL(18, 0),
	detalle_compra_material_tipo BIGINT,
	detalle_compra_precio DECIMAL(18, 2),
	detalle_compra_cantidad DECIMAL(18, 0),
	PRIMARY KEY(detalle_compra_id)
);

CREATE TABLE LOS_GESTORES.Envio (
	envio_numero DECIMAL(18, 0),
	envio_factura_numero BIGINT,
	envio_fecha_programada DATETIME2(6),
	envio_fecha DATETIME2(6),
	envio_importe_traslado DECIMAL(18, 2),
	envio_importe_subida DECIMAL(18, 2),
	PRIMARY KEY(envio_numero)
);

/*
CREATE TABLE LOS_GESTORES.Material (
	material_id  BIGINT IDENTITY(1, 1), -- material_tipo + material_nombre
	material_tipo NVARCHAR(255),
	material_nombre NVARCHAR(255),
	material_precio DECIMAL(38, 2),
	material_tela_id BIGINT, 
	material_madera_id BIGINT,
	material_relleno_densidad DECIMAL(38, 2),
	PRIMARY KEY(material_id)
);
*/

-- Tabla de identificación del grupo

CREATE TABLE LOS_GESTORES.LOS_GESTORES (
    grupo_nombre NVARCHAR(255),
    numero_grupo BIGINT,
    curso NVARCHAR(255),
    integrante1_nombre NVARCHAR(255),
    integrante1_padron BIGINT,
    integrante2_nombre NVARCHAR(255),
    integrante2_padron BIGINT,
    integrante3_nombre NVARCHAR(255),
    integrante3_padron BIGINT,
    integrante4_nombre NVARCHAR(255),
    integrante4_padron BIGINT
);
GO

PRINT 'Tablas creadas correctamente.';

-- Creacion de vista

PRINT '4. Creacion de vista';
GO

CREATE VIEW LOS_GESTORES.Material AS
SELECT 'Madera' AS Material_tipo,
       madera_id AS Material_id,
       madera_nombre AS Material_nombre,
       madera_descripcion AS Material_descripcion,
       madera_precio AS Material_precio
FROM LOS_GESTORES.Madera
UNION 
SELECT 'Tela' AS Material_tipo,
       tela_id AS Material_id,
       tela_nombre AS Material_nombre,
       tela_descripcion AS Material_descripcion,
       tela_precio AS Material_precio
FROM LOS_GESTORES.Tela
UNION 
SELECT 'Relleno' AS Material_tipo,
       relleno_id AS Material_id,
       relleno_nombre AS Material_nombre,
       relleno_descripcion AS Material_descripcion,
       relleno_precio AS Material_precio
FROM LOS_GESTORES.Relleno;
GO

PRINT 'Vista creada correctamente.';

-- Implementacion de Constraints Unique

PRINT '5. Implementando constraints UNIQUE';
GO

ALTER TABLE LOS_GESTORES.Provincia
ADD CONSTRAINT UQ_Provincia_Descripcion UNIQUE (provincia_descripcion);
GO

ALTER TABLE LOS_GESTORES.Localidad
ADD CONSTRAINT UQ_Localidad_Descripcion_Provincia UNIQUE (localidad_descripcion, localidad_provincia);
GO

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT UQ_Proveedor_CUIT UNIQUE (proveedor_cuit);
GO

ALTER TABLE LOS_GESTORES.Cliente
ADD CONSTRAINT UQ_Cliente_DNI_Nombre_Apellido UNIQUE (cliente_dni, cliente_nombre, cliente_apellido);
GO

ALTER TABLE LOS_GESTORES.Sillon_Medida
ADD CONSTRAINT UQ_SillonMedida_Alto_Ancho_Profundidad UNIQUE (sillon_medida_alto, sillon_medida_ancho, sillon_medida_profundidad);
GO

ALTER TABLE LOS_GESTORES.Madera
ADD CONSTRAINT UQ_Madera_Color_Nombre UNIQUE (madera_color, madera_nombre);
GO

ALTER TABLE LOS_GESTORES.Tela
ADD CONSTRAINT UQ_Tela_Color_Descripcion UNIQUE (tela_color, tela_descripcion);
GO

ALTER TABLE LOS_GESTORES.Relleno
ADD CONSTRAINT UQ_Relleno_Nombre UNIQUE (relleno_nombre);
GO

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT UQ_DetallePedido_Numero_Sillon UNIQUE (detalle_pedido_numero, detalle_pedido_sillon_codigo);
GO

PRINT 'Constraints UNIQUE implementados correctamente.';

-- Implementacion de las FKs

PRINT '6. Implementando FKs';
GO

ALTER TABLE LOS_GESTORES.Localidad
ADD CONSTRAINT FK_Localidad_Provincia FOREIGN KEY(localidad_provincia) REFERENCES LOS_GESTORES.Provincia(provincia_id);
GO

ALTER TABLE LOS_GESTORES.Cliente
ADD CONSTRAINT FK_Cliente_Localidad FOREIGN KEY(cliente_localidad) REFERENCES LOS_GESTORES.Localidad(localidad_id);
GO

ALTER TABLE LOS_GESTORES.Sucursal
ADD CONSTRAINT FK_Sucursal_Localidad FOREIGN KEY(sucursal_localidad) REFERENCES LOS_GESTORES.Localidad(localidad_id);
GO

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT FK_Proveedor_Localidad FOREIGN KEY(proveedor_localidad) REFERENCES LOS_GESTORES.Localidad(localidad_id);
GO

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_Sillon_Modelo FOREIGN KEY(sillon_modelo_codigo) REFERENCES LOS_GESTORES.Sillon_Modelo(sillon_modelo_codigo);
GO

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_Sillon_Medida FOREIGN KEY(sillon_medida_id) REFERENCES LOS_GESTORES.Sillon_Medida(sillon_medida_id);
GO

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_Sillon_Madera FOREIGN KEY(sillon_madera_id) REFERENCES LOS_GESTORES.Madera(madera_id);
GO

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_Sillon_Tela FOREIGN KEY(sillon_tela_id) REFERENCES LOS_GESTORES.Tela(tela_id);
GO

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_Sillon_Relleno FOREIGN KEY(sillon_relleno_id) REFERENCES LOS_GESTORES.Relleno(relleno_id);
GO

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_Pedido_Cliente FOREIGN KEY(pedido_cliente_id) REFERENCES LOS_GESTORES.Cliente(cliente_id);
GO

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_Pedido_Sucursal FOREIGN KEY(pedido_sucursal_nroSucursal) REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal);
GO

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_Factura_Cliente FOREIGN KEY(factura_cliente_id) REFERENCES LOS_GESTORES.Cliente(cliente_id);
GO

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_Factura_Sucursal FOREIGN KEY(factura_sucursal_nroSucursal) REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal);
GO

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_Compra_Proveedor FOREIGN KEY(compra_proveedor_id) REFERENCES LOS_GESTORES.Proveedor(proveedor_id);
GO

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_Compra_Sucursal FOREIGN KEY(compra_sucursal_nroSucursal) REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal);
GO

ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY(detalle_compra_numero) REFERENCES LOS_GESTORES.Compra(compra_numero);
GO

ALTER TABLE LOS_GESTORES.Envio
ADD CONSTRAINT FK_Envio_Factura FOREIGN KEY(envio_factura_numero) REFERENCES LOS_GESTORES.Factura(factura_numero);
GO

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY(detalle_pedido_numero) REFERENCES LOS_GESTORES.Pedido(pedido_numero);
GO

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DetallePedido_Sillon FOREIGN KEY(detalle_pedido_sillon_codigo) REFERENCES LOS_GESTORES.Sillon(sillon_codigo);
GO

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY(detalle_factura_numero) REFERENCES LOS_GESTORES.Factura(factura_numero);
GO

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DetalleFactura_DetallePedido FOREIGN KEY(detalle_factura_pedido_id) REFERENCES LOS_GESTORES.Detalle_Pedido(detalle_pedido_id);
GO

-- ALTER TABLE LOS_GESTORES.Detalle_Compra 
-- ADD FOREIGN KEY(detalle_compra_material_id) REFERENCES LOS_GESTORES.Material(material_id);
-- GO

-- ALTER TABLE LOS_GESTORES.Material 
-- ADD FOREIGN KEY(material_tela_id) REFERENCES LOS_GESTORES.Tela(tela_id);
-- GO

-- ALTER TABLE LOS_GESTORES.Material 
-- ADD FOREIGN KEY(material_madera_id) REFERENCES LOS_GESTORES.Madera(madera_id);
-- GO

-- ALTER TABLE LOS_GESTORES.Material 
-- ADD FOREIGN KEY(material_relleno_densidad) REFERENCES LOS_GESTORES.Relleno(relleno_densidad);
-- GO

PRINT 'FKs implementadas correctamente.';

-- Insercion de datos de la tabla LOS_GESTORES

PRINT '7. Insertando datos de LOS_GESTORES';
GO

INSERT INTO LOS_GESTORES.LOS_GESTORES (
    grupo_nombre, numero_grupo, curso,
    integrante1_nombre, integrante1_padron,
    integrante2_nombre, integrante2_padron,
    integrante3_nombre, integrante3_padron,
    integrante4_nombre, integrante4_padron
)
VALUES (
    'LOS_GESTORES',
    36,
    'K3051',
    'Nahuel Franco Terrazas Alcocer', 1731038,
    'Cesar Villalba', 1103544,
    'Agustina Denise Righetti', 1762321,
    'Andrea Denise Villanueva', 1500569
);
GO

PRINT 'Datos de LOS_GESTORES insertados correctamente.';

-- Creacion de los Stored procedures

PRINT '8. Creando Stored Procedures de migración';
GO

CREATE PROCEDURE LOS_GESTORES.SP_PROVINCIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.PROVINCIA (provincia_descripcion)
    SELECT DISTINCT Proveedor_Provincia
    FROM gd_esquema.MAESTRA
    WHERE Proveedor_Provincia IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.PROVINCIA p
          WHERE p.provincia_descripcion = MAESTRA.Proveedor_Provincia
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_LOCALIDAD
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.LOCALIDAD (localidad_descripcion, localidad_provincia)
    SELECT DISTINCT
        m.Proveedor_Localidad,
        p.provincia_id
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
    WHERE m.Proveedor_Localidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.LOCALIDAD l
          WHERE l.localidad_descripcion = m.Proveedor_Localidad
            AND l.localidad_provincia = p.provincia_id
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_CLIENTE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.CLIENTE (
        cliente_dni,
        cliente_nombre,
        cliente_apellido,
        cliente_fechaNacimiento,
        cliente_mail,
        cliente_direccion,
        cliente_telefono,
        cliente_localidad
    )
    SELECT DISTINCT
        m.Cliente_DNI,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_FechaNacimiento,
        m.Cliente_Mail,
        m.Cliente_Direccion,
        m.Cliente_Telefono,
        l.localidad_id
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Cliente_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Cliente_Localidad
                                  AND l.localidad_provincia = p.provincia_id
    WHERE m.Cliente_Nombre IS NOT NULL
      AND m.Cliente_Apellido IS NOT NULL
      AND m.Cliente_DNI IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.CLIENTE c
          WHERE c.cliente_dni = m.Cliente_DNI
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SUCURSAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.SUCURSAL (
        -- sucursal_nroSucursal es IDENTITY, no se inserta directamente
        sucursal_direccion,
        sucursal_localidad,
        sucursal_telefono,
        sucursal_mail
    )
    SELECT DISTINCT
        m.Sucursal_Direccion,
        l.localidad_id,
        m.Sucursal_Telefono,
        m.Sucursal_Mail
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Sucursal_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Sucursal_Localidad
                                  AND l.localidad_provincia = p.provincia_id
    WHERE m.Sucursal_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.SUCURSAL s
          WHERE s.sucursal_direccion = m.Sucursal_Direccion
            AND s.sucursal_localidad = l.localidad_id
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_PROVEEDOR
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.PROVEEDOR (
        proveedor_cuit,
        proveedor_localidad,
        proveedor_razonSocial,
        proveedor_direccion,
        proveedor_telefono,
        proveedor_mail
    )
    SELECT DISTINCT
        m.Proveedor_CUIT,
        l.localidad_id,
        m.Proveedor_RazonSocial,
        m.Proveedor_Direccion,
        m.Proveedor_Telefono,
        m.Proveedor_Mail
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Proveedor_Localidad
                                  AND l.localidad_provincia = p.provincia_id
    WHERE m.Proveedor_CUIT IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.PROVEEDOR pr
          WHERE pr.proveedor_cuit = m.Proveedor_CUIT
      );
END;
GO

/*
CREATE PROCEDURE LOS_GESTORES.SP_RELLENO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Relleno (relleno_nombre, relleno_descripcion, relleno_precio, relleno_densidad)
    SELECT DISTINCT
        CONVERT(NVARCHAR(255), m.Relleno_Densidad) AS relleno_nombre,
        'Densidad: ' + CONVERT(NVARCHAR(255), m.Relleno_Densidad) AS relleno_descripcion,
        NULL AS relleno_precio,
        m.Relleno_Densidad
    FROM gd_esquema.MAESTRA m
    WHERE m.Relleno_Densidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Relleno r
          WHERE r.relleno_nombre = CONVERT(NVARCHAR(255), m.Relleno_Densidad)
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_MADERA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Madera (madera_nombre, madera_descripcion, madera_color, madera_precio, madera_dureza)
    SELECT DISTINCT
        m.Madera_Dureza AS madera_nombre,
        'Color: ' + m.Madera_Color + ', Dureza: ' + m.Madera_Dureza AS madera_descripcion,
        m.Madera_Color,
        NULL AS madera_precio,
        m.Madera_Dureza
    FROM gd_esquema.MAESTRA m
    WHERE m.Madera_Color IS NOT NULL
      AND m.Madera_Dureza IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Madera md
          WHERE md.madera_color = m.Madera_Color
            AND md.madera_nombre = m.Madera_Dureza
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_TELA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Tela (tela_descripcion, tela_color, tela_precio, tela_nombre, tela_textura)
    SELECT DISTINCT
        m.Tela_Textura AS tela_descripcion,
        m.Tela_Color,
        NULL AS tela_precio,
        m.Tela_Textura AS tela_nombre, -- Usamos textura como nombre también
        m.Tela_Textura
    FROM gd_esquema.MAESTRA m
    WHERE m.Tela_Color IS NOT NULL
      AND m.Tela_Textura IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Tela tl
          WHERE tl.tela_color = m.Tela_Color
            AND tl.tela_descripcion = m.Tela_Textura
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MODELO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Sillon_Modelo (sillon_modelo_codigo, sillon_modelo, sillon_modelo_descripcion, sillon_modelo_precio)
    SELECT DISTINCT
        m.Sillon_Modelo_Codigo,
        m.Sillon_Modelo,
        m.Sillon_Modelo_Descripcion,
        m.Sillon_Modelo_Precio
    FROM gd_esquema.MAESTRA m
    WHERE m.Sillon_Modelo_Codigo IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Sillon_Modelo sm
          WHERE sm.sillon_modelo_codigo = m.Sillon_Modelo_Codigo
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MEDIDA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Sillon_Medida (sillon_medida_alto, sillon_medida_ancho, sillon_medida_profundidad, sillon_medida_precio)
    SELECT DISTINCT
        m.Sillon_Medida_Alto,
        m.Sillon_Medida_Ancho,
        m.Sillon_Medida_Profundidad,
        m.Sillon_Medida_Precio
    FROM gd_esquema.MAESTRA m
    WHERE m.Sillon_Medida_Alto IS NOT NULL
      AND m.Sillon_Medida_Ancho IS NOT NULL
      AND m.Sillon_Medida_Profundidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Sillon_Medida sm
          WHERE sm.sillon_medida_alto = m.Sillon_Medida_Alto
            AND sm.sillon_medida_ancho = m.Sillon_Medida_Ancho
            AND sm.sillon_medida_profundidad = m.Sillon_Medida_Profundidad
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.Sillon (
        sillon_codigo,
        sillon_modelo_codigo,
        sillon_medida_id,
        sillon_madera_id,
        sillon_tela_id,
        sillon_relleno_id
    )
    SELECT DISTINCT
        m.Sillon_Codigo,
        sm.sillon_modelo_codigo,
        sme.sillon_medida_id,
        md.madera_id,
        tl.tela_id,
        rl.relleno_id
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Sillon_Modelo sm ON sm.sillon_modelo_codigo = m.Sillon_Modelo_Codigo
    JOIN LOS_GESTORES.Sillon_Medida sme ON sme.sillon_medida_alto = m.Sillon_Medida_Alto
                                       AND sme.sillon_medida_ancho = m.Sillon_Medida_Ancho
                                       AND sme.sillon_medida_profundidad = m.Sillon_Medida_Profundidad
    JOIN LOS_GESTORES.Madera md ON md.madera_color = m.Madera_Color
                                AND md.madera_nombre = m.Madera_Dureza -- Asumiendo este mapeo para nombre
    JOIN LOS_GESTORES.Tela tl ON tl.tela_color = m.Tela_Color
                              AND tl.tela_descripcion = m.Tela_Textura -- Asumiendo este mapeo para descripcion
    JOIN LOS_GESTORES.Relleno rl ON rl.relleno_nombre = CONVERT(NVARCHAR(255), m.Relleno_Densidad) -- Asumiendo este mapeo para nombre
    WHERE m.Sillon_Codigo IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Sillon s
          WHERE s.sillon_codigo = m.Sillon_Codigo
      );
END;
GO
*/

CREATE PROCEDURE LOS_GESTORES.SP_COMPRA
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.Compra (
        compra_numero,
        compra_proveedor_id,
        compra_sucursal_nroSucursal,
        compra_fecha,
        compra_total
    )
    SELECT DISTINCT
        m.Compra_Numero,
        pr.proveedor_id,
        s.sucursal_nroSucursal,
        m.Compra_Fecha,
        m.Compra_Total
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Proveedor pr ON pr.proveedor_cuit = m.Proveedor_Cuit
    JOIN LOS_GESTORES.Provincia p_suc ON p_suc.provincia_descripcion = m.Sucursal_Provincia
    JOIN LOS_GESTORES.Localidad l_suc ON l_suc.localidad_descripcion = m.Sucursal_Localidad
                                      AND l_suc.localidad_provincia = p_suc.provincia_id
    JOIN LOS_GESTORES.Sucursal s ON s.sucursal_direccion = m.Sucursal_Direccion
                                 AND s.sucursal_localidad = l_suc.localidad_id
    WHERE m.Compra_Numero IS NOT NULL
      AND m.Proveedor_Cuit IS NOT NULL
      AND m.Sucursal_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Compra c
          WHERE c.compra_numero = m.Compra_Numero
      );
END;
GO

/*
CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_COMPRA
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.Detalle_Compra (
        detalle_compra_numero,
        detalle_compra_material_tipo,
        detalle_compra_precio,
        detalle_compra_cantidad
    )
    SELECT DISTINCT
        m.Compra_Numero,
        m.Material_Tipo, 
        m.Material_Nombre, 
        m.Detalle_Compra_Precio,
        m.Detalle_Compra_Cantidad
    FROM gd_esquema.MAESTRA m
    WHERE m.Compra_Numero IS NOT NULL
      AND m.Material_Tipo IS NOT NULL
      AND m.Material_Nombre IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Detalle_Compra dc
          WHERE dc.detalle_compra_numero = m.Compra_Numero
            AND dc.detalle_compra_material_tipo = m.Material_Tipo
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_PEDIDO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Pedido (
        pedido_numero,
        pedido_cliente_id,
        pedido_sucursal_nroSucursal,
        pedido_fecha,
        pedido_total,
        pedido_estado,
        pedido_cancelacion_fecha,
        pedido_cancelacion_motivo
    )
    SELECT DISTINCT
        m.Pedido_Numero,
        c.cliente_id,
        s.sucursal_nroSucursal,
        m.Pedido_Fecha,
        m.Pedido_Total,
        m.Pedido_Estado,
        m.Pedido_Cancelacion_Fecha,
        m.Pedido_Cancelacion_Motivo
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Cliente c ON c.cliente_dni = m.Cliente_DNI -- Asumiendo que DNI es suficiente para unirse a Cliente
    JOIN LOS_GESTORES.Provincia p_suc ON p_suc.provincia_descripcion = m.Sucursal_Provincia
    JOIN LOS_GESTORES.Localidad l_suc ON l_suc.localidad_descripcion = m.Sucursal_Localidad
                                      AND l_suc.localidad_provincia = p_suc.provincia_id
    JOIN LOS_GESTORES.Sucursal s ON s.sucursal_direccion = m.Sucursal_Direccion
                                 AND s.sucursal_localidad = l_suc.localidad_id
    WHERE m.Pedido_Numero IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Pedido p
          WHERE p.pedido_numero = m.Pedido_Numero
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_PEDIDO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Detalle_Pedido (
        detalle_pedido_numero,
        detalle_pedido_sillon_codigo,
        detalle_pedido_cantidad,
        detalle_pedido_precio
    )
    SELECT DISTINCT
        m.Pedido_Numero,
        m.Sillon_Codigo,
        m.Detalle_Pedido_Cantidad,
        m.Detalle_Pedido_Precio
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Pedido p ON p.pedido_numero = m.Pedido_Numero
    JOIN LOS_GESTORES.Sillon si ON si.sillon_codigo = m.Sillon_Codigo
    WHERE m.Pedido_Numero IS NOT NULL
      AND m.Sillon_Codigo IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Detalle_Pedido dp
          WHERE dp.detalle_pedido_numero = m.Pedido_Numero
            AND dp.detalle_pedido_sillon_codigo = m.Sillon_Codigo
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Factura (
        factura_numero,
        factura_cliente_id,
        factura_sucursal_nroSucursal,
        factura_fecha,
        factura_total
    )
    SELECT DISTINCT
        m.Factura_Numero,
        c.cliente_id,
        s.sucursal_nroSucursal,
        m.Factura_Fecha,
        m.Factura_Total
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Cliente c ON c.cliente_dni = m.Cliente_DNI -- Asumiendo que DNI es suficiente para unirse a Cliente
    JOIN LOS_GESTORES.Provincia p_suc ON p_suc.provincia_descripcion = m.Sucursal_Provincia
    JOIN LOS_GESTORES.Localidad l_suc ON l_suc.localidad_descripcion = m.Sucursal_Localidad
                                      AND l_suc.localidad_provincia = p_suc.provincia_id
    JOIN LOS_GESTORES.Sucursal s ON s.sucursal_direccion = m.Sucursal_Direccion
                                 AND s.sucursal_localidad = l_suc.localidad_id
    WHERE m.Factura_Numero IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Factura f
          WHERE f.factura_numero = m.Factura_Numero
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Detalle_Factura (
        detalle_factura_numero,
        detalle_factura_pedido_id,
        detalle_factura_cantidad,
        detalle_factura_precio
    )
    SELECT DISTINCT
        m.Factura_Numero,
        dp.detalle_pedido_id,
        m.Detalle_Factura_Cantidad,
        m.Detalle_Factura_Precio
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Factura f ON f.factura_numero = m.Factura_Numero
    JOIN LOS_GESTORES.Pedido p ON p.pedido_numero = m.Pedido_Numero -- Para unir a Detalle_Pedido
    JOIN LOS_GESTORES.Sillon si ON si.sillon_codigo = m.Sillon_Codigo -- Para unir a Detalle_Pedido
    JOIN LOS_GESTORES.Detalle_Pedido dp ON dp.detalle_pedido_numero = p.pedido_numero
                                        AND dp.detalle_pedido_sillon_codigo = si.sillon_codigo
    WHERE m.Factura_Numero IS NOT NULL
      AND m.Pedido_Numero IS NOT NULL -- Asegurar que el pedido exista para el detalle
      AND m.Sillon_Codigo IS NOT NULL -- Asegurar que el sillón exista para el detalle
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Detalle_Factura df
          WHERE df.detalle_factura_numero = m.Factura_Numero
            AND df.detalle_factura_pedido_id = dp.detalle_pedido_id
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_ENVIO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.Envio (
        envio_numero,
        envio_factura_numero,
        envio_fecha_programada,
        envio_fecha,
        envio_importe_traslado,
        envio_importe_subida
    )
    SELECT DISTINCT
        m.Envio_Numero,
        f.factura_numero,
        m.Envio_Fecha_Programada,
        m.Envio_Fecha,
        m.Envio_ImporteTraslado,
        m.Envio_importeSubida
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.Factura f ON f.factura_numero = m.Factura_Numero
    WHERE m.Envio_Numero IS NOT NULL
      AND m.Factura_Numero IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.Envio e
          WHERE e.envio_numero = m.Envio_Numero
      );
END;
GO
*/

PRINT 'Stored Procedures de migración creados correctamente.';

-- Ejecutar Stored procedures

PRINT '9. Ejecutando Stored Procedures de migración de datos';
GO

EXEC LOS_GESTORES.SP_PROVINCIA;
EXEC LOS_GESTORES.SP_LOCALIDAD;
EXEC LOS_GESTORES.SP_CLIENTE;
EXEC LOS_GESTORES.SP_SUCURSAL;
EXEC LOS_GESTORES.SP_PROVEEDOR;
EXEC LOS_GESTORES.SP_RELLENO;
EXEC LOS_GESTORES.SP_MADERA;
EXEC LOS_GESTORES.SP_TELA;
EXEC LOS_GESTORES.SP_SILLON_MODELO;
EXEC LOS_GESTORES.SP_SILLON_MEDIDA;
EXEC LOS_GESTORES.SP_SILLON; 
EXEC LOS_GESTORES.SP_COMPRA;
EXEC LOS_GESTORES.SP_DETALLE_COMPRA; 
EXEC LOS_GESTORES.SP_PEDIDO; 
EXEC LOS_GESTORES.SP_DETALLE_PEDIDO; 
EXEC LOS_GESTORES.SP_FACTURA; 
EXEC LOS_GESTORES.SP_DETALLE_FACTURA; 
EXEC LOS_GESTORES.SP_ENVIO; 
GO

PRINT 'Migración de datos inicial completada.';
PRINT 'Script finalizado.';
