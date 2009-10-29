<navigation>
	<account position="main">
		<login position="action"/>
		<logout position="action"/>
		<password position="main"/>
		<settings position="main"/>
	</account>
	
	<admin position="main">
		<schemes position="main">
			<add position="action"/>
			<delete position="action"/>
			<edit position="action"/>
			<list position="action"/>
			
			<permissions position="main">
				<edit position="action"/>
				<list position="action"/>
				<roles position="main"/>
			</permissions>
			
			<roles position="main">
				<add position="action"/>
				<delete position="action"/>
				<edit position="action"/>
				<list position="action"/>
				<permissions position="main"/>
				<users position="main"/>
			</roles>
		</schemes>
		
		<users position="main">
			<add position="action"/>
			<archive position="action"/>
			<edit position="action"/>
			<list position="action"/>
		</users>
	</admin>
</navigation>
