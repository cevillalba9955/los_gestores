--create schema LOS_GESTORES
--go


-- Creacion de tablas


CREATE TABLE LOS_GESTORES.Provincia (
	provincia_id BIGINT IDENTITY(1, 1),
	provincia_descripcion NVARCHAR(255),
	CONSTRAINT PK_PROVINCIA PRIMARY KEY(provincia_id)
);

CREATE TABLE LOS_GESTORES.Localidad (
	localidad_id BIGINT IDENTITY(1, 1),
	localidad_descripcion NVARCHAR(255),
	localidad_provincia BIGINT,
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY(localidad_id)
);

CREATE TABLE LOS_GESTORES.Sucursal (
	sucursal_nroSucursal BIGINT,
	sucursal_localidad BIGINT,
	sucursal_direccion NVARCHAR(255),
	sucursal_telefono NVARCHAR(255),
	sucursal_mail NVARCHAR(255),
	CONSTRAINT PK_SUCURSAL PRIMARY KEY(sucursal_nroSucursal)
);

CREATE TABLE LOS_GESTORES.Madera (
	madera_id BIGINT IDENTITY(1, 1), -- madera_color + madera_dureza
	madera_nombre NVARCHAR(255),
	madera_descripcion NVARCHAR(255),
	madera_color NVARCHAR(255),
	madera_dureza NVARCHAR(255),
	madera_precio DECIMAL(38,2),
	CONSTRAINT PK_MADERA PRIMARY KEY(madera_id)
);

CREATE TABLE LOS_GESTORES.Tela (
	tela_id BIGINT IDENTITY(1, 1), -- tela_color + tela_textura
	tela_nombre NVARCHAR(255),
	tela_descripcion NVARCHAR(255),
	tela_color NVARCHAR(255),
	tela_textura NVARCHAR(255),
	tela_precio DECIMAL(38,2),
	CONSTRAINT PK_TELA PRIMARY KEY(tela_id)
);

CREATE TABLE LOS_GESTORES.Relleno (
	relleno_id BIGINT IDENTITY(1,1),
	relleno_nombre NVARCHAR(255),
	relleno_descripcion NVARCHAR(255),
	relleno_densidad DECIMAL(38, 2),
	relleno_precio DECIMAL(38,2),
	CONSTRAINT PK_RELLENO PRIMARY KEY(relleno_id)
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
	CONSTRAINT PK_MATERIAL PRIMARY KEY(material_id)
);*/


CREATE TABLE LOS_GESTORES.Sillon_Medida (
	sillon_medida_id BIGINT IDENTITY(1, 1), -- sillon_medida_alto + sillon_medida_ancho + sillon_medida_profundidad
	sillon_medida_alto DECIMAL(18, 2),
	sillon_medida_ancho DECIMAL(18, 2),
	sillon_medida_profundidad DECIMAL(18, 2),
	sillon_medida_precio DECIMAL(18, 2),
	CONSTRAINT PK_SILLON_MEDIDA PRIMARY KEY(sillon_medida_id)
);

CREATE TABLE LOS_GESTORES.Sillon_Modelo (
	sillon_modelo_codigo BIGINT, 
	sillon_modelo NVARCHAR(255),
	sillon_modelo_descripcion NVARCHAR(255),
	sillon_modelo_precio DECIMAL(18, 2),
	CONSTRAINT PK_SILLON_MODELO PRIMARY KEY(sillon_modelo_codigo)
);

CREATE TABLE LOS_GESTORES.Sillon (
	sillon_codigo BIGINT,
	sillon_modelo_codigo BIGINT, 
	sillon_medida BIGINT, 
	sillon_madera BIGINT,
	sillon_tela BIGINT, 
	sillon_relleno BIGINT, 
	CONSTRAINT PK_SILLON PRIMARY KEY(sillon_codigo)
);


/************* compras ********************/

