<cfset viewSchemePermission = application.managers.transient.getViewSchemePermissionForUser(theURL) />

<cfset filter = {
	} />

<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfoutput>#viewSchemePermission.list( permissions, filter )#</cfoutput>