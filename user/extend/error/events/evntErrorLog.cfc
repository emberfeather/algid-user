component extends="algid.inc.resource.base.event" {
	public void function beforeLog(required struct transport, required any exception, string eventName = '') {
		local.user = arguments.transport.theSession.managers.singleton.getUser();
		
		if( local.user.isLoggedIn() && arguments.transport.theApplication.managers.singleton.getApplication().isMaintenance() ) {
			writeDump(arguments.exception);
			abort;
		}
	}
}
