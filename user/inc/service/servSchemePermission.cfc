<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createScheme2Tag2Permission" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		<cfargument name="permission" type="component" required="true" />
		
		<cfset var results = '' />
		
		<cfquery datasource="#variables.datasource.name#" result="results">
			INSERT INTO "#variables.datasource.prefix#user"."bScheme2Tag2Permission"
			(
				"schemeID", 
				"tagID",
				"permission"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.scheme.getSchemeID()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tag.getTagID()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permission.getPermission()#" />
			)
		</cfquery>
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
				AND s."schemeID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.schemeID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				AND u."tagID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.tagID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'permission')>
				AND p."permission" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.permission#" />
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
					AND tu."tagID" = tp."tagID"
			JOIN "#variables.datasource.prefix#user"."user" u
				ON tu."userID" = u."userID"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'schemeID')>
				AND s."schemeID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.schemeID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'tagID')>
				AND tu."tagID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.tagID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID')>
				AND u."userID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.userID#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'permission')>
				AND tp."permission" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.permission#" />
			</cfif>
			
			ORDER BY s.scheme ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>