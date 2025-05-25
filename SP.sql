CREATE PROCEDURE LOS_GESTORES.SP_PROVINCIA
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO LOS_GESTORES.PROVINCIA (provincia_descripcion)
    SELECT DISTINCT Proveedor_Provincia
    FROM gd_esquema.MAESTRA
    WHERE Proveedor_Provincia IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM LOS_GESTORES.PROVINCIA p
          WHERE p.provincia_descripcion = MAESTRA.Proveedor_Provincia
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_LOCALIDAD
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_GESTORES.LOCALIDAD (localidad_descripcion, localidad_provincia)
    SELECT DISTINCT
        m.Proveedor_Localidad,
        p.provincia_id
    FROM gd_esquema.MAESTRA m
    JOIN LOS_GESTORES.PROVINCIA p ON p.provincia_descripcion = m.Proveedor_Provincia
    WHERE m.Proveedor_Localidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM LOS_GESTORES.LOCALIDAD l
          WHERE l.localidad_descripcion = m.Proveedor_Localidad
            AND l.localidad_provincia = p.provincia_id
      );
END;
GO

CREATE PROCEDURE LOS_GESTORES.SP_CLIENTE
AS
BEGIN
    SET NOCOUNT ON;

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


CREATE PROCEDURE LOS_GESTORES.SP_SUCURSAL
AS
BEGIN
    SET NOCOUNT ON;

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
    SET NOCOUNT ON;

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

