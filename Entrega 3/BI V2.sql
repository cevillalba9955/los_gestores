USE [GD1C2025] 
GO

PRINT '1. Creando el esquema BI';
GO

CREATE SCHEMA BI;
GO

PRINT 'Esquema BI creado.';

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

PRINT 'Funciones BI creadas.';
GO

PRINT '2. Creando tablas de dimensiones';
GO

CREATE TABLE BI.dm_ubicacion (
    id_ubicacion INT IDENTITY(1,1) PRIMARY KEY,
    localidad NVARCHAR(100),
    provincia NVARCHAR(100)
);
GO

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

CREATE TABLE BI.dm_proveedor (
    id_proveedor BIGINT PRIMARY KEY, 
    nombre NVARCHAR(255),
    direccion NVARCHAR(150),
    telefono NVARCHAR(20),
    mail NVARCHAR(100),
    id_ubicacion INT,
    CONSTRAINT FK_dm_proveedor_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES BI.dm_ubicacion(id_ubicacion)
);
GO

CREATE TABLE BI.dm_sucursal (
    id_sucursal BIGINT PRIMARY KEY, 
    direccion NVARCHAR(255),
    telefono NVARCHAR(255), 
    mail NVARCHAR(255),
    id_ubicacion INT,
    CONSTRAINT FK_dm_sucursal_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES BI.dm_ubicacion(id_ubicacion)
);
GO

CREATE TABLE BI.dm_tiempo (
    id_tiempo INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    anio INT,
    cuatrimestre INT,
    mes INT
);
GO

CREATE TABLE BI.dm_turno (
    id_turno INT IDENTITY(1,1) PRIMARY KEY,
    descripcion_turno NVARCHAR(20)
);
GO

CREATE TABLE BI.dm_estado_pedido (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    estado NVARCHAR(255)
);
GO

CREATE TABLE BI.dm_material (
    id_material BIGINT PRIMARY KEY, 
    tipo_material NVARCHAR(255),
    nombre_material NVARCHAR(255), 
    descripcion NVARCHAR(255),
    precio DECIMAL(38,2) 
	-- uso_material NVARCHAR(20)  
);
GO

CREATE TABLE BI.dm_modelo (
    id_modelo BIGINT PRIMARY KEY, 
    modelo_nombre NVARCHAR(255), 
    modelo_descripcion NVARCHAR(255),
    modelo_precio DECIMAL(18, 2) 
);
GO

PRINT 'Tablas de dimensiones creadas.';
GO

PRINT '3. Insertando datos en dimensiones';
GO

INSERT INTO BI.dm_ubicacion (localidad, provincia)
SELECT DISTINCT
    l.localidad_descripcion,
    p.provincia_descripcion
FROM LOS_GESTORES.Localidad l
JOIN LOS_GESTORES.Provincia p ON l.localidad_provincia = p.provincia_id;
GO

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
    DATEDIFF(YEAR, c.cliente_fechanacimiento, GETDATE()), -- Edad calculada en el momento de la migración
    BI.getRangoEtario(c.cliente_fechanacimiento),
    u.id_ubicacion
FROM LOS_GESTORES.Cliente c
JOIN LOS_GESTORES.Localidad l ON c.cliente_localidad = l.localidad_id
JOIN LOS_GESTORES.Provincia p ON l.localidad_provincia = p.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = p.provincia_descripcion;
GO

INSERT INTO BI.dm_proveedor (
    id_proveedor, nombre, direccion, telefono, mail, id_ubicacion
)
SELECT
    p.proveedor_id,
    p.proveedor_razonSocial, -- VER
    p.proveedor_direccion,
    p.proveedor_telefono,
    p.proveedor_mail,
    u.id_ubicacion
FROM LOS_GESTORES.Proveedor p
JOIN LOS_GESTORES.Localidad l ON p.proveedor_localidad = l.localidad_id
JOIN LOS_GESTORES.Provincia pr ON l.localidad_provincia = pr.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = pr.provincia_descripcion;
GO

