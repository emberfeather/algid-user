<cfset i18n = application.managers.singleton.getI18N() />

<cfset servScheme = createObject('component', 'plugins.user.inc.service.servScheme').init(application.settings.datasources.update, i18n, SESSION.locale) />