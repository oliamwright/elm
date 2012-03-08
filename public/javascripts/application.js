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

	this.task_ownership_actual_time = function(data) {
		container = $(data).parents(".tasks");
		id = container.attr('data-id');
		$("#story_" + id).load("/stories/" + id + " #story_" + id, unwrap);
	};

	this.story_client_value = function(data) {
		container = $(data).parents(".story");
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

/* keyboard helper functions */

var number_input = "";
var current_story = "1";

var Keyboard = new function() {

	this.selectStory = function(evt) {
		var identifier = '.story[data-story-number="' + current_story + '"] input[name="sel"]';
		$(identifier).click();
	};

	this.focusNewStoryInput = function(evt) {
		current_story = "1";
		$('#story_description').focus();
		evt.stopPropagation();
		evt.preventDefault();
		return false;
	};

	this.highlightCurrent = function() {
		$('.currently_selected').removeClass('currently_selected');
		var identifier = '.story[data-story-number="' + current_story + '"]';
		$(identifier).addClass('currently_selected');
		$(identifier).next('.tasks').addClass('currently_selected');
	};

	this.focusNewTaskInput = function(evt) {
		if (number_input.length > 0) {
			Keyboard.goToStory();
		};
		var identifier = '.story[data-story-number="' + current_story + '"]';
		var input = $(identifier).next('.tasks').find('input[name="sub_item[description]"]');
		input.focus();
		evt.stopPropagation();
		evt.preventDefault();
		return false;
	};

	this.goToNextStory = function(evt) {
		number_input = parseInt(current_story) + 1;
		Keyboard.goToStory();
	};

	this.goToPreviousStory = function(evt) {
		number_input = parseInt(current_story) - 1;
		Keyboard.goToStory();
	};

	this.addNumberToInput = function(evt) {
		number_input += evt.data;
	};

	this.scrollTop = function() {
		$('html, body').animate({scrollTop: 0}, 500);
		current_story = "1";
		Keyboard.clearNumberInput();
		Keyboard.highlightCurrent();
	};

	this.scrollBottom = function() {
		var last_story = $('.story').last();
		var story_num = last_story.attr('data-story-number');
		var top = last_story.offset().top;
		$('html, body').animate({scrollTop: top}, 500);
		current_story = story_num;
		Keyboard.clearNumberInput();
		Keyboard.highlightCurrent();
	};

	this.goToStory = function() {
		var identifier = '.story[data-story-number="' + number_input + '"]';
		if ($(identifier).size() > 0) {
			var pos = $(identifier).first().offset().top - 70;
			$('html, body').animate({scrollTop: pos}, 500);
			current_story = number_input;
		};
		Keyboard.clearNumberInput();
		Keyboard.highlightCurrent();
	};

	this.openHelp = function(evt) {
		window.open('/keyboard_help', 'Keyboard Shortcut Help', 'width=800,height=600');
	};

	this.clearNumberInput = function(evt) {
		number_input = "";
	};

};

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

