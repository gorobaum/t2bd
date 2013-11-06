USE [T2DB]
GO
/****** Object:  StoredProcedure [dbo].[VerificaBoletosCanceladosEProcessados]    Script Date: 06-Nov-13 6:20:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery8.sql|7|0|C:\Users\Caio\AppData\Local\Temp\~vsBAF8.sql
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VerificaBoletosCanceladosEProcessados]
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
		WHERE ((SELECT DATEDIFF ( DAY , [Data] , SYSDATETIME() )) <= 2) AND [Status] = 0 AND [Pago] = 1 
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
		WHERE ((SELECT DATEDIFF ( DAY , [Data] , SYSDATETIME() )) > 2) AND [Status] = 0 AND [Pago] = 0 
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

EXEC dbo.VerificaBoletosCanceladosEProcessados