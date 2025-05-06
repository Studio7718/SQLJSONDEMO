component {

	function configure(){
		// API Echo
		get( "/", "show.json.echo" );

		get( "/show/cache/cacheShow/:showID", "show.cache.cacheShow" );
		get( "/show/cache/:id-numeric", "show.cache.index" );

		// get( "/show/classic/list", "show.classic.list" );
		get( "/show/classic/:id-numeric", "show.classic.index" );
		// get( "/show/json/list", "show.json.list" );
		get( "/show/json/:id-numeric", "show.json.index" );

		route( "/:handler/:action" ).end();
	}

}
