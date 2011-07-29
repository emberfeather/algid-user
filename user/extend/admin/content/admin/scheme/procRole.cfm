<cfif theUrl.search('role') eq ''>
	<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset servRole = services.get('user', 'role') />

<cfset role = servRole.getRole( theURL.search('role') ) />

<!--- Add to the current levels --->
<cfset theUrl.setRole('_base', '/admin/scheme/role') />
<cfset template.addLevel(role.getRole(), role.getRole(), theUrl.getRole(), 0, true) />
