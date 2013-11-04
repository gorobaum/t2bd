-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER TriggerColocarOValorCertoParaMoedaDestino 
   ON  [T2Db].[dbo].[Boleto]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @IdCambio AS INT;
	DECLARE @IdBoleto AS INT;
	DECLARE @IdMoedaOrigem AS INT;
	DECLARE @EmAnalise AS VARCHAR(50);
	DECLARE @ValorMoeda AS FLOAT;
	DECLARE @Taxa AS FLOAT;

	SELECT @IdCambio = INSERTED.Id_Cambio FROM INSERTED;
	SELECT @IdBoleto = INSERTED.Id FROM INSERTED;
	SELECT @ValorMoeda = INSERTED.ValorCompra FROM INSERTED;

	SELECT @EmAnalise = 0;

	SELECT @IdMoedaOrigem = (SELECT TOP 1 [Id_Origem]
							FROM [T2DB].[dbo].[Cambio]
							WHERE [Id] = @IdCambio);

	SELECT @Taxa = 	(SELECT TOP 1 [Valor]
					  FROM [T2DB].[dbo].[Taxa]
					  WHERE [Id_Moeda] = @IdMoedaOrigem
					  ORDER BY Id DESC);

	UPDATE [T2DB].[dbo].[Boleto]
	   SET [Status] = @EmAnalise
		  ,[Data] = GETDATE()
		  ,[ValorMoedaDestino] = @ValorMoeda * @Taxa
	 WHERE [Id] = @IdBoleto

	 
END
GO
