<cfset servRole = services.get('user', 'role') />
<cfset servScheme = services.get('user', 'scheme') />

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
	<cfset modelSerial.deserialize(form, role) />
	
	<cfset servRole.setRole( session.managers.singleton.getUser(), role ) />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/scheme/role/list') />
	<cfset theURL.removeRedirect('role') />
	
	<cfset theURL.redirectRedirect() />
</cfif>
