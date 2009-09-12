<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- User ID --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'userID',
				validation = {
				}
			}) />
		
		<!--- Permissions --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'permissions',
				defaultValue = {}
			}) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modUser') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addPermissions" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="string" required="true" />
		<cfargument name="permissions" type="string" required="true" />
		
		<cfset var permission = '' />
		
		<cfif NOT structKeyExists(variables.instance['permissions'], arguments.scheme)>
			<cfset variables.instance['permissions'][arguments.scheme] = [] />
		</cfif>
		
		<cfloop list="#arguments.permissions#" index="permission">
			<cfset arrayAppend(variables.instance['permissions'][arguments.scheme], permission) />
		</cfloop>
	</cffunction>
	
	<cffunction name="hasPermission" access="public" returntype="boolean" output="false">
		<cfargument name="permission" type="string" required="true" />
		<cfargument name="schemes" type="string" required="true" />
		
		<cfset var scheme = '' />
		
		<cfloop list="#arguments.schemes#" index="scheme">
			<cfif structKeyExists(variables.instance['permissions'], scheme) AND arrayFind(variables.instance['permissions'][scheme], arguments.permission)>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="hasPermissions" access="public" returntype="boolean" output="false">
		<cfargument name="permissions" type="string" required="true" />
		<cfargument name="schemes" type="string" required="true" />
		
		<cfset var permission = '' />
		
		<cfloop list="#arguments.permissions#" index="permission">
			<cfif NOT hasPermission(permission, arguments.schemes)>
				<cfreturn false />
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>