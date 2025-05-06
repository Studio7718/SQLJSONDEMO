component extends="JsonSqlRestHandler" {
	property name="showService" inject="showJSONService";

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
			event.renderData( data:returnStringJSON(jsonData:prc.show,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.show,cbRestReturn:false);
		}
	}
	// Simple
	function shows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShows(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// List
	function showsList( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsList(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Objects
	function showsObjects( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsObjects(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Strings
	function showsStrings( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsStrings(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Custom
	function showsCustom( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// File
	function showsFile( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsFile('/var/opt/mssql/json/movies.json');

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Param
	function showsParam( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsParam('[{"showId":1}]');

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Get Inserted
	function tempShows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getTempShows(rc.limit);

		if (rc.debug) {
			event.renderData( data:returnStringJSON(jsonData:prc.shows,cbRestReturn:false), format:'html' );
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}
	// Insert
	function insertShows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		var showArray = showService.getShowsCustom( rc.limit );
		rc.showJson = returnStringJSON( jsonData:showArray, cbRestReturn:false );

		var show = showService.insertShows( jsonString:rc.showJson );
		if (rc.debug) {
			event.renderData( data:serializeJSON(show), format:'html' );
		} else {
			return show;
		}
	}
	// Update
	function updateShows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		var showArray = showService.getShowsCustom( rc.limit );
		rc.showJson = returnStringJSON( jsonData:showArray, cbRestReturn:false );

		var show = showService.updateShows( jsonString:rc.showJson );
		if (rc.debug) {
			event.renderData( data:serializeJSON(show), format:'html' );
		} else {
			return show;
		}
	}
	// Delete
	function deleteShows( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		var showArray = showService.getShowsCustom( rc.limit );
		rc.showJson = returnStringJSON( jsonData:showArray, cbRestReturn:false );

		var show = showService.deleteShows( jsonString:rc.showJson );
		if (rc.debug) {
			event.renderData( data:serializeJSON(show), format:'html' );
		} else {
			return show;
		}
	}
}