<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addI18NBundle('plugins/user/i18n/inc/view', 'viewSchemePermission') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilter(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addI18NBundle('plugins/user/i18n/inc/view', 'viewSchemePermission') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.locale) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addI18NBundle('plugins/user/i18n/inc/view', 'viewSchemePermission') />
		
		<cfset datagrid.addColumn({
				key = 'permission',
				label = 'permission'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'description',
				label = 'description'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>