<cfset servRole = transport.theApplication.factories.transient.getServRoleForUser(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />
<cfset servScheme = transport.theApplication.factories.transient.getServSchemeForUser(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Check for existing schemes --->
<cfset schemes = servScheme.getSchemes() />

<!--- If no schemes redirect to the domain add page with message --->
<cfif schemes.recordCount eq 0>
	<cfset message = transport.theSession.managers.singleton.getMessage() />
	
	<!--- TODO Use i18n --->
	<cfset message.addMessages('A scheme is needed before adding roles.') />
	
	<cfset theUrl.setRedirect('_base', '/admin/scheme/add') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<!--- Retrieve the object --->
<cfset role = servRole.getRole( theURL.search('role') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset objectSerial.deserialize(form, role) />
	
	<cfset servRole.setRole( session.managers.singleton.getUser(), role ) />
	
	<!--- Add a success message --->
	<cfset session.managers.singleton.getSuccess().addMessages('The role ''' & role.getRole() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
	<cfset theURL.removeRedirect('role') />
	
	<cfset theURL.redirectRedirect() />
</cfif>
