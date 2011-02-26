component extends="algid.inc.resource.base.event" {
	public void function afterCreate( required struct transport, component scheme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'createScheme', 'Created the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, component scheme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'unarchiveScheme', 'Unarchived the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, component scheme ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'updateScheme', 'Updated the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully updated.');
	}
}
