component extends="algid.inc.resource.base.model" {
	public component function init(required component i18n, string locale = 'en_US') {
		super.init(arguments.i18n, arguments.locale);
		
		// Description
		add__attribute(
			attribute = 'navigation',
			defaultValue = xmlParse('<navigation></navigation>')
		);
		
		add__bundle('plugins/user/i18n/inc/model', 'modNavigation');
		
		return this;
	}
	
	private void function addRole(required any root, required string path, required string role, string attribute = 'allow') {
		local.current = listFirst(arguments.path, '/');
		local.rest = listRest(arguments.path, '/');
		
		if(!structKeyExists(arguments.root, local.current)) {
			local.node = xmlElemNew(this.getNavigation(), local.current);
			
			local.keys = listToArray(structKeyList(arguments.root.xmlAttributes));
			
			// Copy the root attributes by default
			for(local.i = 1; local.i <= arrayLen(local.keys); local.i++) {
				local.node.xmlAttributes[local.keys[local.i]] = arguments.root.xmlAttributes[local.keys[local.i]];
			}
			
			arrayAppend(arguments.root.xmlChildren, local.node);
		} else {
			local.node = arguments.root[local.current];
		}
		
		if(local.rest != '') {
			return addRole(local.node, local.rest, arguments.role, arguments.attribute);
		}
		
		local.antiAttribute = arguments.attribute == 'allow' ? 'deny' : 'allow';
		
		// Remove it from the anti attribute
		if(structKeyExists(local.node.xmlAttributes, local.antiAttribute)) {
			local.locate = listFindNoCase(local.node.xmlAttributes[local.antiAttribute], arguments.role);
			
			if(local.locate) {
				local.node.xmlAttributes[local.antiAttribute] = listDeleteAt(local.node.xmlAttributes[local.antiAttribute], locate);
			}
		} else {
			local.node.xmlAttributes[local.antiAttribute] = local.antiAttribute == 'allow' ? '' : '*';
		}
		
		// Add to the proper attribute
		if(structKeyExists(local.node.xmlAttributes, arguments.attribute)) {
			local.locate = listFindNoCase(local.node.xmlAttributes[arguments.attribute], arguments.role);
			
			if(!local.locate) {
				local.node.xmlAttributes[arguments.attribute] = listAppend(local.node.xmlAttributes[arguments.attribute], arguments.role);
			}
		} else {
			local.node.xmlAttributes[arguments.attribute] = arguments.role;
		}
		
		// Apply role to the children
		for(local.i = 1; local.i <= arrayLen(local.node.xmlChildren); local.i++) {
			addRole(local.node, local.node.xmlChildren[local.i].xmlName, arguments.role, arguments.attribute);
		}
	}
	
	public void function applyChanges(required string role, required struct changes) {
		local.root = this.getNavigation().xmlRoot;
		
		local.keys = listToArray(structKeyList(arguments.changes));
		
		for(local.i = 1; local.i <= arrayLen(local.keys); local.i++) {
			addRole(local.root, local.keys[local.i], arguments.role, arguments.changes[local.keys[local.i]]);
		}
	}
}
