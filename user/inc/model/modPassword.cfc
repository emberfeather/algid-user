<cfcomponent extends="cf-compendium.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Password --->
		<cfset attr = {
				attribute = 'password'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Hash --->
		<cfset attr = {
				attribute = 'hash'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Salt --->
		<cfset attr = {
				attribute = 'salt'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/user/i18n/inc/model', 'modPassword') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getHash" access="public" returntype="string" output="false">
		<!--- Make sure that we have a value for the hash --->
		<cfif variables.instance['hash'] EQ ''>
			<!--- Generate the hash --->
			<cfset variables.instance['hash'] = hashPassword( this.getPassword() ) />
		</cfif>
		
		<cfreturn variables.instance['hash'] />
	</cffunction>
	
	<cffunction name="getSalt" access="public" returntype="string" output="false">
		<cfset var base62 = '' />
		
		<!--- Make sure that we have a value for the salt --->
		<cfif variables.instance['salt'] EQ ''>
			<cfset base62 = createObject('component', 'cf-compendium.inc.resource.utility.base62').init() />
			
			<!--- Generate the salt by converting a large random number to a base 62 format --->
			<cfset variables.instance['salt'] = base62.valueToBase62( randRange(1000000, 2147483646, 'SHA1PRNG') + randRange(1, 2147483646, 'SHA1PRNG') ) />
			
			<cfthrow message="#hash(variables.instance['salt'],'SHA-256','utf-8')#" />
		</cfif>
		
		<cfreturn variables.instance['salt'] />
	</cffunction>
	
	<cffunction name="getSaltAndHash" access="public" returntype="string" output="false">
		<cfreturn this.getSalt() & '|' & this.getHash() />
	</cffunction>
	
	<cffunction name="hashPassword" access="public" returntype="string" output="false">
		<cfargument name="password" type="string" required="true" />
		
		<cfreturn hash( getSalt() & '|' & arguments.password, 'SHA-512', 'utf-8' ) />
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
		<cfset var nonAlphaExpr = '[a-zA-Z]' />
		<cfset var results = '' />
		
		<!--- Trim password --->
		<cfset arguments.password = trim(arguments.password) />
		
		<!--- Test password for proper complexity requirements --->
		
		<!--- Check the password for the minimum length --->
		<cfif len(arguments.password) LT minLength>
			<cfthrow message="Password must be at least #minLength# characters long" detail="The password was only #len(arguments.password)# characters" />
		</cfif>
		
		<!--- Check for non-alpha characters --->
		<cfset results = reReplace(arguments.password, nonAlphaExpr, '', 'all') />
		
		<cfif len(results) LT minNonAlpha>
			<cfthrow message="Password must contain at least #minNonAlpha# non-alpha characters" detail="The password only contained #len(results)# non-alpha characters" />
		</cfif>
		
		<!--- Set the hash from the new password --->
		<cfset this.setHash( hashPassword(arguments.password) ) />
		
		<!--- Store the password --->
		<cfset variables.instance['password'] = arguments.password />
	</cffunction>
</cfcomponent>