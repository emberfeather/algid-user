<cfset servRole = transport.theApplication.factories.transient.getServRoleForUser(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset role = servRole.getRole( session.managers.singleton.getUser(), theURL.search('role') ) />

<cfset servRole.archiveRole( session.managers.singleton.getUser(), role ) />

<!--- Add a success message --->
<cfset session.managers.singleton.getSuccess().addMessages('The role ''' & role.getRole() & ''' was successfully removed.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
<cfset theURL.removeRedirect('role') />

<cfset theURL.redirectRedirect() />
