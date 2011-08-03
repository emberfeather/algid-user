<cfset viewNavigation = views.get('user', 'navigation') />

<cfset navigation = servNavigation.getCurrentNavigation(transport.theSession.managers.singleton.getSession().getLocale()) />

<cfoutput>
	#viewNavigation.edit(role, navigation)#
</cfoutput>
