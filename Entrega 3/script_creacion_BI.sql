USE [GD1C2025] 
GO

PRINT '1. Creando tablas de dimensiones';
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

PRINT '2. Creando tablas de hechos';
GO

CREATE TABLE LOS_GESTORES.BI_HECHO_FACTURA
(
    id_sucursal BIGINT,
    id_tiempo NVARCHAR(6),
    TOTAL decimal(38, 2),
    CONSTRAINT FK_BI_factura_sucursal FOREIGN KEY (id_sucursal) REFERENCES LOS_GESTORES.BI_SUCURSAL (id_sucursal),
    CONSTRAINT FK_BI_factura_tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GESTORES.BI_TIEMPO(id_tiempo)
); 
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
    monto_total decimal(18,2),
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
    cantidad_pedidos decimal(18,2), -- Changed to DECIMAL(18,2) for consistency with numeric calculations
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

PRINT 'Tablas de hechos creadas.';
GO

PRINT 'Creando funciones BI';
GO

CREATE FUNCTION LOS_GESTORES.BI_GetTiempoID(@FECHA DATE)
RETURNS NVARCHAR(6)
AS
BEGIN
    RETURN FORMAT(@FECHA,'yyyyMM');
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getCuatrimestre (@MES INT)
RETURNS SMALLINT
AS
BEGIN
    RETURN FLOOR((@MES + 3)/4);
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getEstadoPedidoId(@Estado NVARCHAR(255))
RETURNS SMALLINT
AS
BEGIN
    DECLARE @ID_Estado SMALLINT;

    SET @ID_Estado =
		CASE 
			WHEN @Estado = 'PENDIENTE' THEN 1
			WHEN @Estado = 'ENTREGADO' THEN 2
			WHEN @Estado = 'CANCELADO' THEN 3
            ELSE 0
		END;

    RETURN @ID_Estado;
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getMATERIALId(@material NVARCHAR(255))
RETURNS SMALLINT
AS
BEGIN
    DECLARE @ID_material SMALLINT;

    SET @ID_material =
		CASE 
			WHEN @material = 'Madera' THEN 1
			WHEN @material = 'Tela' THEN 2
			WHEN @material = 'Relleno' THEN 3
            ELSE 0
		END;

    RETURN @ID_material;
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getTurnoVenta (@fechaHora DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @hora INT;
    SET @hora = DATEPART(HOUR, @fechaHora);

    RETURN CASE 
                WHEN @hora >= 8 AND @hora < 14 THEN 1
                WHEN @hora >= 14 AND @hora < 20 THEN 2
                ELSE 0
           END;
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getRangoEtario (@fechaNacimiento DATE, @ANIO INT , @MES INT)
RETURNS NVARCHAR(6)
AS
BEGIN
    DECLARE @EdadActual INT;
    DECLARE @RANGO NVARCHAR(6);

    SET @EdadActual = CASE WHEN MONTH(@fechaNacimiento) > @MES THEN -1 ELSE 0 END; 
    SET @EdadActual = @EdadActual + @ANIO - YEAR(@fechaNacimiento);

    SET @rango =
		CASE 
			WHEN @EdadActual < 25 THEN '<25'
			WHEN @EdadActual < 35 THEN '25-35'
			WHEN @EdadActual < 50 THEN '35-50'
			ELSE '>50'
		END;

    RETURN @rango;
END;
GO

CREATE FUNCTION LOS_GESTORES.BI_getModeloTopVentas (@anio INT, @CUATRIMESTRE INT, @RANGO NVARCHAR(6), @LOCALIDAD_ID INT, @POSICION INT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @MODELO BIGINT;

    WITH VentasRanked AS (
        SELECT
            hv.id_modelo,
            SUM(hv.monto_total) AS TotalVentas,
            ROW_NUMBER() OVER (PARTITION BY T.ANIO, LOS_GESTORES.BI_getCuatrimestre(T.MES), U.id_ubicacion, LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES)
                               ORDER BY SUM(hv.monto_total) DESC) as rn
        FROM LOS_GESTORES.BI_HECHO_VENTA hv
        JOIN LOS_GESTORES.BI_tiempo T ON hv.id_tiempo = T.id_tiempo
        JOIN LOS_GESTORES.BI_cliente CL ON hv.id_cliente = CL.id_cliente
        JOIN LOS_GESTORES.BI_sucursal S ON hv.id_sucursal = S.id_sucursal
        JOIN LOS_GESTORES.BI_ubicacion U ON S.id_ubicacion = U.id_ubicacion
        WHERE T.ANIO = @anio
          AND LOS_GESTORES.BI_getCuatrimestre(T.MES) = @CUATRIMESTRE
          AND LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES) = @RANGO
          AND U.id_ubicacion = @LOCALIDAD_ID
        GROUP BY hv.id_modelo, T.ANIO, LOS_GESTORES.BI_getCuatrimestre(T.MES), U.id_ubicacion, LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES)
    )
    SELECT @MODELO = id_modelo
    FROM VentasRanked
    WHERE rn = @POSICION;

    RETURN @MODELO;
