<cfset viewRole = transport.theApplication.factories.transient.getViewRoleForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewRole.filter( filter )#
</cfoutput>