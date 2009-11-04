<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="stats" access="public" returntype="string" output="false">
		<cfargument name="user" type="component" required="true" />
		
		<cfset var html = '' />
		
		<!--- TODO Use the user to show the stats --->
		<cfset html = 'Show user statistics for ' & arguments.user.getUserID() & '.' />
		
		<cfreturn html />
	</cffunction>
</cfcomponent>