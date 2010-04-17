<cfset servScheme = transport.theApplication.factories.transient.getServSchemeForUser(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset scheme = servScheme.getScheme( theURL.search('scheme') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset objectSerial.deserialize(form, scheme) />
	
	<cfset servScheme.setScheme( session.managers.singleton.getUser(), scheme ) />
	
	<!--- Add a success message --->
	<cfset session.managers.singleton.getSuccess().addMessages('The scheme ''' & scheme.getScheme() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/scheme/list') />
	<cfset theURL.removeRedirect('scheme') />
	
	<cfset theURL.redirectRedirect() />
</cfif>
