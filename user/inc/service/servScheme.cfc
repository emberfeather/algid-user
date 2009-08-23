<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="component" required="true" />
		
		<cfset var results = '' />
		
		<cfquery datasource="#variables.datasource.name#" result="results">
			INSERT INTO "#variables.datasource.prefix#user"."scheme"
			(
				scheme, 
				"updatedOn",
				"updatedBy"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
				now(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.scheme.getUpdatedBy()#" />
			)
		</cfquery>
		
		<!--- Query the schemeID --->
		<!--- TODO replace this with the new id from the insert results --->
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE scheme = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />
		</cfquery>
		
		<cfset arguments.scheme.setSchemeID( results.schemeID ) />
	</cffunction>
	
	<cffunction name="createScheme2Tag2User" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="user" type="component" required="true" />
		
		<cfset var results = '' />
		
		<cfquery datasource="#variables.datasource.name#" result="results">
			INSERT INTO "#variables.datasource.prefix#user"."bScheme2Tag2User"
			(
				"schemeID", 
				"tagID",
				"userID"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.scheme.getSchemeID()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tag.getTagID()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user.getUserID()#" />
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="readScheme" access="public" returntype="component" output="false">
		<cfargument name="schemeID" type="numeric" required="true" />
		
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn", "updatedBy"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.schemeID#" />
		</cfquery>
		
		<cfset scheme = createObject('component', 'plugins.user.inc.model.modScheme').init(variables.i18n, variables.locale) />
		
		<cfset scheme.deserialize(results) />
		
		<cfreturn scheme />
	</cffunction>
	
	<cffunction name="readSchemes" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn", "updatedBy"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'scheme')>
				AND scheme = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.scheme#" />
			</cfif>
			
			ORDER BY scheme ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>