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

CREATE TABLE LOS_GESTORES.Material
(
    material_id BIGINT IDENTITY(1, 1),
    material_tipo NVARCHAR(255), -- Madera, Tela, Relleno
    material_nombre NVARCHAR(255),
    material_descripcion NVARCHAR(255),
    material_precio DECIMAL(38,2),
    CONSTRAINT PK_MATERIAL PRIMARY KEY(material_id)
);

CREATE TABLE LOS_GESTORES.Madera
(
	madera_id BIGINT, 
	madera_color NVARCHAR(255),
	madera_dureza NVARCHAR(255),
	CONSTRAINT PK_MADERA PRIMARY KEY(madera_id)
);

CREATE TABLE LOS_GESTORES.Tela
(
	tela_id BIGINT, 
	tela_color NVARCHAR(255),
	tela_textura NVARCHAR(255),
	CONSTRAINT PK_TELA PRIMARY KEY(tela_id)
);

CREATE TABLE LOS_GESTORES.Relleno
(
	relleno_id BIGINT, 
	relleno_densidad DECIMAL(38, 2),
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
	detalle_compra_material BIGINT, 
	detalle_compra_precio DECIMAL(18, 2),
	detalle_compra_cantidad DECIMAL(18, 0),
	CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY(detalle_compra_id)
);

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

-- Implementacion de Constraints Unique

PRINT '3. Implementando constraints UNIQUE';
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

ALTER TABLE LOS_GESTORES.Material
ADD CONSTRAINT UQ_Material_Tipo_Nombre UNIQUE (material_tipo, material_nombre);
GO

/*
ALTER TABLE LOS_GESTORES.Madera
ADD CONSTRAINT UQ_Madera_Color_Dureza UNIQUE (madera_color, madera_dureza); 
GO

ALTER TABLE LOS_GESTORES.Tela
ADD CONSTRAINT UQ_Tela_Color_Textura UNIQUE (tela_color, tela_textura); 
GO

ALTER TABLE LOS_GESTORES.Relleno
ADD CONSTRAINT UQ_Relleno_Densidad UNIQUE (relleno_densidad);
GO
*/

PRINT 'Constraints UNIQUE implementados correctamente.';

-- Implementacion de las FKs

PRINT '4. Implementando FKs';
GO

-- Provincia

ALTER TABLE LOS_GESTORES.Localidad
ADD CONSTRAINT FK_LOCALIDAD_PROVINCIA FOREIGN KEY(localidad_provincia)
REFERENCES LOS_GESTORES.Provincia(provincia_id)

-- Localidad

