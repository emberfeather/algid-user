<cfset viewScheme = views.get('user', 'scheme') />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewScheme.filter( filter )#
</cfoutput>