component extends="JsonSqlRestHandler" {
	property name="showService" inject="showJSONService";
	property name="cacheService" inject="showCacheService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	function index( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'cached', value:0 );
		if (rc.cached) {
			prc.shows = cacheService.getShowQueryCached( showId:rc.id );
		} else {
			prc.shows = cacheService.getShowCached( showId:rc.id );
		}
		if (rc.debug) {
			event.renderData( data:returnStringJSON( jsonData:prc.shows, cbRestReturn:false), format:'html' );
		} else {
			event.getResponse().setData( returnStringJSON( jsonData:prc.shows ) );
		}
	}

	function cacheShow( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		var showArray = showService.getShowSingle( showID:rc.showID );
		var showJson = returnStringJSON( jsonData:showArray, cbRestReturn:false );
		var show = cacheService.insertShow( showID:rc.showID, jsonString:showJson );
		if (rc.debug) {
			event.renderData( data:serializeJSON(show), format:'html' );
		} else {
			event.getResponse().setData( show ) ;
		}
	}

	function buildCache( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		var cache = cacheService.buildShowCache();
		if (rc.debug) {
			event.renderData( data:serializeJSON(cache), format:'html' );
		} else {
			event.getResponse().setData( cache ) ;
		}
	}

	function getShowsCache( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		var cache = cacheService.getShowsCache();
		if (rc.debug) {
			event.renderData( data:serializeJSON(cache), format:'html' );
		} else {
			return returnStringJSON( jsonData:cache, cbRestReturn:false );
		}
	}

	function getShowsCached( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		var cache = cacheService.getShowsQueryCached();
		if (rc.debug) {
			event.renderData( data:serializeJSON(cache), format:'html' );
		} else {
			return returnStringJSON( jsonData:cache, cbRestReturn:false );
		}
	}

	function clearShowsCached( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		var cache = cacheService.clearShowsCache();
		if (rc.debug) {
			event.renderData( data:serializeJSON(cache), format:'html' );
		} else {
			return returnStringJSON( jsonData:cache, cbRestReturn:false );
		}
	}
}