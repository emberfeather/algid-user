<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/user/i18n/inc/view', 'viewNavigation') />
		
		<cfset datagrid.addColumn({
			key = 'scheme',
			label = 'scheme',
			link = {
				'scheme' = 'schemeID',
				'_base' = '/admin/scheme'
			}
		}) />
		
		<cfset datagrid.addColumn({
			key = 'role',
			label = 'role',
			link = {
				'role' = 'roleID',
				'_base' = '/admin/scheme/role'
			}
		}) />
		
		<cfset datagrid.addColumn({
			class = 'phantom align-right',
			value = [ 'edit' ],
			link = [
				{
					'role' = 'roleID',
					'scheme' = 'schemeID',
					'_base' = '/admin/scheme/navigation/edit'
				}
			],
			linkClass = [ '' ],
			title = 'role'
		}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
	
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="navigation" type="struct" required="true" />
		<cfargument name="roleNavigation" type="struct" required="true" />
		
		<cfsavecontent variable="local.html">
			<cfoutput>
				
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.html />
	</cffunction>
	
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/user/i18n/inc/view', 'viewNavigation') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="values" type="struct" default="#{}#" />
		<cfargument name="schemes" type="query" required="true" />
		
		<cfset var options = '' />
		<cfset var filter = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/user/i18n/inc/view', 'viewNavigation') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<!--- Scheme --->
		<cfif arguments.schemes.recordCount>
			<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
			
			<!--- TODO use i18n --->
			<cfset options.addOption('All Schemes', '') />
			
			<cfloop query="arguments.schemes">
				<cfset options.addOption(arguments.schemes.scheme, arguments.schemes.schemeID.toString()) />
			</cfloop>
			
			<cfset filter.addFilter('schemeID', options) />
		</cfif>
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL(), arguments.values) />
	</cffunction>
</cfcomponent>
