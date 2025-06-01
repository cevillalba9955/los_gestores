-- Creacion del esquema

PRINT '1. Creando el esquema LOS_GESTORES';
GO

CREATE SCHEMA LOS_GESTORES;
GO

PRINT 'Esquema LOS_GESTORES creado.';

-- Creacion de tablas

PRINT '2. Creando tablas del modelo transaccional';
GO

CREATE TABLE LOS_GESTORES.Provincia
(
	provincia_id BIGINT IDENTITY(1, 1),
	provincia_descripcion NVARCHAR(255),
	CONSTRAINT PK_PROVINCIA PRIMARY KEY(provincia_id)
);

CREATE TABLE LOS_GESTORES.Localidad
(
	localidad_id BIGINT IDENTITY(1, 1),
	localidad_descripcion NVARCHAR(255),
	localidad_provincia BIGINT,
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY(localidad_id)
);

CREATE TABLE LOS_GESTORES.Sucursal
(
	sucursal_nroSucursal BIGINT,
	sucursal_localidad BIGINT,
	sucursal_direccion NVARCHAR(255),
	sucursal_telefono NVARCHAR(255),
	sucursal_mail NVARCHAR(255),
	CONSTRAINT PK_SUCURSAL PRIMARY KEY(sucursal_nroSucursal)
);

CREATE TABLE LOS_GESTORES.Madera
(
	madera_id BIGINT IDENTITY(1, 1),
	madera_nombre NVARCHAR(255),
	madera_descripcion NVARCHAR(255),
	madera_color NVARCHAR(255),
	madera_dureza NVARCHAR(255),
	madera_precio DECIMAL(38,2),
	CONSTRAINT PK_MADERA PRIMARY KEY(madera_id)
);

CREATE TABLE LOS_GESTORES.Tela
(
	tela_id BIGINT IDENTITY(1, 1),
	tela_nombre NVARCHAR(255),
	tela_descripcion NVARCHAR(255),
	tela_color NVARCHAR(255),
	tela_textura NVARCHAR(255),
	tela_precio DECIMAL(38,2),
	CONSTRAINT PK_TELA PRIMARY KEY(tela_id)
);

CREATE TABLE LOS_GESTORES.Relleno
(
	relleno_id BIGINT IDENTITY(1,1),
	relleno_nombre NVARCHAR(255),
	relleno_descripcion NVARCHAR(255),
	relleno_densidad DECIMAL(38, 2),
	relleno_precio DECIMAL(38,2),
	CONSTRAINT PK_RELLENO PRIMARY KEY(relleno_id)
);

CREATE TABLE LOS_GESTORES.Sillon_Medida
(
	sillon_medida_id BIGINT IDENTITY(1, 1),
	sillon_medida_alto DECIMAL(18, 2),
	sillon_medida_ancho DECIMAL(18, 2),
	sillon_medida_profundidad DECIMAL(18, 2),
	sillon_medida_precio DECIMAL(18, 2),
	CONSTRAINT PK_SILLON_MEDIDA PRIMARY KEY(sillon_medida_id)
);

CREATE TABLE LOS_GESTORES.Sillon_Modelo
(
	sillon_modelo_codigo BIGINT,
	sillon_modelo NVARCHAR(255),
	sillon_modelo_descripcion NVARCHAR(255),
	sillon_modelo_precio DECIMAL(18, 2),
	CONSTRAINT PK_SILLON_MODELO PRIMARY KEY(sillon_modelo_codigo)
);

CREATE TABLE LOS_GESTORES.Sillon
(
	sillon_codigo BIGINT,
	sillon_modelo_codigo BIGINT,
	sillon_medida BIGINT,
	sillon_madera BIGINT,
	sillon_tela BIGINT,
	sillon_relleno BIGINT,
	CONSTRAINT PK_SILLON PRIMARY KEY(sillon_codigo)
);

/************* Compras ********************/

CREATE TABLE LOS_GESTORES.Proveedor
(
	proveedor_id BIGINT IDENTITY(1, 1),
	proveedor_cuit NVARCHAR(255),
	proveedor_localidad BIGINT,
	proveedor_razonSocial NVARCHAR(255),
	proveedor_direccion NVARCHAR(255),
	proveedor_telefono NVARCHAR(255),
	proveedor_mail NVARCHAR(255),
	CONSTRAINT PK_PROVEEDOR PRIMARY KEY(proveedor_id)
);

