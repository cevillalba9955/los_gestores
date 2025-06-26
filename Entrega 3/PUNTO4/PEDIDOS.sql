SELECT YEAR(PEDIDO_FECHA) ANIO
,MONTH(PEDIDO_FECHA) MES
,pedido_sucursal
,BI.getTurnoVenta(pedido_fecha) TURNOVENTA
,pedido_estado
,COUNT(*) CANTIDAD
INTO BI.PEDIDOS

FROM LOS_GESTORES.Pedido
GROUP BY YEAR(PEDIDO_FECHA) 
,MONTH(PEDIDO_FECHA) 
,pedido_sucursal
,BI.getTurnoVenta(pedido_fecha) 
,pedido_estado