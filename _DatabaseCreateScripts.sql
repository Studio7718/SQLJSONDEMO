
-- ***** show *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[show](
	[showId] [bigint] NOT NULL,
	[title] [varchar](1024) NULL,
	[description] [varchar](max) NULL,
	[type] [varchar](50) NULL,
	[releaseYear] [int] NULL,
	[rating] [varchar](16) NULL,
	[durationMinutes] [int] NULL,
	[durationSeasons] [smallint] NULL,
	[dateAdded] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[show] ADD  CONSTRAINT [PK_show] PRIMARY KEY CLUSTERED 
(
	[showId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** show_cast *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[show_cast](
	[showId] [bigint] NOT NULL,
	[cast] [nvarchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[show_cast] ADD  CONSTRAINT [PK_show_cast] PRIMARY KEY CLUSTERED 
(
	[showId] ASC,
	[cast] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** show_category *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[show_category](
	[showId] [bigint] NOT NULL,
	[listed_in] [varchar](128) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[show_category] ADD  CONSTRAINT [PK_show_category] PRIMARY KEY CLUSTERED 
(
	[showId] ASC,
	[listed_in] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** show_country *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[show_country](
	[showId] [bigint] NOT NULL,
	[country] [varchar](128) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[show_country] ADD  CONSTRAINT [PK_show_country] PRIMARY KEY CLUSTERED 
(
	[showId] ASC,
	[country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** show_director *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[show_director](
	[showId] [bigint] NOT NULL,
	[director] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[show_director] ADD  CONSTRAINT [PK_show_director] PRIMARY KEY CLUSTERED 
(
	[showId] ASC,
	[director] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** storedJSON *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[storedJSON](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[jsonValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[storedJSON] ADD  CONSTRAINT [PK_storedJSON] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** temp_show *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_show](
	[showId] [bigint] NOT NULL,
	[title] [varchar](1024) NULL,
	[description] [varchar](max) NULL,
	[type] [varchar](50) NULL,
	[releaseYear] [bigint] NULL,
	[rating] [varchar](32) NULL,
	[durationMinutes] [varchar](22) NULL,
	[durationSeasons] [varchar](50) NULL,
	[dateAdded] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_show] ADD  CONSTRAINT [PK_temp_show] PRIMARY KEY CLUSTERED 
(
	[showId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- ***** Slugify *****
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Slugify](@str nvarchar(max)) returns nvarchar(max) as
begin
    declare @IncorrectCharLoc int
    set @str = replace(replace(lower(@str),'.','-'),'''','')

    -- remove non alphanumerics:
    set @IncorrectCharLoc = patindex('%[^0-9a-z -]%',@str)
    while @IncorrectCharLoc > 0
    begin
        set @str = stuff(@str,@incorrectCharLoc,1,' ')
        set @IncorrectCharLoc = patindex('%[^0-9a-z -]%',@str)
    end

    -- replace all spaces with dashes
    set @str = replace(@str,' ','-')

    -- remove consecutive dashes:
    while charindex('--',@str) > 0
    begin
        set @str = replace(@str, '--', '-')
    end

    -- remove leading dashes
    while charindex('-', @str) = 1
    begin
        set @str = RIGHT(@str, len(@str) - 1)
    end

    -- remove trailing dashes
    while len(@str) > 0 AND substring(@str, len(@str), 1) = '-'
    begin
        set @str = LEFT(@str, len(@str) - 1)
    end
    return @str
end
GO

-- ***** cache_show *****
-- YOU NEED TO BE SETUP TO CREATE MEMORY OPTIMIZED TABLES ON THE DB PRIOR TO RUNNING THIS!!!!
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cache_show]
(
	[showId] [bigint] NOT NULL,
	[jsonValue] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,

 CONSTRAINT [PK_cache_show]  PRIMARY KEY NONCLUSTERED 
(
	[showId] ASC
)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO
