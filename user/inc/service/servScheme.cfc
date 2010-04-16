<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getScheme" access="public" returntype="component" output="false">
		<cfargument name="schemeID" type="string" required="true" />
		
		<cfset var i18n = '' />
		<cfset var objectSerial = '' />
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemeID#" null="#arguments.schemeID eq ''#" />::uuid
		</cfquery>
		
		<cfset scheme = variables.transport.theApplication.factories.transient.getModSchemeForUser(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<cfif results.recordCount>
			<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
			
			<cfset objectSerial.deserialize(results, scheme) />
		</cfif>
		
		<cfreturn scheme />
	</cffunction>
	
	<cffunction name="getSchemes" access="public" returntype="query" output="false">
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
	
	<cffunction name="setScheme" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('user', 'scheme') />
		
		<!--- TODO Check permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.scheme) />
		
		<cfif arguments.scheme.getSchemeID() eq ''>
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
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.scheme) />
		<cfelse>
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.scheme) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.scheme) />
		
		<cfset arguments.scheme.setSchemeID( results.schemeID ) />
	</cffunction>
</cfcomponent>