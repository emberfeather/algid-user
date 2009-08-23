<cfset viewSchemeTag = createObject('component', 'plugins.user.inc.view.viewSchemeTag').init(theURL) />

<cfset filter = {
	} />

<cfset users = servSchemeTag.readTagUsers( filter ) />

<cfoutput>#viewSchemeTag.list( users, filter )#</cfoutput>