<cfset i18n = application.managers.singleton.getI18N() />

<cfset servSchemePermission = application.factories.transient.getServSchemePermissionForUser(application.app.getDSUpdate(), i18n, SESSION.locale) />