END;
GO

PRINT 'Funciones BI creadas.';
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
FROM LOS_GESTORES.Cliente c;
GO

INSERT INTO LOS_GESTORES.BI_proveedor
    (
    id_proveedor, nombre, id_ubicacion
    )
SELECT
    p.proveedor_id,
    p.proveedor_razonSocial,
    P.proveedor_localidad
FROM LOS_GESTORES.Proveedor p;
GO

INSERT INTO LOS_GESTORES.BI_sucursal
    (
    id_sucursal, id_ubicacion
    )
SELECT
    s.sucursal_nroSucursal,
    S.sucursal_localidad
FROM LOS_GESTORES.Sucursal s;
GO

INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(1, '08:00-14:00');
INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(2, '14:00-20:00');
INSERT INTO LOS_GESTORES.BI_turno
    (ID_TURNO,descripcion_turno)
VALUES(0, 'Fuera de turno');
GO

INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (1, 'PENDIENTE');
INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (2, 'ENTREGADO');
INSERT INTO LOS_GESTORES.BI_estado_pedido
    (id_estado,estado)
VALUES
    (3, 'CANCELADO');
GO

INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (1, 'Madera');
INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (2, 'Tela');
INSERT INTO LOS_GESTORES.BI_material
    (id_material, tipo_material)
VALUES
    (3, 'Relleno');
GO

INSERT INTO LOS_GESTORES.BI_modelo
    (id_modelo, modelo_nombre)
SELECT
    sm.sillon_modelo_codigo,
    sm.sillon_modelo
FROM LOS_GESTORES.Sillon_Modelo sm;
GO

INSERT INTO LOS_GESTORES.BI_tiempo
    (ID_TIEMPO, anio, mes)
SELECT LOS_GESTORES.BI_GetTiempoID(PEDIDO_FECHA), YEAR(pedido_fecha), MONTH(pedido_fecha)
FROM LOS_GESTORES.Pedido
GROUP BY YEAR(pedido_fecha), MONTH(pedido_fecha), LOS_GESTORES.BI_GetTiempoID(PEDIDO_FECHA)
ORDER BY 1,2;
GO

PRINT 'Datos en dimensiones insertados.';
GO

PRINT '4. Insertando datos en tablas de hechos';
GO

INSERT INTO LOS_GESTORES.BI_HECHO_FACTURA
    (id_sucursal,id_tiempo,TOTAL)
SELECT FACTURA_SUCURSAL 
	, LOS_GESTORES.BI_GetTiempoID(FACTURA_FECHA)
	, SUM(FACTURA_TOTAL)
FROM LOS_GESTORES.FACTURA
GROUP BY
	 FACTURA_SUCURSAL
	,LOS_GESTORES.BI_GetTiempoID(FACTURA_FECHA);
GO

INSERT INTO LOS_GESTORES.BI_HECHO_COMPRA
    (id_sucursal, id_tiempo, monto_total, cantidad)
SELECT COMPRA_SUCURSAL
	, LOS_GESTORES.BI_GetTiempoID(compra_fecha)
	, SUM(COMPRA_TOTAL)
	, COUNT(*)
FROM LOS_GESTORES.COMPRA
GROUP BY
	 COMPRA_SUCURSAL
	,LOS_GESTORES.BI_GetTiempoID(compra_fecha);
GO

INSERT INTO LOS_GESTORES.BI_HECHO_VENTA
    (id_cliente,id_sucursal,id_tiempo,id_modelo,monto_total)
