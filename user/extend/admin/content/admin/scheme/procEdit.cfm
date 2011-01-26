<cfset servScheme = services.get('user', 'scheme') />

<!--- Retrieve the object --->
<cfset scheme = servScheme.getScheme( theURL.search('scheme') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, scheme) />
	
	<cfset servScheme.setScheme( session.managers.singleton.getUser(), scheme ) />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/scheme/list') />
	<cfset theURL.removeRedirect('scheme') />
	
	<cfset theURL.redirectRedirect() />
</cfif>
