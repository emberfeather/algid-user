<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="scheme" type="component" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var i18n = '' />
		<cfset var theForm = '' />
		<cfset var theURL = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getFormStandard('scheme', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/user/i18n/inc/view', 'viewScheme') />
		
		<!--- Scheme --->
		<cfset theForm.addElement('text', {
				name = "scheme",
				label = "scheme",
				value = ( structKeyExists(arguments.request, 'scheme') ? arguments.request.scheme : arguments.scheme.getScheme() )
			}) />
		
		<cfreturn theForm.toHTML(theURL.get()) />
	</cffunction>
	
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/user/i18n/inc/view', 'viewScheme') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="values" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/user/i18n/inc/view', 'viewScheme') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL(), arguments.values) />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/user/i18n/inc/view', 'viewScheme') />
		
		<cfset datagrid.addColumn({
				key = 'scheme',
				label = 'Scheme',
				link = {
					'scheme' = 'schemeID',
					'_base' = '/admin/scheme/detail'
				}
			}) />
		
		<cfset datagrid.addColumn({
				class = 'phantom align-right',
				value = [ 'delete', 'edit' ],
				link = [
					{
						'scheme' = 'schemeID',
						'_base' = '/admin/scheme/archive'
					},
					{
						'scheme' = 'schemeID',
						'_base' = '/admin/scheme/edit'
					}
				],
				linkClass = [ 'delete', '' ],
				title = 'scheme'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>
