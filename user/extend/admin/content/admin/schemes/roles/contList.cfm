<cfset users = servSchemeTag.readTagUsers( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(users.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, users, viewSchemeTag, paginate, filter)#</cfoutput>
