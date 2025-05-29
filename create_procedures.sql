
CREATE PROCEDURE LOS_GESTORES.SP_PROVINCIA
AS
BEGIN
   -- SET NOCOUNT ON;
    INSERT INTO LOS_GESTORES.PROVINCIA (provincia_descripcion)
    SELECT DISTINCT Proveedor_Provincia    FROM gd_esquema.MAESTRA    WHERE Proveedor_Provincia IS NOT NULL
	union
    SELECT DISTINCT Cliente_Provincia    FROM gd_esquema.MAESTRA    WHERE Cliente_Provincia IS NOT NULL
	union
    SELECT DISTINCT Sucursal_Provincia    FROM gd_esquema.MAESTRA    WHERE Sucursal_Provincia IS NOT NULL
    ;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_LOCALIDAD
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.LOCALIDAD (localidad_descripcion, localidad_provincia)
        SELECT DISTINCT CLIENTE_LOCALIDAD,p.provincia_id FROM gd_esquema.Maestra m
        JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.cliente_Provincia
        where CLIENTE_LOCALIDAD is not null
        UNION
        SELECT DISTINCT Proveedor_Localidad,p.provincia_id FROM gd_esquema.Maestra m
        JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
        where Proveedor_Localidad is not null
        UNION
        SELECT DISTINCT Sucursal_Localidad,p.provincia_id FROM gd_esquema.Maestra m
        JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Sucursal_Provincia
        where Sucursal_Localidad is not null;
END;
GO

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


CREATE PROCEDURE LOS_GESTORES.SP_SUCURSAL
AS
BEGIN
   -- SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.SUCURSAL (
        sucursal_direccion,
        sucursal_localidad,
        sucursal_telefono,
        sucursal_mail
    )
    SELECT DISTINCT
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
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.PROVEEDOR pr
          WHERE pr.proveedor_cuit = m.Proveedor_CUIT
      );
END;
GO


/*
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
*/

CREATE PROCEDURE LOS_GESTORES.SP_COMPRA
AS
BEGIN
--	SET NOCOUNT ON;
	INSERT INTO LOS_GESTORES.Compra (
		compra_numero,
		compra_proveedor_id, 
		compra_sucursal_nroSucursal,
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
	JOIN LOS_GESTORES.Provincia p ON p.provincia_descripcion = m.Sucursal_Provincia
	JOIN LOS_GESTORES.Localidad l ON l.localidad_descripcion = m.Sucursal_Localidad
		AND l.localidad_provincia = p.provincia_id
	JOIN LOS_GESTORES.Sucursal s ON s.sucursal_direccion = m.Sucursal_Direccion
		AND s.sucursal_localidad = l.localidad_id
	WHERE m.Compra_Numero IS NOT NULL
		AND m.Proveedor_Cuit IS NOT NULL
		AND m.Sucursal_Direccion IS NOT NULL
		AND NOT EXISTS (
			SELECT 1
			FROM LOS_GESTORES.Compra c
			WHERE c.compra_numero = m.Compra_Numero
		);
END;
GO
/*
CREATE PROCEDURE LOS_GESTORES.SP_DETALLE_COMPRA
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

CREATE PROCEDURE LOS_GESTORES.SP_SILLON
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MEDIDA
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_SILLON_MODELO
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_MATERIAL
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_MADERA
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_TELA
AS
BEGIN
--	SET NOCOUNT ON;
END;
GO
*/

CREATE PROCEDURE LOS_GESTORES.SP_RELLENO
AS
BEGIN
--	SET NOCOUNT ON;
	INSERT INTO LOS_GESTORES.Relleno (relleno_densidad)
	SELECT DISTINCT Relleno_Densidad
	FROM gd_esquema.Maestra
	WHERE Relleno_Densidad IS NOT NULL
		AND NOT EXISTS (
			SELECT 1
			FROM LOS_GESTORES.Relleno r
			WHERE r.relleno_densidad = Maestra.Relleno_Densidad
		);
END;
GO
