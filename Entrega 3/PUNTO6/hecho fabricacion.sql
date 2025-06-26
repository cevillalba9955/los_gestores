CREATE TABLE BI.HECHOS_FABRICACION (
    id_fabricacion INT IDENTITY PRIMARY KEY,
    pedido_numero INT,
    sucursal_id INT,
    fecha_pedido DATE,
    fecha_factura DATE,
    dias_demora INT,
    FOREIGN KEY (pedido_numero) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id)
);


INSERT INTO BI.HECHOS_FABRICACION (
    pedido_numero, sucursal_id, fecha_pedido, fecha_factura, dias_demora
)
SELECT 
    p.pedido_numero,
    p.pedido_sucursal,
    p.pedido_fecha,
    f.factura_fecha,
    DATEDIFF(DAY, p.pedido_fecha, f.factura_fecha) AS dias_demora
FROM 
    Pedido p
JOIN 
    Factura f ON f.factura_pedido = p.pedido_numero
WHERE 
    f.factura_fecha IS NOT NULL AND p.pedido_fecha IS NOT NULL;


CREATE VIEW BI.V_TIEMPO_FABRICACION AS
SELECT 
    p.pedido_sucursal,
    BI.getCuatrimestre(p.pedido_fecha) AS CUATRIMESTRE,
    AVG(DATEDIFF(DAY, p.pedido_fecha, f.factura_fecha)) AS DIAS_DEMORA
FROM LOS_GESTORES.Pedido p
JOIN LOS_GESTORES.Factura f ON p.pedido_numero = f.factura_pedido
GROUP BY 
    p.pedido_sucursal,
    BI.getCuatrimestre(p.pedido_fecha);

