<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Permission ID --->
		<cfset addAttribute(
				attribute = 'permissionID',
				validation = {
				}
			) />
		
		<!--- Description --->
		<cfset addAttribute(
				attribute = 'description',
				validation = {
				}
			) />
		
		<!--- Key --->
		<cfset addAttribute(
				attribute = 'key',
				validation = {
				}
			) />
		
		<!--- Permission --->
		<cfset addAttribute(
				attribute = 'permission',
				validation = {
					minLength = 5,
					maxLength = 50
				}
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset addBundle('plugins/user/i18n/inc/model', 'modPermission') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>