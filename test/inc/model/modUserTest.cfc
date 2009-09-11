<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
	</cffunction>
	
	<cffunction name="testHasPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('testing') />
		
		<cfset assertTrue(user.hasPermission('testing')) />
	</cffunction>
	
	<cffunction name="testHasPermissionSansPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset assertFalse(user.hasPermission('testing')) />
	</cffunction>
</cfcomponent>