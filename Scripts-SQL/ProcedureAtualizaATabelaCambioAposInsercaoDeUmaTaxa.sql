USE [T2DB]
GO
/****** Object:  Trigger [dbo].[AtualizaATabelaCambioAposInsercaoDeUmaTaxa]    Script Date: 04/11/2013 01:08:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[AtualizaATabelaCambioAposInsercaoDeUmaTaxa]
   ON  [dbo].[Taxa]
   AFTER INSERT 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @IdMoeda AS INT;
	DECLARE @IdMoedaBRL AS INT;
	SELECT @IdMoeda = INSERTED.Id_Moeda FROM INSERTED
	SELECT @IdMoedaBRL = (SELECT [Id] FROM [T2DB].[dbo].[Moeda] WHERE [Nome] = 'BRL');


	INSERT INTO [dbo].[Cambio]
				([Id_Origem]
				,[Id_Destino])
			VALUES
				(@IdMoeda
				,@IdMoedaBRL)
END
