<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Role ID --->
		<cfset add__attribute(
			attribute = 'roleID'
		) />
		
		<!--- Description --->
		<cfset add__attribute(
			attribute = 'description'
		) />
		
		<!--- Role --->
		<cfset add__attribute(
			attribute = 'role',
			validation = {
				notEmpty = true,
				maxLength = 100
			}
		) />
		
		<!--- Scheme ID --->
		<cfset add__attribute(
			attribute = 'schemeID'
		) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/user/i18n/inc/model', 'modRole') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
