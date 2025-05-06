component extends="JsonSqlRestHandler" {
	property name="qb" inject="provider:QueryBuilder@qb";
	// JSON
	function index( event, rc, prc ){
		event.paramValue( name:'limit', value:0 );
		event.paramValue( name:'debug', value:0 );

		prc.shows = getShowsQBJSON(rc.limit);

		if (rc.debug) {
			event.renderData(data:'COMPLETE', format:'html');
		} else {
			return returnStringJSON( jsonData:prc.shows, cbRestReturn:false );
		}
	}
	// Classic
	function classic( event, rc, prc ){
		event.paramValue( name:'limit', value:0 );
		event.paramValue( name:'debug', value:0 );

		prc.shows = getShowsQB(rc.limit);

		if (rc.debug) {
			event.renderData(data:'COMPLETE', format:'html');
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// Classic Data
	private function getShowsQB(numeric count = 1) {
		var shows = qb
			.from("dbo.show")
			.select( "showId, title, type, releaseYear, rating, durationMinutes, durationSeasons, dateAdded" )
			// .where('showId', 419733)
			.limit(arguments.count)
			.get();
		shows.each( (show) => {
			show.category = qb
				.from("dbo.show_category")
				.selectRaw("listed_in AS category")
				.where("showId",show.showId)
				.get();
			show.cast = qb
				.from("dbo.show_cast")
				.where("showId",show.showId)
				.get("cast");
			show.director = qb
				.from("dbo.show_director")
				.where("showId",show.showId)
				.get("director");

			show["meta"] = {
				"Release Year": show.releaseYear,
				"rating": show.rating,
				"duration": {
					"minutes": show.durationMinutes,
					"seasons": show.durationSeasons
				},
				"dateAdded": dateFormat(show.dateAdded, "MM/DD/YYYY")
			};
		} );
		return shows;
	}
	// JSON Data
	private function getShowsQBJSON(numeric count = 1) {
		var shows = qb
			.from("dbo.show")
			.select( "showId, title, type, releaseYear, rating, durationMinutes, durationSeasons, dateAdded" )
			.limit(arguments.count)
			.subSelect( "category", function( q ) {
				q.selectRaw( "listed_in AS category" )
					.from( "show_category" )
					.setReturnFormat( 'jsonpath' )
					.whereColumn( "show.showId", "show_category.showId" );
			} )
			.subSelect( "cast", function( q ) {
				q.selectRaw( "TOP 100 PERCENT CONCAT(
								'[""',
								STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([cast],'JSON'), 'N/A')),
								'"", ""') WITHIN GROUP (ORDER BY [cast]),'""]'
							) AS [Cast]" )
					.from( "show_cast" )
					.setReturnFormat( 'jsonquery' )
					.whereColumn( "show.showId", "show_cast.showId" );
			} )
			.subSelect( "director", function( q ) {
				q.selectRaw( "TOP 100 PERCENT STRING_AGG(CONVERT (NVARCHAR (MAX), ISNULL(STRING_ESCAPE([director],'JSON'), 'N/A')), ', ') AS [director]" )
					.from( "show_director" )
					.whereColumn( "show.showId", "show_director.showId" );
			} )
			.setReturnFormat( 'jsonpath' )
			.get(options = { returnType : "array" });

		return shows;
	}
}