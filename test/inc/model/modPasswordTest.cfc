<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="testAutoSalt" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset assertNotEquals('', password.getSalt()) />
	</cffunction>
	
	<cffunction name="testGetHashFromSaltAndHash" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm') />
		
		<cfset assertEquals('Ecnwo2k432n2$kcmo!kcnowkm', password.getHash() ) />
	</cffunction>
	
	<cffunction name="testGetSaltFromSaltAndHash" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm') />
		
		<cfset assertEquals('nIPEv', password.getSalt() ) />
	</cffunction>
	
	<cffunction name="testHashPasswordFromSalt" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var password = createObject('component', 'user.inc.model.modPassword').init(i18n) />
		
		<cfset password.setSalt('nIPEv') />
		
		<cfset password.setPassword('Test4Password!') />
		
		<cfset assertEquals('12a8a72423b6330a86f70415acf6ce9536c7ddf4b6a95a9633dddf6fef2cfbf262d729b8946228f9f415cfa90293ebc00f260c03e0385fc1a9ff30a43980198e', password.getHash() ) />
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