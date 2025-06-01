/*
DROP VIEW LOS_GESTORES.Material
*/

Create View Los_gestores.Material as 
select 'Madera' Material_tipo
	,madera_id Material_id
	,madera_nombre Material_nombre
	,madera_descripcion Material_descripcion
	,madera_precio Material_precio
from LOS_GESTORES.Madera
union
select 'Tela' Material_tipo
	,tela_id Material_id
	,tela_nombre Material_nombre
	,tela_descripcion Material_descripcion
	,tela_precio Material_precio
from LOS_GESTORES.Tela
union
select 'Relleno' Material_tipo
	,relleno_id Material_id
	,relleno_nombre Material_nombre
	,relleno_descripcion Material_descripcion
	,relleno_precio Material_precio
from LOS_GESTORES.Relleno