ALTER TABLE LOS_GESTORES.Cliente
ADD CONSTRAINT FK_CLIENTE_LOCALIDAD FOREIGN KEY(cliente_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Sucursal
ADD CONSTRAINT FK_SUCURSAL_LOCALIDAD FOREIGN KEY(sucursal_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

ALTER TABLE LOS_GESTORES.Proveedor
ADD CONSTRAINT FK_PROVEEDOR_LOCALIDAD FOREIGN KEY(proveedor_localidad) 
REFERENCES LOS_GESTORES.Localidad(localidad_id)

-- Sucursal

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_SUCURSAL FOREIGN KEY(pedido_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_SUCURSAL FOREIGN KEY(factura_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_SUCURSAL FOREIGN KEY(compra_sucursal) 
REFERENCES LOS_GESTORES.Sucursal(sucursal_nroSucursal)

-- Cliente 

ALTER TABLE LOS_GESTORES.Pedido
ADD CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY(pedido_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_CLIENTE FOREIGN KEY(factura_cliente) 
REFERENCES LOS_GESTORES.Cliente(cliente_id)

-- Pedido

ALTER TABLE LOS_GESTORES.Detalle_Pedido
ADD CONSTRAINT FK_DETALLE_PEDIDO FOREIGN KEY(detalle_pedido_numero) 
REFERENCES LOS_GESTORES.Pedido(pedido_numero)

ALTER TABLE LOS_GESTORES.Factura
ADD CONSTRAINT FK_FACTURA_PEDIDO FOREIGN KEY(factura_pedido) 
REFERENCES LOS_GESTORES.Pedido(pedido_numero)

-- Factura

ALTER TABLE LOS_GESTORES.Detalle_Factura
ADD CONSTRAINT FK_DETALLE_FACTURA FOREIGN KEY(detalle_factura_numero) 
REFERENCES LOS_GESTORES.Factura(factura_numero)

ALTER TABLE LOS_GESTORES.Envio
ADD CONSTRAINT FK_ENVIO_FACTURA FOREIGN KEY(envio_factura) 
REFERENCES LOS_GESTORES.Factura(factura_numero)

-- Proveedor

ALTER TABLE LOS_GESTORES.Compra
ADD CONSTRAINT FK_COMPRA_PROVEEDOR FOREIGN KEY(compra_proveedor) 
REFERENCES LOS_GESTORES.Proveedor(proveedor_id)

-- Compra

ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DETALLE_COMPRA FOREIGN KEY(detalle_compra_numero) 
REFERENCES LOS_GESTORES.Compra(compra_numero)

ALTER TABLE LOS_GESTORES.Detalle_Compra
ADD CONSTRAINT FK_DETALLE_COMPRA_MATERIAL FOREIGN KEY(detalle_compra_material) 
REFERENCES LOS_GESTORES.Material(material_id);

-- Sillon

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
ADD CONSTRAINT FK_SILLON_MADERA FOREIGN KEY(sillon_madera) 
REFERENCES LOS_GESTORES.Madera(madera_id); 

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_TELA FOREIGN KEY(sillon_tela) 
REFERENCES LOS_GESTORES.Tela(tela_id);

ALTER TABLE LOS_GESTORES.Sillon
ADD CONSTRAINT FK_SILLON_RELLENO FOREIGN KEY(sillon_relleno)
REFERENCES LOS_GESTORES.Relleno(relleno_id); 

-- Materiales

ALTER TABLE LOS_GESTORES.Madera
ADD CONSTRAINT FK_MADERA_MATERIAL FOREIGN KEY(madera_id) 
REFERENCES LOS_GESTORES.Material(material_id);

ALTER TABLE LOS_GESTORES.Tela
ADD CONSTRAINT FK_TELA_MATERIAL FOREIGN KEY(tela_id) 
REFERENCES LOS_GESTORES.Material(material_id);

ALTER TABLE LOS_GESTORES.Relleno
ADD CONSTRAINT FK_RELLENO_MATERIAL FOREIGN KEY(relleno_id) 
REFERENCES LOS_GESTORES.Material(material_id);

PRINT 'FKs implementadas correctamente.';
GO

-- Creacion de Triggers 

PRINT '5. Creando Triggers';
GO

-- Trigger para evitar la eliminacion de materiales si están referenciados en Detalle_Compra o Sillon

CREATE TRIGGER LOS_GESTORES.MATERIAL_AD
ON LOS_GESTORES.MATERIAL
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM LOS_GESTORES.DETALLE_COMPRA dc
        JOIN deleted d ON dc.detalle_compra_material = d.material_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el material porque está referenciado en DETALLE_COMPRA.', 16, 1);
        ROLLBACK TRANSACTION;
    END

    IF EXISTS (
        SELECT 1
        FROM LOS_GESTORES.SILLON s
        JOIN deleted d ON s.sillon_madera = d.material_id OR s.sillon_tela = d.material_id OR s.sillon_relleno = d.material_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el material porque está referenciado en SILLON.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

/*
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
*/

PRINT 'Triggers implementadas correctamente.';
GO

-- Creacion de los Stored procedures

PRINT '6. Creando Stored Procedures de migracion';
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

-- Materiales

CREATE PROCEDURE LOS_GESTORES.SP_MATERIAL
AS
BEGIN
    INSERT INTO LOS_GESTORES.Material
        (material_tipo, material_nombre, material_descripcion, material_precio)
    SELECT DISTINCT
        Material_Tipo,
        Material_Nombre,
        Material_Descripcion,
        Material_Precio
    FROM gd_esquema.Maestra
    WHERE Material_Tipo IS NOT NULL; 
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_MADERA
AS
BEGIN
   INSERT INTO LOS_GESTORES.Madera
    (madera_id
    ,madera_color
    ,madera_dureza
    )
  SELECT
    m.material_id,
    t.MADERA_COLOR,
    t.MADERA_DUREZA
  FROM gd_esquema.Maestra t
    JOIN LOS_GESTORES.Material m ON m.material_nombre = t.Material_Nombre
        AND m.material_tipo = t.Material_Tipo
  WHERE t.Material_tipo = 'Madera'
  GROUP BY m.material_id, t.MADERA_COLOR, t.MADERA_DUREZA; 
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_TELA
AS
BEGIN
  INSERT INTO LOS_GESTORES.Tela
    (tela_id
    ,tela_color
    ,tela_textura
    )
  SELECT
    m.material_id,
    t.Tela_Color,
    t.Tela_Textura
  FROM gd_esquema.Maestra t
    JOIN LOS_GESTORES.Material m ON m.material_nombre = t.Material_Nombre
        AND m.material_tipo = t.Material_Tipo
  WHERE t.Material_tipo = 'Tela'
  GROUP BY m.material_id, t.Tela_Color, t.Tela_Textura;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_RELLENO
AS
BEGIN
  INSERT INTO LOS_GESTORES.Relleno
    (
    relleno_id
    ,relleno_densidad
    )
  SELECT
    m.material_id,
    t.Relleno_Densidad
  FROM gd_esquema.Maestra t
    JOIN LOS_GESTORES.Material m ON m.material_nombre = t.Material_Nombre
        AND m.material_tipo = t.Material_Tipo
  WHERE t.Material_tipo = 'Relleno'
  GROUP BY m.material_id, t.Relleno_Densidad;
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
		  ,sm.[Sillon_Medida_Profundidad];
  -- Actualizar madera del sillón
  UPDATE t1
	SET t1.sillon_madera = mtl.material_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Sillon_Codigo = t1.sillon_codigo AND m.Material_Tipo = 'Madera'
    JOIN LOS_GESTORES.Material mtl ON m.Material_Nombre = mtl.material_nombre AND m.Material_Tipo = mtl.material_tipo;

  -- Actualizar tela del sillón
  UPDATE t1
	SET t1.sillon_tela = mtl.material_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Sillon_Codigo = t1.sillon_codigo AND m.Material_Tipo = 'Tela'
    JOIN LOS_GESTORES.Material mtl ON m.Material_Nombre = mtl.material_nombre AND m.Material_Tipo = mtl.material_tipo;

  -- Actualizar relleno del sillón
  UPDATE t1
	SET t1.sillon_relleno = mtl.material_id
	FROM LOS_GESTORES.sillon t1
    JOIN gd_esquema.Maestra	m on m.Sillon_Codigo = t1.sillon_codigo AND m.Material_Tipo = 'Relleno'
    JOIN LOS_GESTORES.Material mtl ON m.Material_Nombre = mtl.material_nombre AND m.Material_Tipo = mtl.material_tipo;
END;
GO

-- Compra

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
    ,[detalle_compra_material] 
    ,[detalle_compra_precio]
    ,[detalle_compra_cantidad])
  SELECT DISTINCT
    m.[Compra_Numero]
		  , mat.material_id 
		  , m.[Detalle_Compra_Precio]
		  , m.[Detalle_Compra_Cantidad]
  FROM [gd_esquema].[Maestra] m
    JOIN LOS_GESTORES.Material mat ON m.Material_Nombre = mat.material_nombre
      AND m.Material_Tipo = mat.material_tipo 
  where m.COMPRA_NUMERO IS NOT NULL
  AND m.Material_Nombre IS NOT NULL; 
END;
GO

-- Cliente

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

-- Pedido

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

-- Factura

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

PRINT '7. Ejecutando Stored Procedures de migracion de datos';
GO

EXEC LOS_GESTORES.SP_PROVINCIA;
EXEC LOS_GESTORES.SP_LOCALIDAD;
EXEC LOS_GESTORES.SP_SUCURSAL;
EXEC LOS_GESTORES.SP_MATERIAL; 
EXEC LOS_GESTORES.SP_MADERA;
EXEC LOS_GESTORES.SP_TELA;
EXEC LOS_GESTORES.SP_RELLENO;
EXEC LOS_GESTORES.SP_SILLON_MEDIDA;
EXEC LOS_GESTORES.SP_SILLON_MODELO;
EXEC LOS_GESTORES.SP_SILLON;
EXEC LOS_GESTORES.SP_PROVEEDOR;
EXEC LOS_GESTORES.SP_COMPRA;
EXEC LOS_GESTORES.SP_DETALLE_COMPRA;
EXEC LOS_GESTORES.SP_CLIENTE;
EXEC LOS_GESTORES.SP_PEDIDO;
EXEC LOS_GESTORES.SP_DETALLE_PEDIDO;
EXEC LOS_GESTORES.SP_FACTURA;
EXEC LOS_GESTORES.SP_DETALLE_FACTURA;
EXEC LOS_GESTORES.SP_ENVIO;
GO

PRINT 'Migracion de datos inicial completada.';
PRINT 'Script finalizado.';
