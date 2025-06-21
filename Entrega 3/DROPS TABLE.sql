IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'BI')
    EXEC('CREATE SCHEMA BI;');
GO

IF OBJECT_ID('BI.dm_ubicacion', 'U') IS NOT NULL
    DROP TABLE BI.dm_ubicacion;
GO

IF OBJECT_ID('BI.dm_cliente', 'U') IS NOT NULL
    DROP TABLE BI.dm_cliente;
GO

IF OBJECT_ID('BI.dm_proveedor', 'U') IS NOT NULL
    DROP TABLE BI.dm_proveedor;
GO

IF OBJECT_ID('BI.dm_sucursal', 'U') IS NOT NULL
    DROP TABLE BI.dm_sucursal;
GO

IF OBJECT_ID('BI.dm_tiempo', 'U') IS NOT NULL
    DROP TABLE BI.dm_tiempo;
GO


IF OBJECT_ID('BI.dm_turno', 'U') IS NOT NULL
    DROP TABLE BI.dm_turno;
GO


IF OBJECT_ID('BI.dm_estado_pedido', 'U') IS NOT NULL
    DROP TABLE BI.dm_estado_pedido;
GO

IF OBJECT_ID('BI.dm_material', 'U') IS NOT NULL
    DROP TABLE BI.dm_material;
GO

DROP TABLE BI.ft_envio;
DROP TABLE BI.ft_pedido;
DROP TABLE BI.ft_factura;
DROP TABLE BI.ft_compra;

DROP FUNCTION BI.getCuatrimestre;
DROP FUNCTION BI.getRangoEtario;
DROP FUNCTION BI.getTurnoVenta;