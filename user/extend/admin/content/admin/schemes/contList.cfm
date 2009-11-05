<cfset schemes = servScheme.readSchemes( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(schemes.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, schemes, viewScheme, paginate, filter)#</cfoutput>