INSERT INTO BI.dm_sucursal (
    id_sucursal, direccion, telefono, mail, id_ubicacion
)
SELECT
    s.sucursal_nroSucursal,
    s.sucursal_direccion,
    s.sucursal_telefono,
    s.sucursal_mail,
    u.id_ubicacion
FROM LOS_GESTORES.Sucursal s
JOIN LOS_GESTORES.Localidad l ON s.sucursal_localidad = l.localidad_id
JOIN LOS_GESTORES.Provincia pr ON l.localidad_provincia = pr.provincia_id
JOIN BI.dm_ubicacion u
    ON u.localidad = l.localidad_descripcion AND u.provincia = pr.provincia_descripcion;

GO

INSERT INTO BI.dm_tiempo (fecha, anio, cuatrimestre, mes)
SELECT DISTINCT
    f.fecha,
    YEAR(f.fecha),
    BI.getCuatrimestre(f.fecha),
    MONTH(f.fecha)
FROM (
    SELECT CAST(pedido_fecha AS DATE) AS fecha FROM LOS_GESTORES.Pedido
    UNION
    SELECT CAST(factura_fecha AS DATE) FROM LOS_GESTORES.Factura
    UNION
    SELECT CAST(compra_fecha AS DATE) FROM LOS_GESTORES.Compra
    UNION
    SELECT CAST(envio_fecha_programada AS DATE) FROM LOS_GESTORES.Envio
    UNION
    SELECT CAST(envio_fecha AS DATE) FROM LOS_GESTORES.Envio WHERE envio_fecha IS NOT NULL
) AS f;
GO

INSERT INTO BI.dm_turno (descripcion_turno)
SELECT DISTINCT
    BI.getTurnoVenta(f.fecha_hora)
FROM (
    SELECT CAST(pedido_fecha AS DATETIME) AS fecha_hora FROM LOS_GESTORES.Pedido
    UNION
    SELECT CAST(factura_fecha AS DATETIME) FROM LOS_GESTORES.Factura
) AS f;
GO

INSERT INTO BI.dm_estado_pedido (estado)
SELECT DISTINCT pedido_estado FROM LOS_GESTORES.Pedido;
GO

INSERT INTO BI.dm_material (id_material, tipo_material, nombre_material, descripcion, precio)
SELECT
    material_id,
    material_tipo,
    material_nombre,
    material_descripcion,
    material_precio
FROM LOS_GESTORES.Material;
GO

INSERT INTO BI.dm_modelo (id_modelo, modelo_nombre, modelo_descripcion, modelo_precio)
SELECT DISTINCT
    sm.sillon_modelo_codigo,
    sm.sillon_modelo,
    sm.sillon_modelo_descripcion,
    sm.sillon_modelo_precio
FROM LOS_GESTORES.Sillon_Modelo sm;
GO

PRINT '4. Creando tablas de hechos';
GO

CREATE TABLE BI.ft_envio (
    id_envio DECIMAL(18,0) PRIMARY KEY, 
    id_tiempo INT,
    id_cliente INT,
    id_pedido DECIMAL(18,0), 
    id_sucursal BIGINT, 
    fecha_envio_programada DATE,
    fecha_envio_real DATE,
    costo_envio DECIMAL(18,2), 
    cumplimiento_en_tiempo BIT,
    FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES LOS_GESTORES.Pedido(pedido_numero), 
    FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal)
);
GO

CREATE TABLE BI.ft_pedido (
    id_detalle_pedido BIGINT PRIMARY KEY, 
    id_pedido_encabezado DECIMAL(18,0), 
    id_cliente INT,
    id_sucursal BIGINT, 
    id_tiempo INT,
    id_estado INT,
    id_turno INT,
    id_sillon BIGINT,
    cantidad_pedida BIGINT, 
    precio_unitario_sillon DECIMAL(18,2), 
    total_pedido DECIMAL(18,2), 
    tiempo_fabricacion INT, 
    motivo_cancelacion NVARCHAR(255), 
    CONSTRAINT FK_ft_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    CONSTRAINT FK_ft_pedido_sucursal FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal),
    CONSTRAINT FK_ft_pedido_tiempo FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo),
    CONSTRAINT FK_ft_pedido_estado FOREIGN KEY (id_estado) REFERENCES BI.dm_estado_pedido(id_estado),
    CONSTRAINT FK_ft_pedido_turno FOREIGN KEY (id_turno) REFERENCES BI.dm_turno(id_turno),
    -- CONSTRAINT FK_ft_pedido_sillon FOREIGN KEY (id_sillon) REFERENCES BI.dm_sillon(id_sillon)
);
GO

