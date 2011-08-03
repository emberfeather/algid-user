(function($) {
	$(function(){
		$('input[type="radio"]').live('change', updateRow);
		$('.level').live('dblclick', toggleRow);
	});
	
	function changeAccess(element, access) {
		var parts;
		var parent = '';
		var subPaths = '';
		var level = $('.level', element);
		var inputs = $('input[type="radio"]', element);
		var path = $('[data-path]', element);
		
		if(access === 'allow') {
			level.removeClass('deny').addClass('allow');
			
			inputs.filter('[value="allow"]').prop('checked', 'checked').focus();
			
			// Deny,Allow - Make sure that all parent paths are allowed
			parts = path.data('path').substr(1).split('/');
			
			for(var i = 0; i < parts.length - 1; i++) {
				parent += '/' + parts[i];
				subPaths += ',[data-path="' + parent + '"]';
			}
			
			subPaths = $(subPaths);
			
			$('.level', subPaths).removeClass('deny').addClass('allow');
			$('input[type="radio"]', subPaths).filter('[value="allow"]').prop('checked', 'checked');
		} else {
			level.removeClass('allow').addClass('deny');
			
			inputs.filter('[value="deny"]').prop('checked', 'checked').focus();
			
			// Deny,Allow - Deny the child paths
			subPaths = $('[data-path^="' + path.data('path') + '/"]');
			
			$('.level', subPaths).removeClass('allow').addClass('deny');
			$('input[type="radio"]', subPaths).filter('[value="deny"]').prop('checked', 'checked');
		}
	}
	
	function updateRow() {
		changeAccess($(this).parents('.element'), this.value);
	}
	
	function toggleRow() {
		var level = $(this);
		
		if(level.hasClass('allow')) {
			changeAccess(level.parents('.element'), 'deny');
		} else {
			changeAccess(level.parents('.element'), 'allow');
		}
	}
}(jQuery));
