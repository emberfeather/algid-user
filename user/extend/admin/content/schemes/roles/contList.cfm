<cfset viewSchemeTag = application.factories.transient.getViewSchemeTagForUser( transport ) />

<cfset filter = {
	} />

<cfset users = servSchemeTag.readTagUsers( filter ) />

<cfoutput>#viewSchemeTag.list( users )#</cfoutput>