<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required user */
	public void function afterArchive( struct transport, component currUser, component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleArchive', 'Archived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	/* required user */
	public void function afterCreate( struct transport, component currUser, component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleCreate', 'Created the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	/* required user */
	public void function afterUnarchive( struct transport, component currUser, component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUnarchive', 'Unarchived the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
	
	/* required user */
	public void function afterUpdate( struct transport, component currUser, component role ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// TODO use i18n
		eventLog.logEvent('user', 'roleUpdate', 'Updated the ''' & arguments.role.getRole() & ''' role.', arguments.currUser.getUserID(), arguments.role.getRoleID());
	}
</cfscript>
</cfcomponent>
