<cfset viewSchemePermission = application.factories.transient.getViewSchemePermissionForUser( transport ) />

<cfset filter = {
	} />

<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfoutput>#viewSchemePermission.list( permissions )#</cfoutput>