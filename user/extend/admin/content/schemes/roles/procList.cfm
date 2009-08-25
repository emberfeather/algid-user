<cfset i18n = application.managers.singleton.getI18N() />

<cfset servSchemeTag = application.managers.transient.getServSchemeTagForUser(application.settings.datasources.update, i18n, SESSION.locale) />