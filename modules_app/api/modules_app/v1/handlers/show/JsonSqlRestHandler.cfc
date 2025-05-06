/**
 * Takes a JSON string or SQL JSON Object string and returns as JSON string without using serialization
 */
component extends="coldbox.system.RestHandler" {
	/**
	 * returnStringJSON
	 *
	 * @jsonData The SQL JSON Array or JSON string
	 * @cbRestReturn Boolean to determine if we want to include default nodes / format from the ColdBox REST API. (default: No Value. No Value: ColdBox Default behavior, True: Include default nodes, False: JSON as is)
	 * @metaData The meta data to append to the JSON string
	 *
	 * @return JSON string
	 */
	function returnStringJSON( any jsonData, boolean cbRestReturn, struct metaData ) {
		var jsonString = '';
		// If not a string the assumption is SQL Array JSON, return just the JSON
		if ( isArray( arguments.jsonData ) ) {
			jsonString = decodeSQLJSON( arguments.jsonData );
		} else {
			jsonString = arguments.jsonData;
		}
		// Return as JSON to browser
		getRequestContext().setHTTPHeader( name="Content-Type", value="application/json" );
		// ColdBox way of doing things
		if ( !StructKeyExists( arguments, "cbRestReturn" ) ) {
			return deserializeJSON( jsonString );
		// Non-ColdBox way of doing things, but same response
		} else if ( arguments.cbRestReturn ) {
			// Standard REST Object Prefix
			var returnJsonPrefix = '{"data":';
			// If meta data is passed in, append it to the end
			if ( StructKeyExists( arguments, "metaData" ) ) {
				var suffix = jsonMeta( arguments.metaData );
			// Append base rest object to end, Use a string to speed up as we dont need to serialize base
			} else {
				var suffix = ',"error": false,"pagination": {"totalPages": 1, "maxRows": 0, "offset": 0, "page": 1, "totalRecords": 0},"messages": []}';
			}

			// wrap rest object around the JSON string
			return returnJsonPrefix & jsonString & suffix;
		// Non-ColdBox way of doing things, standard api nodes not added
		} else {
			// Return just the JSON string
			return jsonString;
		}
	}
	/**
	 * decodeSQLJSON
	 *
	 * @sqlArray The SQL JSON Array
	 *
	 * @return JSON string
	 */
	private string function decodeSQLJSON( array sqlArray ) {
		var jsonString = '';
		arguments.sqlArray.each( function( value ){
			value.each( function( key ) {
				jsonString &= value[key];
			} );
		} );
		return jsonString;
	}
	/**
	 * jsonMeta
	 *
	 * @metaData The meta data to append to the JSON string
	 *
	 * @return JSON string
	 */
	private string function jsonMeta( struct metaData = {} ) {
		var meta = {
			"error": false,
			"pagination": {
				"totalPages": 1,
				"maxRows": 0,
				"offset": 0,
				"page": 1,
				"totalRecords": 0
			},
			"messages": []
		}
		structAppend( meta, arguments.metaData, true );
		var jsonString = serializeJSON( meta );
		// Format object string to be used as a wrapper suffix
		return ',' & jsonString.right( jsonString.len() - 1 );
	}
}