<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	public void function afterArchive( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleArchive', 'Archived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	public void function afterCreate( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleCreate', 'Created the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	public void function afterUnarchive( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUnarchive', 'Unarchived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	public void function afterUpdate( required struct transport, required component currUser, required component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUpdate', 'Updated the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
</cfscript>
</cfcomponent>
