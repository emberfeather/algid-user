component extends="algid.inc.resource.base.event" {
	public void function beforeExclude(required struct transport) {
		local.user = arguments.transport.theSession.managers.singleton.getUser();
		
		if( !local.user.isLoggedIn() ) {
			throw(type = 'validation', message = 'Cannot exclude from analytics unless signed into the adminstration');
		}
	}
}
