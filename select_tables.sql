
select * from LOS_GESTORES.Provincia

select * from LOS_GESTORES.Localidad
join LOS_GESTORES.Provincia on localidad_provincia = provincia_id
order by provincia_id,localidad_id





