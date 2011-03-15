component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
	}
	
	public void function testGetPermissions() {
		variables.user.addPermissions('scheme', 'take');
		variables.user.addPermissions('scheme', 'give');
		
		assertEquals('give,take', listSort(arrayToList(variables.user.getPermissions('scheme')), 'text'));
	}
	
	public void function testGetPermissionsWithMultiScheme() {
		variables.user.addPermissions('scheme', 'take');
		variables.user.addPermissions('plan', 'give');
		
		assertEquals('give,take', listSort(arrayToList(variables.user.getPermissions('scheme,plan')), 'text'));
	}
	
	public void function testGetPermissionsWithMultiSchemeDuplicates() {
		variables.user.addPermissions('scheme', 'take');
		variables.user.addPermissions('plan', 'give');
		variables.user.addPermissions('plan', 'take');
		
		assertEquals('give,take', listSort(arrayToList(variables.user.getPermissions('scheme,plan')), 'text'));
	}
	
	public void function testGetPermissionsWithMultiSchemeWildcard() {
		variables.user.addPermissions('scheme', 'take');
		variables.user.addPermissions('plan', 'give');
		variables.user.addPermissions('devise', 'plunder');
		
		assertEquals('give,plunder,take', listSort(arrayToList(variables.user.getPermissions('*')), 'text'));
	}
	
	public void function testHasPermission() {
		variables.user.addPermissions('scheme', 'give');
		
		assertTrue(variables.user.hasPermission('give', 'scheme'), 'The permission should exist for the scheme.');
	}
	
	public void function testHasPermissionSansPermission() {
		assertFalse(variables.user.hasPermission('give', 'scheme'), 'The permission should not exist for the scheme');
	}
	
	public void function testHasPermissionWithMultiScheme() {
		variables.user.addPermissions('scheme', 'take');
		variables.user.addPermissions('plan', 'give');
		
		assertTrue(variables.user.hasPermission('give', 'scheme,plan'), 'The permission should exist in one of the scheme.');
	}
	
	public void function testHasPermissionsWithOneScheme() {
		variables.user.addPermissions('scheme', 'give,grant');
		
		assertTrue(variables.user.hasPermissions('give,grant', 'scheme'), 'The permissions should exist for the scheme.');
	}
	
	public void function testHasPermissionsWithOneSchemeFailMissingPermission() {
		variables.user.addPermissions('scheme', 'give');
		
		assertFalse(variables.user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.');
	}
	
	public void function testHasPermissionsWithMultiSchemeParts() {
		variables.user.addPermissions('scheme', 'give');
		variables.user.addPermissions('plan', 'grant');
		
		assertTrue(variables.user.hasPermissions('give,grant', 'scheme,plan'), 'The permissions should exist for the scheme.');
	}
	
	public void function testHasPermissionsWithMultiSchemeFailMissingPermission() {
		variables.user.addPermissions('scheme', 'give');
		variables.user.addPermissions('plan', 'steal');
		
		assertFalse(variables.user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.');
	}
}
