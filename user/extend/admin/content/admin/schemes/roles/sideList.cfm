<cfset viewSchemeTag = transport.theApplication.factories.transient.getViewSchemeTagForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewSchemeTag.filter( filter )#
</cfoutput>