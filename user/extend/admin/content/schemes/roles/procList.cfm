<cfset i18n = application.managers.singleton.getI18N() />

<cfset servSchemeTag = createObject('component', 'plugins.user.inc.service.servSchemeTag').init(application.settings.datasources.update, i18n, SESSION.locale) />