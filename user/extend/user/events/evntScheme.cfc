component extends="algid.inc.resource.base.event" {
	public void function afterCreate( required struct transport, required component currUser, component scheme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('user', 'createScheme', 'Created the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component currUser, component scheme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('user', 'unarchiveScheme', 'Unarchived the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component currUser, component scheme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('user', 'updateScheme', 'Updated the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The scheme ''' & arguments.scheme.getScheme() & ''' was successfully updated.');
	}
}
