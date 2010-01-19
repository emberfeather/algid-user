<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		}
		
		public void function testAutoSalt() {
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			
			assertNotEquals('', password.getSalt());
		}
		
		public void function testGetHashFromSaltAndHash() {
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			
			password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm');
			
			assertEquals('Ecnwo2k432n2$kcmo!kcnowkm', password.getHash() );
		}
		
		public void function testGetSaltFromSaltAndHash() {
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			
			password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm');
			
			assertEquals('nIPEv', password.getSalt() );
		}
		
		public void function testHashPasswordFromSalt() {
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			
			password.setSalt('nIPEv');
			
			password.setPassword('Test4Password!');
			
			assertEquals('12a8a72423b6330a86f70415acf6ce9536c7ddf4b6a95a9633dddf6fef2cfbf262d729b8946228f9f415cfa90293ebc00f260c03e0385fc1a9ff30a43980198e', password.getHash() );
		}
		
		public void function testPasswordMinLength() {
			var minLength = 7;
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			var testPassword = '';
			var i = '';
			
			testPassword = left( generateSecretKey('DESEDE'), minLength - 1 );
			
			try {
				password.setPassword(testPassword);
				
				fail("Should not be able to set the password without the minimum length of #minLength#.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
		
		public void function testPasswordSansSpecial() {
			var password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
			
			try {
				password.setPassword('fullOfText');
				
				fail("Should not be able to set the password without numbers or special characters.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
	</cfscript>
</cfcomponent>