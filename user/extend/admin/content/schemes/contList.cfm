<cfset viewScheme = application.factories.transient.getViewSchemeForUser(theURL) />

<cfset filter = {
	} />

<cfset schemes = servScheme.readSchemes( filter ) />

<cfoutput>#viewScheme.list( schemes, filter )#</cfoutput>