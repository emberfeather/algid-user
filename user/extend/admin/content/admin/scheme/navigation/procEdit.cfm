<cfif theUrl.search('role') eq ''>
	<cfset theURL.setRedirect('_base', '/admin/scheme/navigation/list') />
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset servNavigation = services.get('user', 'navigation') />
<cfset servRole = services.get('user', 'role') />

<cfset role = servRole.getRole( theURL.search('role') ) />
<cfset navigation = servNavigation.getNavigation() />

<cfif cgi.request_method eq 'post'>
	<cfset fields = listSort(form.fieldnames, 'text') />
	
	<cfset changes = {} />
	
	<cfloop list="#fields#" index="i">
		<cfset last = listLast(i, '/') />
		<cfset partParent = len(i) gt len(last) ? left(i, len(i) - len(last) - 1) : '' />
		
		<cfif partParent eq '' || not structKeyExists(form, 'partParent') || form[partParent] neq form[i]>
			<cfset changes[i] = form[i] />
		</cfif>
	</cfloop>
	
	<cfset navigation.applyChanges(role.getRoleID(), changes) />
	
	<cfset servNavigation.setNavigation( navigation ) />
	
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
