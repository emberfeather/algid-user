<cfset viewSchemePermission = application.factories.transient.getViewSchemePermissionForUser(theURL) />

<cfset filter = {
	} />

<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfoutput>#viewSchemePermission.list( permissions, filter )#</cfoutput>