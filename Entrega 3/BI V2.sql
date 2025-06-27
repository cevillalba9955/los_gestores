USE [GD1C2025] 
GO


CREATE FUNCTION LOS_GESTORES.BI_GetTiempoID(@FECHA DATE)
 RETURNS NVARCHAR(6) AS BEGIN
    RETURN FORMAT(@FECHA,'yyyyMM')
END
GO

CREATE FUNCTION LOS_GESTORES.BI_getCuatrimestre (@MES INT)
RETURNS SMALLINT
AS BEGIN
    RETURN FLOOR((@MES + 3)/4)
END
GO

create FUNCTION LOS_GESTORES.BI_getEstadoPedidoId(@Estado NVARCHAR(255))
RETURNS SMALLINT
AS BEGIN
    DECLARE @ID_Estado SMALLINT

    SET @ID_Estado =
		CASE 
			WHEN @Estado = 'PENDIENTE' THEN 1
			WHEN @Estado = 'ENTREGADO' THEN 2
			WHEN @Estado = 'CANCELADO' THEN 3
            ELSE 0
		END

    RETURN @ID_Estado
END
GO


CREATE FUNCTION LOS_GESTORES.BI_getMATERIALId(@material NVARCHAR(255))
RETURNS SMALLINT
AS BEGIN
    DECLARE @ID_material SMALLINT

    SET @ID_material =
		CASE 
			WHEN @material = 'Madera' THEN 1
			WHEN @material = 'Tela' THEN 2
			WHEN @material = 'Relleno' THEN 3
            ELSE 0
		END

    RETURN @ID_material
END
GO