CREATE TABLE LOS_GESTORES.Proveedor (
	proveedor_id BIGINT IDENTITY(1, 1), -- proveedor_cuit + ...
	proveedor_cuit NVARCHAR(255),
	proveedor_localidad BIGINT,
	proveedor_razonSocial NVARCHAR(255),
	proveedor_direccion NVARCHAR(255),
	proveedor_telefono NVARCHAR(255),
	proveedor_mail NVARCHAR(255),
	CONSTRAINT PK_PROVEEDOR PRIMARY KEY(proveedor_id)
);

CREATE TABLE LOS_GESTORES.Compra (
	compra_numero DECIMAL(18, 0),
	compra_proveedor BIGINT, 
	compra_sucursal BIGINT,
	compra_fecha DATETIME2(6),
	compra_total DECIMAL(18, 2),
	CONSTRAINT PK_COMPRA PRIMARY KEY(compra_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Compra (
	detalle_compra_id BIGINT IDENTITY(1, 1), -- detalle_compra_numero + detalle_compra_material_id
	detalle_compra_numero DECIMAL(18, 0),
	detalle_compra_tipo nvarchar(255),
	detalle_compra_material BIGINT,
	detalle_compra_precio DECIMAL(18, 2),
	detalle_compra_cantidad DECIMAL(18, 0),
	CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY(detalle_compra_id)
);


/********** CLIENTES **********************/ 

CREATE TABLE LOS_GESTORES.Cliente (
    cliente_id BIGINT IDENTITY(1, 1), -- cliente_dni + cliente_nombre + cliente_apellido
    cliente_dni BIGINT,
    cliente_localidad BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2(6),
    cliente_mail NVARCHAR(255),
    cliente_direccion NVARCHAR(255),
    cliente_telefono NVARCHAR(255)
	CONSTRAINT PK_CLIENTE PRIMARY KEY(cliente_id)

);


/************* pedidos ***********************/

CREATE TABLE LOS_GESTORES.Pedido (
	pedido_numero DECIMAL(18, 0),
	pedido_cliente BIGINT,
	pedido_sucursal BIGINT,
	pedido_fecha DATETIME2(6),
	pedido_total DECIMAL(18, 2),
	pedido_estado NVARCHAR(255),
	pedido_cancelacion_fecha DATETIME2(6),
	pedido_cancelacion_motivo VARCHAR(255),
	CONSTRAINT PK_PEDIDO PRIMARY KEY(pedido_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Pedido (
	detalle_pedido_id BIGINT IDENTITY(1, 1), -- detalle_pedido_numero + detalle_pedido_sillon_codigo
	detalle_pedido_numero DECIMAL(18, 0),
	detalle_pedido_sillon_codigo BIGINT,
	detalle_pedido_cantidad BIGINT,
	detalle_pedido_precio DECIMAL(18, 2),
	CONSTRAINT PK_DETALLE_PEDIDO PRIMARY KEY(detalle_pedido_id)
);


/************ facturas *******************/

CREATE TABLE LOS_GESTORES.Factura (
	factura_numero BIGINT,
	factura_cliente BIGINT,
	factura_sucursal BIGINT,
	factura_fecha DATETIME2(6),
	factura_total DECIMAL(38, 2),
	CONSTRAINT PK_FACTURA PRIMARY KEY(factura_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Factura (
	detalle_factura_id BIGINT IDENTITY(1, 1), -- detalle_factura_numero + detalle_factura_pedido_id
	detalle_factura_numero BIGINT,
	detalle_factura_pedido BIGINT, 
	detalle_factura_cantidad DECIMAL(18, 0),
	detalle_factura_precio DECIMAL(18, 2),
	CONSTRAINT PK_DETALLE_FACTURA PRIMARY KEY(detalle_factura_id)
);

CREATE TABLE LOS_GESTORES.Envio (
	envio_numero DECIMAL(18, 0),
	envio_factura BIGINT,
	envio_fecha_programada DATETIME2(6),
	envio_fecha DATETIME2(6),
	envio_importe_traslado DECIMAL(18, 2),
	envio_importe_subida DECIMAL(18, 2),
	CONSTRAINT PK_ENVIO PRIMARY KEY(envio_numero)
);









-- implementacion  constraint 
ALTER TABLE LOS_GESTORES.PROVINCIA
ADD CONSTRAINT UQ_Provincia_Descripcion UNIQUE (provincia_descripcion);

ALTER TABLE LOS_GESTORES.LOCALIDAD
ADD CONSTRAINT UQ_Localidad_Provincia UNIQUE (localidad_descripcion, localidad_provincia);

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT UQ_Proveedor_CUIT UNIQUE (proveedor_cuit);

-- Implementacion de las FK

ALTER TABLE LOS_GESTORES.Cliente
ADD CONSTRAINT FK_CLIENTE_LOCALIDAD FOREIGN KEY(cliente_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY(pedido_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_SUCURSAL FOREIGN KEY(pedido_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DETALLE_PEDIDO FOREIGN KEY(detalle_pedido_numero) 
REFERENCES LOS_GESTORES.Pedido(pedido_numero)

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DETALL_PEDIDO_SILLON FOREIGN KEY(detalle_pedido_sillon_codigo) 
REFERENCES LOS_GESTORES.Sillon(sillon_codigo)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_CLIENTE FOREIGN KEY(factura_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_SUCURSAL FOREIGN KEY(factura_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DETALLE_FACTURA FOREIGN KEY(detalle_factura_numero) 
REFERENCES LOS_GESTORES.Factura(factura_numero)

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DETALLE_FACTURA_PEDIDO FOREIGN KEY(detalle_factura_pedido) 
REFERENCES LOS_GESTORES.Detalle_Pedido(detalle_pedido_id)

ALTER TABLE LOS_GESTORES.Sucursal
ADD CONSTRAINT FK_SUCURSAL_LOCALIDAD FOREIGN KEY(sucursal_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT FK_PROVEEDOR_LOCALIDAD FOREIGN KEY(proveedor_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_PROVEEDOR FOREIGN KEY(compra_proveedor) 
REFERENCES LOS_GESTORES.Proveedor(proveedor_id)

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_SUCURSAL FOREIGN KEY(compra_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DETALLE_COMPRA FOREIGN KEY(detalle_compra_numero) 
REFERENCES LOS_GESTORES.Compra(compra_numero)

/*
ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DETALLE_COMPRA_MATERIAL FOREIGN KEY(detalle_compra_material_id) 
REFERENCES LOS_GESTORES.Material(material_id)
*/

ALTER TABLE LOS_GESTORES.Envio
ADD CONSTRAINT FK_ENVIO_FACTURA FOREIGN KEY(envio_factura) 
REFERENCES LOS_GESTORES.Factura(factura_numero)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MODELO FOREIGN KEY(sillon_modelo_codigo) 
REFERENCES LOS_GESTORES.Sillon_Modelo(sillon_modelo_codigo)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MEDIDA FOREIGN KEY(sillon_medida) 
REFERENCES LOS_GESTORES.Sillon_Medida(sillon_medida_id)

/*
ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MATERIAL FOREIGN KEY(sillon_material_id) 
REFERENCES LOS_GESTORES.Material(material_id)
*/
ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_TELA FOREIGN KEY(sillon_tela) 
REFERENCES LOS_GESTORES.Tela(tela_id)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MADERA FOREIGN KEY(sillon_madera) 
REFERENCES LOS_GESTORES.Madera(madera_id)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_RELLENO FOREIGN KEY(sillon_relleno)
REFERENCES LOS_GESTORES.Relleno(relleno_id)

ALTER TABLE LOS_GESTORES.Localidad
ADD CONSTRAINT FK_LOCALIDAD_PROVINCIA FOREIGN KEY(localidad_provincia)
REFERENCES LOS_GESTORES.Provincia(provincia_id)

-- Tabla LOS_GESTORES
/*
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

INSERT INTO LOS_GESTORES VALUES (
    'LOS_GESTORES',
    36,
    'K3051',
    'Nahuel Franco Terrazas Alcocer', 1731038,
    'Cesar Villalba', 1103544,
    'Agustina Denise Righetti', 1762321,
    'Andrea Denise Villanueva', 1500569
);
*/

