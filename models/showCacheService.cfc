component {
	// Builds the cache for shows
	public function buildShowCache() {
		var q = queryExecute( "
				DECLARE @json NVARCHAR(MAX);
				set @json = (
					SELECT
						[showId],[title],[type]
						,[releaseYear] AS [meta.Release Year], [rating] AS [meta.rating]
						,[durationMinutes] AS [meta.duration.minutes], [durationSeasons] AS [meta.duration.seasons]
						,CONVERT( varchar, [dateAdded], 101 ) AS [meta.dateAdded]
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
				FOR JSON PATH);

				INSERT 	INTO dbo.cache_show
						( [showId], [jsonValue] )
				SELECT 	[showId], [jsonValue]
				FROM 	OPENJSON( @json ) WITH (
							[showId] [bigint] '$.showId',
							[jsonValue] [nvarchar](MAX) '$' AS JSON
						) AS j
				WHERE 	NOT EXISTS (SELECT 1 FROM dbo.cache_show WHERE [showId] = j.[showId])
			",
			{ },
			{ 'returnType' : 'query' }
		);
		return q;
	}
	// Insert a single show into the cache
	public function insertShow( required numeric showId, required string jsonString ) {
		if (!isJSON(arguments.jsonString)) {
			return false;
		}
		var q = queryExecute( "
				INSERT 	INTO dbo.cache_show
						( [showId], [jsonValue] )
				VALUES 	( :showId, :jsonString )
			",
			{ 'showId' : arguments.showId, 'jsonString' : arguments.jsonString },
			{ 'returnType' : 'query' }
		);
		return q;
	}
	// Get Full Cache
	public function getShowsCache( ) {
		var q = queryExecute( "
				SELECT	'[' + STRING_AGG(CONVERT (NVARCHAR (MAX), jsonValue), ',') + ']' AS [jsonValue]
				FROM 	dbo.cache_show
			",
			{ },
			{ 'returnType' : 'array' }
		);
		return q;
	}
	// Get Full Query Cached
	public function getShowsQueryCached( ) {
		var q = queryExecute( "
				SELECT	'[' + STRING_AGG(CONVERT (NVARCHAR (MAX), jsonValue), ',') + ']' AS [jsonValue]
				FROM 	dbo.cache_show
			",
			{ },
			{
				'returnType' : 'array',
				'cachedWithin' : createTimespan(0, 0, 10, 0)
			}
		);
		return q;
	}
	// Get a single show from the cache
	public function getShowCached( required numeric showId ) {
		var q = queryExecute( "
				SELECT 	[jsonValue]
				FROM	dbo.cache_show
				WHERE 	showID = :showId
			",
			{ 'showId' : arguments.showId },
			{ 'returnType' : 'array' }
		);
		return q;
	}
	// Get a single show from the cache with query caching
	public function getShowQueryCached( required numeric showId ) {
		var q = queryExecute( "
				SELECT 	[jsonValue]
				FROM	dbo.cache_show
				WHERE 	showID = :showId
			",
			{ 'showId' : arguments.showId },
			{
				'returnType' : 'array',
				'cachedWithin' : createTimespan(0, 0, 10, 0),
				'tags' : 'jsonShowCache'
		 	}
		);
		return q;
	}
	// Clear the cache
	public function clearShowsCache( ) {
		var q = queryExecute( "
				DELETE FROM dbo.cache_show
			"
		);
		return 'CLEARED';
	}
}