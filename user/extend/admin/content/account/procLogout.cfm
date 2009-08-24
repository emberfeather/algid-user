<!--- Recreate the SESSION --->
<cfset sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />

<!--- Lock the session scope --->
<cflock scope="session" type="exclusive" timeout="5">
	<!--- Restart the session --->
	<cfset sparkplug.restart( application, SESSION ) />
</cflock>

<!--- Redirect to the main page --->
<cfset theURL.cleanRedirect() />

<cflocation url="#theURL.getRedirect(false)#" addtoken="false" />