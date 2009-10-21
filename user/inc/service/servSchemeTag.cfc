<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme2Tag2User" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="user" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.applicationSingletons.getEventLog() />
		
		<!--- TODO Check Permissions --->
		
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
		
		<!--- Log the create event --->
		<cfset eventLog.logEvent('user', 'createScheme2Tag2User', 'Granted the ''' & arguments.tag.getTag() & ''' tag to ''' & arguments.user.getUsername() & ''' for the ''' & arguments.scheme.getScheme() & '''.scheme.', arguments.currUser.getUserID()) />
	</cffunction>
	
	<cffunction name="readTagUsers" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", "tagID", "userID"
			FROM "#variables.datasource.prefix#user"."bScheme2Tag2User"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'schemeID')>
				AND s."schemeID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.schemeID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				AND u."tagID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.tagID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID')>
				AND u."userID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.userID#" />
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>