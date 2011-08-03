<cfset roles = servNavigation.getRoles( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(roles.recordcount, transport.theSession.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, roles, viewNavigation, paginate, filter)#</cfoutput>
