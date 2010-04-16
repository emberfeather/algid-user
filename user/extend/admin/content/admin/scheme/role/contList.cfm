<cfset roles = servRole.getRoles( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(roles.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, roles, viewRole, paginate, filter)#</cfoutput>
