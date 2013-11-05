USE [T2DB]
GO
/****** Object:  Trigger [dbo].[ValoresCertosParaNovoBoleto]    Script Date: 05-Nov-13 12:21:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[ValoresCertosParaNovoBoleto] 
   ON  [T2DB].[dbo].[Boleto]
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
	DECLARE @IdMoedaDestino AS INT;
	DECLARE @EmAnalise AS VARCHAR(50);
	DECLARE @NaoPago AS BIT;
	DECLARE @ValorMoeda AS FLOAT;
	DECLARE @TaxaOrigem AS FLOAT;
	DECLARE @TaxaDestino AS FLOAT;

	SELECT @IdCambio = INSERTED.Id_Cambio FROM INSERTED;
	SELECT @IdBoleto = INSERTED.Id FROM INSERTED;
	SELECT @ValorMoeda = INSERTED.ValorMoedaDestino FROM INSERTED;

	SELECT @EmAnalise = 0;
	SELECT @NaoPago = 0;

	SELECT @IdMoedaOrigem = (SELECT TOP 1 [Id_Origem]
							FROM [T2DB].[dbo].[Cambio]
							WHERE [Id] = @IdCambio);

	SELECT @IdMoedaDestino = (SELECT TOP 1 [Id_Destino]
							FROM [T2DB].[dbo].[Cambio]
							WHERE [Id] = @IdCambio);

	SELECT @TaxaOrigem = (SELECT TOP 1 [Valor]
						FROM [T2DB].[dbo].[Taxa]
						WHERE [Id] = @IdMoedaOrigem);

	SELECT @TaxaDestino = (SELECT TOP 1 [Valor]
						FROM [T2DB].[dbo].[Taxa]
						WHERE [Id] = @IdMoedaDestino);



	UPDATE [T2DB].[dbo].[Boleto]
	   SET [Status] = @EmAnalise
		  ,[Data] = SYSDATETIME()
		  ,[ValorCompra] = (@ValorMoeda*(@TaxaDestino/@TaxaOrigem))
		  ,[Pago] = @NaoPago
	 WHERE [Id] = @IdBoleto


END