CREATE TABLE BI.ft_factura (
    id_detalle_factura BIGINT PRIMARY KEY,
    id_factura_encabezado BIGINT,
    id_cliente INT,
    id_pedido DECIMAL(18,0),
    id_sucursal BIGINT, 
    id_tiempo INT,
    cantidad_facturada DECIMAL(18,0), 
    precio_unitario_facturado DECIMAL(18,2), 
    total_facturado_item DECIMAL(38,2), 
    total_facturado_encabezado DECIMAL(38,2), 
    tiempo_fabricacion INT, 
    CONSTRAINT FK_ft_factura_cliente FOREIGN KEY (id_cliente) REFERENCES BI.dm_cliente(id_cliente),
    CONSTRAINT FK_ft_factura_pedido FOREIGN KEY (id_pedido) REFERENCES LOS_GESTORES.Pedido(pedido_numero), 
    CONSTRAINT FK_ft_factura_sucursal FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal),
    CONSTRAINT FK_ft_factura_tiempo FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo)
);
GO

CREATE TABLE BI.ft_compra (
    id_detalle_compra BIGINT PRIMARY KEY, 
    id_compra_encabezado DECIMAL(18,0),
    id_proveedor INT,
    id_material BIGINT,
    id_sucursal BIGINT, 
    id_tiempo INT,
    monto_compra_item DECIMAL(18,2), 
    cantidad_comprada DECIMAL(18,0),
    total_compra_encabezado DECIMAL(18,2), 
    CONSTRAINT FK_ft_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES BI.dm_proveedor(id_proveedor),
    CONSTRAINT FK_ft_compra_material FOREIGN KEY (id_material) REFERENCES BI.dm_material(id_material),
    CONSTRAINT FK_ft_compra_sucursal FOREIGN KEY (id_sucursal) REFERENCES BI.dm_sucursal(id_sucursal),
    CONSTRAINT FK_ft_compra_tiempo FOREIGN KEY (id_tiempo) REFERENCES BI.dm_tiempo(id_tiempo)
);
GO

PRINT '5. Insertando datos en tablas de hechos';
GO

INSERT INTO BI.ft_envio (id_tiempo, id_cliente, id_pedido, id_sucursal, fecha_envio_programada, fecha_envio_real, costo_envio, cumplimiento_en_tiempo)
SELECT
    t.id_tiempo,
    c.cliente_id,
    p.pedido_numero,
    s.sucursal_nroSucursal,
    e.envio_fecha_programada,
    e.envio_fecha,
    e.envio_importe_traslado + ISNULL(e.envio_importe_subida, 0), 
    CASE
        WHEN e.envio_fecha IS NOT NULL AND e.envio_fecha <= e.envio_fecha_programada THEN 1 
        WHEN e.envio_fecha IS NOT NULL AND e.envio_fecha > e.envio_fecha_programada THEN 0 
        ELSE NULL 
    END
FROM LOS_GESTORES.Envio e
JOIN LOS_GESTORES.Factura f ON e.envio_factura = f.factura_numero
JOIN LOS_GESTORES.Pedido p ON f.factura_pedido = p.pedido_numero
JOIN LOS_GESTORES.Cliente c ON p.pedido_cliente = c.cliente_id
JOIN LOS_GESTORES.Sucursal s ON p.pedido_sucursal = s.sucursal_nroSucursal
JOIN BI.dm_tiempo t ON CAST(e.envio_fecha_programada AS DATE) = t.fecha;
GO

