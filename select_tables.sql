/******** LOCALIDAD PROVINCIA SUCURSAL *********/
select * from LOS_GESTORES.Provincia

select * from LOS_GESTORES.Localidad
join LOS_GESTORES.Provincia on localidad_provincia = provincia_id

select * from LOS_GESTORES.Sucursal
join LOS_GESTORES.Localidad on sucursal_localidad = localidad_id
join LOS_GESTORES.Provincia on localidad_provincia = provincia_id
order by sucursal_nroSucursal

select distinct Sucursal_NroSucursal,Sucursal_Direccion,Sucursal_Localidad,Sucursal_Provincia from gd_esquema.Maestra
order by sucursal_nroSucursal

/****************** sillon **************** */ 
select * from LOS_GESTORES.Sillon_Medida;

SELECT distinct Sillon_Medida_Alto
    ,Sillon_Medida_Ancho
    ,Sillon_Medida_Profundidad
    ,Sillon_Medida_Precio
FROM gd_esquema.Maestra
    where Sillon_Medida_Alto IS NOT NULL 


select * from gd_esquema.Maestra

