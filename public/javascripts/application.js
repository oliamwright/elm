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

var bipCallbacks = new function() {
	this.sub_item_estimated_time = function(data) {
		container = $(data).parents(".tasks");
		id = container.attr('data-id');
		$("#story_" + id + " .est_time").load("/stories/" + id + " #story_" + id + " .est_time");
	};

	this.sub_item_status = function(data) {
		t = $(data);
		t.parents(".item").load(t.attr("data-url"), unwrap);
		container = $(data).parents(".tasks");
		id = container.attr('data-id');
		$("#story_" + id).load("/stories/" + id + " #story_" + id, unwrap);
	};

	this.sub_item = function(data) {
		container = $(data).parents(".tasks");
		id = container.attr('data-id');
		$("#story_" + id).load("/stories/" + id + " #story_" + id, unwrap);
	};

	this.project_test_output_url = function(data) {
		window.location=window.location;
	};

	this.generic = function(data) {
	};
};

function testCallback(func, data) {
	fn = window["bipCallbacks"][func];
	fnExists = typeof fn === "function";
	if (fnExists) {
		fn(data);
		return true;
	}
	return false;
}

function unwrap() {
	$(this).children(":first").unwrap();
	resetBip();
}

function resetBip() {
	$(".best_in_place").best_in_place();
}

/* main */
$(function() {
	$(document).delegate('#project_dropdown', 'click', function() { $('#project_dropdown_menu').toggle(); });
	//$(document).delegate('#project_dropdown_menu', 'mouseout', function() { $(this).hide(); });
	$('.best_in_place').best_in_place();
	$(document).delegate(".best_in_place", 'ajax:success', function(e) {
		t = $(this);
		object = t.attr('data-object');
		attribute = t.attr('data-attribute');
		if (!testCallback(object + "_" + attribute, t)) {
			if (!testCallback(object, t)) {
				bipCallbacks.generic(t);
			}
		}
	});

});

