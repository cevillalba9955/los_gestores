SELECT PEDIDO_SUCURSAL
,BI.getCuatrimestre(pedido_fecha) CUATRIMESTRE
,AVG(DATEDIFF(DAY, pedido_fecha,factura_fecha)) DIAS_DEMORA
INTO BI.FABRICACION
FROM LOS_GESTORES.Pedido
JOIN LOS_GESTORES.Factura ON pedido_sucursal+pedido_numero = FACTURA_SUCURSAL+factura_pedido
GROUP BY pedido_sucursal,BI.getCuatrimestre(pedido_fecha)
ORDER BY 1,2


