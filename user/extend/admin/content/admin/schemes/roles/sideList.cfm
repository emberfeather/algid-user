<cfset viewSchemeTag = application.factories.transient.getViewSchemeTagForUser( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewSchemeTag.filter( filter )#
</cfoutput>