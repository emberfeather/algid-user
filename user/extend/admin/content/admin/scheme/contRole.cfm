<cfset viewRole = views.get('user', 'role') />

<cfset roleUsers = servRole.getUsers(role, { inRole: true }) />
<cfset users = servRole.getUsers(role, { inRole: false }) />

<cfoutput>
	#viewRole.editUsers(role, roleUsers, users)#
</cfoutput>
