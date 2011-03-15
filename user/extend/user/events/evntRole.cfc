component extends="algid.inc.resource.base.event" {
	public void function afterArchive( required struct transport, required component role ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'roleArchive', 'Archived the ''' & arguments.role.getRole() & ''' role.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully saved.');
	}
	
	public void function afterCreate( required struct transport, required component role ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'roleCreate', 'Created the ''' & arguments.role.getRole() & ''' role.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully created.');
	}
	
	public void function afterUnarchive( required struct transport, required component role ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'roleUnarchive', 'Unarchived the ''' & arguments.role.getRole() & ''' role.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully unarchived.');
	}
	
	public void function afterUpdate( required struct transport, required component role ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('user', 'roleUpdate', 'Updated the ''' & arguments.role.getRole() & ''' role.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.role.getRoleID());
		
		// Add success message
		arguments.transport.theSession.managers.singleton.getSuccess().addMessages('The role ''' & arguments.role.getRole() & ''' was successfully updated.');
	}
}
