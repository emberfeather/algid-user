(function($) {
	$(function(){
		$('input[type="radio"]').live('change', updateRow);
		
		$('.level').live('dblclick', toggleRow);
	});
	
	function changeClass(element, className) {
		element
			.removeClass('deny')
			.removeClass('allow')
			.removeClass('inherit')
			.addClass(className);
	}
	
	function updateRow() {
		changeClass($('.level', $(this).parents('.element')), this.value);
	}
	
	function toggleRow() {
		var level = $(this);
		var inputs = $('input[type="radio"]', level.parents('.element'));
		
		if(level.hasClass('allow')) {
			changeClass(level, 'deny');
			inputs.filter('[value="deny"]').prop('checked', 'checked').focus();
		} else {
			changeClass(level, 'allow');
			inputs.filter('[value="allow"]').prop('checked', 'checked').focus();
		}
	}
}(jQuery));
