<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getScheme" access="public" returntype="component" output="false">
		<cfargument name="schemeID" type="string" required="true" />
		
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		<cfset var scheme = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE "schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemeID#" null="#arguments.schemeID eq ''#" />::uuid
		</cfquery>
		
		<cfset scheme = getModel('user', 'scheme') />
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, scheme) />
		</cfif>
		
		<cfreturn scheme />
	</cffunction>
	
	<cffunction name="getSchemes" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "schemeID", scheme, "createdOn", "updatedOn"
			FROM "#variables.datasource.prefix#user"."scheme"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'scheme')>
				and scheme = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.scheme#" />
			</cfif>
			
			ORDER BY scheme ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setScheme" access="public" returntype="void" output="false">
		<cfargument name="scheme" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('user', 'scheme') />
		
		<cfset scrub__model(arguments.scheme) />
		<cfset validate__model(arguments.scheme) />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.scheme) />
		
		<cfif arguments.scheme.getSchemeID() eq ''>
			<!--- Check for archived scheme --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "schemeID", "scheme", "archivedOn"
				FROM "#variables.datasource.prefix#user"."scheme"
				WHERE
					"scheme" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />
			</cfquery>
			
			<!--- Check if we found an existing scheme --->
			<cfif results.recordCount gt 0>
				<cfif results.archivedOn eq ''>
					<!--- Duplicate scheme --->
					<cfthrow type="validation" message="Scheme name already in use" detail="The '#arguments.scheme.getScheme()#' scheme already exists." />
				<cfelse>
					<!--- Pull in the real schemeID --->
					<cfset arguments.scheme.setSchemeID( results.schemeID ) />
					
					<!--- Before Unarchive Event --->
					<cfset observer.beforeUnarchive(variables.transport, arguments.scheme) />
					
					<!--- Unarchive the scheme --->
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							UPDATE "#variables.datasource.prefix#user"."scheme"
							SET
								"scheme" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
								"description" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.scheme.getDescription()#" />,
								"archivedOn" = NULL, 
								"updatedOn" = now()
							WHERE
								"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" />::uuid
						</cfquery>
					</cftransaction>
					
					<!--- After Unarchive Event --->
					<cfset observer.afterUnarchive(variables.transport, arguments.scheme) />
				</cfif>
			<cfelse>
				<!--- Insert as a new scheme --->
				<!--- Create the new ID --->
				<cfset arguments.scheme.setSchemeID( createUUID() ) />
				
				<!--- Before Create Event --->
				<cfset observer.beforeCreate(variables.transport, arguments.scheme) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#user"."scheme"
						(
							"schemeID",
							"scheme",
							"updatedOn"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
							now()
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.scheme) />
			</cfif>
		<cfelse>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.scheme) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#user"."scheme"
					SET
						"scheme" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getScheme()#" />,
						"archivedOn" = NULL, 
						"updatedOn" = now()
					WHERE
						"schemeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme.getSchemeID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.scheme) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.scheme) />
	</cffunction>
</cfcomponent>
