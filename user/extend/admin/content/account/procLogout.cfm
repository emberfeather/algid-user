<!--- Recreate the session --->
<cfset sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />

<!--- Restart the session --->
<cfset sparkplug.start( application, session ) />

<!--- Redirect to the main page --->
<cfset theURL.cleanRedirect() />

<cfset theURL.redirectRedirect() />
