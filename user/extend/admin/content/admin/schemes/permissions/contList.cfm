<cfset permissions = servSchemePermission.readPermissions( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(permissions.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, permissions, viewSchemePermission, paginate, filter)#</cfoutput>
