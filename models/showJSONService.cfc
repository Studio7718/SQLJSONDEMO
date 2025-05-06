component {
	// Simple
	public function getShows(count = 0) {
		var shows = queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 	dbo.[show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);

		return shows;
	}
	// List
	public function getShowsList(count = 0) {
		return queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
						, (
							SELECT		TOP 100 PERCENT STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL([listed_in], 'N/A')), ', ') AS [listed_in]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
							ORDER BY	[listed_in]
						) AS [categories]
						, (
							SELECT		TOP 100 PERCENT STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')), ', ') AS [cast]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
							ORDER BY	[cast]
						) AS [cast]
						, (SELECT STUFF(
						(
							SELECT  	TOP 100 PERCENT ', ' + STRING_ESCAPE([director],'JSON')
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
							ORDER BY	[director]
							FOR
								XML PATH('')
						), 1, 2, '') ) AS [directors]
				FROM 	dbo.[show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);
	}
	// Objects
	public function getShowsObjects(count = 0) {
		return queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
						, (
							SELECT		[listed_in] AS [category]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
							ORDER BY	[listed_in]
							FOR JSON PATH
						) AS [categories]
						, (
							SELECT		[cast] AS [name]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
							ORDER BY	[cast]
							FOR JSON PATH
						) AS [cast]
						, (
							SELECT		[director] AS [name]
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
							ORDER BY	[director]
							FOR JSON PATH
						) AS [directors]
				FROM 	dbo.[show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);
	}
	// Strings
	public function getShowsStrings(count = 0) {
		return queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL([listed_in], 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [listed_in]),'""]'
										) AS [listed_in]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
						)) AS [categories]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [cast]),'""]'
										) AS [Cast]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
						)) AS [cast]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([director],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [director]),'""]'
										) AS [Director]
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
						)) AS [directors]
				FROM 	dbo.[show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);
	}
	// Custom
	public function getShowsCustom(count = 0) {
		return queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type]
						,[releaseYear] AS [meta.Release Year], [rating] AS [meta.rating]
						,[durationMinutes] AS [meta.duration.minutes], [durationSeasons] AS [meta.duration.seasons]
						,CONVERT(varchar, [dateAdded], 101) AS [meta.dateAdded]
						, (
							SELECT		ROW_NUMBER() OVER (ORDER BY	[listed_in]) AS [categoryID],
										[listed_in] AS [Category],
										dbo.Slugify([listed_in]) AS [slug]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
							ORDER BY	[listed_in]
							FOR JSON PATH, ROOT('categories')
						) AS [search]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [cast]),'""]'
										) AS [Cast]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
						)) AS [people.cast]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([director],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [director]),'""]'
										) AS [Director]
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
						)) AS [people.directors]
				FROM 	dbo.[show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);
	}
	// This uses a different method to combine the JSON string, you get a single row
	public function getShowsCustomPreMerged(count = 0) {
		return queryExecute("
				SELECT(SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type]
						,[releaseYear] AS [meta.Release Year], [rating] AS [meta.rating]
						,[durationMinutes] AS [meta.duration.minutes], [durationSeasons] AS [meta.duration.seasons]
						,CONVERT(varchar, [dateAdded], 101) AS [meta.dateAdded]
						, (
							SELECT		ROW_NUMBER() OVER (ORDER BY	[listed_in]) AS [categoryID],
										[listed_in] AS [Category],
										dbo.Slugify([listed_in]) AS [slug]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
							ORDER BY	[listed_in]
							FOR JSON PATH, ROOT('categories')
						) AS [search]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [cast]),'""]'
										) AS [Cast]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
						)) AS [people.cast]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([director],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [director]),'""]'
										) AS [Director]
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
						)) AS [people.directors]
				FROM 	dbo.[show] AS s
				FOR JSON PATH)
			",
			{},
			{ 'returnType':'array' }
		);
	}
	// Single
	public function getShowSingle(showID = 1) {
		return queryExecute("
				SELECT 	TOP (1)
						[showId],[title],[type]
						,[releaseYear] AS [meta.Release Year], [rating] AS [meta.rating]
						,[durationMinutes] AS [meta.duration.minutes], [durationSeasons] AS [meta.duration.seasons]
						,CONVERT(varchar, [dateAdded], 101) AS [meta.dateAdded]
						, (
							SELECT		ROW_NUMBER() OVER (ORDER BY	[listed_in]) AS [categoryID],
										[listed_in] AS [Category],
										dbo.Slugify([listed_in]) AS [slug]
							FROM		dbo.[show_category]
							WHERE		[showId] = s.showId
							ORDER BY	[listed_in]
							FOR JSON PATH, ROOT('categories')
						) AS [search]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [cast]),'""]'
										) AS [Cast]
							FROM		dbo.[show_cast]
							WHERE		[showId] = s.showId
						)) AS [people.cast]
						, JSON_QUERY((
							SELECT		TOP 100 PERCENT CONCAT(
											'[""',
											STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([director],'JSON'), 'N/A')),
											'"", ""') WITHIN GROUP (ORDER BY [director]),'""]'
										) AS [Director]
							FROM		dbo.[show_director]
							WHERE		[showId] = s.showId
						)) AS [people.directors]
				FROM 	dbo.[show] AS s
				WHERE	[showId] = :showID
				FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
			",
			{ 'showID':arguments.showID },
			{ 'returnType':'array' }
		);
	}
	// File
	public function getShowsFile(required string filePath) {
		var q = queryExecute("
				SELECT BulkColumn
				FROM OPENROWSET(BULK '#arguments.filePath#', SINGLE_CLOB) AS s
			",
			{},
			{ 'returnType':'array' }
		);

		return q;
	}
	// Param
	public function getShowsParam(required string jsonString) {
		if (!isJSON(arguments.jsonString)) {
			return false;
		}
		var q = queryExecute("
				SELECT value
				FROM OPENJSON(:jsonString) AS s
			",
			{ 'jsonString':jsonString },
			{ 'returnType':'array' }
		);

		return q;
	}
	// Get Inserted
	public function getTempShows(count = 0) {
		var shows = queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 	dbo.[temp_show] AS s
				FOR JSON PATH
			",
			{},
			{ 'returnType':'array' }
		);

		return shows;
	}
	// Insert
	public function insertShows(required string jsonString) {
		if (!isJSON(arguments.jsonString)) {
			return false;
		}
		var q = queryExecute( "
				INSERT 	INTO dbo.temp_show
						( [showId], [title], [type], [releaseYear], [rating], [durationMinutes], [durationSeasons], [dateAdded] )
				SELECT 	[showId], [title], [type], [releaseYear], [rating], [durationMinutes], [durationSeasons], [dateAdded]
				FROM 	OPENJSON(:jsonString) WITH (
							[showId] [bigint] '$.showId',
							[title] [varchar](1024) '$.title',
							[type] [varchar](50) '$.type',
							[releaseYear] [bigint] '$.meta.""Release Year""',
							[rating] [varchar](32) '$.meta.rating',
							[durationMinutes] [varchar](22) '$.meta.duration.minutes',
							[durationSeasons] [varchar](50) '$.meta.duration.seasons',
							[dateAdded] [date] '$.meta.dateAdded'
						);
			",
			{ 'jsonString' : arguments.jsonString },
			{ 'returnType' : 'query' }
		);
		return q;
	}
	// Update
	public function updateShows(required string jsonString) {
		if (!isJSON(arguments.jsonString)) {
			return false;
		}
		var q = queryExecute( "
				UPDATE 	dbo.temp_show
				SET		[showId] = jd.[showId],
						[title] = jd.[title] + ' **UPDATED**',
						[type] = jd.[type],
						[releaseYear] = jd.[releaseYear],
						[rating] = jd.[rating],
						[durationMinutes] = jd.[durationMinutes],
						[durationSeasons] = jd.[durationSeasons],
						[dateAdded] = jd.[dateAdded]
				FROM 	OPENJSON(:jsonString) WITH (
							[showId] [bigint] '$.showId',
							[title] [varchar](1024) '$.title',
							[type] [varchar](50) '$.type',
							[releaseYear] [bigint] '$.meta.""Release Year""',
							[rating] [varchar](32) '$.meta.rating',
							[durationMinutes] [varchar](22) '$.meta.duration.minutes',
							[durationSeasons] [varchar](50) '$.meta.duration.seasons',
							[dateAdded] [date] '$.meta.dateAdded'
						) AS jd
				WHERE	[temp_show].[showId] = jd.[showId]
			",
			{ 'jsonString' : arguments.jsonString },
			{ 'returnType' : 'query' }
		);
		return q;
	}
	// Delete
	public function deleteShows(required string jsonString) {
		if (!isJSON(arguments.jsonString)) {
			return false;
		}
		var q = queryExecute( "
				DELETE FROM dbo.temp_show
				WHERE		showId IN (
								SELECT 	showId
								FROM 	OPENJSON(:jsonString) WITH (
                                                [showId] [bigint] '$.showId'
                                        )
							)
			",
			{ 'jsonString' : arguments.jsonString },
			{ 'returnType' : 'query' }
		);
		return q;
	}
}