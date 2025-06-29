CREATE VIEW BI.PUNTO2 AS 
SELECT PROVINCIA_ID
	,PROVINCIA_DESCRIPCION
	,ANIO
	,FLOOR((F.MES+3)/4) CUATRIMESTRE
	,FLOOR(AVG(TOTAL)) PROMEDIO
	,SUM(TOTAL) /
	(SELECT SUM(TOTAL) FROM BI.FACTURACION WHERE ANIO = F.ANIO AND FLOOR((MES+3)/4) = FLOOR((F.MES+3)/4)) *100 PORCENTAJE_DEL_PERIODO
FROM BI.FACTURACION F
JOIN BI.SUCURSAL ON SUCURSAL = SUCURSAL_NRO
GROUP BY PROVINCIA_ID
	,PROVINCIA_DESCRIPCION
	,ANIO
	,FLOOR((F.MES+3)/4) 

