SELECT ANIO,MES , SUM(TOTAL)/SUM(CANTIDAD) PROMEDIO_MENSUAL 
FROM BI.COMPRAS 
GROUP BY ANIO,MES