CREATE FUNCTION LOS_GESTORES.BI_getTurnoVenta (@fechaHora DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @hora INT
    DECLARE @turno NVARCHAR(20)

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





GO
CREATE FUNCTION LOS_GESTORES.BI.getModeloTopVentas (@anio INT, @CUATRIMESTRE INT, @RANGO NVARCHAR(6), @LOCALIDAD INT, @POSICION INT)
RETURNS BIGINT
AS
BEGIN

    DECLARE @MODELO BIGINT
    DECLARE TOPVENTAS CURSOR FOR
	SELECT TOP 3
        SILLON_MODELO
    FROM BI.VENTAS_POR_MODELO
    WHERE ANIO = @ANIO
        AND CUATRIMESTRE = @CUATRIMESTRE
        AND RANGO_ETAREO = @RANGO
        AND SUCURSAL_LOCALIDAD = @LOCALIDAD
    GROUP BY SILLON_MODELO
    ORDER BY SUM(TOTAL_VENTAS) DESC


    OPEN TOPVENTAS
    WHILE (@POSICION>0)
	BEGIN
        FETCH NEXT FROM TOPVENTAS INTO @MODELO
        SET @POSICION = @POSICION -1
    END

    CLOSE TOPVENTAS
    DEALLOCATE TOPVENTAS
    RETURN @MODELO
END
GO




PRINT 'Funciones BI creadas.';
GO

PRINT '2. Creando tablas de dimensiones';
GO

CREATE TABLE LOS_GESTORES.BI_ubicacion
(
    id_ubicacion INT PRIMARY KEY,
    localidad NVARCHAR(100),
    provincia NVARCHAR(100)
);
GO

CREATE TABLE LOS_GESTORES.BI_cliente
(
    id_cliente INT PRIMARY KEY,
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    fecha_nacimiento DATE,
    id_ubicacion INT,
    CONSTRAINT FK_dm_cliente_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_proveedor
(
    id_proveedor BIGINT PRIMARY KEY,
    nombre NVARCHAR(255),
    id_ubicacion INT,
    CONSTRAINT FK_dm_proveedor_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_sucursal
(
    id_sucursal BIGINT PRIMARY KEY,
    id_ubicacion INT,
    CONSTRAINT FK_dm_sucursal_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOS_GESTORES.BI_ubicacion(id_ubicacion)
);
GO

CREATE TABLE LOS_GESTORES.BI_tiempo
(
    id_tiempo NVARCHAR(6) PRIMARY KEY,
    anio INT,
    mes INT
);
GO

CREATE TABLE LOS_GESTORES.BI_turno
(
    id_turno INT PRIMARY KEY,
    descripcion_turno NVARCHAR(20)
);
GO

CREATE TABLE LOS_GESTORES.BI_estado_pedido
(
    id_estado INT PRIMARY KEY,
    estado NVARCHAR(255)
);
GO

CREATE TABLE LOS_GESTORES.BI_material
(
    id_material BIGINT PRIMARY KEY,
    tipo_material NVARCHAR(255)
);
GO

CREATE TABLE LOS_GESTORES.BI_modelo
(
    id_modelo BIGINT PRIMARY KEY,
    modelo_nombre NVARCHAR(255)
);
GO

PRINT 'Tablas de dimensiones creadas.';
GO

PRINT '3. Insertando datos en dimensiones';
GO

INSERT INTO LOS_GESTORES.BI_ubicacion
    (id_ubicacion,localidad, provincia)
SELECT DISTINCT
    l.localidad_id,
    l.localidad_descripcion,
    p.provincia_descripcion
FROM LOS_GESTORES.Localidad l
    JOIN LOS_GESTORES.Provincia p ON l.localidad_provincia = p.provincia_id;

GO

INSERT INTO LOS_GESTORES.BI_cliente
    (
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

INSERT INTO LOS_GESTORES.BI_proveedor
    (
    id_proveedor, nombre, id_ubicacion
    )
SELECT
    p.proveedor_id,
    p.proveedor_razonSocial,
    P.proveedor_localidad
FROM LOS_GESTORES.Proveedor p
GO


INSERT INTO LOS_GESTORES.BI_sucursal
    (
    id_sucursal, id_ubicacion
    )
SELECT
    s.sucursal_nroSucursal,
    S.sucursal_localidad
FROM LOS_GESTORES.Sucursal s
GO

INSERT INTO LOS_GESTORES.BI_tiempo
    (ID_TIEMPO,anio,mes)
SELECT BI_GET_TIEMPO_ID(PEDIDO_FECHA) , YEAR(pedido_fecha), MONTH(pedido_fecha)
FROM LOS_GESTORES.Pedido
GROUP BY YEAR(pedido_fecha), MONTH(pedido_fecha)
ORDER BY 1,2
GO

INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(1, '08:00-14:00')
INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(2, '14:00-20:00')
INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(0, 'Fuera de turno')
GO

INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (1, 'PENDIENTE')
INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (2, 'ENTREGADO')
INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (3, 'CANCELADO')
GO



INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (1, 'Madera')
INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (2, 'Tela')
INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (3, 'Relleno')
GO


INSERT INTO LOS_GESTORES.BI_modelo
    (id_modelo, modelo_nombre)
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

CREATE TABLE LOS_GESTORES.BI_HECHO_COMPRA
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    monto_total DECIMAL(18,2),
    cantidad DECIMAL(18,0),
    CONSTRAINT FK_BI_compra_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_SUCURSAL (id_sucursal),
    CONSTRAINT FK_BI_compra_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo)
);
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_VENTA
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    id_cliente INT,
    id_modelo BIGINT,
    monto_total decimal(18,2)
        CONSTRAINT FK_BI_venta_cliente FOREIGN KEY (id_cliente) REFERENCES LOS_GESTORES.BI_cliente (id_cliente),
    CONSTRAINT FK_BI_venta_modelo FOREIGN KEY (id_modelo) REFERENCES LOS_GESTORES.BI_modelo (id_modelo),
    CONSTRAINT FK_BI_venta_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_SUCURSAL (id_sucursal),
    CONSTRAINT FK_BI_venta_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo)
);
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_PEDIDO
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    id_estado INT,
    id_turno INT,
    cantidad DECIMAL(18,0),
    CONSTRAINT FK_BI_pedido_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_SUCURSAL (id_sucursal),
    CONSTRAINT FK_BI_pedido_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo),
    CONSTRAINT FK_BI_pedido_estado FOREIGN KEY (id_estado) REFERENCES LOS_GESTORES.BI_ESTADO_pedido (id_estado),
    CONSTRAINT FK_BI_pedido_turno  FOREIGN KEY (id_turno) REFERENCES LOS_GESTORES.BI_TURNO(id_turno)
);
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_FABRICACION
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    dias_demora DECIMAL(18, 2),
    cantidad_pedidos decimal(18,2)
        CONSTRAINT FK_BI_fabricacion_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo),
    CONSTRAINT FK_bi_FABRICACION_SUCURSAL FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_Sucursal(id_sucursal)
);
GO


