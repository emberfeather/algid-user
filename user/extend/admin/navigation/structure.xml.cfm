<navigation>
	<account position="main">
		<logout position="action"/>
		<password position="secondary"/>
		<settings position="secondary"/>
	</account>
	
	<schemes position="main">
		<add position="action"/>
		<delete position="action"/>
		<edit position="action"/>
		<list position="action"/>
		
		<permissions position="secondary">
			<edit position="action"/>
			<list position="action"/>
			<roles position="secondary"/>
		</permissions>
		
		<roles position="secondary">
			<add position="action"/>
			<delete position="action"/>
			<edit position="action"/>
			<list position="action"/>
			<permissions position="secondary"/>
			<users position="secondary"/>
		</roles>
	</schemes>
	
	<users position="main">
		<add position="action"/>
		<archive position="action"/>
		<edit position="action"/>
		<list position="action"/>
	</users>
</navigation>
