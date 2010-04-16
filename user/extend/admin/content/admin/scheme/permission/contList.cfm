<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(permissions.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, permissions, viewSchemePermission, paginate, filter)#</cfoutput>
