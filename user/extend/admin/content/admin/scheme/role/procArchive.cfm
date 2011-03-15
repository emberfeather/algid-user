<cfset servRole = services.get('user', 'role') />

<!--- Retrieve the object --->
<cfset role = servRole.getRole( theURL.search('role') ) />

<cfset servRole.archiveRole( role ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
<cfset theURL.removeRedirect('role') />

<cfset theURL.redirectRedirect() />
