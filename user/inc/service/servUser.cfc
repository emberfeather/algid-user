<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getUser" access="public" returntype="component" output="false">
		<cfargument name="userID" type="string" required="true" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by an authentication plugin" />
	</cffunction>
	
	<cffunction name="getUsers" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by an authentication plugin" />
	</cffunction>
	
	<cffunction name="setUser" access="public" returntype="void" output="false">
		<cfargument name="user" type="component" required="true" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by an authentication plugin" />
	</cffunction>
</cfcomponent>