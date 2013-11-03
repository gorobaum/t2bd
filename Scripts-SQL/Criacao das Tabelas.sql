USE [T2DB]
GO

/****** Object:  Table [dbo].[Moeda]    Script Date: 03-Nov-13 5:31:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Moeda](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Moeda] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [T2DB]
GO

/****** Object:  Table [dbo].[Taxa]    Script Date: 03-Nov-13 5:31:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Taxa](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Id_Moeda] [int] NOT NULL,
	[Valor] [float] NOT NULL,
	[Data] [date] NOT NULL,
 CONSTRAINT [PK_Taxa] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Taxa]  WITH CHECK ADD  CONSTRAINT [Taxa da Moeda] FOREIGN KEY([Id_Moeda])
REFERENCES [dbo].[Moeda] ([Id])
GO

ALTER TABLE [dbo].[Taxa] CHECK CONSTRAINT [Taxa da Moeda]
GO


USE [T2DB]
GO

/****** Object:  Table [dbo].[Cambio]    Script Date: 03-Nov-13 5:32:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cambio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Id_Origem] [int] NOT NULL,
	[Id_Destino] [int] NOT NULL,
 CONSTRAINT [PK_Cambio] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Cambio]  WITH CHECK ADD  CONSTRAINT [Taxa Destino] FOREIGN KEY([Id_Destino])
REFERENCES [dbo].[Taxa] ([Id])
GO

ALTER TABLE [dbo].[Cambio] CHECK CONSTRAINT [Taxa Destino]
GO

ALTER TABLE [dbo].[Cambio]  WITH CHECK ADD  CONSTRAINT [Taxa Origem] FOREIGN KEY([Id_Origem])
REFERENCES [dbo].[Taxa] ([Id])
GO

ALTER TABLE [dbo].[Cambio] CHECK CONSTRAINT [Taxa Origem]
GO


USE [T2DB]
GO

/****** Object:  Table [dbo].[Boleto]    Script Date: 03-Nov-13 5:32:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Boleto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [int] NOT NULL,
	[Data] [date] NOT NULL,
	[Valor] [float] NOT NULL,
	[Id_Cambio] [int] NOT NULL,
 CONSTRAINT [PK_Boleto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Boleto]  WITH CHECK ADD  CONSTRAINT [Camio do Boleto] FOREIGN KEY([Id_Cambio])
REFERENCES [dbo].[Cambio] ([Id])
GO

ALTER TABLE [dbo].[Boleto] CHECK CONSTRAINT [Camio do Boleto]
GO

