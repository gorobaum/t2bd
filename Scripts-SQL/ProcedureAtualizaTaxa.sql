USE [T2DB]
GO
/****** Object:  StoredProcedure [dbo].[AtualizaTaxa]    Script Date: 04-Nov-13 9:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery3.sql|15|0|C:\Users\Gabriel\AppData\Local\Temp\~vs6320.sql
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AtualizaTaxa]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

    -- Inset statements for procedure here

	-- Declarando variável para colocar a taxa da moeda
	DECLARE @currency VARCHAR(50);

	-- Inicializando o cursor para verificar cada moeda a ser atualizada
	DECLARE CursorMoeda CURSOR FOR
		SELECT [Nome]
		FROM [dbo].[Moeda]
		OPEN CursorMoeda;
		FETCH NEXT FROM CursorMoeda into @currency;
		WHILE @@FETCH_STATUS = 0
		   BEGIN

			-- Realizando a busca pela taxa da moeda
			DECLARE @URL VARCHAR(8000) 
			SELECT @URL = 'http://trabalho2db.azurewebsites.net/Currency/Get?exchangeRate=' + @currency	-- This works

			Declare @Object as Int; 
			Declare @ResponseText as Varchar(8000); 

			-- Pegando a taxa da moeda
			Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT; 
			Exec sp_OAMethod @Object, 'open', NULL, 'get', @Url, 'false' 
			Exec sp_OAMethod @Object, 'send' 
			Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT      
			Exec sp_OADestroy @Object 

			-- Convertendo o valor que está em string em float
			Declare @FloatResponse as float; 
			select @FloatResponse = CAST(@ResponseText as float);
			
			DECLARE @IntMoeda as Int; 
			SELECT @IntMoeda = (SELECT [Id]
								FROM [dbo].[Moeda]
								WHERE [Nome] = @currency);

			-- Realizando a atualização das novas taxa na tabela	
			INSERT INTO [dbo].[Taxa]
			   ([Id_Moeda]
			   ,[Valor]
			   ,[Data])
				 VALUES
				(@IntMoeda
				,@FloatResponse
				,SYSDATETIME());
		
			-- Indo para próxima taxa
			FETCH NEXT FROM CursorMoeda into @currency;
		   END
		CLOSE CursorMoeda;
		DEALLOCATE CursorMoeda;

END
