<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- User ID --->
		<cfset attr = {
				attribute = 'userID',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Username --->
		<cfset attr = {
				attribute = 'username',
				validation = {
					minLength = 5,
					maxLength = 45
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- First Name --->
		<cfset attr = {
				attribute = 'firstName'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Email --->
		<cfset attr = {
				attribute = 'email'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Last Name --->
		<cfset attr = {
				attribute = 'lastName'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Permissions --->
		<cfset attr = {
				attribute = 'permissions',
				defaultValue = []
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modUser') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="hasPermission" access="public" returntype="boolean" output="false">
		<cfargument name="permission" type="string" required="true" />
		
		<cfreturn arrayFind(variables.instance['permissions'], arguments.permission) />
	</cffunction>
</cfcomponent>