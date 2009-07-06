<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="testAutoHash" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset assertNotEquals('', password.getHash()) />
	</cffunction>
	
	<cffunction name="testGetHashFromSaltAndHash" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset password.setSaltAndHash('nIPEv|') />
	</cffunction>
	
	<cffunction name="testMinLength" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cftry>
			<cfset password.setPassword('123456') />
			
			<cfset fail("Should not be able to set the password without a minimum length.") />
			
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfrethrow />
			</cfcatch>
			
			<cfcatch type="any">
				<!--- expect to get here --->
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="testSansSpecial" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cftry>
			<cfset password.setPassword('fullOfText') />
			
			<cfset fail("Should not be able to set the password without numbers or special characters.") />
			
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfrethrow />
			</cfcatch>
			
			<cfcatch type="any">
				<!--- expect to get here --->
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>