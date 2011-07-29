(function($) {
	$(function(){
		$('input[type=radio]').live('change', updateRow);
	});
	
	function updateRow() {
		var element = $(this);
		
		$('.level', element.parents('.element'))
			.removeClass('deny')
			.removeClass('allow')
			.removeClass('inherit')
			.addClass(this.value);
	}
}(jQuery));
