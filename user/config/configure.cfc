<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="configureSession" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="newSession" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Add the user singleton --->
		<cfset temp = arguments.newSession.factories.transient.getUser(arguments.theApplication.managers.singleton.getI18N()) />
		
		<cfset arguments.newSession.managers.singleton.setUser(temp) />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') LT 0>
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
			SEQUENCES
		--->
		
		<!--- User Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#user"."user_userID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."user_userID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Scheme Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#user"."scheme_schemeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."scheme_schemeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."user"
			(
				"userID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#user"."user_userID_seq"'::regclass),
				"createdOn" timestamp without time zone DEFAULT now(),
				"archivedOn" timestamp without time zone,
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
				"schemeID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#user"."scheme_schemeID_seq"'::regclass),
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
		
		<!--- Bridge Scheme to Tag to Permission Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."bScheme2Tag2Permission"
			(
				"schemeID" integer NOT NULL,
				"tagID" integer NOT NULL,
				permission character varying(75) NOT NULL,
				CONSTRAINT "bScheme2Tag2Permission_PK" PRIMARY KEY ("schemeID", permission, "tagID"),
				CONSTRAINT "bScheme2Tag2Permission_schemeID_FK" FOREIGN KEY ("schemeID")
					REFERENCES "#variables.datasource.prefix#user".scheme ("schemeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bScheme2Tag2Permission_userID_FK" FOREIGN KEY ("tagID")
					REFERENCES #variables.datasource.prefix#tagger.tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."bScheme2Tag2Permission" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."bScheme2Tag2Permission" IS 'Bridge for applying a permission to a tag.';
		</cfquery>
		
		<!--- Bridge Scheme to Tag to User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#user"."bScheme2Tag2User"
			(
				"schemeID" integer NOT NULL,
				"userID" integer NOT NULL,
				"tagID" integer NOT NULL,
				CONSTRAINT "bScheme2Tag2User_PK" PRIMARY KEY ("schemeID", "userID", "tagID"),
				CONSTRAINT "bScheme2Tag2User_schemeID_FK" FOREIGN KEY ("schemeID")
					REFERENCES "#variables.datasource.prefix#user".scheme ("schemeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bScheme2Tag2User_tagID_FK" FOREIGN KEY ("tagID")
					REFERENCES #variables.datasource.prefix#tagger.tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bScheme2Tag2User_userID_FK" FOREIGN KEY ("userID")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#user"."bScheme2Tag2User" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#user"."bScheme2Tag2User" IS 'Bridge for applying a tag to a user.';
		</cfquery>
	</cffunction>
</cfcomponent>