SELECT
    FACTURA_CLIENTE
	, factura_sucursal
	, LOS_GESTORES.BI_GetTiempoID(factura_fecha)
	, SILLON_MODELO_CODIGO 
	, SUM(DETALLE_PEDIDO_CANTIDAD * DETALLE_PEDIDO_PRECIO)
FROM LOS_GESTORES.FACTURA
    JOIN LOS_GESTORES.DETALLE_PEDIDO ON FACTURA_PEDIDO = DETALLE_PEDIDO_NUMERO
    JOIN LOS_GESTORES.SILLON ON DETALLE_PEDIDO_SILLON_CODIGO = SILLON_CODIGO
GROUP BY
	factura_sucursal
	,LOS_GESTORES.BI_GetTiempoID(factura_fecha)
	,FACTURA_CLIENTE
	,SILLON_MODELO_CODIGO;
GO

INSERT INTO LOS_GESTORES.BI_HECHO_PEDIDO
    (id_sucursal,id_tiempo,id_estado,id_turno,cantidad)
SELECT
    pedido_sucursal
    , LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    , LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    , LOS_GESTORES.BI_getTurnoVenta(pedido_fecha) 
    , COUNT(*)
FROM LOS_GESTORES.Pedido
GROUP BY 
    pedido_sucursal
    ,LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    ,LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    ,LOS_GESTORES.BI_getTurnoVenta(pedido_fecha);
GO

INSERT INTO LOS_GESTORES.BI_HECHO_FABRICACION
    (id_sucursal , id_tiempo , dias_demora , cantidad_pedidos)
SELECT P.pedido_sucursal
    , LOS_GESTORES.BI_GetTiempoID(P.pedido_fecha)
    , SUM(DATEDIFF(DAY, P.pedido_fecha, F.factura_fecha)) 
    , COUNT(*)
FROM LOS_GESTORES.Pedido P
    JOIN LOS_GESTORES.Factura F ON P.pedido_sucursal = F.factura_sucursal AND P.pedido_numero = F.factura_pedido
GROUP BY P.pedido_sucursal
    ,LOS_GESTORES.BI_GetTiempoID(P.pedido_fecha);
GO

INSERT INTO LOS_GESTORES.BI_HECHO_MATERIAL
    ( id_sucursal , id_tiempo , id_material , total_compra )
SELECT C.compra_sucursal
    , LOS_GESTORES.BI_GetTiempoID(C.compra_fecha)
	, LOS_GESTORES.BI_getMATERIALId(M.material_tipo)
	, SUM(DC.detalle_compra_cantidad* DC.detalle_compra_precio)
FROM LOS_GESTORES.COMPRA C
    JOIN LOS_GESTORES.Detalle_Compra DC ON C.compra_numero = DC.detalle_compra_numero
    JOIN LOS_GESTORES.Material M ON DC.detalle_compra_material = M.material_id
GROUP BY
	 C.compra_sucursal
    , LOS_GESTORES.BI_GetTiempoID(C.compra_fecha)
	,LOS_GESTORES.BI_getMATERIALId(M.material_tipo);
GO

INSERT INTO LOS_GESTORES.BI_HECHO_ENVIO
    (id_tiempo, id_cliente, costo, total_envios, envios_en_fecha)
SELECT LOS_GESTORES.BI_GetTiempoID(E.envio_fecha) AS id_tiempo_envio,
       F.factura_cliente AS id_cliente_envio,
       SUM(E.envio_importe_subida + E.envio_importe_traslado) AS COSTO,
       COUNT(*) AS TOTAL_ENVIOS,
       SUM(CASE WHEN DATEDIFF(DAY, E.envio_fecha_programada, E.envio_fecha) = 0 THEN 1 ELSE 0 END) AS ENVIOS_EN_FECHA
FROM LOS_GESTORES.Envio E
JOIN LOS_GESTORES.Factura F ON E.envio_factura = F.factura_numero
GROUP BY LOS_GESTORES.BI_GetTiempoID(E.envio_fecha), F.factura_cliente;
GO

PRINT 'Datos en tablas de hechos insertados.';
GO

PRINT '5. Creando vistas para consultas de negocio';
GO

