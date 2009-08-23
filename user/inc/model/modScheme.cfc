<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Scheme ID --->
		<cfset attr = {
				attribute = 'schemeID',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Created On --->
		<cfset attr = {
				attribute = 'createdOn',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Scheme --->
		<cfset attr = {
				attribute = 'scheme',
				validation = {
					minLength = 5,
					maxLength = 50
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Updated By --->
		<cfset attr = {
				attribute = 'updatedBy',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Updated On --->
		<cfset attr = {
				attribute = 'updatedOn',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modScheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>