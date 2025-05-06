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

	function index( event, rc, prc ){
		return '';
	}

	function rawReturn( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			event.renderData(data:'', format:'html');
		} else {
			return prc.shows;
		}
	}

	function default( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			event.getResponse().setData( returnStringJSON(jsonData:prc.shows) );
		} else {
			event.getResponse().setData( returnStringJSON(jsonData:prc.shows) );
		}
	}

	function rest( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:true);
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:true);
		}
	}
	/**
	 * This is what we will be using in our demo
	 */
	function noRest( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:false);
		}
	}

	function defaultReturn( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);

		if (rc.debug) {
			return returnStringJSON(jsonData:prc.shows);
		} else {
			return returnStringJSON(jsonData:prc.shows);
		}
	}

	function restMeta( event, rc, prc ){
		event.paramValue( name:'debug', value:0 );
		event.paramValue( name:'limit', value:0 );

		prc.shows = showService.getShowsCustom(rc.limit);
		var meta = {
			"error": false,
			"pagination": {
				"totalPages": 10
			},
			"messages": ['weeee', 'wheee', 'hooo']
		}
		if (rc.debug) {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:true,metaData:meta);
		} else {
			return returnStringJSON(jsonData:prc.shows,cbRestReturn:true,metaData:meta);
		}
	}
}