CREATE TABLE LOS_GESTORES.BI_HECHO_MATERIAL
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    id_material BIGINT,
    total_compra NUMERIC(18,2),
        CONSTRAINT FK_BI_MATERIAL_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo),
        CONSTRAINT FK_BI_MATERIAL_MATERIAL FOREIGN KEY (id_material) REFERENCES LOS_GESTORES.BI_MATERIAL(id_material),
        CONSTRAINT FK_bi_MATERIAL_SUCURSAL FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_Sucursal(id_sucursal)

);
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_ENVIO
(
    id_tiempo NVARCHAR(6),
    id_cliente INT,
    costo DECIMAL(10,2),
    envios_en_fecha int,
    total_envios int,
    CONSTRAINT FK_BI_envio_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo),
    CONSTRAINT FK_BI_envio_cliente FOREIGN KEY (id_cliente) REFERENCES LOS_GESTORES.BI_CLIENTE(id_cliente)
);
GO








PRINT '5. Insertando datos en tablas de hechos';
GO

INSERT INTO LOS_GESTORES.BI_HECHO_FACTURA
    (id_sucursal,id_tiempo,TOTAL)
SELECT FACTURA_SUCURSAL 
	, LOS_GESTORES.BI_GetTiempoID(FACTURA_FECHA)
	, SUM(FACTURA_TOTAL)
FROM LOS_GESTORES.FACTURA
GROUP BY
	 FACTURA_SUCURSAL
	,LOS_GESTORES.BI_GetTiempoID(FACTURA_FECHA)

INSERT INTO LOS_GESTORES.BI_HECHO_COMPRA
    (id_sucursal,id_tiempo,id_cliente,id_modelo,monto_total,cantidad)
SELECT COMPRA_SUCURSAL SUCURSAL
	, LOS_GESTORES.bi_gettiempoid(compra_fecha)
	, SUM(COMPRA_TOTAL) TOTAL
	, COUNT(*) CANTIDAD
FROM LOS_GESTORES.COMPRA
GROUP BY
	 COMPRA_SUCURSAL
	,LOS_GESTORES.bi_gettiempoid(compra_fecha)


INSERT INTO LOS_GESTORES.BI_HECHO_VENTA
    (id_cliente,id_sucursal,id_tiempo,id_modelo,monto_total)
SELECT
    FACTURA_CLIENTE
	, factura_sucursal
	, LOS_GESTORES.bi_gettiempoid(factura_fecha)
	, SILLON_MODELO_CODIGO 
	, SUM(DETALLE_PEDIDO_CANTIDAD * DETALLE_PEDIDO_PRECIO) TOTAL_VENTAS

FROM LOS_GESTORES.FACTURA
    JOIN LOS_GESTORES.DETALLE_PEDIDO ON FACTURA_PEDIDO = DETALLE_PEDIDO_NUMERO
    JOIN LOS_GESTORES.SILLON ON DETALLE_PEDIDO_SILLON_CODIGO = SILLON_CODIGO
GROUP BY
	factura_sucursal
	,LOS_GESTORES.bi_gettiempoid(factura_fecha)
	,FACTURA_CLIENTE
	,SILLON_MODELO_CODIGO

insert into LOS_GESTORES.BI_HECHO_PEDIDO
    (id_sucursal,id_tiempo,id_estado,id_turno,cantidad)
SELECT
    pedido_sucursal
    , LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    , LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    , LOS_GESTORES.BI_getTurnoVenta(pedido_fecha) 