-- 1. Ganancias
CREATE VIEW LOS_GESTORES.BI_V01_ganancias_mensuales_por_sucursal
AS
    SELECT T.ANIO, T.MES,F.ID_SUCURSAL, 
        ISNULL(F.TOTAL,0) - ISNULL(C.monto_total,0) GANANCIA
    FROM LOS_GESTORES.BI_tiempo T
    LEFT JOIN LOS_GESTORES.BI_HECHO_FACTURA F ON F.id_tiempo = T.id_tiempo
    LEFT JOIN LOS_GESTORES.BI_HECHO_COMPRA C ON C.ID_TIEMPO = T.ID_TIEMPO AND F.id_sucursal = C.ID_SUCURSAL;
GO

-- 2. Factura promedio mensual
CREATE VIEW LOS_GESTORES.BI_V02_factura_promedio_provincia_cuatrimestre
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
        ,LOS_GESTORES.BI_getCuatrimestre(T.MES);
GO

-- 3. Rendimiento de modelos
CREATE VIEW LOS_GESTORES.BI_V03_top_3_modelos_por_cuatrimestre_localidad_rango_etario
AS
    WITH ModeloVentas AS
    (
        SELECT
            T.ANIO,
            LOS_GESTORES.BI_getCuatrimestre(T.MES) AS CUATRIMESTRE,
            U.localidad,
            LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES) AS RANGO_ETAREO,
            MOD.modelo_nombre,
            SUM(HV.monto_total) AS TOTAL_VENTAS_MODELO,
            ROW_NUMBER() OVER (PARTITION BY T.ANIO, LOS_GESTORES.BI_getCuatrimestre(T.MES), U.localidad, LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES) ORDER BY SUM(HV.monto_total) DESC) AS rn
        FROM LOS_GESTORES.BI_HECHO_VENTA HV
        JOIN LOS_GESTORES.BI_tiempo T ON HV.id_tiempo = T.id_tiempo
        JOIN LOS_GESTORES.BI_cliente CL ON HV.id_cliente = CL.id_cliente
        JOIN LOS_GESTORES.BI_sucursal S ON HV.id_sucursal = S.id_sucursal
        JOIN LOS_GESTORES.BI_ubicacion U ON S.id_ubicacion = U.id_ubicacion
        JOIN LOS_GESTORES.BI_modelo MOD ON HV.id_modelo = MOD.id_modelo
        GROUP BY T.ANIO, LOS_GESTORES.BI_getCuatrimestre(T.MES), U.localidad, LOS_GESTORES.BI_getRangoEtario(CL.fecha_nacimiento, T.ANIO, T.MES), MOD.modelo_nombre
    )
    SELECT
        ANIO,
        CUATRIMESTRE,
        localidad,
        RANGO_ETAREO,
        modelo_nombre,
        TOTAL_VENTAS_MODELO
    FROM ModeloVentas
    WHERE rn <= 3;
GO

-- 4. Volumen de pedidos
CREATE VIEW LOS_GESTORES.BI_V04_volumen_pedidos_por_turno_sucursal_mes_anio
AS
SELECT ID_SUCURSAL
    ,T.ANIO
    ,T.MES
    ,TU.descripcion_turno
    ,SUM(CANTIDAD) CANTIDAD_PEDIDOS
FROM LOS_GESTORES.BI_HECHO_PEDIDO P
JOIN LOS_GESTORES.BI_TIEMPO T ON P.ID_TIEMPO = T.ID_TIEMPO 
JOIN LOS_GESTORES.BI_TURNO TU ON P.ID_TURNO = TU.ID_TURNO
GROUP BY ID_SUCURSAL
    ,T.ANIO
    ,T.MES
    ,TU.descripcion_turno;
GO

-- 5. Conversión de pedidos
CREATE VIEW LOS_GESTORES.BI_V05_conversion_pedidos_por_estado_cuatrimestre_sucursal
AS
    SELECT T.ANIO,
    LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES) CUATRIMESTRE,
    P.ID_SUCURSAL,
    E.Estado,
	100.0 * SUM(P.CANTIDAD) / -- Se agregó .0 para asegurar división decimal
	(SELECT SUM(P1.CANTIDAD) 
    FROM LOS_GESTORES.BI_HECHO_PEDIDO P1
    JOIN LOS_GESTORES.BI_TIEMPO T1 ON P1.ID_TIEMPO = T1.ID_TIEMPO
		WHERE  T1.ANIO = T.ANIO
		AND LOS_GESTORES.BI_GETCUATRIMESTRE(T1.MES)= LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES) 
		AND P1.ID_SUCURSAL = P.ID_SUCURSAL) PORCENTAJE
    FROM LOS_GESTORES.BI_HECHO_PEDIDO P
    JOIN LOS_GESTORES.BI_ESTADO_pedido E ON P.ID_Estado = E.ID_Estado
    JOIN LOS_GESTORES.BI_TIEMPO T ON P.ID_TIEMPO = T.ID_TIEMPO
    GROUP BY T.ANIO,
    LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES),
    P.ID_SUCURSAL,
    E.Estado;
