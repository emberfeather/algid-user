<cfset viewSchemeTag = application.factories.transient.getViewSchemeTagForUser(theURL) />

<cfset filter = {
	} />

<cfset users = servSchemeTag.readTagUsers( filter ) />

<cfoutput>#viewSchemeTag.list( users, filter )#</cfoutput>