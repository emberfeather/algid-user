<cfset viewUser = transport.theApplication.factories.transient.getViewUserForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewUser.filter( filter )#
</cfoutput>
