
CREATE PROCEDURE LOS_GESTORES.SP_PROVINCIA
AS
BEGIN
   -- SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.PROVINCIA (provincia_descripcion)
    SELECT DISTINCT Proveedor_Provincia 
		FROM gd_esquema.MAESTRA    
		WHERE Proveedor_Provincia IS NOT NULL
	union
    SELECT DISTINCT Cliente_Provincia 
		FROM gd_esquema.MAESTRA    
		WHERE Cliente_Provincia IS NOT NULL
	union
    SELECT DISTINCT Sucursal_Provincia 
		FROM gd_esquema.MAESTRA    
		WHERE Sucursal_Provincia IS NOT NULL
    ;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_LOCALIDAD
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.LOCALIDAD (localidad_descripcion, localidad_provincia)
        SELECT DISTINCT CLIENTE_LOCALIDAD,p.provincia_id 
			FROM gd_esquema.Maestra m
			JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.cliente_Provincia
			where CLIENTE_LOCALIDAD is not null
        UNION
        SELECT DISTINCT Proveedor_Localidad,p.provincia_id 
			FROM gd_esquema.Maestra m
			JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
			where Proveedor_Localidad is not null
        UNION
			SELECT DISTINCT Sucursal_Localidad,p.provincia_id 
			FROM gd_esquema.Maestra m
			JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Sucursal_Provincia
			where Sucursal_Localidad is not null;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SUCURSAL
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.SUCURSAL (
		sucursal_nroSucursal,
        sucursal_direccion,
        sucursal_localidad,
        sucursal_telefono,
        sucursal_mail
    )
    SELECT DISTINCT
		m.Sucursal_NroSucursal,
        m.Sucursal_Direccion,
        l.localidad_id,
        m.Sucursal_Telefono,
        m.Sucursal_Mail
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Sucursal_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Sucursal_Localidad
                                  AND l.localidad_provincia = p.provincia_id
    WHERE m.Sucursal_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.SUCURSAL s
          WHERE s.sucursal_direccion = m.Sucursal_Direccion
            AND s.sucursal_localidad = l.localidad_id
      );
END;
GO

/*************** MATERIALES *********************/
CREATE PROCEDURE LOS_GESTORES.SP_MADERA
AS
BEGIN
--	SET NOCOUNT ON;

INSERT INTO LOS_GESTORES.Madera
           (madera_nombre
		   ,madera_descripcion
		   ,madera_color
           ,madera_dureza
		   ,madera_precio
		   )
 SELECT distinct Material_Nombre,Material_Descripcion,MADERA_COLOR,MADERA_DUREZA,Material_Precio
	FROM gd_esquema.Maestra
	where Material_tipo = 'Madera'

END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_TELA
AS
BEGIN
--	SET NOCOUNT ON;
	INSERT INTO LOS_GESTORES.Tela
			   (tela_nombre
			   ,tela_descripcion
			   ,tela_color
			   ,tela_textura
			   ,tela_precio
			   )
	 SELECT distinct Material_Nombre,Material_Descripcion,Tela_Color,Tela_Textura,Material_Precio
		FROM gd_esquema.Maestra
		where Material_tipo = 'Tela'
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_RELLENO
AS
BEGIN
--	SET NOCOUNT ON;
	INSERT INTO LOS_GESTORES.Relleno (
		relleno_nombre
		,relleno_descripcion
		,relleno_densidad
		,relleno_precio
		)
	 SELECT distinct Material_Nombre,Material_Descripcion,Relleno_Densidad,Material_Precio
		FROM gd_esquema.Maestra
		where Material_tipo = 'Relleno'
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MEDIDA
AS
BEGIN
    --	SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.Sillon_Medida (
                sillon_medida_alto
            ,sillon_medida_ancho
            ,sillon_medida_profundidad
            ,sillon_medida_precio
            )
        SELECT distinct Sillon_Medida_Alto
            ,Sillon_Medida_Ancho
            ,Sillon_Medida_Profundidad
            ,Sillon_Medida_Precio
        FROM gd_esquema.Maestra
          where Sillon_Medida_Alto IS NOT NULL 
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MODELO
AS
BEGIN
--	SET NOCOUNT ON;

INSERT INTO LOS_GESTORES.Sillon_Modelo
           (sillon_modelo_codigo
           ,sillon_modelo
           ,sillon_modelo_descripcion
           ,sillon_modelo_precio)
    SELECT distinct
         Sillon_Modelo_Codigo
        ,Sillon_Modelo
        ,Sillon_Modelo_Descripcion
        ,Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
        where Sillon_Modelo_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON
