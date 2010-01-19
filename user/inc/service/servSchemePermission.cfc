<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme2Tag2Permission" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="permission" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check Permissions --->
		
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				INSERT INTO "#variables.datasource.prefix#user"."bScheme2Tag2Permission"
				(
					"schemeID",
					"tagID",
					"permission"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" null="#arguments.scheme.getSchemeID() eq ''#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTagID()#" null="#arguments.tag.getTagID() eq ''#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permission.getPermission()#" />
				)
			</cfquery>
		</cftransaction>
		
		<!--- Log the create event --->
		<cfset eventLog.logEvent('user', 'createScheme2Tag2Permission', 'Granted the ''' & arguments.permission.getPermission() & ''' permission ''' & arguments.tag.getTag() & ''' tag for the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID()) />
	</cffunction>
	
	<cffunction name="readPermissions" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<!--- TODO Read the permissions from the plugin files --->
		<cfset results = queryNew('permission,description,locale') />
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="readTagPermissions" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", "tagID", "permission"
			FROM "#variables.datasource.prefix#user"."bScheme2Tag2Permission"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'schemeID')>
				and s."schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" null="#arguments.filter.schemeID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				and u."tagID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tagID#" null="#arguments.filter.tagID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'permission')>
				and p."permission" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.permission#" />
			</cfif>
			
			ORDER BY permission ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="readUserPermissions" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT s."schemeID", s.scheme, u."userID", tu."tagID", tp."permission"
			FROM "#variables.datasource.prefix#user"."scheme" s
			JOIN "#variables.datasource.prefix#user"."bScheme2Tag2User" tu
				ON s."schemeID" = tu."schemeID"
			JOIN "#variables.datasource.prefix#user"."bScheme2Tag2Permission" tp
				ON s."schemeID" = tp."schemeID"
					and tu."tagID" = tp."tagID"
			JOIN "#variables.datasource.prefix#user"."user" u
				ON tu."userID" = u."userID"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'schemeID')>
				and s."schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" null="#arguments.filter.schemeID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				and tu."tagID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tagID#" null="#arguments.filter.tagID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID')>
				and u."userID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userID#" null="#arguments.filter.userID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'permission')>
				and tp."permission" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.permission#" />
			</cfif>
			
			ORDER BY s.scheme ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>