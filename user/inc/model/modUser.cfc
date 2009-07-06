<cfcomponent extends="cf-compendium.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
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
		
		<!--- Last Name --->
		<cfset attr = {
				attribute = 'lastName'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Email --->
		<cfset attr = {
				attribute = 'email'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modUser') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>