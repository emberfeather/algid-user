<cfset viewScheme = application.factories.transient.getViewSchemeForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewScheme.filter( filter )#
</cfoutput>