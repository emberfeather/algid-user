<cfset viewRole = views.get('user', 'role') />

<!--- Get existing schemes --->
<cfset schemes = servScheme.getSchemes() />

<cfset filter = {
		'search' = theURL.search('search'),
		'schemeID' = theURL.search('scheme')
	} />

<cfoutput>
	#viewRole.filter( filter, schemes )#
</cfoutput>
