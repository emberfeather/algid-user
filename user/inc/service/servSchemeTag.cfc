<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme2Tag2User" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="user" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check Permissions --->
		
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				INSERT INTO "#variables.datasource.prefix#user"."bScheme2Tag2User"
				(
					"schemeID", 
					"tagID",
					"userID"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTagID()#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user.getUserID()#" />::uuid
				)
			</cfquery>
		</cftransaction>
		
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
				and s."schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				and u."tagID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tagID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID')>
				and u."userID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userID#" />::uuid
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>