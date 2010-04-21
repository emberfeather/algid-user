<navigation>
	<account position="main">
		<login position="action"/>
		<logout position="action"/>
		<password position="main"/>
		<settings position="main"/>
	</account>
	
	<admin position="main">
		<scheme position="main">
			<add position="action"/>
			<archive position="action"/>
			<detail position="action"/>
			<edit position="action"/>
			<list position="action"/>
			
			<permission position="main">
				<list position="action"/>
			</permission>
			
			<role position="main" ids="schemeID">
				<add position="action"/>
				<archive position="action"/>
				<detail position="action"/>
				<edit position="action"/>
				<list position="action"/>
				<permission position="action" ids="schemeID,roleID"/>
				<user position="action" ids="schemeID,roleID"/>
			</role>
		</scheme>
		
		<user position="main">
			<add position="action"/>
			<archive position="action"/>
			<edit position="action"/>
			<list position="action"/>
		</user>
	</admin>
</navigation>
