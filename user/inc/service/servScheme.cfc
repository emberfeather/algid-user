<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check permissions --->
		
		<!--- Create the new ID --->
		<cfset arguments.scheme.setSchemeID( createUUID() ) />
		
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				INSERT INTO "#variables.datasource.prefix#user"."scheme"
				(
					"schemeID",
					"scheme", 
					"updatedOn"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
					now()
				)
			</cfquery>
		</cftransaction>
		
		<!--- Log the create event --->
		<cfset eventLog.logEvent('user', 'createScheme', 'Created the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID()) />
		
		<cfset arguments.scheme.setSchemeID( results.schemeID ) />
	</cffunction>
	
	<cffunction name="readScheme" access="public" returntype="component" output="false">
		<cfargument name="schemeID" type="string" required="true" />
		
		<cfset var i18n = '' />
		<cfset var objectSerial = '' />
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemeID#" />::uuid
		</cfquery>
		
		<cfset scheme = variables.transport.theApplication.factories.transient.getModSchemeForUser(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<cfif results.recordCount>
			<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
			
			<cfset objectSerial.deserialize(results, scheme) />
		</cfif>
		
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