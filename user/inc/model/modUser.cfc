<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- User ID --->
		<cfset addAttribute(
				attribute = 'userID'
			) />
		
		<!--- Full Name --->
		<cfset addAttribute(
				attribute = 'fullname',
				defaultValue = 'Guest'
			) />
		
		<!--- Is Deity? --->
		<cfset addAttribute(
				attribute = 'isDeity',
				defaultValue = false
			) />
		
		<!--- Language --->
		<cfset addAttribute(
				attribute = 'language',
				defaultValue = 'en-US'
			) />
		
		<!--- Username --->
		<cfset addAttribute(
				attribute = 'username'
			) />
		
		<!--- Permissions --->
		<cfset addAttribute(
				attribute = 'permissions',
				defaultValue = {}
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modUser') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addPermissions" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="string" required="true" />
		<cfargument name="permissions" type="string" required="true" />
		
		<cfset var permission = '' />
		
		<cfif not structKeyExists(variables.instance['permissions'], arguments.scheme)>
			<cfset variables.instance['permissions'][arguments.scheme] = [] />
		</cfif>
		
		<cfloop list="#arguments.permissions#" index="permission">
			<cfset arrayAppend(variables.instance['permissions'][arguments.scheme], permission) />
		</cfloop>
	</cffunction>
	
	<cffunction name="getDisplayName" access="public" returntype="string" output="false">
		<cfreturn variables.instance['fullname'] />
	</cffunction>
	
	<cffunction name="getPermissions" access="public" returntype="array" output="false">
		<cfargument name="schemes" type="string" required="true" />
		
		<cfset var permission = '' />
		<cfset var permissions = [] />
		<cfset var scheme = '' />
		
		<!--- If wildcard, return them all --->
		<cfif arguments.schemes eq '*'>
			<cfset arguments.schemes = structKeyList(variables.instance['permissions']) />
		</cfif>
		
		<!--- Find all the permissions for each of the desired schemes --->
		<cfloop list="#arguments.schemes#" index="scheme">
			<cfif structKeyExists(variables.instance['permissions'], scheme)>
				<cfloop array="#variables.instance['permissions'][scheme]#" index="permission">
					<!--- Prevent duplicate permissions --->
					<cfif not arrayFind(permissions, permission)>
						<cfset arrayAppend(permissions, permission) />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn permissions />
	</cffunction>
	
	<cffunction name="hasPermission" access="public" returntype="boolean" output="false">
		<cfargument name="permission" type="string" required="true" />
		<cfargument name="schemes" type="string" required="true" />
		
		<cfset var scheme = '' />
		
		<!--- Check for master users --->
		<cfif this.getIsDeity() eq true>
			<cfreturn true />
		</cfif>
		
		<cfloop list="#arguments.schemes#" index="scheme">
			<cfif structKeyExists(variables.instance['permissions'], scheme) and arrayFind(variables.instance['permissions'][scheme], arguments.permission)>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="hasPermissions" access="public" returntype="boolean" output="false">
		<cfargument name="permissions" type="string" required="true" />
		<cfargument name="schemes" type="string" required="true" />
		
		<cfset var permission = '' />
		
		<!--- Check for master users --->
		<cfif this.getIsDeity() eq true>
			<cfreturn true />
		</cfif>
		
		<cfloop list="#arguments.permissions#" index="permission">
			<cfif not hasPermission(permission, arguments.schemes)>
				<cfreturn false />
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
		<cfreturn this.getUserID() neq '' />
	</cffunction>
</cfcomponent>