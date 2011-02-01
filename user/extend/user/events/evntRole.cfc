component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleArchive', 'Archived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully saved.');
	}
	
	public void function afterCreate( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleCreate', 'Created the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUnarchive', 'Unarchived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUpdate', 'Updated the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully updated.');
	}
}
