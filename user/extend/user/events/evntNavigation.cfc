component extends="algid.inc.resource.base.event" {
	public void function afterSave( required struct transport, required component navigation ) {
		// Reinitialize the admin navigation
		local.plugin = arguments.transport.theApplication.managers.plugin.getAdmin()
		
		lock type="exclusive" scope="application" timeout="100" {
			local.plugin.getConfigure().onApplicationStart(arguments.transport.theApplication);
		}
		
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'navigationSave', 'Updated the navigation permissions.', arguments.transport.theSession.managers.singleton.getUser().getUserID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The navigation role permissions were successfully updated.');
	}
	
	public void function beforeSave( required struct transport, required component navigation ) {
		// Ensure universal access to login/logout functionality
		local.nav = arguments.navigation.getNavigation();
		local.nav.xmlRoot.account.xmlAttributes['allow'] = '*';
		local.nav.xmlRoot.account.login.xmlAttributes['allow'] = '*';
		local.nav.xmlRoot.account.logout.xmlAttributes['allow'] = '*';
	}
}
