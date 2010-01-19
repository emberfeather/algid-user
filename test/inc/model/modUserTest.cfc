<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		/**
		 * 
		 */
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		}
		
		/**
		 * 
		 */
		public void function testGetPermissions() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'take');
			user.addPermissions('scheme', 'give');
			
			assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme')), 'text'));
		}
		
		/**
		 * 
		 */
		public void function testGetPermissionsWithMultiScheme() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'take');
			user.addPermissions('plan', 'give');
			
			assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme,plan')), 'text'));
		}
		
		/**
		 * 
		 */
		public void function testGetPermissionsWithMultiSchemeDuplicates() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'take');
			user.addPermissions('plan', 'give');
			user.addPermissions('plan', 'take');
			
			assertEquals('give,take', listSort(arrayToList(user.getPermissions('scheme,plan')), 'text'));
		}
		
		/**
		 * 
		 */
		public void function testGetPermissionsWithMultiSchemeWildcard() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'take');
			user.addPermissions('plan', 'give');
			user.addPermissions('devise', 'plunder');
			
			assertEquals('give,plunder,take', listSort(arrayToList(user.getPermissions('*')), 'text'));
		}
		
		/**
		 * 
		 */
		public void function testHasPermission() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'give');
			
			assertTrue(user.hasPermission('give', 'scheme'), 'The permission should exist for the scheme.');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionSansPermission() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			assertFalse(user.hasPermission('give', 'scheme'), 'The permission should not exist for the scheme');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionWithMultiScheme() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'take');
			user.addPermissions('plan', 'give');
			
			assertTrue(user.hasPermission('give', 'scheme,plan'), 'The permission should exist in one of the scheme.');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionsWithOneScheme() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'give,grant');
			
			assertTrue(user.hasPermissions('give,grant', 'scheme'), 'The permissions should exist for the scheme.');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionsWithOneSchemeFailMissingPermission() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'give');
			
			assertFalse(user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionsWithMultiSchemeParts() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'give');
			user.addPermissions('plan', 'grant');
			
			assertTrue(user.hasPermissions('give,grant', 'scheme,plan'), 'The permissions should exist for the scheme.');
		}
		
		/**
		 * 
		 */
		public void function testHasPermissionsWithMultiSchemeFailMissingPermission() {
			var user = createObject('component', 'plugins.user.inc.model.modUser').init(variables.i18n);
			
			user.addPermissions('scheme', 'give');
			user.addPermissions('plan', 'steal');
			
			assertFalse(user.hasPermissions('give,steal', 'scheme'), 'The permissions do not exist in their entirety.');
		}
	</cfscript>
</cfcomponent>