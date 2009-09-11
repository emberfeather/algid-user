<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Password --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'password',
				defaultValue = 'password.123',
				validation = {
					minLength = 7
				}
			}) />
		
		<!--- Hash --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'hash'
			}) />
		
		<!--- Salt --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'salt'
			}) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modPassword') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getHash" access="public" returntype="string" output="false">
		<!--- Make sure that we have a value for the hash --->
		<cfif variables.instance['hash'] EQ ''>
			<!--- Generate the hash --->
			<cfset variables.instance['hash'] = hashPassword() />
		</cfif>
		
		<cfreturn variables.instance['hash'] />
	</cffunction>
	
	<cffunction name="getSalt" access="public" returntype="string" output="false">
		<cfset var base62 = '' />
		
		<!--- Make sure that we have a value for the salt --->
		<cfif variables.instance['salt'] EQ ''>
			<cfset base62 = createObject('component', 'cf-compendium.inc.resource.utility.base62').init() />
			
			<!--- Generate the salt by converting a large random number to a base 62 format --->
			<cfset variables.instance['salt'] = base62.valueToBase62( randRange(500000, 2147483646, 'SHA1PRNG') + randRange(500000, 2147483646, 'SHA1PRNG') ) />
		</cfif>
		
		<cfreturn variables.instance['salt'] />
	</cffunction>
	
	<cffunction name="getSaltAndHash" access="public" returntype="string" output="false">
		<cfreturn this.getSalt() & '|' & this.getHash() />
	</cffunction>
	
	<cffunction name="hashPassword" access="public" returntype="string" output="false">
		<cfargument name="password" type="string" default="" />
		
		<cfset arguments.password = trim(arguments.password) />
		
		<!--- If not given a password to hash use the local password --->
		<cfif arguments.password EQ ''>
			<cfset arguments.password = this.getPassword() />
		</cfif>
		
		<cfreturn hash( this.getSalt() & '~' & arguments.password, 'SHA-512', 'utf-8' ) />
	</cffunction>
	
	<cffunction name="setSaltAndHash" access="public" returntype="void" output="false">
		<cfargument name="saltAndHash" type="string" required="true" />
		
		<cfif listLen(arguments.saltAndHash, '|') NEQ 2>
			<cfthrow message="Salt and Hash incorrectly formatted" detail="The salt and hash value need to be the salt and hash separated by a pipe (|) character" />
		</cfif>
		
		<!--- Separate out the salt and hash values --->
		<cfset this.setSalt(listGetAt(arguments.saltAndHash, 1, '|')) />
		<cfset this.setHash(listGetAt(arguments.saltAndHash, 2, '|')) />
	</cffunction>
	
	<cffunction name="setPassword" access="public" returntype="void" output="false">
		<cfargument name="password" type="string" required="true" />
		
		<cfset var minLength = 7 />
		<cfset var minNonAlpha = 2 />
		<cfset var results = '' />
		
		<!--- Trim password --->
		<cfset arguments.password = trim(arguments.password) />
		
		<!--- Check for minimum length --->
		<cfif len(arguments.password) LT minLength>
			<!--- TODO make this locale friendly --->
			<cfthrow message="Password must be at least #minNonAlpha# characters" detail="The password only contained #len(results)# characters" />
		</cfif>
		
		<!--- Test password for proper complexity requirements --->
		
		<!--- Check for non-alpha characters --->
		<cfset results = reReplace(arguments.password, '[a-zA-Z]', '', 'all') />
		
		<cfif len(results) LT minNonAlpha>
			<!--- TODO make this locale friendly --->
			<cfthrow message="Password must contain at least #minNonAlpha# non-alpha characters" detail="The password only contained #len(results)# non-alpha characters" />
		</cfif>
		
		<!--- Set the hash from the new password --->
		<cfset this.setHash( hashPassword(arguments.password) ) />
		
		<!--- Store the password --->
		<cfset variables.instance['password'] = arguments.password />
	</cffunction>
</cfcomponent>