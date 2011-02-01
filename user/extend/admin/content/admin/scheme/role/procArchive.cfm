<cfset servRole = services.get('user', 'role') />

<!--- Retrieve the object --->
<cfset role = servRole.getRole( session.managers.singleton.getUser(), theURL.search('role') ) />

<cfset servRole.archiveRole( session.managers.singleton.getUser(), role ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
<cfset theURL.removeRedirect('role') />

<cfset theURL.redirectRedirect() />
