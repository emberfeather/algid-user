<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createUser" access="public" returntype="void" output="false">
		<cfargument name="user" type="component" required="true" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by a authentication plugin" />
	</cffunction>
	
	<cffunction name="readUser" access="public" returntype="component" output="false">
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by a authentication plugin" />
	</cffunction>
	
	<cffunction name="readUsers" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfthrow message="Not implemented" detail="This function should be overridden by a authentication plugin" />
	</cffunction>
</cfcomponent>