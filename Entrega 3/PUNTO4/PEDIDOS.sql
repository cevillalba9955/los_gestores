SELECT
 pedido_sucursal
    ,LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    ,LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    ,LOS_GESTORES.BI_getTurnoVenta(pedido_fecha) 
, COUNT(*) CANTIDAD
--INTO BI.PEDIDOS

FROM LOS_GESTORES.Pedido
GROUP BY 
 pedido_sucursal
    ,LOS_GESTORES.BI_GetTiempoID(pedido_fecha)
    ,LOS_GESTORES.BI_getEstadoPedidoId(pedido_estado)
    ,LOS_GESTORES.BI_getTurnoVenta(pedido_fecha) 