GO

-- 6. Tiempo promedio de fabricación (Asegurado que esté en su propio batch)
CREATE VIEW LOS_GESTORES.BI_V06_tiempo_promedio_fabricacion_sucursal_cuatrimestre
AS
SELECT T.ANIO ,
LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES) CUATRIMESTRE,
SUM(dias_demora) / SUM(CANTIDAD_PEDIDOS) DIAS_PROMEDIO
FROM LOS_GESTORES.BI_HECHO_FABRICACION F
    JOIN LOS_GESTORES.BI_TIEMPO T ON F.ID_TIEMPO = T.ID_TIEMPO
GROUP BY 
T.ANIO ,
LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES);
GO

-- 7. Promedio de Compras (Asegurado que esté en su propio batch)
CREATE VIEW LOS_GESTORES.BI_V07_promedio_compras_mensual
AS
    SELECT T.ANIO,T.MES,
    SUM(monto_total) / SUM(CANTIDAD) PROMEDIO
    FROM LOS_GESTORES.BI_HECHO_COMPRA C
    JOIN LOS_GESTORES.BI_TIEMPO T ON C.ID_TIEMPO = T.ID_TIEMPO
    GROUP BY T.ANIO,T.MES;
GO

-- 8. Compras por Tipo de Material
CREATE VIEW LOS_GESTORES.BI_V08_compras_por_tipo_material_sucursal_cuatrimestre
AS
SELECT T.ANIO, 
 LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES) CUATRIMESTRE,
 C.ID_SUCURSAL,
 M.tipo_material,
 SUM(TOTAL_COMPRA) TOTAL_COMPRAS
FROM LOS_GESTORES.BI_HECHO_MATERIAL C
  JOIN LOS_GESTORES.BI_TIEMPO T ON C.ID_TIEMPO = T.ID_TIEMPO
  JOIN LOS_GESTORES.BI_MATERIAL M ON C.ID_material = M.ID_material
GROUP BY
T.ANIO, 
 LOS_GESTORES.BI_GETCUATRIMESTRE(T.MES),
 C.ID_SUCURSAL,
 M.tipo_material;
GO

-- 9. Porcentaje de cumplimiento de envíos en los tiempos programados por mes
CREATE VIEW LOS_GESTORES.BI_V09_porcentaje_cumplimiento_envios_mensual
AS
SELECT T.ANIO,T.MES,100.0 * SUM(ENVIOS_EN_FECHA) / SUM(TOTAL_ENVIOS) PORCENTAJE_CUMPLIMIENTO -- Se agregó .0 para asegurar división decimal
FROM LOS_GESTORES.BI_HECHO_ENVIO C
  JOIN LOS_GESTORES.BI_TIEMPO T ON C.ID_TIEMPO = T.ID_TIEMPO
  GROUP BY T.ANIO,T.MES;
GO

-- 10. Localidades que pagan mayor costo de envío
CREATE VIEW LOS_GESTORES.BI_V10_top_3_localidades_mayor_costo_envio
AS
SELECT TOP 3 U.localidad
FROM LOS_GESTORES.BI_HECHO_ENVIO E
JOIN LOS_GESTORES.BI_cliente C ON E.ID_CLIENTE = C.ID_CLIENTE
JOIN LOS_GESTORES.BI_ubicacion U ON C.id_ubicacion = U.id_ubicacion
GROUP BY U.localidad,U.id_ubicacion
ORDER BY SUM(E.COSTO)/SUM(TOTAL_ENVIOS) DESC;
GO

PRINT 'Vistas BI creadas.';
GO

PRINT 'Script de Modelo BI completado.';
GO
