USE [T2DB]
GO
/****** Object:  StoredProcedure [dbo].[GeraCambioAposAtualizacaoDetTaxa]    Script Date: 04-Nov-13 9:09:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GeraCambioAposAtualizacaoDeTaxa]
AS
BEGIN

DECLARE @moeda_origem AS INT;
DECLARE @moeda_destino AS INT;
DECLARE @taxa_moeda_origem AS INT;
DECLARE @taxa_moeda_destino AS INT;

DECLARE Cursor1 CURSOR FOR
  SELECT [Id]
  FROM [T2DB].[dbo].[Moeda]
  OPEN Cursor1
  FETCH NEXT FROM Cursor1 into @moeda_origem;
  WHILE @@FETCH_STATUS = 0
	BEGIN
		--SELECT @moeda_origem
		SELECT @taxa_moeda_origem = (SELECT TOP 1 [Id] FROM [T2DB].[dbo].[Taxa]
		WHERE(Id_Moeda = @moeda_origem)
		ORDER BY Data DESC)


		DECLARE Cursor2 CURSOR FOR
		SELECT [Id]
		FROM [T2DB].[dbo].[Moeda]
		OPEN Cursor2
		FETCH NEXT FROM Cursor2 into @moeda_destino;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--SELECT @moeda_destino
				SELECT @taxa_moeda_destino = (SELECT TOP 1 [Id] FROM [T2DB].[dbo].[Taxa]
				WHERE(Id_Moeda = @moeda_destino)
				ORDER BY Data DESC)
				INSERT INTO [T2DB].[dbo].[Cambio]
					([Id_origem]
					,[Id_Destino])
					 VALUES
					(@taxa_moeda_origem
					,@taxa_moeda_destino);
					--SELECT @taxa_moeda_oarigem, @taxa_moeda_destino

				FETCH NEXT FROM Cursor2 into @moeda_destino
			END
		CLOSE Cursor2
		DEALLOCATE Cursor2

		FETCH NEXT FROM Cursor1 into @moeda_origem
	END
	CLOSE Cursor1
	DEALLOCATE Cursor1

END