INSERT INTO BI.ft_pedido (id_pedido, id_cliente, id_sucursal, id_tiempo, id_estado, id_turno, id_sillon, cantidad_pedida, precio_unitario_sillon, total_pedido, tiempo_fabricacion, motivo_cancelacion)
SELECT
    dp.detalle_pedido_numero,
    c.id_cliente,
    suc.id_sucursal,
    t.id_tiempo,
    ep.id_estado,
    tu.id_turno,
    -- ds.id_sillon,
    dp.detalle_pedido_cantidad,
    dp.detalle_pedido_precio,
    p.pedido_total, 
    DATEDIFF(DAY, p.pedido_fecha, ISNULL(f.factura_fecha, GETDATE())), 
    p.pedido_cancelacion_motivo
FROM LOS_GESTORES.Detalle_Pedido dp
JOIN LOS_GESTORES.Pedido p ON dp.detalle_pedido_numero = p.pedido_numero
LEFT JOIN LOS_GESTORES.Factura f ON p.pedido_numero = f.factura_pedido 
JOIN BI.dm_cliente c ON p.pedido_cliente = c.id_cliente
JOIN BI.dm_sucursal suc ON p.pedido_sucursal = suc.id_sucursal
JOIN BI.dm_tiempo t ON CAST(p.pedido_fecha AS DATE) = t.fecha
JOIN BI.dm_estado_pedido ep ON p.pedido_estado = ep.estado
JOIN BI.dm_turno tu ON BI.getTurnoVenta(CAST(p.pedido_fecha AS DATETIME)) = tu.descripcion_turno
-- JOIN BI.dm_sillon ds ON dp.detalle_pedido_sillon_codigo = ds.id_sillon;
GO

INSERT INTO BI.ft_factura (id_factura, id_cliente, id_pedido, id_sucursal, id_tiempo, total_facturado, tiempo_fabricacion)
SELECT
    f.factura_numero,
    c.id_cliente,
    p.pedido_numero,
    suc.id_sucursal,
    t.id_tiempo,
    f.factura_total,
    DATEDIFF(DAY, p.pedido_fecha, f.factura_fecha) 
FROM LOS_GESTORES.Factura f
JOIN LOS_GESTORES.Pedido p ON f.factura_pedido = p.pedido_numero
JOIN BI.dm_cliente c ON f.factura_cliente = c.id_cliente
JOIN BI.dm_sucursal suc ON f.factura_sucursal = suc.id_sucursal
JOIN BI.dm_tiempo t ON CAST(f.factura_fecha AS DATE) = t.fecha;
GO

INSERT INTO BI.ft_compra (id_compra, id_proveedor, id_material, id_sucursal, id_tiempo, monto_compra, cantidad_comprada)
SELECT
    dc.detalle_compra_numero,
    prov.id_proveedor,
    dm.id_material,
    suc.id_sucursal,
    t.id_tiempo,
    dc.detalle_compra_precio * dc.detalle_compra_cantidad,
    dc.detalle_compra_cantidad
FROM LOS_GESTORES.Detalle_Compra dc
JOIN LOS_GESTORES.Compra com ON dc.detalle_compra_numero = com.compra_numero
JOIN BI.dm_proveedor prov ON com.compra_proveedor = prov.id_proveedor
JOIN BI.dm_material dm ON dc.detalle_compra_material = dm.id_material
JOIN BI.dm_sucursal suc ON com.compra_sucursal = suc.id_sucursal
JOIN BI.dm_tiempo t ON CAST(com.compra_fecha AS DATE) = t.fecha;
GO

PRINT '6. Creando vistas para consultas de negocio';
GO

-- 1. Ganancias
CREATE VIEW BI.vw_ganancias_mensuales_por_sucursal AS
SELECT
    t.anio,
    t.mes,
    s.direccion AS sucursal_direccion,
    ISNULL(SUM(f.total_facturado_encabezado), 0) - ISNULL(SUM(c.total_compra_encabezado), 0) AS ganancia_neta 
FROM BI.dm_tiempo t
JOIN BI.dm_sucursal s ON 1 = 1 
LEFT JOIN BI.ft_factura f ON f.id_tiempo = t.id_tiempo AND f.id_sucursal = s.id_sucursal
LEFT JOIN BI.ft_compra c ON c.id_tiempo = t.id_tiempo AND c.id_sucursal = s.id_sucursal
GROUP BY t.anio, t.mes, s.direccion
ORDER BY t.anio, t.mes, s.direccion;
GO

