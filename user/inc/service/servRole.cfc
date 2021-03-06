<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveRole" access="public" returntype="void" output="false">
		<cfargument name="role" type="component" required="true" />
		
		<cfset local.observer = getPluginObserver('user', 'role') />
		
		<cfset local.observer.beforeArchive(variables.transport, arguments.role) />
		
		<!--- Archive the role --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#">
				UPDATE "#variables.datasource.prefix#user"."role"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- Remove the role from the navigation --->
		<cfset local.servNavigation = getService('user', 'navigation') />
		<cfset local.navigation = local.servNavigation.getNavigation() />
		<cfset local.navigation.removeRole(arguments.role.getRoleID()) />
		<cfset local.servNavigation.setNavigation(local.navigation) />
		
		<cfset local.observer.afterArchive(variables.transport, arguments.role) />
	</cffunction>
	
	<cffunction name="getRole" access="public" returntype="component" output="false">
		<cfargument name="roleID" type="string" required="true" />
		
		<cfset var role = '' />
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		
		<cfset role = getModel('user', 'role') />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "roleID", "schemeID", "role", "description", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#user"."role"
			WHERE "roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.roleID#" null="#arguments.roleID eq ''#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, role) />
		</cfif>
		
		<cfreturn role />
	</cffunction>
	
	<cffunction name="getRoles" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
			isArchived = false,
			orderBy = 'role',
			orderSort = 'asc'
		} />
		<cfset var results = '' />
		
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "roleID", "schemeID", "role", "description", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#user"."role"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					"role" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR "description" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'schemeID') and arguments.filter.schemeID neq ''>
				AND "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.schemeID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				AND "archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"role" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="getUsers" access="public" returntype="query" output="false">
		<cfargument name="role" type="component" required="true" />
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset arguments.filter = extend({
			isArchived = false,
			orderBy = 'fullname',
			orderSort = 'asc'
		}, arguments.filter) />
		
		<cfquery name="local.results" datasource="#variables.datasource.name#">
			SELECT u."userID", u."fullname"
			FROM "#variables.datasource.prefix#user"."user" u
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'inRole')>
				<cfif arguments.filter.inRole>
					AND EXISTS
				<cfelse>
					AND NOT EXISTS
				</cfif> (
					SELECT r."roleID"
					FROM "#variables.datasource.prefix#user"."bRole2User" r
					WHERE r."userID" = u."userID"
						AND r."roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" null="#arguments.role.getRoleID() eq ''#">::uuid
				)
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					u."fullname" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="hasRole" access="public" returntype="boolean" output="false">
		<cfargument name="schemeID" type="string" required="true" />
		<cfargument name="role" type="string" required="true" />
		
		<cfset var results = '' />
		
		<cfset arguments.role = trim(arguments.role) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "roleID"
			FROM "#variables.datasource.prefix#user"."role"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemeID#" />::uuid
				AND "role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role#" />
				AND "archivedOn" IS NULL
		</cfquery>
		
		<cfreturn results.recordCount GT 0 />
	</cffunction>
	
	<cffunction name="setRole" access="public" returntype="void" output="false">
		<cfargument name="role" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<cfset observer = getPluginObserver('user', 'role') />
		
		<cfset scrub__model(arguments.role) />
		<cfset validate__model(arguments.role) />
		
		<cfset observer.beforeSave(variables.transport, arguments.role) />
		
		<cfif arguments.role.getRoleID() eq ''>
			<!--- Check for archived role --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "roleID", "role", "archivedOn"
				FROM "#variables.datasource.prefix#user"."role"
				WHERE
					"role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />
					AND "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid
			</cfquery>
			
			<!--- Check if we found an existing role --->
			<cfif results.recordCount gt 0>
				<cfif results.archivedOn eq ''>
					<!--- Duplicate role --->
					<cfthrow type="validation" message="Role name already in use" detail="The '#arguments.role.getRole()#' role already exists." />
				<cfelse>
					<!--- Pull in the real roleID --->
					<cfset arguments.role.setRoleID( results.roleID.toString() ) />
					
					<cfset observer.beforeUnarchive(variables.transport, arguments.role) />
					
					<!--- Unarchive the role --->
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							UPDATE "#variables.datasource.prefix#user"."role"
							SET
								"role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
								"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
								"description" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />,
								"archivedOn" = NULL
							WHERE
								"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
						</cfquery>
					</cftransaction>
					
					<cfset observer.afterUnarchive(variables.transport, arguments.role) />
				</cfif>
			<cfelse>
				<!--- Insert as a new role --->
				<!--- Create the new ID --->
				<cfset arguments.role.setRoleID( createUUID() ) />
				
				<cfset observer.beforeCreate(variables.transport, arguments.role) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#user"."role"
						(
							"roleID",
							"schemeID",
							"role",
							"description"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />
						)
					</cfquery>
				</cftransaction>
				
				<cfset observer.afterCreate(variables.transport, arguments.role) />
			</cfif>
		<cfelse>
			<cfset observer.beforeUpdate(variables.transport, arguments.role) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#user"."role"
					SET
						"role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
						"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
						"description" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />,
						"archivedOn" = NULL
					WHERE
						"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<cfset observer.afterUpdate(variables.transport, arguments.role) />
		</cfif>
		
		<cfset observer.afterSave(variables.transport, arguments.role) />
	</cffunction>
	
	<cffunction name="setRoleUsers" access="public" returntype="void" output="false">
		<cfargument name="role" type="component" required="true" />
		<cfargument name="users" type="array" required="true" />
		
		<cfset local.observer = getPluginObserver('user', 'role') />
		
		<cfset local.observer.beforeUsersSave(variables.transport, arguments.role) />
		
		<cfquery datasource="#variables.datasource.name#" name="local.results">
			SELECT "userID"
			FROM "#variables.datasource.prefix#user"."bRole2User"
			WHERE "roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
		</cfquery>
		
		<cftransaction>
			<!--- Remove Old Users --->
			<cfquery datasource="#variables.datasource.name#">
				DELETE
				FROM "#variables.datasource.prefix#user"."bRole2User"
				WHERE "roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
					<cfif arrayLen(arguments.users)>
						AND "userID" NOT IN (
							<cfloop from="1" to="#arrayLen(arguments.users)#" index="local.i">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.users[local.i]#" />::uuid<cfif local.i lt arrayLen(arguments.users)>,</cfif>
							</cfloop>
						)
					</cfif>
			</cfquery>
			
			<!--- Find new users --->
			<cfloop query="local.results">
				<cfset local.loc = arrayFind(arguments.users, local.results.userID.toString()) />
				
				<cfif local.loc>
					<cfset arrayDeleteAt(arguments.users, local.loc) />
				</cfif>
			</cfloop>
			
			<cfif arrayLen(arguments.users)>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#user"."bRole2User"
					(
						"roleID",
						"userID"
					) VALUES
					<cfloop from="1" to="#arrayLen(arguments.users)#" index="local.i">
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.users[local.i]#" />::uuid
						)<cfif local.i lt arrayLen(arguments.users)>,</cfif>
					</cfloop>
				</cfquery>
			</cfif>
		</cftransaction>
		
		<cfset local.observer.afterUsersSave(variables.transport, arguments.role) />
	</cffunction>
</cfcomponent>
