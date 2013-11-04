-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE VerificaBoletosCanceladosEProcessadosParaPagamentosEmAte2Dias
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @IdBoleto AS INT;
	-- Inicializando o cursor para verificar cada boleto a ser atualizado para Status 1 ( Processado )
	DECLARE CursorBoletosProcessados CURSOR FOR
		SELECT [Id]
		FROM [dbo].[Boleto]
		WHERE ((SELECT DATEDIFF ( DAY , [Data] , GETDATE() )) <= 2) AND [Status] = 0 AND [Pago] = 1 
		OPEN CursorBoletosProcessados;
		FETCH NEXT FROM CursorBoletosProcessados into @IdBoleto;
		WHILE @@FETCH_STATUS = 0
		   BEGIN

		   	UPDATE [dbo].[Boleto]
			   SET [Status] = 1
			 WHERE [Id] = @IdBoleto					
			
			-- Indo para próximo boleto
			FETCH NEXT FROM CursorBoletosProcessados into @IdBoleto;
		   END
		CLOSE CursorBoletosProcessados;
		DEALLOCATE CursorBoletosProcessados;


		
	-- Inicializando o cursor para verificar cada boleto a ser atualizado para Status 2 ( Cancelado )
	DECLARE CursorBoletosCancelados CURSOR FOR
		SELECT [Id]
		FROM [dbo].[Boleto]
		WHERE ((SELECT DATEDIFF ( DAY , [Data] , GETDATE() )) > 2) AND [Status] = 0 AND [Pago] = 0 
		OPEN CursorBoletosCancelados;
		FETCH NEXT FROM CursorBoletosCancelados into @IdBoleto;
		WHILE @@FETCH_STATUS = 0
		   BEGIN

		   	UPDATE [dbo].[Boleto]
			   SET [Status] = 2
			 WHERE [Id] = @IdBoleto					
			
			-- Indo para próximo boleto
			FETCH NEXT FROM CursorBoletosCancelados into @IdBoleto;
		   END
		CLOSE CursorBoletosCancelados;
		DEALLOCATE CursorBoletosCancelados;

END
GO
