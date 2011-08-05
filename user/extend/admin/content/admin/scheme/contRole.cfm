<cfset viewRole = views.get('user', 'role') />

<cfset roleUsers = servRole.getUsers(role, { inRole: true }) />

<cfoutput>
	#viewRole.detail(role, roleUsers)#
</cfoutput>
