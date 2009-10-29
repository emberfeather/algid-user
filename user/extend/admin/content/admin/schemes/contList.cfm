<cfset viewScheme = application.factories.transient.getViewSchemeForUser( transport ) />

<cfset filter = {
	} />

<cfset schemes = servScheme.readSchemes( filter ) />

<cfoutput>#viewScheme.list( schemes )#</cfoutput>