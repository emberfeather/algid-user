<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	public void function afterCreate( required struct transport, required component currUser, component scheme ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('user', 'createScheme', 'Created the ''' & arguments.scheme.getScheme() & ''' scheme.', arguments.currUser.getUserID(), arguments.scheme.getSchemeID());
	}
</cfscript>
</cfcomponent>
