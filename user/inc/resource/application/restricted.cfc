<!--- Restricts the application to only logged-in users --->
<cfcomponent extends="plugins.error.inc.resource.application.error" output="false">
	<cfset this.name = 'user-restricted' />
	<cfset this.applicationTimeout = createTimeSpan(2, 0, 0, 0) />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0) />
	
	<cffunction name="onError" access="public" returntype="void" output="false">
		<cfargument name="exception" type="struct" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<!--- TODO Check if a user is logged in --->
		<cfif 1 eq 1>
			<!--- Dump out the error --->
			<cfdump var="#arguments.exception#" /><cfabort />
		<cfelse>
			<cfset super.onError(argumentCollection = arguments) />
		</cfif>
	</cffunction>
</cfcomponent>