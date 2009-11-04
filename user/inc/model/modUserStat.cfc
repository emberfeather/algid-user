<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- User ID --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'userID',
				defaultValue = 0
			}) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modUserStat') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>