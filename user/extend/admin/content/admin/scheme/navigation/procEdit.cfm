<cfif theUrl.search('role') eq ''>
	<cfset theURL.setRedirect('_base', '/admin/scheme/navigation/list') />
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset servNavigation = services.get('user', 'navigation') />
<cfset servRole = services.get('user', 'role') />

<!--- Retrieve the object --->
<cfset role = servRole.getRole( theURL.search('role') ) />

<cfif cgi.request_method eq 'post'>
	<!--- TODO Remove --->
	<cfdump var="#form#" />
	<cfabort />
	
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, role) />
	
	<cfset servRole.setRole( role ) />
	<cfset servRole.setRoleUsers( role, listToArray(form.users) ) />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/scheme/navigation/list') />
	<cfset theURL.removeRedirect('role') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<!--- Add to the current levels --->
<cfset theUrl.setRole('_base', '/admin/scheme/role') />
<cfset template.addLevel(role.getRole(), role.getRole(), theUrl.getRole(), 0, true) />

<cfset template.addStyle(transport.theRequest.webRoot & 'plugins/user/style/admin/navigation.css') />
<cfset template.addScripts(transport.theRequest.webRoot & 'plugins/user/script/admin/jquery.navigation.js') />
