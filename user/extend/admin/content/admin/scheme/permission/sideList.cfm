<cfset viewSchemePermission = views.get('user', 'schemePermission') />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewSchemePermission.filter( filter )#
</cfoutput>