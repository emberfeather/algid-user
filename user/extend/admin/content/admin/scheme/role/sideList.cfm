<cfset viewRole = transport.theApplication.factories.transient.getViewRoleForUser( transport ) />

<!--- Get existing schemes --->
<cfset schemes = servScheme.getSchemes() />

<cfset filter = {
		'search' = theURL.search('search'),
		'schemeID' = theURL.search('scheme')
	} />

<cfoutput>
	#viewRole.filter( filter, schemes )#
</cfoutput>
