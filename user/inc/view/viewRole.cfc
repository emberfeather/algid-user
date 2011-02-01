<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="role" type="component" required="true" />
		<cfargument name="schemes" type="query" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var i18n = '' />
		<cfset var element = '' />
		<cfset var theForm = '' />
		<cfset var theURL = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getFormStandard('role', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/user/i18n/inc/view', 'viewRole') />
		
		<!--- Scheme --->
		<cfif arguments.schemes.recordCount GT 1>
			<!--- Select --->
			<cfset element = {
					name = "schemeID",
					label = "scheme",
					options = variables.transport.theApplication.factories.transient.getOptions(),
					value = ( structKeyExists(arguments.request, 'schemeID') ? arguments.request.schemeID : arguments.role.getSchemeID() )
				} />
			
			<!--- Create the options for the select --->
			<cfloop query="arguments.schemes">
				<cfset element.options.addOption(arguments.schemes.scheme, arguments.schemes.schemeID.toString()) />
			</cfloop>
			
			<cfset theForm.addElement('select', element) />
		<cfelse>
			<!--- Hidden --->
			<cfset theForm.addElement('hidden', {
					name = "schemeID",
					label = "scheme",
					value = arguments.schemes.schemeID
				}) />
		</cfif>
		
		<!--- Role --->
		<cfset theForm.addElement('text', {
				name = "role",
				label = "role",
				value = ( structKeyExists(arguments.request, 'role') ? arguments.request.role : arguments.role.getRole() )
			}) />
		
		<!--- Description --->
		<cfset theForm.addElement('textarea', {
				name = "description",
				label = "description",
				value = ( structKeyExists(arguments.request, 'description') ? arguments.request.description : arguments.role.getDescription() )
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
		<cfset filterActive.addBundle('plugins/user/i18n/inc/view', 'viewRole') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="values" type="struct" default="#{}#" />
		<cfargument name="schemes" type="query" required="true" />
		
		<cfset var options = '' />
		<cfset var filter = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/user/i18n/inc/view', 'viewRole') />
		
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
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/user/i18n/inc/view', 'viewRole') />
		
		<cfset datagrid.addColumn({
				key = 'role',
				label = 'role',
				link = {
					'role' = 'roleID',
					'_base' = '/admin/scheme/role/detail'
				}
			}) />
		
		<cfset datagrid.addColumn({
				key = 'description',
				label = 'description'
			}) />
		
		<cfset datagrid.addColumn({
				class = 'phantom align-right',
				value = [ 'delete', 'edit' ],
				link = [
					{
						'role' = 'roleID',
						'_base' = '/admin/scheme/role/archive'
					},
					{
						'role' = 'roleID',
						'_base' = '/admin/scheme/role/edit'
					}
				],
				linkClass = [ 'delete', '' ],
				title = 'role'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>
