<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Role ID --->
		<cfset addAttribute(
				attribute = 'roleID'
			) />
		
		<!--- Description --->
		<cfset addAttribute(
				attribute = 'description'
			) />
		
		<!--- Role --->
		<cfset addAttribute(
				attribute = 'role',
				validation = {
					minLength = 5,
					maxLength = 100
				}
			) />
		
		<!--- Scheme ID --->
		<cfset addAttribute(
				attribute = 'schemeID'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modRole') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
