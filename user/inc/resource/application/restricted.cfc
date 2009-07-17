<!--- Restricts the application to only logged-in users --->
<cfcomponent extends="plugins.error.inc.resource.application.error" output="false">
	<cffunction name="onError" access="public" returntype="void" output="false">
		<cfargument name="exception" type="struct" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<!--- TODO Check if a user is logged in --->
		<cfif 1 EQ 1>
			<!--- Dump out the error --->
			<cfdump var="#arguments.exception#" /><cfabort />
		<cfelse>
			<cfset super.onError(argumentCollection = arguments) />
		</cfif>
	</cffunction>
</cfcomponent>