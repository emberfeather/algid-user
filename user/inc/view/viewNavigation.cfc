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
					'_base' = '/admin/scheme/navigation/edit'
				}
			],
			linkClass = [ '' ],
			title = 'role'
		}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
	
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="role" type="component" required="true" />
		<cfargument name="navigation" type="query" required="true" />
		
		<cfset local.i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset local.theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset local.theForm = variables.transport.theApplication.factories.transient.getForm('navigation', i18n) />
		
		<cfset theForm.addBundle('plugins/user/i18n/inc/view', 'viewNavigation') />
		<cfset theForm.addFormElement(variables.transport.theApplication.factories.transient.getFormElementForUser()) />
		
		<cfset local.options = variables.transport.theApplication.factories.transient.getOptions() />
		
		<cfset local.options.addOption(theForm.getLabel('allow'), 'allow') />
		<cfset local.options.addOption(theForm.getLabel('deny'), 'deny') />
		
		<cfset local.roleID = arguments.role.getRoleID() />
		<cfset local.parentPath = '' />
		
		<cfloop query="arguments.navigation">
			<cfset local.inputName = replace(right(arguments.navigation.path, len(arguments.navigation.path) -1), '/', '.', 'all') />
			
			<cfset local.theForm.addElement('navigation', {
				name = replace(right(arguments.navigation.path, len(arguments.navigation.path) -1), '/', '.', 'all'),
				label = "",
				level = arguments.navigation.level,
				path = arguments.navigation.path,
				value = getAccess(local.roleID, arguments.navigation.secureOrder, arguments.navigation.allow, arguments.navigation.deny),
				options = local.options
			}) />
		</cfloop>
		
		<cfreturn theForm.toHTML(theURL.get(), { class: 'condensed' }) />
	</cffunction>
	
	<cffunction name="getAccess" access="private" returntype="string" output="false">
		<cfargument name="role" type="string" required="true" />
		<cfargument name="secureOrder" type="string" required="true" />
		<cfargument name="allow" type="string" required="true" />
		<cfargument name="deny" type="string" required="true" />
		
		<cfif arguments.secureOrder eq 'allow,deny'>
			<!--- Everyone is allowed --->
			<cfif arguments.allow eq '*'>
				<cfreturn 'allow' />
			</cfif>
			
			<!--- Has explicit permission --->
			<cfif listFind(arguments.allow, arguments.role)>
				<cfreturn 'allow' />
			</cfif>
			
			<!--- Everyone is blocked --->
			<cfif arguments.deny eq '*'>
				<cfreturn 'deny' />
			</cfif>
			
			<!--- Is not explicitly blocked --->
			<cfif listFind(arguments.deny, arguments.role)>
				<cfreturn 'deny' />
			</cfif>
		<cfelse>
			<!--- Everyone is blocked --->
			<cfif arguments.deny eq '*'>
				<cfreturn 'deny' />
			</cfif>
			
			<!--- Is not explicitly blocked --->
			<cfif listFind(arguments.deny, arguments.role)>
				<cfreturn 'deny' />
			</cfif>
			
			<!--- Everyone is allowed --->
			<cfif arguments.allow eq '*'>
				<cfreturn 'allow' />
			</cfif>
			
			<!--- Has explicit permission --->
			<cfif listFind(arguments.allow, arguments.role)>
				<cfreturn 'allow' />
			</cfif>
		</cfif>
		
		<cfreturn 'inherit' />
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