CREATE TABLE LOS_GESTORES.Compra
(
	compra_numero DECIMAL(18, 0),
	compra_proveedor BIGINT,
	compra_sucursal BIGINT,
	compra_fecha DATETIME2(6),
	compra_total DECIMAL(18, 2),
	CONSTRAINT PK_COMPRA PRIMARY KEY(compra_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Compra
(
	detalle_compra_id BIGINT IDENTITY(1, 1),
	detalle_compra_numero DECIMAL(18, 0),
	detalle_compra_tipo nvarchar(255),
	detalle_compra_material BIGINT,
	detalle_compra_precio DECIMAL(18, 2),
	detalle_compra_cantidad DECIMAL(18, 0),
	CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY(detalle_compra_id)
);

/********** Clientes **********************/

CREATE TABLE LOS_GESTORES.Cliente
(
	cliente_id BIGINT IDENTITY(1, 1),
	cliente_dni BIGINT,
	cliente_localidad BIGINT,
	cliente_nombre NVARCHAR(255),
	cliente_apellido NVARCHAR(255),
	cliente_fechaNacimiento DATETIME2(6),
	cliente_mail NVARCHAR(255),
	cliente_direccion NVARCHAR(255),
	cliente_telefono NVARCHAR(255),
	CONSTRAINT PK_CLIENTE PRIMARY KEY(cliente_id)
);

/************* Pedidos ***********************/

CREATE TABLE LOS_GESTORES.Pedido
(
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

CREATE TABLE LOS_GESTORES.Detalle_Pedido
(
	detalle_pedido_id BIGINT IDENTITY(1, 1),
	detalle_pedido_numero DECIMAL(18, 0),
	detalle_pedido_sillon_codigo BIGINT,
	detalle_pedido_cantidad BIGINT,
	detalle_pedido_precio DECIMAL(18, 2),
	CONSTRAINT PK_DETALLE_PEDIDO PRIMARY KEY(detalle_pedido_id)
);

/************ Facturas *******************/

CREATE TABLE LOS_GESTORES.Factura
(
	factura_numero BIGINT,
	factura_cliente BIGINT,
	factura_sucursal BIGINT,
	factura_pedido DECIMAL(18, 0),
	factura_fecha DATETIME2(6),
	factura_total DECIMAL(38, 2),
	CONSTRAINT PK_FACTURA PRIMARY KEY(factura_numero)
);

CREATE TABLE LOS_GESTORES.Detalle_Factura
(
	detalle_factura_id BIGINT IDENTITY(1, 1),
	detalle_factura_numero BIGINT,
	detalle_factura_cantidad DECIMAL(18, 0),
	detalle_factura_precio DECIMAL(18, 2),
	CONSTRAINT PK_DETALLE_FACTURA PRIMARY KEY(detalle_factura_id)
);

CREATE TABLE LOS_GESTORES.Envio
(
	envio_numero DECIMAL(18, 0),
	envio_factura BIGINT,
	envio_fecha_programada DATETIME2(6),
	envio_fecha DATETIME2(6),
	envio_importe_traslado DECIMAL(18, 2),
	envio_importe_subida DECIMAL(18, 2),
	CONSTRAINT PK_ENVIO PRIMARY KEY(envio_numero)
);

GO

PRINT 'Tablas creadas correctamente.';

-- Creacion de vista

PRINT '3. Creacion de vista';
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

PRINT '4. Implementando constraints UNIQUE';
GO

ALTER TABLE LOS_GESTORES.PROVINCIA
ADD CONSTRAINT UQ_Provincia_Descripcion UNIQUE (provincia_descripcion);

ALTER TABLE LOS_GESTORES.LOCALIDAD
ADD CONSTRAINT UQ_Localidad_Provincia UNIQUE (localidad_descripcion, localidad_provincia);

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT UQ_Proveedor_CUIT UNIQUE (proveedor_cuit);

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

PRINT 'Constraints UNIQUE implementados correctamente.';

-- Implementacion de las FKs

PRINT '5. Implementando FKs';
GO

/**** FK provincia ****/

ALTER TABLE LOS_GESTORES.Localidad
ADD CONSTRAINT FK_LOCALIDAD_PROVINCIA FOREIGN KEY(localidad_provincia)
REFERENCES LOS_GESTORES.Provincia(provincia_id)

/**** FK localidad ****/

ALTER TABLE LOS_GESTORES.Cliente
ADD CONSTRAINT FK_CLIENTE_LOCALIDAD FOREIGN KEY(cliente_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Sucursal
ADD CONSTRAINT FK_SUCURSAL_LOCALIDAD FOREIGN KEY(sucursal_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT FK_PROVEEDOR_LOCALIDAD FOREIGN KEY(proveedor_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

/*** FK sucursales ***/

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_SUCURSAL FOREIGN KEY(pedido_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_SUCURSAL FOREIGN KEY(factura_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_SUCURSAL FOREIGN KEY(compra_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

/** FK clientes **/ 

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY(pedido_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_CLIENTE FOREIGN KEY(factura_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

/** FK pedido **/ 

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DETALLE_PEDIDO FOREIGN KEY(detalle_pedido_numero) 
REFERENCES LOS_GESTORES.Pedido(pedido_numero)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_PEDIDO FOREIGN KEY(factura_pedido) 
REFERENCES LOS_GESTORES.Pedido(pedido_numero)

/** FK factura **/

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DETALLE_FACTURA FOREIGN KEY(detalle_factura_numero) 
REFERENCES LOS_GESTORES.Factura(factura_numero)


ALTER TABLE LOS_GESTORES.Envio
ADD CONSTRAINT FK_ENVIO_FACTURA FOREIGN KEY(envio_factura) 
REFERENCES LOS_GESTORES.Factura(factura_numero)


/** FK proveedor  */ 

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_PROVEEDOR FOREIGN KEY(compra_proveedor) 
REFERENCES LOS_GESTORES.Proveedor(proveedor_id)

/* FK compra */ 

ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DETALLE_COMPRA FOREIGN KEY(detalle_compra_numero) 
REFERENCES LOS_GESTORES.Compra(compra_numero)

/* FK sillon */ 

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DETALL_PEDIDO_SILLON FOREIGN KEY(detalle_pedido_sillon_codigo) 
REFERENCES LOS_GESTORES.Sillon(sillon_codigo)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MODELO FOREIGN KEY(sillon_modelo_codigo) 
REFERENCES LOS_GESTORES.Sillon_Modelo(sillon_modelo_codigo)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MEDIDA FOREIGN KEY(sillon_medida) 
REFERENCES LOS_GESTORES.Sillon_Medida(sillon_medida_id)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_TELA FOREIGN KEY(sillon_tela) 
REFERENCES LOS_GESTORES.Tela(tela_id)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_MADERA FOREIGN KEY(sillon_madera) 
REFERENCES LOS_GESTORES.Madera(madera_id)

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_RELLENO FOREIGN KEY(sillon_relleno)
REFERENCES LOS_GESTORES.Relleno(relleno_id)

PRINT 'FKs implementadas correctamente.';
GO
-- Creacion de Triggers 

PRINT '6. Creando Triggers';
GO

-- Trigger para evitar la insercion si no hay material registrado

CREATE TRIGGER LOS_GESTORES.DETALLE_COMPRA_AI
   ON LOS_GESTORES.DETALLE_COMPRA 
   AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
    FROM LOS_GESTORES.MATERIAL p
        JOIN inserted i ON p.MATERIAL_TIPO = I.DETALLE_COMPRA_TIPO
            AND P.MATERIAL_ID = I.DETALLE_COMPRA_MATERIAL 
    )
    BEGIN
        RAISERROR ('Violacion de clave foranea DETALLE_COMPRA_MATERIAL', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- Triggers para evitar eliminaciones en la tabla DETALLE_COMPRA si hay referencias en la tabla de materiales

CREATE TRIGGER LOS_GESTORES.MADERA_AD
ON LOS_GESTORES.MADERA
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Madera'
            and c.DETALLE_COMPRA_MATERIAL = d.madera_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque esta referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER LOS_GESTORES.TELA_AD
ON LOS_GESTORES.TELA
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Tela'
            and c.DETALLE_COMPRA_MATERIAL = d.tela_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque esta referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER LOS_GESTORES.RELLENO_AD
ON LOS_GESTORES.RELLENO
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Relleno'
            and c.DETALLE_COMPRA_MATERIAL = d.relleno_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque esta referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

GO

PRINT 'Triggers implementadas correctamente.';
GO

-- Creacion de los Stored procedures

PRINT '7. Creando Stored Procedures de migracion';
GO

CREATE PROCEDURE LOS_GESTORES.SP_PROVINCIA
AS
BEGIN
  INSERT INTO LOS_GESTORES.PROVINCIA
    (provincia_descripcion)
        SELECT DISTINCT Proveedor_Provincia
    FROM gd_esquema.MAESTRA
    WHERE Proveedor_Provincia IS NOT NULL
  union
    SELECT DISTINCT Cliente_Provincia
    FROM gd_esquema.MAESTRA
    WHERE Cliente_Provincia IS NOT NULL
  union
    SELECT DISTINCT Sucursal_Provincia
    FROM gd_esquema.MAESTRA
    WHERE Sucursal_Provincia IS NOT NULL
;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_LOCALIDAD
AS
BEGIN
  INSERT INTO LOS_GESTORES.LOCALIDAD
    (localidad_descripcion, localidad_provincia)
        SELECT DISTINCT CLIENTE_LOCALIDAD, p.provincia_id
    FROM gd_esquema.Maestra m
      JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.cliente_Provincia
    where CLIENTE_LOCALIDAD is not null
  UNION
    SELECT DISTINCT Proveedor_Localidad, p.provincia_id
    FROM gd_esquema.Maestra m
      JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
    where Proveedor_Localidad is not null
  UNION
    SELECT DISTINCT Sucursal_Localidad, p.provincia_id
    FROM gd_esquema.Maestra m
      JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Sucursal_Provincia
    where Sucursal_Localidad is not null;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SUCURSAL
AS
BEGIN
  INSERT INTO LOS_GESTORES.SUCURSAL
    (
    sucursal_nroSucursal,
    sucursal_direccion,
    sucursal_localidad,
    sucursal_telefono,
    sucursal_mail
    )
  SELECT DISTINCT
    m.Sucursal_NroSucursal,
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

/*************** Materiales *********************/

CREATE PROCEDURE LOS_GESTORES.SP_MADERA
AS
BEGIN
   INSERT INTO LOS_GESTORES.Madera
    (madera_nombre
    ,madera_descripcion
    ,madera_color
    ,madera_dureza
    ,madera_precio
    )
  SELECT distinct Material_Nombre, Material_Descripcion, MADERA_COLOR, MADERA_DUREZA, Material_Precio
  FROM gd_esquema.Maestra
  where Material_tipo = 'Madera'

END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_TELA
AS
BEGIN
  INSERT INTO LOS_GESTORES.Tela
    (tela_nombre
    ,tela_descripcion
    ,tela_color
    ,tela_textura
    ,tela_precio
    )
  SELECT distinct Material_Nombre, Material_Descripcion, Tela_Color, Tela_Textura, Material_Precio
  FROM gd_esquema.Maestra
  where Material_tipo = 'Tela'
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_RELLENO
AS
BEGIN
  INSERT INTO LOS_GESTORES.Relleno
    (
    relleno_nombre
    ,relleno_descripcion
    ,relleno_densidad
    ,relleno_precio
    )
  SELECT distinct Material_Nombre, Material_Descripcion, Relleno_Densidad, Material_Precio
  FROM gd_esquema.Maestra
  where Material_tipo = 'Relleno'
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MEDIDA
AS
BEGIN
  INSERT INTO LOS_GESTORES.Sillon_Medida
    (
    sillon_medida_alto
    ,sillon_medida_ancho
    ,sillon_medida_profundidad
    ,sillon_medida_precio
    )
  SELECT distinct Sillon_Medida_Alto
            , Sillon_Medida_Ancho
            , Sillon_Medida_Profundidad
            , Sillon_Medida_Precio
  FROM gd_esquema.Maestra
  where Sillon_Medida_Alto IS NOT NULL
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MODELO
AS
BEGIN
  --	SET NOCOUNT ON;
  INSERT INTO LOS_GESTORES.Sillon_Modelo
    (sillon_modelo_codigo
    ,sillon_modelo
    ,sillon_modelo_descripcion
    ,sillon_modelo_precio)
  SELECT distinct
    Sillon_Modelo_Codigo
        , Sillon_Modelo
        , Sillon_Modelo_Descripcion
        , Sillon_Modelo_Precio
  FROM gd_esquema.Maestra
  where Sillon_Modelo_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO [LOS_GESTORES].[Sillon]
    ([sillon_codigo]
    ,[sillon_modelo_codigo]
    ,[sillon_medida])
  SELECT Sillon_Codigo
		  , [Sillon_Modelo_Codigo]
		  , sm.sillon_medida_id
  FROM [gd_esquema].[Maestra] m
    join LOS_GESTORES.Sillon_Medida sm
    on m.Sillon_Medida_Alto = sm.sillon_medida_alto
      and m.Sillon_Medida_Ancho = sm.sillon_medida_ancho
      and m.Sillon_Medida_Profundidad = sm.sillon_medida_profundidad

  where Sillon_Codigo is not null
  group by Sillon_Codigo
		  ,[Sillon_Modelo_Codigo]
		  ,m.[Sillon_Medida_Alto]
		  ,m.[Sillon_Medida_Ancho]
		  ,m.[Sillon_Medida_Profundidad]
		  ,sm.sillon_medida_id
		  ,sm.[Sillon_Medida_Alto]
		  ,sm.[Sillon_Medida_Ancho]
		  ,sm.[Sillon_Medida_Profundidad]


  UPDATE t1
	SET t1.sillon_madera = t2.madera_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Madera' and m.Sillon_Codigo = t1.sillon_codigo
    JOIN LOS_GESTORES.madera t2 on m.Material_Nombre = t2.madera_nombre

  UPDATE t1
	SET t1.sillon_tela = t2.tela_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Tela' and m.Sillon_Codigo = t1.sillon_codigo
    JOIN LOS_GESTORES.tela t2 on m.Material_Nombre = t2.tela_nombre

  UPDATE t1
	SET t1.sillon_relleno = t2.relleno_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Relleno' and m.Sillon_Codigo = t1.sillon_codigo
    JOIN LOS_GESTORES.relleno t2 on m.Material_Nombre = t2.relleno_nombre
END;
GO

/************* Compras ********************/

CREATE PROCEDURE LOS_GESTORES.SP_PROVEEDOR
AS
BEGIN


  INSERT INTO LOS_GESTORES.PROVEEDOR
    (
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
;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_COMPRA
AS
BEGIN
  --	SET NOCOUNT ON;
  INSERT INTO LOS_GESTORES.Compra
    (
    compra_numero,
    compra_proveedor,
    compra_sucursal,
    compra_fecha,
    compra_total
    )
  SELECT DISTINCT
    m.Compra_Numero,
    pr.proveedor_id,
    s.sucursal_nroSucursal,
    m.Compra_Fecha,
    m.Compra_Total
  FROM gd_esquema.Maestra m
    JOIN LOS_GESTORES.Proveedor pr ON pr.proveedor_cuit = m.Proveedor_Cuit
    JOIN LOS_GESTORES.Sucursal s ON s.sucursal_nroSucursal = m.Sucursal_NroSucursal
  WHERE m.Compra_Numero IS NOT NULL

END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_COMPRA
AS
BEGIN
  --	SET NOCOUNT ON;
  INSERT INTO [LOS_GESTORES].[Detalle_Compra]
    ([detalle_compra_numero]
    ,[detalle_compra_tipo]
    ,[detalle_compra_material]
    ,[detalle_compra_precio]
    ,[detalle_compra_cantidad])
  SELECT
    m.[Compra_Numero]
		  , m.Material_Tipo
		  , ma.material_id
		  , m.[Detalle_Compra_Precio]
		  , m.[Detalle_Compra_Cantidad]
  FROM [gd_esquema].[Maestra] m
    join LOS_GESTORES.material ma on m.Material_Nombre = ma.material_nombre
      and m.Material_Tipo = ma.material_tipo
  where m.COMPRA_NUMERO IS NOT NULL

END;
GO

/**************** Cliente ************/

CREATE PROCEDURE LOS_GESTORES.SP_CLIENTE
AS
BEGIN


  INSERT INTO LOS_GESTORES.CLIENTE
    (
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
END;
GO

/**************** Pedidos ************/

CREATE PROCEDURE LOS_GESTORES.SP_PEDIDO
AS
BEGIN
  INSERT INTO [LOS_GESTORES].[Pedido]
    ([pedido_numero]
    ,[pedido_cliente]
    ,[pedido_sucursal]
    ,[pedido_fecha]
    ,[pedido_total]
    ,[pedido_estado])
  SELECT DISTINCT
    [Pedido_Numero]
      , C.CLIENTE_ID Pedido_Cliente
      , [Sucursal_NroSucursal]
      , [Pedido_Fecha]
      , [Pedido_Total]
      , [Pedido_Estado]
  FROM [gd_esquema].[Maestra] TM
    JOIN LOS_GESTORES.Cliente C ON C.Cliente_Dni = TM.Cliente_Dni AND C.Cliente_Mail = TM.Cliente_Mail
  WHERE Pedido_Numero IS NOT NULL

  -- AGREGO INFORMACION DE CANCELACION DE PEDIDOS

  UPDATE t1
	SET t1.pedido_cancelacion_fecha = m.Pedido_Cancelacion_Fecha
	 , t1.pedido_cancelacion_motivo = m.Pedido_Cancelacion_Motivo
	FROM LOS_GESTORES.PEDIDO t1
    JOIN gd_esquema.Maestra	m on m.Pedido_Numero = t1.pedido_numero and m.Pedido_Cancelacion_Fecha is not null
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_PEDIDO
AS
BEGIN

  INSERT INTO [LOS_GESTORES].[Detalle_Pedido]
    ([detalle_pedido_numero]
    ,[detalle_pedido_sillon_codigo]
    ,[detalle_pedido_cantidad]
    ,[detalle_pedido_precio])
  SELECT DISTINCT
    [Pedido_Numero] 
      , [Sillon_Codigo]
      , [Detalle_Pedido_Cantidad]
      , [Detalle_Pedido_Precio]
  FROM [gd_esquema].[Maestra]
  WHERE Pedido_Numero IS NOT NULL
    AND Sillon_Codigo IS NOT NULL
END;
GO

/************* Facturas **************/

CREATE PROCEDURE LOS_GESTORES.SP_FACTURA
AS
BEGIN
  INSERT INTO [LOS_GESTORES].[Factura]
    ([factura_numero]
    ,[factura_cliente]
    ,[factura_sucursal]
    ,factura_pedido
    ,[factura_fecha]
    ,[factura_total])
  SELECT distinct
    [Factura_Numero]
		  , c.cliente_id 
		  , [Sucursal_NroSucursal] 
		  , [Pedido_numero]
		  , [Factura_Fecha]
		  , [Factura_Total]
  FROM [gd_esquema].[Maestra] TM
    JOIN LOS_GESTORES.Cliente C ON C.Cliente_Dni = TM.Cliente_Dni AND C.Cliente_Mail = TM.Cliente_Mail
  where Factura_Numero is not null
    AND Pedido_Numero IS NOT NULL
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_FACTURA
AS
BEGIN
  INSERT INTO [LOS_GESTORES].[Detalle_Factura]
    ([detalle_factura_numero]
    ,[detalle_factura_cantidad]
    ,[detalle_factura_precio])
  SELECT
    [Factura_Numero]
		  , [Detalle_Factura_Precio]
		  , [Detalle_Factura_Cantidad]
  FROM [GD1C2025].[gd_esquema].[Maestra]
  where Factura_Numero is not null
    and Detalle_Factura_Cantidad is not null
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_ENVIO
AS
BEGIN
  INSERT INTO [LOS_GESTORES].[Envio]
    ([envio_numero]
    ,[envio_factura]
    ,[envio_fecha_programada]
    ,[envio_fecha]
    ,[envio_importe_traslado]
    ,[envio_importe_subida])
  SELECT
    [Envio_Numero]
      , [Factura_Numero]
      , [Envio_Fecha_Programada]
      , [Envio_Fecha]
      , [Envio_ImporteTraslado]
      , [Envio_importeSubida]
  FROM [GD1C2025].[gd_esquema].[Maestra]
  WHERE Envio_Numero IS NOT NULL
END;

GO

PRINT 'Stored Procedures de migracion creados correctamente.';

-- Ejecutar Stored procedures

PRINT '8. Ejecutando Stored Procedures de migracion de datos';
GO

EXEC LOS_GESTORES.SP_PROVINCIA
EXEC LOS_GESTORES.SP_LOCALIDAD
EXEC LOS_GESTORES.SP_SUCURSAL
EXEC LOS_GESTORES.SP_MADERA
EXEC LOS_GESTORES.SP_TELA
EXEC LOS_GESTORES.SP_RELLENO
EXEC LOS_GESTORES.SP_SILLON_MEDIDA
EXEC LOS_GESTORES.SP_SILLON_MODELO
EXEC LOS_GESTORES.SP_SILLON
EXEC LOS_GESTORES.SP_PROVEEDOR
EXEC LOS_GESTORES.SP_COMPRA
EXEC LOS_GESTORES.SP_DETALLE_COMPRA
EXEC LOS_GESTORES.SP_CLIENTE
EXEC LOS_GESTORES.SP_PEDIDO
EXEC LOS_GESTORES.SP_DETALLE_PEDIDO
EXEC LOS_GESTORES.SP_FACTURA
EXEC LOS_GESTORES.SP_DETALLE_FACTURA
EXEC LOS_GESTORES.SP_ENVIO
GO

PRINT 'Migracion de datos inicial completada.';
PRINT 'Script finalizado.';
