--DROP TRIGGER LOS_GESTORES.DETALLE_COMPRA_BIU


CREATE TRIGGER LOS_GESTORES.DETALLE_COMPRA_BIU 
   ON LOS_GESTORES.DETALLE_COMPRA 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    -- Check if the foreign key constraint is violated
    IF NOT EXISTS (
        SELECT 1 FROM LOS_GESTORES.MATERIAL p
        JOIN inserted i ON p.MATERIAL_TIPO = I.DETALLE_COMPRA_TIPO
		 AND P.MATERIAL_ID = I.DETALLE_COMPRA_MATERIAL 
    )
    BEGIN
        RAISERROR ('Violación de clave foránea DETALLE_COMPRA_MATERIAL', 16, 1);
        ROLLBACK TRANSACTION;
    END


END
GO


-- Trigger para evitar eliminaciones en la tabla padre si hay referencias en la tabla hija
CREATE TRIGGER LOS_GESTORES.MADERA_AD
ON LOS_GESTORES.MADERA
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Madera'
		 and c.DETALLE_COMPRA_MATERIAL = d.madera_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque está referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER LOS_GESTORES.TELA_AD
ON LOS_GESTORES.TELA
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Tela'
		 and c.DETALLE_COMPRA_MATERIAL = d.tela_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque está referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER LOS_GESTORES.RELLENO_AD
ON LOS_GESTORES.RELLENO
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM LOS_GESTORES.DETALLE_COMPRA c
        JOIN deleted d ON c.DETALLE_COMPRA_TIPO = 'Relleno'
		 and c.DETALLE_COMPRA_MATERIAL = d.relleno_id
    )
    BEGIN
        RAISERROR ('No se puede eliminar el registro porque está referenciado en DETALLE_COMPRA', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
