// Keep track of all header cells.
var cells = [];

function getAbsolutePosition(element) {
	var r = { x: element.offsetLeft, y: element.offsetTop };
	if (element.offsetParent) {
		var tmp = getAbsolutePosition(element.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
};

// Attach to all headers.
$(document).ready(function() {
	var z = 0;
	var offset = 0;
	$('.stickify').each(function () {

		// Find stickify height.
		var story_list = $(this)[0];
		var height = $(story_list).addClass('sticky-header').height();
		var i = 0;

		// Ensure each cell has an element in it.
		var html = $(this).html();
		if (html == ' ') {
			html = '&nbsp;';
		}
		if ($(this).children().size() == 0) {
			html = '<span>'+ html +'</span>';
		}

		// Clone and wrap cell contents in sticky wrapper that overlaps the cell's padding.
		var cont = $('<div class="sticky-header" style="position: fixed; visibility: hidden; top: ' + offset + 'px;background: white;border-bottom:1px solid #ccc"></div>');
		$(this).clone(true).appendTo(cont);
		cont.prependTo($(this));
		var div = $('div.sticky-header', this).css({
			'marginLeft': '-'+ $(this).css('paddingLeft'),
			'marginRight': '-'+ $(this).css('paddingRight'),
			'paddingLeft': $(this).css('paddingLeft'),
			'paddingTop': $(this).css('paddingTop'),
			'paddingBottom': $(this).css('paddingBottom'),
			'z-index': ++z
		})[0];
		cells.push(div);

		offset += height;

		// Adjust width to fit cell/table.
		var ref = this;
		if (!i++) {
			// The first cell is as wide as the table to prevent gaps.
			ref = story_list;
			div.wide = true;
		}
		$(div).css('width', parseInt($(ref).width())
											- parseInt($(div).css('paddingLeft')) +'px');

		// Get position and store.
		div.cell = this;
		div.table = story_list;
		div.stickyMax = $(document).height();
		div.stickyPosition = getAbsolutePosition(this).y;
	});
});

// Track scrolling.
var scroll = function() {
	$(cells).each(function () {
		// Fetch scrolling position.
		var scroll = document.documentElement.scrollTop || document.body.scrollTop;
		var offset = scroll - this.stickyPosition - 4;
		if (offset > 0 && offset < this.stickyMax - 100) {
			$(this).css('visibility', 'visible');
		}
		else {
			$(this).css('visibility', 'hidden');
		}
	});
};
$(window).scroll(scroll);
$(document.documentElement).scroll(scroll);

// Track resizing.
var time = null;
var resize = function () {
	// Ensure minimum time between adjustments.
	if (time) {
		clearTimeout(time);
		time = null;
	}
	time = setTimeout(function () {

		// Precalculate table heights
		$('.sticky-header').each(function () {
			this.height = $(this).height();
		})

		$(cells).each(function () {
			// Get position.
			this.stickyPosition = getAbsolutePosition(this.cell).y;
			this.stickyMax = this.story_list.height;

			// Reflow the cell.
			var ref = this.cell;
			if (this.wide) {
				// Resize the first cell to fit the table.
				ref = this.story_list;
			}
			$(this).css('width', parseInt($(ref).width())
												 - parseInt($(this).css('paddingLeft')) +'px');
		});
	}, 250);
};
$(window).resize(resize);
