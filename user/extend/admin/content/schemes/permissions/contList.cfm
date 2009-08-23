<cfset viewSchemePermission = createObject('component', 'plugins.user.inc.view.viewSchemePermission').init(theURL) />

<cfset filter = {
	} />

<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfoutput>#viewSchemePermission.list( permissions, filter )#</cfoutput>