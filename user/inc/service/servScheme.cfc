<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check permissions --->
		
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				INSERT INTO "#variables.datasource.prefix#user"."scheme"
				(
					scheme, 
					"updatedOn"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
					now()
				)
			</cfquery>
			
			<!--- Query the schemeID --->
			<!--- TODO replace this with the new id from the insert results --->
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "schemeID"
				FROM "#variables.datasource.prefix#user"."scheme"
				WHERE scheme = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />
			</cfquery>
		</cftransaction>
		
		<!--- Log the create event --->
		<cfset eventLog.logEvent('user', 'createScheme', 'Created the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID()) />
		
		<cfset arguments.scheme.setSchemeID( results.schemeID ) />
	</cffunction>
	
	<cffunction name="readScheme" access="public" returntype="component" output="false">
		<cfargument name="schemeID" type="numeric" required="true" />
		
		<cfset var i18n = '' />
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.schemeID#" />
		</cfquery>
		
		<cfset scheme = variables.transport.theApplication.factories.transient.getModSchemeForUser(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<cfset scheme.deserialize(results) />
		
		<cfreturn scheme />
	</cffunction>
	
	<cffunction name="readSchemes" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'scheme')>
				and scheme = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.scheme#" />
			</cfif>
			
			ORDER BY scheme ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>