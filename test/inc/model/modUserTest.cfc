<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
	</cffunction>
	
	<cffunction name="testGetPermissions" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'take') />
		<cfset user.addPermissions('scheme', 'give') />
		
		<cfset assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme')), 'text')) />
	</cffunction>
	
	<cffunction name="testGetPermissionsWithMultiScheme" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'take') />
		<cfset user.addPermissions('plan', 'give') />
		
		<cfset assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme,plan')), 'text')) />
	</cffunction>
	
	<cffunction name="testGetPermissionsWithMultiSchemeDuplicates" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'take') />
		<cfset user.addPermissions('plan', 'give') />
		<cfset user.addPermissions('plan', 'take') />
		
		<cfset assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme,plan')), 'text')) />
	</cffunction>
	
	<cffunction name="testGetPermissionsWithMultiSchemeWildcard" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'take') />
		<cfset user.addPermissions('plan', 'give') />
		<cfset user.addPermissions('devise', 'plunder') />
		
		<cfset assertEquals('give,plunder,take', listSort(arrayToList(user.getPermissions('*')), 'text')) />
	</cffunction>
	
	<cffunction name="testHasPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'give') />
		
		<cfset assertTrue(user.hasPermission('give', 'scheme'), 'The permission should exist for the scheme.') />
	</cffunction>
	
	<cffunction name="testHasPermissionSansPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset assertFalse(user.hasPermission('give', 'scheme'), 'The permission should not exist for the scheme') />
	</cffunction>
	
	<cffunction name="testHasPermissionWithMultiScheme" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'take') />
		<cfset user.addPermissions('plan', 'give') />
		
		<cfset assertTrue(user.hasPermission('give', 'scheme,plan'), 'The permission should exist in one of the scheme.') />
	</cffunction>
	
	<cffunction name="testHasPermissionsWithOneScheme" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'give,grant') />
		
		<cfset assertTrue(user.hasPermissions('give,grant', 'scheme'), 'The permissions should exist for the scheme.') />
	</cffunction>
	
	<cffunction name="testHasPermissionsWithOneSchemeFailMissingPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'give') />
		
		<cfset assertFalse(user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.') />
	</cffunction>
	
	<cffunction name="testHasPermissionsWithMultiSchemeParts" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'give') />
		<cfset user.addPermissions('plan', 'grant') />
		
		<cfset assertTrue(user.hasPermissions('give,grant', 'scheme,plan'), 'The permissions should exist for the scheme.') />
	</cffunction>
	
	<cffunction name="testHasPermissionsWithMultiSchemeFailMissingPermission" access="public" returntype="void" output="false">
		<cfset var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n) />
		
		<cfset user.addPermissions('scheme', 'give') />
		<cfset user.addPermissions('plan', 'steal') />
		
		<cfset assertFalse(user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.') />
	</cffunction>
</cfcomponent>