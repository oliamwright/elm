// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var templateJS = new function() {

	this.process = function(data) {
		$('#' + data.type).jqoteapp('#tmpl_' + data.type, data);
	};

	this.setup = function() {
		// load templates
		$.ajax({
			async: false,
			url: 'templates/templates.tpl.html',
			cache: false,
			success: function(data) {
				$('#templates').html(data);
			}
		});
	};

};

/* main */
$(function() {
});

