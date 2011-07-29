<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getNavigation" access="public" returntype="query" output="false">
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset local.adminNavigation = variables.transport.theApplication.managers.singleton.getAdminNavigation() />
		
		<cfset local.navigation = local.adminNavigation.getNavigation() />
		
		<cfquery name="local.results" dbtype="query">
			SELECT *
			FROM local.navigation
			WHERE [locale] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
			ORDER BY path asc
		</cfquery>
		
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="getRoles" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset arguments.filter = extend({
			isArchived = false,
			orderBy = 'role',
			orderSort = 'asc'
		}, arguments.filter) />
		
		<cfquery name="local.results" datasource="#variables.datasource.name#">
			SELECT r."roleID", r."role", s."schemeID", s."scheme"
			FROM "#variables.datasource.prefix#user"."role" r
			JOIN "#variables.datasource.prefix#user"."scheme" s
				ON r."schemeID" = s."schemeID"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					r."role" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR r."description" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'schemeID') and arguments.filter.schemeID neq ''>
				AND r."schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				AND r."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
				AND s."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					r."role" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="setNavigation" access="public" returntype="void" output="false">
		<cfargument name="navigation" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<cfset observer = getPluginObserver('user', 'navigation') />
		
		<cfset scrub__model(arguments.role) />
		<cfset validate__model(arguments.role) />
		
		<cfset observer.beforeSave(variables.transport, arguments.navigation) />
		
		
		
		<cfset observer.afterSave(variables.transport, arguments.navigation) />
	</cffunction>
</cfcomponent>
