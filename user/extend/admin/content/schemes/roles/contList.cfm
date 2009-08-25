<cfset viewSchemeTag = application.managers.transient.getViewSchemeTagForUser(theURL) />

<cfset filter = {
	} />

<cfset users = servSchemeTag.readTagUsers( filter ) />

<cfoutput>#viewSchemeTag.list( users, filter )#</cfoutput>