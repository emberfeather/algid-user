<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="login" access="public" returntype="string" output="false">
		<cfreturn 'This functionality needs to be overridden by another plugin.' />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- TODO Remove --->
		<cfdump var="#arguments.data#" />
		<cfabort />
		
		<cfset datagrid.addColumn({
				key = 'path',
				label = 'Path'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>