, COUNT(*) CANTIDAD
FROM LOS_GESTORES.Pedido
GROUP BY 
 pedido_sucursal
    ,LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    ,LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    ,LOS_GESTORES.BI_getTurnoVenta(pedido_fecha)


INSERT INTO LOS_GESTORES.BI_HECHO_FABRICACION
    (id_sucursal , id_tiempo , dias_demora , cantidad_pedidos)
SELECT PEDIDO_SUCURSAL
, LOS_GESTORES.bi_gettiempoID(pedido_fecha)
, sum(DATEDIFF(DAY, pedido_fecha,factura_fecha)) 
, count(*)
FROM LOS_GESTORES.Pedido
    JOIN LOS_GESTORES.Factura ON pedido_sucursal+pedido_numero = FACTURA_SUCURSAL+factura_pedido
GROUP BY pedido_sucursal
,LOS_GESTORES.bi_gettiempoID(pedido_fecha)


INSERT INTO LOS_GESTORES.BI_HECHO_MATERIAL
    ( id_sucursal , id_tiempo , id_material , total_compra )
SELECT COMPRA_SUCURSAL SUCURSAL
    , LOS_GESTORES.bi_gettiempoID(COMPRA_FECHA)
	, LOS_GESTORES.BI_getMATERIALId(material_tipo)
	, SUM(detalle_compra_cantidad* detalle_compra_precio) TOTAL
FROM LOS_GESTORES.COMPRA
    JOIN LOS_GESTORES.Detalle_Compra ON COMPRA.compra_numero = detalle_compra_numero
    JOIN LOS_GESTORES.Material ON detalle_compra_material = material_id
GROUP BY
	 COMPRA_SUCURSAL
    , LOS_GESTORES.bi_gettiempoID(COMPRA_FECHA)
	,LOS_GESTORES.BI_getMATERIALId(material_tipo)


insert into LOS_GESTORES.BI_HECHO_ENVIO
    ( id_tiempo , id_cliente , costo , envios_en_fecha, total_envios )
SELECT LOS_GESTORES.bi_gettiempoID(envio_fecha)
	, factura_cliente
	, SUM(envio_importe_subida + envio_importe_traslado) COSTO
	, COUNT(*) TOTAL_ENVIOS,
    (SELECT COUNT(*)
    FROM LOS_GESTORES.Envio
        JOIN LOS_GESTORES.Factura ON envio_factura = factura_numero
    WHERE 
    LOS_GESTORES.bi_gettiempoID(envio_fecha) = LOS_GESTORES.bi_gettiempoID(t1.envio_fecha)
        and factura_cliente = f1.factura_cliente
        AND DATEDIFF(DAY,envio_fecha_programada,envio_fecha) = 0 ) ENVIOS_EN_FECHA

fROM LOS_GESTORES.Envio T1
    JOIN LOS_GESTORES.Factura F1 ON envio_factura = factura_numero
GROUP BY 
LOS_GESTORES.bi_gettiempoID(envio_fecha)
	,factura_cliente

GO






PRINT '6. Creando vistas para consultas de negocio';
GO

-- 1. Ganancias
CREATE VIEW LOS_GESTORES.BI_V01_ganancias_mensuales_por_sucursal
AS
    SELECT T.ANIO, T.MES,F.ID_SUCURSAL, 
        ISNULL(F.TOTAL,0) - ISNULL(C.monto_total,0) GANANCIA
    FROM LOS_GESTORES.BI_tiempo T
    LEFT JOIN LOS_GESTORES.BI_HECHO_FACTURA F ON F.id_tiempo = T.id_tiempo
    LEFT JOIN LOS_GESTORES.BI_HECHO_COMPRA C ON C.ID_TIEMPO = T.ID_TIEMPO AND F.id_sucursal = C.ID_SUCURSAL 
GO


