SELECT	YEAR(ENVIO_FECHA) ANIO 
	,MONTH(ENVIO_FECHA) MES
	,cliente_localidad
	,SUM(envio_importe_subida + envio_importe_traslado) COSTO
	,COUNT(*) TOTAL_ENVIOS,
	(SELECT COUNT(*) FROM  LOS_GESTORES.Envio
	JOIN LOS_GESTORES.Factura ON envio_factura = factura_numero
	JOIN LOS_GESTORES.CLIENTE  ON factura_cliente = cliente_id
	WHERE YEAR(ENVIO_FECHA) = YEAR(T1.ENVIO_FECHA)
	AND MONTH(ENVIO_FECHA) = MONTH(T1.ENVIO_FECHA)
	and cliente_localidad = C1.cliente_localidad
	AND DATEDIFF(DAY,envio_fecha_programada,envio_fecha) = 0 ) ENVIOS_EN_FECHA

	INTO BI.ENVIOS
FROM LOS_GESTORES.Envio T1
JOIN LOS_GESTORES.Factura F1 ON envio_factura = factura_numero
JOIN LOS_GESTORES.CLIENTE C1 ON factura_cliente = cliente_id
GROUP BY 
YEAR(ENVIO_FECHA)
,MONTH(ENVIO_FECHA)
,cliente_localidad

