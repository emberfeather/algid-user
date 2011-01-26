<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Scheme ID --->
		<cfset add__attribute(
				attribute = 'schemeID'
			) />
		
		<!--- Created On --->
		<cfset add__attribute(
				attribute = 'createdOn'
			) />
		
		<!--- Scheme --->
		<cfset add__attribute(
				attribute = 'scheme',
				validation = {
					minLength = 5,
					maxLength = 50
				}
			) />
		
		<!--- Updated On --->
		<cfset add__attribute(
				attribute = 'updatedOn'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/user/i18n/inc/model', 'modScheme') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
