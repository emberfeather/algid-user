{
	"applicationManagers": {
		"transient": {
			"modSchemeForUser": "plugins.user.inc.model.modScheme",
			"servSchemeForUser": "plugins.user.inc.service.servScheme",
			"servSchemePermissionForUser": "plugins.user.inc.service.servSchemePermission",
			"servSchemeTagForUser": "plugins.user.inc.service.servSchemeTag",
			"viewSchemeForUser": "plugins.user.inc.view.viewScheme",
			"viewSchemePermissionForUser": "plugins.user.inc.view.viewSchemePermission",
			"viewSchemeTagForUser": "plugins.user.inc.view.viewSchemeTag"
		}
	},
	"i18n": {
		"locales": [
			"en_PI",
			"en_US"
		]
	},
	"key": "@project.key@",
	"prerequisites": {
		"algid": "@prerequisites.algid@",
		"tagger": "@prerequisites.tagger@"
	},
	"sessionManagers": {
		"transient": {
			"user": "plugins.user.inc.model.modUser"
		}
	},
	"version": "@project.version.major@.@project.version.minor@.@project.version.build@"
}