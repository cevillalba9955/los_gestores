-- Creacion de tablas

CREATE TABLE Cliente (
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

CREATE TABLE Pedido (
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

CREATE TABLE Detalle_Pedido (
	detalle_pedido_id BIGINT IDENTITY(1, 1), -- detalle_pedido_numero + detalle_pedido_sillon_codigo
	detalle_pedido_numero DECIMAL(18, 0),
	detalle_pedido_sillon_codigo BIGINT,
	detalle_pedido_cantidad BIGINT,
	detalle_pedido_precio DECIMAL(18, 2),
	PRIMARY KEY(detalle_pedido_id)
);

CREATE TABLE Factura (
	factura_numero BIGINT,
	factura_cliente_id BIGINT,
	factura_sucursal_nroSucursal BIGINT,
	factura_fecha DATETIME2(6),
	factura_total DECIMAL(38, 2),
	PRIMARY KEY(factura_numero)
);

CREATE TABLE Detalle_Factura (
	detalle_factura_id BIGINT IDENTITY(1, 1), -- detalle_factura_numero + detalle_factura_pedido_id
	detalle_factura_numero BIGINT,
	detalle_factura_pedido_id BIGINT, 
	detalle_factura_cantidad DECIMAL(18, 0),
	detalle_factura_precio DECIMAL(18, 2),
	PRIMARY KEY(detalle_factura_id)
);

CREATE TABLE Sucursal (
	sucursal_nroSucursal BIGINT,
	sucursal_localidad BIGINT,
	sucursal_direccion NVARCHAR(255),
	sucursal_telefono NVARCHAR(255),
	sucursal_mail NVARCHAR(255),
	PRIMARY KEY(sucursal_nroSucursal)
);

CREATE TABLE Proveedor (
	proveedor_id BIGINT IDENTITY(1, 1), -- proveedor_cuit + ...
	proveedor_cuit NVARCHAR(255),
	proveedor_localidad BIGINT,
	proveedor_razonSocial NVARCHAR(255),
	proveedor_direccion NVARCHAR(255),
	proveedor_telefono NVARCHAR(255),
	proveedor_mail NVARCHAR(255),
	PRIMARY KEY(proveedor_id)
);

CREATE TABLE Compra (
	compra_numero DECIMAL(18, 0),
	compra_proveedor_id BIGINT, 
	compra_sucursal_nroSucursal BIGINT,
	compra_fecha DATETIME2(6),
	compra_total DECIMAL(18, 2),
	PRIMARY KEY(compra_numero)
);

CREATE TABLE Detalle_Compra (
	detalle_compra_id BIGINT IDENTITY(1, 1), -- detalle_compra_numero + detalle_compra_material_id
	detalle_compra_numero DECIMAL(18, 0),
	detalle_compra_material_id BIGINT,
	detalle_compra_precio DECIMAL(18, 2),
	detalle_compra_cantidad DECIMAL(18, 0),
	PRIMARY KEY(detalle_compra_id)
);

CREATE TABLE Envio (
	envio_numero DECIMAL(18, 0),
	envio_factura_numero BIGINT,
	envio_fecha_programada DATETIME2(6),
	envio_fecha DATETIME2(6),
	envio_importe_traslado DECIMAL(18, 2),
	envio_importe_subida DECIMAL(18, 2),
	PRIMARY KEY(envio_numero)
);

CREATE TABLE Sillon (
	sillon_codigo BIGINT,
	sillon_modelo_codigo BIGINT, 
	sillon_medida_id BIGINT, 
	sillon_material_id BIGINT, 
	PRIMARY KEY(sillon_codigo)
);

CREATE TABLE Sillon_Medida (
	sillon_medida_id BIGINT IDENTITY(1, 1), -- sillon_medida_alto + sillon_medida_ancho + sillon_medida_profundidad
	sillon_medida_alto DECIMAL(18, 2),
	sillon_medida_ancho DECIMAL(18, 2),
	sillon_medida_profundidad DECIMAL(18, 2),
	sillon_medida_precio DECIMAL(18, 2),
	PRIMARY KEY(sillon_medida_id)
);

CREATE TABLE Sillon_Modelo (
	sillon_modelo_codigo BIGINT, 
	sillon_modelo NVARCHAR(255),
	sillon_modelo_descripcion NVARCHAR(255),
	sillon_modelo_precio DECIMAL(18, 2),
	PRIMARY KEY(sillon_modelo_codigo)
);

CREATE TABLE Material (
	material_id  BIGINT IDENTITY(1, 1), -- material_tipo + material_nombre
	material_tipo NVARCHAR(255),
	material_nombre NVARCHAR(255),
	material_precio DECIMAL(38, 2),
	material_tela_id BIGINT, 
	material_madera_id BIGINT,
	material_relleno_densidad DECIMAL(38, 2),
	PRIMARY KEY(material_id)
);

CREATE TABLE Madera (
	madera_id BIGINT IDENTITY(1, 1), -- madera_color + madera_dureza
	madera_color NVARCHAR(255),
	madera_dureza NVARCHAR(255),
	PRIMARY KEY(madera_id)
);

CREATE TABLE Tela (
	tela_id BIGINT IDENTITY(1, 1), -- tela_color + tela_textura
	tela_color NVARCHAR(255),
	tela_textura NVARCHAR(255),
	PRIMARY KEY(tela_id)
);

CREATE TABLE Relleno (
	relleno_densidad DECIMAL(38, 2),
	PRIMARY KEY(relleno_densidad)
);

CREATE TABLE Localidad (
	localidad_id BIGINT IDENTITY(1, 1),
	localidad_descripcion NVARCHAR(255),
	localidad_provincia BIGINT,
	PRIMARY KEY(localidad_id)
);

CREATE TABLE Provincia (
	provincia_id BIGINT IDENTITY(1, 1),
	provincia_descripcion NVARCHAR(255),
	PRIMARY KEY(provincia_id)
);

-- Implementacion de las FK

ALTER TABLE Cliente
ADD FOREIGN KEY(cliente_localidad) REFERENCES Localidad(localidad_id)

ALTER TABLE Pedido
ADD FOREIGN KEY(pedido_cliente_id) REFERENCES Cliente(cliente_id)

ALTER TABLE Pedido
ADD FOREIGN KEY(pedido_sucursal_nroSucursal) REFERENCES Sucursal(sucursal_nroSucursal)

ALTER TABLE Detalle_Pedido
ADD FOREIGN KEY(detalle_pedido_numero) REFERENCES Pedido(pedido_numero)

ALTER TABLE Detalle_Pedido
ADD FOREIGN KEY(detalle_pedido_sillon_codigo) REFERENCES Sillon(sillon_codigo)

ALTER TABLE Factura
ADD FOREIGN KEY(factura_cliente_id) REFERENCES Cliente(cliente_id)

ALTER TABLE Factura
ADD FOREIGN KEY(factura_sucursal_nroSucursal) REFERENCES Sucursal(sucursal_nroSucursal)

ALTER TABLE Detalle_Factura
ADD FOREIGN KEY(detalle_factura_numero) REFERENCES Factura(factura_numero)

ALTER TABLE Detalle_Factura
ADD FOREIGN KEY(detalle_factura_pedido_id) REFERENCES Detalle_Pedido(detalle_pedido_id)

ALTER TABLE Sucursal
ADD FOREIGN KEY(sucursal_localidad) REFERENCES Localidad(localidad_id)

ALTER TABLE Proveedor
ADD FOREIGN KEY(proveedor_localidad) REFERENCES Localidad(localidad_id)

ALTER TABLE Compra
ADD FOREIGN KEY(compra_proveedor_id) REFERENCES Proveedor(proveedor_id)

ALTER TABLE Compra
ADD FOREIGN KEY(compra_sucursal_nroSucursal) REFERENCES Sucursal(sucursal_nroSucursal)

ALTER TABLE Detalle_Compra
ADD FOREIGN KEY(detalle_compra_numero) REFERENCES Compra(compra_numero)

ALTER TABLE Detalle_Compra
ADD FOREIGN KEY(detalle_compra_material_id) REFERENCES Material(material_id)

ALTER TABLE Envio
ADD FOREIGN KEY(envio_factura_numero) REFERENCES Factura(factura_numero)

ALTER TABLE Sillon
ADD FOREIGN KEY(sillon_modelo_codigo) REFERENCES Sillon_Modelo(sillon_modelo_codigo)

ALTER TABLE Sillon
ADD FOREIGN KEY(sillon_medida_id) REFERENCES Sillon_Medida(sillon_medida_id)

ALTER TABLE Sillon
ADD FOREIGN KEY(sillon_material_id) REFERENCES Material(material_id)

ALTER TABLE Material
ADD FOREIGN KEY(material_tela_id) REFERENCES Tela(tela_id)

ALTER TABLE Material
ADD FOREIGN KEY(material_madera_id) REFERENCES Madera(madera_id)

ALTER TABLE Material
ADD FOREIGN KEY(material_relleno_densidad) REFERENCES Relleno(relleno_densidad)

ALTER TABLE Localidad
ADD FOREIGN KEY(localidad_provincia) REFERENCES Provincia(provincia_id)

-- Tabla LOS_GESTORES

CREATE TABLE LOS_GESTORES (
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

INSERT INTO LOS_GESTORES VALUES (
    'LOS_GESTORES',
    36,
    'K3051',
    'Nahuel Franco Terrazas Alcocer', 1731038,
    'Cesar Villalba', 1103544,
    'Agustina Denise Righetti', 1762321,
    'Andrea Denise Villanueva', 1500569
);

-- Migracion de datos de la tabla maestra

