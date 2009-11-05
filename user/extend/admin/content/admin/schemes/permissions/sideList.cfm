<cfset viewSchemePermission = application.factories.transient.getViewSchemePermissionForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewSchemePermission.filter( filter )#
</cfoutput>