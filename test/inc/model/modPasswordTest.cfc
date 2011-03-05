component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.password = createObject('component', 'plugins.user.inc.model.modPassword').init(variables.i18n);
	}
	
	public void function testAutoSalt() {
		assertNotEquals('', variables.password.getSalt());
	}
	
	public void function testGetHashFromSaltAndHash() {
		variables.password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm');
		
		assertEquals('Ecnwo2k432n2$kcmo!kcnowkm', variables.password.getHash() );
	}
	
	public void function testGetSaltFromSaltAndHash() {
		variables.password.setSaltAndHash('nIPEv|Ecnwo2k432n2$kcmo!kcnowkm');
		
		assertEquals('nIPEv', variables.password.getSalt() );
	}
	
	public void function testHashPasswordFromSalt() {
		variables.password.setSalt('nIPEv');
		
		variables.password.setPassword('Test4Password!');
		
		assertEquals('12a8a72423b6330a86f70415acf6ce9536c7ddf4b6a95a9633dddf6fef2cfbf262d729b8946228f9f415cfa90293ebc00f260c03e0385fc1a9ff30a43980198e', variables.password.getHash() );
	}
	
	public void function testPasswordMinLength() {
		var minLength = 7;
		var testPassword = '';
		var i = '';
		
		testPassword = left( generateSecretKey('DESEDE'), minLength - 1 );
		
		try {
			variables.password.setPassword(testPassword);
			
			fail("Should not be able to set the variables.password.without the minimum length of #minLength#.");
		} catch(mxunit.exception.AssertionFailedError exception) {
			rethrow();
		} catch(any exception) {
			// expect to get here
		}
	}
	
	public void function testPasswordSansSpecial() {
		try {
			variables.password.setPassword('fullOfText');
			
			fail("Should not be able to set the variables.password.without numbers or special characters.");
		} catch(mxunit.exception.AssertionFailedError exception) {
			rethrow();
		} catch(any exception) {
			// expect to get here
		}
	}
}
