<cfset viewRole = views.get('user', 'role') />

<cfoutput>
	#viewRole.edit(role, schemes, form)#
</cfoutput>
