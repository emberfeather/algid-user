<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveRole" access="public" returntype="void" output="false">
		<cfargument name="role" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('user', 'role') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.role) />
		
		<!--- Archive the role --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				UPDATE "#variables.datasource.prefix#user"."role"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.role) />
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
		
		<!--- Expand the with defaults --->
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
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('user', 'role') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
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
					<cfset arguments.role.setRoleID( results.roleID ) />
					
					<!--- Before Unarchive Event --->
					<cfset observer.beforeUnarchive(variables.transport, arguments.role) />
					
					<!--- Unarchive the role --->
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							UPDATE "#variables.datasource.prefix#user"."role"
							SET
								"role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
								"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
								"description" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />,
								"archivedOn" = NULL, 
								"updatedOn" = now()
							WHERE
								"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
						</cfquery>
					</cftransaction>
					
					<!--- After Unarchive Event --->
					<cfset observer.afterUnarchive(variables.transport, arguments.role) />
				</cfif>
			<cfelse>
				<!--- Insert as a new role --->
				<!--- Create the new ID --->
				<cfset arguments.role.setRoleID( createUUID() ) />
				
				<!--- Before Create Event --->
				<cfset observer.beforeCreate(variables.transport, arguments.role) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#user"."role"
						(
							"roleID",
							"schemeID",
							"role",
							"description", 
							"updatedOn"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />,
							now()
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.role) />
			</cfif>
		<cfelse>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.role) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#user"."role"
					SET
						"role" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRole()#" />,
						"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getSchemeID()#" />::uuid,
						"description" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.role.getDescription()#" />,
						"archivedOn" = NULL, 
						"updatedOn" = now()
					WHERE
						"roleID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role.getRoleID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.role) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.role) />
	</cffunction>
</cfcomponent>
