component {
	// Simple
	public function getShows(numeric count = 0) {
		var shows = queryExecute("
				SELECT 	TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
						[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 	dbo.[show] AS s
			",
			{},
			{ 'returnType':'array' }
		);

		return shows;
	}
	// List
	public function getShowsList(numeric count = 0) {
		var movies = queryExecute("
				SELECT 		TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
							[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 		dbo.[show] AS s
			",
			{},
			{ 'returnType':'array' }
		);
		movies.each( (movie) => {
			var q1 = queryExecute("
					SELECT		[cast] AS [Name]
					FROM		dbo.[show_cast]
					WHERE		[showId] = :showID
					ORDER BY	[cast]
				",
				{showID:movie.showID},
				{returnType:'query'}
			);
			movie["cast"] = ListChangeDelims(list:valueList(q1.name),new_delimiter:', ',multiCharacterDelimiter:true);
			var q2 = queryExecute("
					SELECT		[listed_in] AS [Name]
					FROM		dbo.[show_category]
					WHERE		[showId] = :showID
					ORDER BY	[listed_in]
				",
				{showID:movie.showID},
				{returnType:'query'}
			);
			movie["categories"] = ListChangeDelims(list:valueList(q2.name),new_delimiter:', ',multiCharacterDelimiter:true);;
			var q3 = queryExecute("
					SELECT		[director] AS [director]
					FROM		dbo.[show_director]
					WHERE		[showId] = :showID
					ORDER BY	[director]
				",
				{showID:movie.showID},
				{returnType:'query'}
			);
			movie["directors"] = ListChangeDelims(list:valueList(q3.director),new_delimiter:', ',multiCharacterDelimiter:true);;
		} );

		return movies;
	}
	// Objects
	public function getShowsObjects(numeric count = 0) {
		var movies = queryExecute("
				SELECT 		TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
							[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 		dbo.[show] AS s
			",
			{},
			{ 'returnType':'array' }
		);
		movies.each( (movie) => {
			var q1 = queryExecute("
					SELECT		[cast] AS [Name]
					FROM		dbo.[show_cast]
					WHERE		[showId] = :showID
					ORDER BY	[cast]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["cast"] = q1.map(function(item,index,arr){
				return item.name;
			});
			var q2 = queryExecute("
					SELECT		[listed_in] AS [Name]
					FROM		dbo.[show_category]
					WHERE		[showId] = :showID
					ORDER BY	[listed_in]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["categories"] = q2.map(function(item,index,arr){
				return item.name;
			});
			var q3 = queryExecute("
					SELECT		[director] AS [director]
					FROM		dbo.[show_director]
					WHERE		[showId] = :showID
					ORDER BY	[director]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["directors"] = q3.map(function(item,index,arr){
				return item.director;
			});
		} );

		return movies;
	}
	// Strings
	public function getShowsStrings(numeric count = 0) {
		var movies = queryExecute("
				SELECT 		TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
							[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 		dbo.[show] AS s
			",
			{},
			{ 'returnType':'array' }
		);
		movies.each( (movie) => {
			movie["cast"] = queryExecute("
					SELECT		[cast] AS [Name]
					FROM		dbo.[show_cast]
					WHERE		[showId] = :showID
					ORDER BY	[cast]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["categories"] = queryExecute("
					SELECT		[listed_in] AS [Name]
					FROM		dbo.[show_category]
					WHERE		[showId] = :showID
					ORDER BY	[listed_in]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["directors"] = queryExecute("
					SELECT		[director] AS [director]
					FROM		dbo.[show_director]
					WHERE		[showId] = :showID
					ORDER BY	[director]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
		} );

		return movies;
	}
	// Custom
	public function getShowsCustom(numeric count = 0) {
		var movies = queryExecute("
				SELECT 		TOP #val(arguments.count) ? val(arguments.count) : '100 PERCENT'#
							[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 		dbo.[show] AS s
			",
			{},
			{ 'returnType':'array' }
		);
		movies.each( (movie) => {
			movie["meta"] = {
				"Release Year": movie.releaseYear,
				"rating": movie.rating,
				"duration": {
					"minutes": movie.durationMinutes,
					"seasons": movie.durationSeasons
				},
				"dateAdded": dateFormat(movie.dateAdded, "MM/DD/YYYY")
			};
			movie.delete("releaseYear");
			movie.delete("rating");
			movie.delete("durationMinutes");
			movie.delete("durationSeasons");
			movie.delete("dateAdded");
			var q1 = queryExecute("
					SELECT		[cast] AS [Name]
					FROM		dbo.[show_cast]
					WHERE		[showId] = :showID
					ORDER BY	[cast]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["people"]["cast"] = q1.map(function(item,index,arr){
				return item.name;
			});
			var q2 = queryExecute("
					SELECT		ROW_NUMBER() OVER (ORDER BY	[listed_in]) AS [categoryID], [listed_in] AS [Category], dbo.Slugify([listed_in]) AS [slug]
					FROM		dbo.[show_category]
					WHERE		[showId] = :showID
					ORDER BY	[listed_in]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["search"]["categories"] = q2;
			var q3 = queryExecute("
					SELECT		[director] AS [director]
					FROM		dbo.[show_director]
					WHERE		[showId] = :showID
					ORDER BY	[director]
				",
				{showID:movie.showID},
				{returnType:'array'}
			);
			movie["people"]["directors"] = q3.map(function(item,index,arr){
				return item.director;
			});
		} );

		return movies;
	}
	// Single
	public function getShowSingle(showID = 1) {
		var movies = queryExecute("
				SELECT 		TOP (1)
							[showId],[title],[type],[releaseYear],[rating],[durationMinutes],[durationSeasons],[dateAdded]
				FROM 		dbo.[show] AS s
				WHERE 		[showId] = :showID
			",
			{ 'showID':arguments.showID },
			{ 'returnType':'array' }
		);
		movies.each( (movie) => {
			movie["meta"] = {
				"Release Year": movie.releaseYear,
				"rating": movie.rating,
				"duration": {
					"minutes": movie.durationMinutes,
					"seasons": movie.durationSeasons
				},
				"dateAdded": dateFormat(movie.dateAdded, "MM/DD/YYYY")
			};
			movie.delete("releaseYear");
			movie.delete("rating");
			movie.delete("durationMinutes");
			movie.delete("durationSeasons");
			movie.delete("dateAdded");
			var q1 = queryExecute("
					SELECT		[cast] AS [Name]
					FROM		dbo.[show_cast]
					WHERE		[showId] = :showID
					ORDER BY	[cast]
				",
				{ 'showID' : movie.showID },
				{ 'returnType' : 'array' }
			);
			movie["people"]["cast"] = q1.map(function(item,index,arr){
				return item.name;
			});
			var q2 = queryExecute("
					SELECT		ROW_NUMBER() OVER (ORDER BY	[listed_in]) AS [categoryID], [listed_in] AS [Category], dbo.Slugify([listed_in]) AS [slug]
					FROM		dbo.[show_category]
					WHERE		[showId] = :showID
					ORDER BY	[listed_in]
				",
				{ 'showID' : movie.showID },
				{ 'returnType' : 'array' }
			);
			movie["search"]["categories"] = q2;
			var q3 = queryExecute("
					SELECT		[director] AS [director]
					FROM		dbo.[show_director]
					WHERE		[showId] = :showID
					ORDER BY	[director]
				",
				{ 'showID' : movie.showID },
				{ 'returnType' : 'array' }
			);
			movie["people"]["directors"] = q3.map(function(item,index,arr){
				return item.director;
			});
		} );

		return movies[1];
	}
	// File
	public function getShowsFile(filePath) {
		var filePath = expandPath( arguments.filePath );
		var fileJson = fileRead( filePath );

		if ( !isJSON(fileJson) ) {
			throw( "File not json: " & filePath );
		}

		return deserializeJSON(fileJson);
	}
	// Param
	public function getShowsParam(jsonString) {
		return arguments.jsonString;
	}
}