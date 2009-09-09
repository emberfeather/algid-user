{
	"applicationSingletons": {
	},
	"applicationTransients": {
		"modSchemeForUser": "plugins.user.inc.model.modScheme",
		"servSchemeForUser": "plugins.user.inc.service.servScheme",
		"servSchemePermissionForUser": "plugins.user.inc.service.servSchemePermission",
		"servSchemeTagForUser": "plugins.user.inc.service.servSchemeTag",
		"viewSchemeForUser": "plugins.user.inc.view.viewScheme",
		"viewSchemePermissionForUser": "plugins.user.inc.view.viewSchemePermission",
		"viewSchemeTagForUser": "plugins.user.inc.view.viewSchemeTag"
	},
	"i18n": {
		"locales": [
			"en_PI",
			"en_US"
		]
	},
	"key": "user",
	"prerequisites": {
		"algid": "0.1.1",
		"tagger": "0.1.1"
	},
	"sessionSingletons": {
	},
	"sessionTransients": {
		"user": "plugins.user.inc.model.modUser"
	},
	"version": "0.1.1"
}