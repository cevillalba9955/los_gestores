 SELECT COMPRA_SUCURSAL SUCURSAL
	,YEAR(COMPRA_FECHA) ANIO
	,MONTH(COMPRA_FECHA) MES
	,material_tipo
	,SUM(detalle_compra_cantidad* detalle_compra_precio) TOTAL
INTO BI.MATERIAL
 FROM LOS_GESTORES.COMPRA
 JOIN LOS_GESTORES.Detalle_Compra ON COMPRA.compra_numero = detalle_compra_numero
 JOIN LOS_GESTORES.Material ON detalle_compra_material = material_id
 GROUP BY
	 COMPRA_SUCURSAL
	,YEAR(COMPRA_FECHA)
	,MONTH(COMPRA_FECHA)
	,material_tipo

	GO 

