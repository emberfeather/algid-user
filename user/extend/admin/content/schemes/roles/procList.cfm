<cfset i18n = application.managers.singleton.getI18N() />

<cfset servSchemeTag = application.factories.transient.getServSchemeTagForUser(application.app.getDSUpdate(), i18n, SESSION.locale) />