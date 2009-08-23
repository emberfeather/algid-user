<cfset viewScheme = createObject('component', 'plugins.user.inc.view.viewScheme').init(theURL) />

<cfset filter = {
	} />

<cfset schemes = servScheme.readSchemes( filter ) />

<cfoutput>#viewScheme.list( schemes, filter )#</cfoutput>