-- 2. Factura promedio mensual 
CREATE VIEW BI.vw_factura_promedio_provincia_cuatrimestre AS
SELECT
    t.anio,
    t.cuatrimestre,
    u.provincia,
    AVG(f.total_facturado_encabezado) AS factura_promedio_mensual
FROM BI.ft_factura f
JOIN BI.dm_tiempo t ON f.id_tiempo = t.id_tiempo
JOIN BI.dm_sucursal s ON f.id_sucursal = s.id_sucursal
JOIN BI.dm_ubicacion u ON s.id_ubicacion = u.id_ubicacion
GROUP BY t.anio, t.cuatrimestre, u.provincia
ORDER BY t.anio, t.cuatrimestre, u.provincia;
GO

-- 3. Rendimiento de modelos
CREATE VIEW BI.vw_top_3_modelos_por_cuatrimestre_localidad_rango_etario AS
WITH ModeloVentas AS (
    SELECT
        t.anio,
        t.cuatrimestre,
        u.localidad,
        c.rango_etario,
        -- dm.modelo_nombre,
        SUM(fp.cantidad_pedida * fp.precio_unitario_sillon) AS total_ventas_modelo,
        ROW_NUMBER() OVER (PARTITION BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario ORDER BY SUM(fp.cantidad_pedida * fp.precio_unitario_sillon) DESC) AS rn
    FROM BI.ft_pedido fp
    JOIN BI.dm_tiempo t ON fp.id_tiempo = t.id_tiempo
    JOIN BI.dm_sucursal s ON fp.id_sucursal = s.id_sucursal
    JOIN BI.dm_ubicacion u ON s.id_ubicacion = u.id_ubicacion
    JOIN BI.dm_cliente c ON fp.id_cliente = c.id_cliente
    -- JOIN BI.dm_sillon ds ON fp.id_sillon = ds.id_sillon
    -- JOIN BI.dm_modelo dm ON ds.id_modelo = dm.id_modelo
    GROUP BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario --, dm.modelo_nombre
)
SELECT
    anio,
    cuatrimestre,
    localidad,
    rango_etario,
    -- modelo_nombre,
    total_ventas_modelo
FROM ModeloVentas
WHERE rn <= 3
ORDER BY anio, cuatrimestre, localidad, rango_etario, total_ventas_modelo DESC;
GO

-- 4. Volumen de pedidos
CREATE VIEW BI.vw_volumen_pedidos_por_turno_sucursal_mes_anio AS
SELECT
    t.anio,
    t.mes,
    tu.descripcion_turno,
    s.direccion AS sucursal_direccion,
    COUNT(DISTINCT fp.id_pedido_encabezado) AS cantidad_pedidos 
FROM BI.ft_pedido fp
JOIN BI.dm_tiempo t ON fp.id_tiempo = t.id_tiempo
JOIN BI.dm_turno tu ON fp.id_turno = tu.id_turno
JOIN BI.dm_sucursal s ON fp.id_sucursal = s.id_sucursal
GROUP BY t.anio, t.mes, tu.descripcion_turno, s.direccion
ORDER BY t.anio, t.mes, tu.descripcion_turno, s.direccion;
GO

-- 5. Conversión de pedidos
CREATE VIEW BI.vw_conversion_pedidos_por_estado_cuatrimestre_sucursal AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.direccion AS sucursal_direccion,
    ep.estado AS estado_pedido,
    COUNT(DISTINCT fp.id_pedido_encabezado) AS total_pedidos_estado,
    CAST(COUNT(DISTINCT fp.id_pedido_encabezado) AS DECIMAL(18,2)) * 100.0 /
        (SELECT COUNT(DISTINCT fp2.id_pedido_encabezado)
         FROM BI.ft_pedido fp2
         JOIN BI.dm_tiempo t2 ON fp2.id_tiempo = t2.id_tiempo
         JOIN BI.dm_sucursal s2 ON fp2.id_sucursal = s2.id_sucursal
         WHERE t2.anio = t.anio AND t2.cuatrimestre = t.cuatrimestre AND s2.id_sucursal = s.id_sucursal) AS porcentaje_conversion
