<cfset viewSchemePermission = transport.theApplication.factories.transient.getViewSchemePermissionForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewSchemePermission.filter( filter )#
</cfoutput>