AS
BEGIN
  SET NOCOUNT ON;

	INSERT INTO [LOS_GESTORES].[Sillon]
			   ([sillon_codigo]
			   ,[sillon_modelo_codigo]
			   ,[sillon_medida])
	SELECT Sillon_Codigo
		  ,[Sillon_Modelo_Codigo]
		  ,sm.sillon_medida_id
	  FROM [gd_esquema].[Maestra] m
	  join LOS_GESTORES.Sillon_Medida sm 
		on m.Sillon_Medida_Alto = sm.sillon_medida_alto 
		and m.Sillon_Medida_Ancho = sm.sillon_medida_ancho 
		and m.Sillon_Medida_Profundidad = sm.sillon_medida_profundidad 

	  where Sillon_Codigo is not null
	  group by Sillon_Codigo
		  ,[Sillon_Modelo_Codigo]
		  ,m.[Sillon_Medida_Alto]
		  ,m.[Sillon_Medida_Ancho]
		  ,m.[Sillon_Medida_Profundidad]
		  ,sm.sillon_medida_id
		  ,sm.[Sillon_Medida_Alto]
		  ,sm.[Sillon_Medida_Ancho]
		  ,sm.[Sillon_Medida_Profundidad]


	UPDATE t1
	SET t1.sillon_madera = t2.madera_id
	FROM LOS_GESTORES.sillon t1
	JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Madera' and m.Sillon_Codigo = t1.sillon_codigo 
	JOIN LOS_GESTORES.madera t2 on m.Material_Nombre = t2.madera_nombre

	UPDATE t1
	SET t1.sillon_tela = t2.tela_id
	FROM LOS_GESTORES.sillon t1
	JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Tela' and m.Sillon_Codigo = t1.sillon_codigo 
	JOIN LOS_GESTORES.tela t2 on m.Material_Nombre = t2.tela_nombre

	UPDATE t1
	SET t1.sillon_relleno = t2.relleno_id
	FROM LOS_GESTORES.sillon t1
	JOIN gd_esquema.Maestra	m on m.Material_Tipo = 'Relleno' and m.Sillon_Codigo = t1.sillon_codigo 
	JOIN LOS_GESTORES.relleno t2 on m.Material_Nombre = t2.relleno_nombre
	END;
GO



/************* compras ********************/

CREATE PROCEDURE LOS_GESTORES.SP_PROVEEDOR
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.PROVEEDOR (
        proveedor_cuit,
        proveedor_localidad,
        proveedor_razonSocial,
        proveedor_direccion,
        proveedor_telefono,
        proveedor_mail
    )
    SELECT DISTINCT
        m.Proveedor_CUIT,
        l.localidad_id,
        m.Proveedor_RazonSocial,
        m.Proveedor_Direccion,
        m.Proveedor_Telefono,
        m.Proveedor_Mail
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Proveedor_Localidad
                                   AND l.localidad_provincia = p.provincia_id
    WHERE m.Proveedor_CUIT IS NOT NULL
	;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_COMPRA
AS
BEGIN
--	SET NOCOUNT ON;
	INSERT INTO LOS_GESTORES.Compra (
		compra_numero,
		compra_proveedor, 
		compra_sucursal,
		compra_fecha,
		compra_total
	)
	SELECT DISTINCT
		m.Compra_Numero,
		pr.proveedor_id,
		s.sucursal_nroSucursal,
		m.Compra_Fecha,
		m.Compra_Total
	FROM gd_esquema.Maestra m
	JOIN LOS_GESTORES.Proveedor pr ON pr.proveedor_cuit = m.Proveedor_Cuit
	JOIN LOS_GESTORES.Sucursal s ON s.sucursal_nroSucursal = m.Sucursal_NroSucursal
	WHERE m.Compra_Numero IS NOT NULL

END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_COMPRA
AS
BEGIN


SELECT 
      m.[Compra_Numero]
	  ,m.Material_Tipo
	  ,ma.material_id
      ,m.[Detalle_Compra_Precio]
      ,m.[Detalle_Compra_Cantidad] 
  FROM [GD1C2025].[gd_esquema].[Maestra] m
  join LOS_GESTORES.material ma on m.Material_Nombre = ma.material_nombre 
	and m.Material_Tipo = ma.material_tipo
   where m.COMPRA_NUMERO IS NOT NULL

--	SET NOCOUNT ON;
END;
GO



/*


/**************** pedidos ************/

CREATE PROCEDURE LOS_GESTORES.SP_CLIENTE
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.CLIENTE (
        cliente_dni,
        cliente_nombre,
        cliente_apellido,
        cliente_fechaNacimiento,
        cliente_mail,
        cliente_direccion,
        cliente_telefono,
        cliente_localidad
    )
    SELECT DISTINCT
        m.Cliente_DNI,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_FechaNacimiento,
        m.Cliente_Mail,
        m.Cliente_Direccion,
        m.Cliente_Telefono,
        l.localidad_id
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Cliente_Provincia
    JOIN LOS_GESTORES.LOCALIDAD l ON l.localidad_descripcion = m.Cliente_Localidad
                                   AND l.localidad_provincia = p.provincia_id
    WHERE m.Cliente_Nombre IS NOT NULL
      AND m.Cliente_Apellido IS NOT NULL
      AND m.Cliente_DNI IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.CLIENTE c
          WHERE c.cliente_dni = m.Cliente_DNI
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_PEDIDO
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_PEDIDO
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_FACTURA
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_FACTURA
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO


CREATE PROCEDURE LOS_GESTORES.SP_ENVIO
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO
*/





