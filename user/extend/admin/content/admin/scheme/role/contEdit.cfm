<cfset viewRole = transport.theApplication.factories.transient.getViewRoleForUser( transport ) />

<cfoutput>
	#viewRole.edit(role, schemes, form)#
</cfoutput>
