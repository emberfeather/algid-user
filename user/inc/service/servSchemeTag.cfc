<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="readTagUsers" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", "tagID", "userID"
			FROM "#variables.datasource.prefix#user"."bScheme2Tag2User"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'schemeID')>
				and s."schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" null="#arguments.filter.schemeID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				and u."tagID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tagID#" null="#arguments.filter.tagID eq ''#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID')>
				and u."userID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userID#" null="#arguments.filter.userID eq ''#" />::uuid
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setScheme2Tag2User" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="user" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('user', 'scheme') />
		
		<!--- TODO Check Permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.scheme, arguments.tag, arguments.user) />
		
		<!--- TODO Check if the scheme tag already exists --->
		<cfif 1 eq 0>
		<cfelse>
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					INSERT INTO "#variables.datasource.prefix#user"."bScheme2Tag2User"
					(
						"schemeID", 
						"tagID",
						"userID"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" null="#arguments.scheme.getSchemeID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTagID()#" null="#arguments.tag.getTagID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user.getUserID()#" null="#arguments.user.getUserID() eq ''#" />::uuid
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.scheme, arguments.tag, arguments.user) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.scheme, arguments.tag, arguments.user) />
	</cffunction>
</cfcomponent>