<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Scheme ID --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'schemeID',
				validation = {
				}
			}) />
		
		<!--- Created On --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'createdOn',
				validation = {
				}
			}) />
		
		<!--- Scheme --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'scheme',
				validation = {
					minLength = 5,
					maxLength = 50
				}
			}) />
		
		<!--- Updated By --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'updatedBy',
				validation = {
				}
			}) />
		
		<!--- Updated On --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'updatedOn',
				validation = {
				}
			}) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modScheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>