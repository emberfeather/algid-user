<cfset servSchemeTag = transport.theApplication.factories.transient.getServSchemeTagForUser(application.app.getDSUpdate(), transport) />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cflocation url="#theURL.get('', false)#" addtoken="false" />
</cfif>
