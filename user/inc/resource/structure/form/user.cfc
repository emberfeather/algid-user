<cfcomponent extends="cf-compendium.inc.resource.structure.form.common" output="false">
	<cffunction name="elementNavigation" access="public" returntype="string" output="false">
		<cfargument name="element" type="struct" required="true" />
		
		<cfset local.pathParts = listToArray(arguments.element.data.path, '/') />
		<cfset local.pathCount = arrayLen(local.pathParts) />
		
		<cfsavecontent variable="local.formatted">
			<cfoutput>
				<div data-path="#arguments.element.data.path#">
					<div class="float-right phantom">
						#elementRadio({
							type: 'radio',
							id: arguments.element.id,
							name: arguments.element.name,
							options: arguments.element.options,
							value: arguments.element.value,
							class: arguments.element.class
						})#
					</div>
					
					<div class="level #arguments.element.value#">
						<cfloop from="1" to="#local.pathCount#" index="local.i">
							<span class="part <cfif local.i eq local.pathCount>strong</cfif>">
								/#local.pathParts[local.i]#
							</span>
						</cfloop>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.formatted />
	</cffunction>
</cfcomponent>
