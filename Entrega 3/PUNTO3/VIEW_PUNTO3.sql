CREATE VIEW BI.PUNTO3 AS
SELECT ANIO
	,CUATRIMESTRE
	,RANGO_ETAREO
	,SUCURSAL_LOCALIDAD
	,BI.getModeloTopVentas (anio,CUATRIMESTRE,RANGO_ETAREO,SUCURSAL_LOCALIDAD,1) TOP1
	,BI.getModeloTopVentas (anio,CUATRIMESTRE,RANGO_ETAREO,SUCURSAL_LOCALIDAD,2) TOP2
	,BI.getModeloTopVentas (anio,CUATRIMESTRE,RANGO_ETAREO,SUCURSAL_LOCALIDAD,3) TOP3
	
	FROM BI.VENTAS_POR_MODELO VM
GROUP BY 
	ANIO
	,CUATRIMESTRE
	,RANGO_ETAREO
	,SUCURSAL_LOCALIDAD



