<cfset viewScheme = transport.theApplication.factories.transient.getViewSchemeForUser( transport ) />

<cfoutput>
	#viewScheme.edit(scheme, form)#
</cfoutput>