-- 2. Factura promedio mensual 
CREATE VIEW LOS_GESTORES.BI.V02_factura_promedio_provincia_cuatrimestre
AS
    SELECT U.provincia
        ,T.anio
        ,LOS_GESTORES.BI_getCuatrimestre(T.MES)  CUATRIMESTRE
        ,AVG(F.TOTAL) FACTURACION_PROMEDIO
        ,100 * SUM(F.TOTAL)
        / (SELECT SUM(F2.TOTAL)
            FROM LOS_GESTORES.BI_HECHO_FACTURA F2
            JOIN LOS_GESTORES.BI_tiempo T2 ON F2.id_tiempo = T2.id_tiempo
        WHERE T2.anio = T.anio
        AND LOS_GESTORES.BI_getCuatrimestre(T2.MES) = LOS_GESTORES.BI_getCuatrimestre(T.MES)) PORCENTAJE_DEL_PERIODO

    FROM LOS_GESTORES.BI_HECHO_FACTURA F
    JOIN LOS_GESTORES.BI_sucursal S ON F.id_sucursal = S.id_sucursal
    JOIN LOS_GESTORES.BI_ubicacion U ON S.id_ubicacion = U.id_ubicacion
    JOIN LOS_GESTORES.BI_tiempo T ON F.id_tiempo = T.id_tiempo
    GROUP BY 
    U.provincia
        ,T.anio
        ,LOS_GESTORES.BI_getCuatrimestre(T.MES) 
GO

-- 3. Rendimiento de modelos
CREATE VIEW BI.vw_top_3_modelos_por_cuatrimestre_localidad_rango_etario
AS
    WITH
        ModeloVentas
        AS
        (
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
            GROUP BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario
            --, dm.modelo_nombre
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
CREATE VIEW BI.vw_volumen_pedidos_por_turno_sucursal_mes_anio
AS
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

-- 5. Conversi�n de pedidos
CREATE VIEW BI.vw_conversion_pedidos_por_estado_cuatrimestre_sucursal
AS
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

-- 6. Tiempo promedio de fabricaci�n
CREATE VIEW BI.vw_tiempo_promedio_fabricacion_sucursal_cuatrimestre
AS
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

CREATE VIEW LOS_GESTORES.VW_PEDIDOS_POR_TURNO
AS
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





-- 5. Conversi�n de pedidos
CREATE VIEW LOS_GESTORES.VW_CONVERSION_PEDIDOS
AS
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


-- 6. Tiempo promedio de fabricaci�n---- 
---nose si esta bien en el join hace 
---JOIN LOS_GESTORES.Factura ON pedido_sucursal+pedido_numero = FACTURA_SUCURSAL+factura_pedido

CREATE VIEW LOS_GESTORES.VW_FABRICACION_PROMEDIO
AS
    SELECT
        f.id_sucursal,
        f.cuatrimestre,
        s.sucursal_direccion,
        CAST(f.dias_demora_promedio AS DECIMAL(10,2)) AS promedio_dias_demora
    FROM LOS_GESTORES.BI_FABRICACION f
        JOIN LOS_GESTORES.Sucursal s ON f.id_sucursal = s.sucursal_id
    ORDER BY f.id_sucursal, f.cuatrimestre;
GO


-- 7. Promedio de Compras
CREATE VIEW BI.vw_promedio_compras_mensual
AS
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
CREATE VIEW BI.vw_compras_por_tipo_material_sucursal_cuatrimestre
AS
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

-- 9. Porcentaje de cumplimiento de env�os en los tiempos programados por mes
CREATE VIEW BI.vw_porcentaje_cumplimiento_envios_mensual
AS
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

-- 10. Localidades que pagan mayor costo de env�o
CREATE VIEW BI.vw_top_3_localidades_mayor_costo_envio
AS
    WITH
        LocalidadCostoEnvio
        AS
        (
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
CREATE VIEW BI.vw_compras_por_tipo_material_sucursal_cuatrimestre
AS
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

-- 9. Porcentaje de cumplimiento de env�os en los tiempos programados por mes
CREATE VIEW LOS_GESTORES.VW_PORCENTAJE_CUMPLIMIENTO_MENSUAL_ENVIOS
AS
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


-- 10. Localidades que pagan mayor costo de env�o 
CREATE VIEW LOS_GESTORES.VW_LOCALIDADES_MAYOR_COSTO_ENVIO
AS
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