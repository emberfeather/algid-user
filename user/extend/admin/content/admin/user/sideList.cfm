<cfset viewUser = views.get('user', 'user') />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewUser.filter( filter )#
</cfoutput>
