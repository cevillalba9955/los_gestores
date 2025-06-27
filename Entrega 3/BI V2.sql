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
RETURNS INT
AS
BEGIN
    DECLARE @hora INT
    DECLARE @turno INT

    SET @hora = DATEPART(HOUR, @fechaHora)

    SET @turno = 
        CASE 
            WHEN @hora >= 8 AND @hora < 14 THEN 1
            WHEN @hora >= 14 AND @hora < 20 THEN 2
            ELSE 0
        END

    RETURN @turno
END
GO


PRINT 'Funciones BI creadas.';
GO

PRINT '2. Creando tablas de dimensiones';
GO

CREATE TABLE LOS_GESTORES.BI_ubicacion (
    id_ubicacion INT PRIMARY KEY,
    localidad NVARCHAR(100),
    provincia NVARCHAR(100)
);
GO

CREATE TABLE LOS_GESTORES.BI_cliente (
    id_cliente INT PRIMARY KEY,
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    fecha_nacimiento DATE,
    id_ubicacion INT,
    CONSTRAINT FK_dm_cliente_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_proveedor (
    id_proveedor BIGINT PRIMARY KEY, 
    nombre NVARCHAR(255),
    id_ubicacion INT,
    CONSTRAINT FK_dm_proveedor_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_sucursal (
    id_sucursal BIGINT PRIMARY KEY, 
    id_ubicacion INT,
    CONSTRAINT FK_dm_sucursal_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_tiempo (
    id_tiempo NVARCHAR(6) PRIMARY KEY,
    anio INT,
    mes INT
);
GO

CREATE TABLE LOS_GESTORES.BI_turno (
    id_turno INT PRIMARY KEY,
    descripcion_turno NVARCHAR(20)
);
GO

CREATE TABLE LOS_GESTORES.BI_estado_pedido (
    id_estado INT PRIMARY KEY,
    estado NVARCHAR(255)
);
GO

CREATE TABLE LOS_GESTORES.BI_material (
    id_material BIGINT PRIMARY KEY, 
    tipo_material NVARCHAR(255)
);
GO

CREATE TABLE LOS_GESTORES.BI_modelo (
    id_modelo BIGINT PRIMARY KEY, 
    modelo_nombre NVARCHAR(255)
);
GO

PRINT 'Tablas de dimensiones creadas.';
GO

PRINT '3. Insertando datos en dimensiones';
GO

INSERT INTO LOS_GESTORES.BI_ubicacion(id_ubicacion,localidad, provincia)
SELECT DISTINCT
	l.localidad_id,
    l.localidad_descripcion,
    p.provincia_descripcion
FROM LOS_GESTORES.Localidad l
JOIN LOS_GESTORES.Provincia p ON l.localidad_provincia = p.provincia_id;

GO

INSERT INTO LOS_GESTORES.BI_cliente(
    id_cliente, nombre, apellido, fecha_nacimiento, id_ubicacion
)
SELECT
    c.cliente_id,
    c.cliente_nombre,
    c.cliente_apellido,
    c.cliente_fechanacimiento,
    c.cliente_localidad
FROM LOS_GESTORES.Cliente c
GO

INSERT INTO LOS_GESTORES.BI_proveedor (
    id_proveedor, nombre, id_ubicacion
)
SELECT
    p.proveedor_id,
    p.proveedor_razonSocial, 
    P.proveedor_localidad
FROM LOS_GESTORES.Proveedor p
GO


INSERT INTO LOS_GESTORES.BI_sucursal(
    id_sucursal, id_ubicacion
)
SELECT
    s.sucursal_nroSucursal,
	S.sucursal_localidad
FROM LOS_GESTORES.Sucursal s
GO

INSERT INTO LOS_GESTORES.BI_tiempo(ID_TIEMPO,anio,mes)
SELECT  FORMAT(MIN(PEDIDO_FECHA),'yyyyMM') , YEAR(pedido_fecha), MONTH(pedido_fecha)
FROM LOS_GESTORES.Pedido
GROUP BY YEAR(pedido_fecha), MONTH(pedido_fecha)
ORDER BY 1,2

GO

INSERT INTO LOS_GESTORES.BI_turno(ID_TURNO,descripcion_turno)VALUES(1,'08:00-14:00')
INSERT INTO LOS_GESTORES.BI_turno(ID_TURNO,descripcion_turno)VALUES(2,'14:00-20:00')
INSERT INTO LOS_GESTORES.BI_turno(ID_TURNO,descripcion_turno)VALUES(0,'Fuera de turno')
GO 

INSERT INTO LOS_GESTORES.BI_estado_pedido(id_estado,estado) VALUES (1,'PENDIENTE')
INSERT INTO LOS_GESTORES.BI_estado_pedido(id_estado,estado) VALUES (2,'ENTREGADO')
INSERT INTO LOS_GESTORES.BI_estado_pedido(id_estado,estado) VALUES (3,'CANCELADO')
GO



INSERT INTO LOS_GESTORES.BI_material (id_material, tipo_material) VALUES (1,'Madera')
INSERT INTO LOS_GESTORES.BI_material (id_material, tipo_material) VALUES (2,'Tela')
INSERT INTO LOS_GESTORES.BI_material (id_material, tipo_material) VALUES (3,'Relleno')
GO


INSERT INTO LOS_GESTORES.BI_modelo(id_modelo, modelo_nombre)
SELECT
    sm.sillon_modelo_codigo,
    sm.sillon_modelo
	FROM LOS_GESTORES.Sillon_Modelo sm;
GO

PRINT '4. Creando tablas de hechos';
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_FACTURA
(
    id_sucursal BIGINT, 
    id_tiempo NVARCHAR(6),
	TOTAL decimal(38, 2),
    CONSTRAINT FK_BI_factura_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_SUCURSAL (id_sucursal),
    CONSTRAINT FK_BI_factura_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo)
) 
GO




CREATE TABLE LOS_GESTORES.BI_HECHO_ENVIO 
(
    id_tiempo INT,
    id_cliente INT,
    envios_en_fecha int,
    costo DECIMAL(10,2), 
	total_envios int,
    CONSTRAINT FK_BI_envio_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo),
    CONSTRAINT FK_BI_envio_cliente FOREIGN KEY (id_cliente) REFERENCES LOS_GESTORES.BI_CLIENTE(id_cliente)
);
GO



CREATE TABLE LOS_GESTORES.BI_HECHO_PEDIDOS (
    id_tiempo INT
    id_sucursal INT,
    id_turno INT,
    estado_pedido VARCHAR(50),
    cantidad INT,
	CONSTRAINT FK_BI_pedido_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(ID_TIEMPO),
    CONSTRAINT FK_BI_pedido_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.Sucursal(ID_SUCURSAL),
    CONSTRAINT FK_BI_pedido_turno FOREIGN KEY (id_turno) REFERENCES LOS_GESTORES.BI_TURNO(ID_TURNO)
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

INSERT INTO LOS_GESTORES.BI_HECHO_FACTURA(id_sucursal,id_tiempo,TOTAL)
 SELECT FACTURA_SUCURSAL 
	,FORMAT(FACTURA_FECHA,'yyyyMM')
	,SUM(FACTURA_TOTAL) 
 FROM LOS_GESTORES.FACTURA
 GROUP BY
	 FACTURA_SUCURSAL
	,FORMAT(FACTURA_FECHA,'yyyyMM')



INSERT INTO LOS_GESTORES.BI_ENVIO (
    id_tiempo,
    id_cliente,
    envios_en_fecha,
    costo,
    total_envios
)
SELECT
    t.id_tiempo,
    c2.id_cliente,
    SUM(CASE 
            WHEN DATEDIFF(DAY, e.envio_fecha_programada, e.envio_fecha) = 0 
            THEN 1 ELSE 0 
        END) AS envios_en_fecha,
    SUM(e.envio_importe_subida + e.envio_importe_traslado) AS costo,
    COUNT(*) AS total_envios
FROM LOS_GESTORES.Envio e
JOIN LOS_GESTORES.Factura f ON e.envio_factura = f.factura_numero
JOIN LOS_GESTORES.Cliente c ON f.factura_cliente = c.cliente_id
JOIN LOS_GESTORES.BI_CLIENTE c2 ON c2.localidad_id = c.cliente_localidad
JOIN LOS_GESTORES.BI_TIEMPO t ON t.anio = YEAR(e.envio_fecha) AND t.mes = MONTH(e.envio_fecha)
GROUP BY
    t.id_tiempo,
    c2.id_cliente;
GO




INSERT INTO LOS_GESTORES.BI_HECHO_PEDIDOS (
    id_tiempo,
    id_sucursal,
    id_turno,
    estado_pedido,
    cantidad
)
SELECT
    t.id_tiempo,
    p.pedido_sucursal,
    BI.getTurnoVenta(p.pedido_fecha) AS id_turno,
    p.pedido_estado,
    COUNT(*) AS cantidad
FROM LOS_GESTORES.Pedido p
JOIN LOS_GESTORES.BI_TIEMPO t
    ON t.anio = YEAR(p.pedido_fecha)
    AND t.mes = MONTH(p.pedido_fecha)
GROUP BY 
    t.id_tiempo,
    p.pedido_sucursal,
    BI.getTurnoVenta(p.pedido_fecha),
    p.pedido_estado;
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

CREATE VIEW LOS_GESTORES.VW_PEDIDOS_POR_TURNO AS
SELECT 
    t.anio,
    t.mes,
    p.id_sucursal,
    p.id_turno,
    SUM(p.cantidad) AS pedidos
FROM LOS_GESTORES.BI_HECHO_PEDIDOS p
JOIN LOS_GESTORES.BI_TIEMPO t ON t.id_tiempo = FORMAT(p.pedido_fecha, 'yyyyMM')
GROUP BY 
    t.anio,
    t.mes,
    p.id_sucursal,
    p.id_turno;
GO





-- 5. Conversión de pedidos
CREATE VIEW LOS_GESTORES.VW_CONVERSION_PEDIDOS AS
SELECT 
    t.anio,
    FLOOR((t.mes + 3) / 4) AS cuatrimestre,
    p.id_sucursal,
    p.estado_pedido,
    CAST(
        100.0 * SUM(p.cantidad) / (
            SELECT SUM(p2.cantidad)
            FROM LOS_GESTORES.BI_HECHO_PEDIDOS p2
            JOIN LOS_GESTORES.BI_TIEMPO t2 ON t2.id_tiempo = FORMAT(p2.pedido_fecha, 'yyyyMM')
            WHERE t2.anio = t.anio
              AND FLOOR((t2.mes + 3) / 4) = FLOOR((t.mes + 3) / 4)
              AND p2.id_sucursal = p.id_sucursal
        ) AS DECIMAL(5,2)
    ) AS porcentaje
FROM LOS_GESTORES.BI_HECHO_PEDIDOS p
JOIN LOS_GESTORES.BI_TIEMPO t ON t.id_tiempo = FORMAT(p.pedido_fecha, 'yyyyMM')
GROUP BY 
    t.anio,
    FLOOR((t.mes + 3) / 4),
    p.id_sucursal,
    p.estado_pedido;
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
CREATE VIEW LOS_GESTORES.VW_PORCENTAJE_CUMPLIMIENTO_MENSUAL_ENVIOS AS
SELECT 
    t.anio,
    t.mes,
    CAST(100.0 * SUM(e.envios_en_fecha) / SUM(e.total_envios) AS DECIMAL(5,2)) AS porcentaje_cumplimiento
FROM LOS_GESTORES.BI_ENVIO e
JOIN LOS_GESTORES.BI_TIEMPO t ON e.id_tiempo = t.id_tiempo
GROUP BY 
    t.anio,
    t.mes;
GO


-- 10. Localidades que pagan mayor costo de envío 
CREATE VIEW LOS_GESTORES.VW_LOCALIDADES_MAYOR_COSTO_ENVIO AS
SELECT TOP 3
    cl.localidad_id,
    cl.localidad_descripcion,
    CAST(SUM(e.costo) / SUM(e.total_envios) AS DECIMAL(10,2)) AS promedio_envio
FROM LOS_GESTORES.BI_ENVIO e
JOIN LOS_GESTORES.BI_CLIENTE cl ON e.id_cliente = cl.id_cliente
GROUP BY 
    cl.localidad_id,
    cl.localidad_descripcion
ORDER BY 
    promedio_envio DESC;
GO


PRINT 'Vistas BI creadas.';
GO

PRINT 'Script de Modelo BI completado.';
GO