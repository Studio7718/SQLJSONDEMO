component extends="JsonSqlRestHandler" {
	property name="showService" inject="showClassicService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	// Single
	function index( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );

		prc.show = showService.getShowSingle( showId:rc.id );

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.show ), format:'html' );
		} else {
			event.getResponse().setData( prc.show );
		}
	}
	// Simple
	function shows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShows(rc.limit);

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// List
	function showsList( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsList(rc.limit);

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// Objects
	function showsObjects( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsObjects(rc.limit);

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// Strings
	function showsStrings( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsStrings(rc.limit);

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// Custom
	function showsCustom( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// File
	function showsFile( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsFile("./models/data/movies.json");

		if (rc.debug) {
			event.renderData( data:serializeJSON( prc.shows ), format:'html' );
		} else {
			event.getResponse().setData( prc.shows );
		}
	}
	// Param
	function showsParam( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsParam('[{"showId":1}]');

		if (rc.debug) {
			event.renderData( data:prc.shows, format:'html' );
		} else {
			event.getResponse().setData( deserializeJSON(prc.shows) );
		}
	}
}