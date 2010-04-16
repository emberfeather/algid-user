<!--- Trigger the session end --->
<cfset transport.theSession.sparkplug.end( transport.theApplication, transport.theSession ) />

<!--- Recreate the session --->
<cfset transport.theSession.sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />

<!--- Restart the session --->
<cfset transport.theSession.sparkplug.start( transport.theApplication, transport.theSession ) />

<!--- Redirect to the main page --->
<cfset theURL.cleanRedirect() />

<cfset theURL.redirectRedirect() />
