<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="onSessionStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Add the user singleton --->
		<cfset temp = arguments.theApplication.factories.transient.getModUserForUser(arguments.theApplication.managers.singleton.getI18N()) />
		
		<cfset arguments.theSession.managers.singleton.setUser(temp) />
	</cffunction>
	
	<cffunction name="canReinitialize" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theForm" type="struct" required="true" />
		
		<cfset var hasPermission = false />
		
		<!--- Check if there is a user set --->
		<cfset hasPermission = arguments.theSession.managers.singleton.hasUser() />
		
		<!--- Check if the user is an admin --->
		<cfset hasPermission = hasPermission and arguments.theSession.managers.singleton.getUser().hasPermission('reinit', '') />
		
		<cfreturn hasPermission />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_0() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- User schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#user"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#user" IS 'User Plugin Schema';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."user"
			(
				"userID" uuid NOT NULL,
				"createdOn" timestamp without time zone DEFAULT now(),
				"archivedOn" timestamp without time zone,
				"fullname" character varying(100),
				"username" character varying(30),
				"language" character varying(8) NOT NULL DEFAULT 'en_US'::character varying,
				CONSTRAINT "user_PK" PRIMARY KEY ("userID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."user" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."user" IS 'User information';
		</cfquery>
		
		<!--- Scheme Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user".scheme
			(
				"schemeID" uuid NOT NULL,
				scheme character varying(75),
				"createdOn" timestamp without time zone DEFAULT now(),
				"updatedOn" timestamp without time zone,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "scheme_PK" PRIMARY KEY ("schemeID"),
				CONSTRAINT "scheme_scheme_U" UNIQUE (scheme)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."scheme" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."scheme" IS 'Permission Scheme Information';
		</cfquery>
		
		<!--- Role Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."role"
			(
				"roleID" uuid NOT NULL,
				"schemeID" uuid NOT NULL,
				"role" character varying(100) NOT NULL,
				description text,
				"createdOn" timestamp without time zone not NULL DEFAULT now(),
				"archivedOn" timestamp without time zone,
				CONSTRAINT role_pkey PRIMARY KEY ("roleID"),
				CONSTRAINT "role_schemeID_fkey" FOREIGN KEY ("schemeID")
					REFERENCES "#variables.datasource.prefix#user".scheme ("schemeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "role_schemeID_key" UNIQUE ("schemeID", role)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."role" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."role" IS 'Permission Scheme Roles';
		</cfquery>
		
		<!--- Bridge Role to Permission Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."bRole2Permission"
			(
				"roleID" uuid NOT NULL,
				permission character varying(300) NOT NULL,
				CONSTRAINT "bRole2Permission_pkey" PRIMARY KEY ("roleID", permission),
				CONSTRAINT "bRole2Permission_roleID_fkey" FOREIGN KEY ("roleID")
					REFERENCES "#variables.datasource.prefix#user"."role" ("roleID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."bRole2Permission" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."bRole2Permission" IS 'Bridge for applying a permission to a role.';
		</cfquery>
		
		<!--- Bridge Role to User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."bRole2User"
			(
				"roleID" uuid NOT NULL,
				"userID" uuid NOT NULL,
				CONSTRAINT "bRole2User_pkey" PRIMARY KEY ("roleID", "userID"),
				CONSTRAINT "bRole2User_roleID_fkey" FOREIGN KEY ("roleID")
					REFERENCES "#variables.datasource.prefix#user"."role" ("roleID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bScheme2Tag2User_userID_FK" FOREIGN KEY ("userID")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."bRole2User" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."bRole2User" IS 'Bridge for applying a role to a user.';
		</cfquery>
	</cffunction>
</cfcomponent>