FROM BI.ft_pedido fp
JOIN BI.dm_tiempo t ON fp.id_tiempo = t.id_tiempo
JOIN BI.dm_sucursal s ON fp.id_sucursal = s.id_sucursal
JOIN BI.dm_estado_pedido ep ON fp.id_estado = ep.id_estado
GROUP BY t.anio, t.cuatrimestre, s.direccion, s.id_sucursal, ep.estado
ORDER BY t.anio, t.cuatrimestre, s.direccion, ep.estado;
GO

-- 6. Tiempo promedio de fabricación
CREATE VIEW BI.vw_tiempo_promedio_fabricacion_sucursal_cuatrimestre AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.direccion AS sucursal_direccion,
    AVG(f.tiempo_fabricacion) AS tiempo_promedio_fabricacion_dias
FROM BI.ft_factura f
JOIN BI.dm_tiempo t ON f.id_tiempo = t.id_tiempo
JOIN BI.dm_sucursal s ON f.id_sucursal = s.id_sucursal
WHERE f.tiempo_fabricacion IS NOT NULL
GROUP BY t.anio, t.cuatrimestre, s.direccion
ORDER BY t.anio, t.cuatrimestre, s.direccion;
GO

-- 7. Promedio de Compras
CREATE VIEW BI.vw_promedio_compras_mensual AS
SELECT
    t.anio,
    t.mes,
    AVG(fc.total_compra_encabezado) AS importe_promedio_compras
FROM BI.ft_compra fc
JOIN BI.dm_tiempo t ON fc.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes
ORDER BY t.anio, t.mes;
GO

-- 8. Compras por Tipo de Material
CREATE VIEW BI.vw_compras_por_tipo_material_sucursal_cuatrimestre AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.direccion AS sucursal_direccion,
    dm.tipo_material,
    SUM(fc.monto_compra_item) AS importe_total_gastado
FROM BI.ft_compra fc
JOIN BI.dm_tiempo t ON fc.id_tiempo = t.id_tiempo
JOIN BI.dm_sucursal s ON fc.id_sucursal = s.id_sucursal
JOIN BI.dm_material dm ON fc.id_material = dm.id_material
GROUP BY t.anio, t.cuatrimestre, s.direccion, dm.tipo_material
ORDER BY t.anio, t.cuatrimestre, s.direccion, dm.tipo_material;
GO

-- 9. Porcentaje de cumplimiento de envíos en los tiempos programados por mes
CREATE VIEW BI.vw_porcentaje_cumplimiento_envios_mensual AS
SELECT
    t.anio,
    t.mes,
    COUNT(e.id_envio) AS total_envios,
    SUM(CASE WHEN e.cumplimiento_en_tiempo = 1 THEN 1 ELSE 0 END) AS envios_cumplidos_a_tiempo,
    CAST(SUM(CASE WHEN e.cumplimiento_en_tiempo = 1 THEN 1 ELSE 0 END) AS DECIMAL(18,2)) * 100.0 / COUNT(e.id_envio) AS porcentaje_cumplimiento
FROM BI.ft_envio e
JOIN BI.dm_tiempo t ON e.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes
ORDER BY t.anio, t.mes;
GO

-- 10. Localidades que pagan mayor costo de envío
CREATE VIEW BI.vw_top_3_localidades_mayor_costo_envio AS
WITH LocalidadCostoEnvio AS (
    SELECT
        u.localidad,
        AVG(e.costo_envio) AS promedio_costo_envio,
        ROW_NUMBER() OVER (ORDER BY AVG(e.costo_envio) DESC) AS rn
    FROM BI.ft_envio e
    JOIN BI.dm_cliente c ON e.id_cliente = c.id_cliente
    JOIN BI.dm_ubicacion u ON c.id_ubicacion = u.id_ubicacion
    GROUP BY u.localidad
)
SELECT
    localidad,
    promedio_costo_envio
FROM LocalidadCostoEnvio
WHERE rn <= 3
ORDER BY promedio_costo_envio DESC;
GO

PRINT 'Vistas BI creadas.';
GO

PRINT 'Script de Modelo BI completado.';
GO