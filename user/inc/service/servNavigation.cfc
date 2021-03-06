<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getCurrentNavigation" access="public" returntype="query" output="false">
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
	
	<cffunction name="getNavigation" access="public" returntype="component" output="false">
		<cfset local.navigation = getModel('user', 'navigation') />
		
		<cfset local.plugin = variables.transport.theApplication.managers.plugin.getUser() />
		
		<cfif fileExists(local.plugin.getStoragePath() & '/extend/admin/navigation/roles.xml.cfm')>
			<cfset local.navigation.setNavigation(xmlParse(fileRead(local.plugin.getStoragePath() & '/extend/admin/navigation/roles.xml.cfm'))) />
		</cfif>
		
		<cfreturn local.navigation />
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
		
		<cfset local.observer = getPluginObserver('user', 'navigation') />
		
		<cfset scrub__model(arguments.navigation) />
		<cfset validate__model(arguments.navigation) />
		
		<cfset local.observer.beforeSave(variables.transport, arguments.navigation) />
		
		<cfset local.plugin = variables.transport.theApplication.managers.plugin.getUser() />
		
		<cfset fileWrite(local.plugin.getStoragePath() & '/extend/admin/navigation/roles.xml.cfm', toString(arguments.navigation.getNavigation())) />
		
		<cfset local.observer.afterSave(variables.transport, arguments.navigation) />
	</cffunction>
</cfcomponent>
