SELECT TOP 3 CLIENTE_LOCALIDAD 

FROM BI.ENVIOS
GROUP BY CLIENTE_LOCALIDAD
ORDER BY SUM(COSTO)/SUM(TOTAL_ENVIOS) DESC