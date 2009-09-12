{
	"applicationSingletons": {
	},
	"applicationTransients": {
		"modPasswordForUser": "plugins.user.inc.model.modPassword",
		"modPermissionForUser": "plugins.user.inc.model.modPermission",
		"modSchemeForUser": "plugins.user.inc.model.modScheme",
		"modUserForUser": "plugins.user.inc.model.modUser",
		"servSchemeForUser": "plugins.user.inc.service.servScheme",
		"servSchemePermissionForUser": "plugins.user.inc.service.servSchemePermission",
		"servSchemeTagForUser": "plugins.user.inc.service.servSchemeTag",
		"servUserForUser": "plugins.user.inc.service.servUser",
		"viewSchemeForUser": "plugins.user.inc.view.viewScheme",
		"viewSchemePermissionForUser": "plugins.user.inc.view.viewSchemePermission",
		"viewSchemeTagForUser": "plugins.user.inc.view.viewSchemeTag",
		"viewUserForUser": "plugins.user.inc.view.viewUser"
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