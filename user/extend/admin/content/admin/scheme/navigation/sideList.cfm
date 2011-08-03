<cfset viewNavigation = views.get('user', 'navigation') />

<!--- Get existing schemes --->
<cfset schemes = servScheme.getSchemes() />

<cfset filter = {
	'search' = theURL.search('search'),
	'schemeID' = theURL.search('scheme')
} />

<cfoutput>
	#viewNavigation.filter( filter, schemes )#
</cfoutput>
