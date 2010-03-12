<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required content */
	public void function afterCreate( struct transport, component currUser, component scheme, component tag, component user ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('user', 'createScheme2Tag2User', 'Granted the ''' & arguments.tag.getTag() & ''' tag to ''' & arguments.user.getUsername() & ''' for the ''' & arguments.scheme.getScheme() & '''.scheme.', arguments.currUser.getUserID());
	}
</cfscript>
</cfcomponent>
