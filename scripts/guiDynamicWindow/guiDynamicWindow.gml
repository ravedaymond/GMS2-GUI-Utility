/// @description Create a resizeable GUI window
/// @param _name Name of window.
/// @param _x Initial x position (top left)
/// @param _y Initial y position (top left)
/// @param _w Default width
/// @param _h Default height
function GuiDynamicWindow(_name, _xstart, _ystart, _default_width, _default_height, _nine_slice_sprite, _title_bar_sprite) : GuiStaticWindow(_name, _xstart, _ystart, _default_width, _default_height, _nine_slice_sprite, _title_bar_sprite) constructor {
	
	#region Attribute Override
	min_width = string_width(_name)+padding*2+gui_window_button_width*5;
	min_height = min_width;
	if(min_width > def_width) {
		def_width = min_width;
		width = min_width;
	}
	if(min_height > def_height) {
		def_height = min_height;
		height = min_height;
	}
	#endregion
	
	overlap = {
		sprite: sprButtonOverlap,
		position: 2,
		hover: false,
		enabled: false
	}
	
	pinned = {
		sprite: sprButtonPinned,
		position: 3,
		hover: false,
		enabled: false
	}
	
	reset = {
		sprite: sprButtonReset,
		position: 4,
		hover: false
	}

	static mouseGrab = function(_mx, _my) {
		return !pinned.enabled && mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x, y, x2(), y+title_height);	
	}
	
	static mouseResize = function(_mx, _my) {
		return !pinned.enabled && mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-padding, y2()-padding, x2(), y2());
	}
	
	static resetSize = function() {
		width = def_width;
		height = def_height;
	}
	
	#region Overlap Button
	static hoverOverlap = function(_mx, _my) {
		overlap.hover = point_in_rectangle(_mx, _my, x2()-padding-(gui_window_button_width*overlap.position), y+button_shelf, x2()-padding-(gui_window_button_width*(overlap.position-1)), y+button_shelf+gui_window_button_height);
		return overlap.hover;
	}
	
	static mouseOverlap = function(_mx, _my) {
		var retval = hoverOverlap(_mx, _my) && mouse_check_button_pressed(mb_left);
		if(retval) {
			overlap.enabled = !overlap.enabled;
		}
		return retval;
	}
	
	static drawButtonOverlap = function() {
		var index = overlap.enabled ? 1:0;
		if(overlap.hover) index = index == 1 ? 0 : 1;
		draw_sprite_ext(overlap.sprite, index, x2()-padding-(gui_window_button_width*overlap.position), y+button_shelf, xscale, yscale, 0, c_white, 1);
	}
	#endregion
	
	#region Pinned Button
	static hoverPinned = function(_mx, _my) {
		pinned.hover = point_in_rectangle(_mx, _my, x2()-padding-(gui_window_button_width*pinned.position), y+button_shelf, x2()-padding-(gui_window_button_width*(pinned.position-1)), y+button_shelf+gui_window_button_height);
		return pinned.hover;
	}
	
	static mousePinned = function (_mx, _my) {
		var retval = hoverPinned(_mx, _my) && mouse_check_button_pressed(mb_left);
		if(retval) {
			pinned.enabled = !pinned.enabled;
		}
		return retval;
	}
	
	static drawButtonPinned = function() {
		var index = pinned.enabled ? 1:0;
		if(pinned.hover) index = index == 1 ? 0 : 1;
		draw_sprite_ext(pinned.sprite, index, x2()-padding-(gui_window_button_width*pinned.position), y+button_shelf, xscale, yscale, 0, c_white, 1);
	}
	#endregion
	
	#region Reset Button
	static hoverReset = function(_mx, _my) {
		reset.hover = point_in_rectangle(_mx, _my, x2()-padding-gui_window_button_width*reset.position, y+button_shelf, x2()-padding-(gui_window_button_width*(reset.position-1)), y+button_shelf+gui_window_button_height);
		return reset.hover;
	}
	
	static mouseReset = function(_mx, _my) {
		return hoverReset(_mx, _my) && mouse_check_button_pressed(mb_left);
	}
	
	static drawButtonReset = function() {
		draw_sprite_ext(reset.sprite, reset.hover ? 1:0, x2()-padding-(gui_window_button_width*reset.position), y+button_shelf, xscale, yscale, 0, c_white, 1);
	}
	#endregion
	
	static resize = function(_mx, _my) {
		draw_set_alpha(0.45);
		draw_set_color(c_blue);
		draw_rectangle(x, y, _mx, _my, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
	
	static draw = function() {
		drawWindow();
		drawTitleBar();
		drawTitleName();
		drawButtonClose();
		drawButtonOverlap();
		drawButtonPinned();
		drawButtonReset();
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
	
	// @Override
	static drawWindow = function() {
		NineSliceBoxStretched(sprNineSlice, x, y, x2(), y2(), 4);
	}
	
	#region Debugging Functions	
	static debugDrawResizeCorner = function() {
		draw_set_color(c_red);
		draw_set_alpha(0.7);
		draw_rectangle(x2()-padding, y2()-padding, x2(), y2(), false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	
	static debugDrawOverlapButton = function() {
		draw_set_color(c_orange);
		draw_set_alpha(0.7);
		draw_rectangle(x2()-padding-(gui_window_button_width*overlap.position), y+button_shelf, x2()-padding-(gui_window_button_width*(overlap.position-1)), y+button_shelf+gui_window_button_height, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	
	static debugDrawPinnedButton = function(position) {
		draw_set_color(c_lime);
		draw_set_alpha(0.7);
		draw_rectangle(x2()-padding-(gui_window_button_width*pinned.position), y+button_shelf, x2()-padding-(gui_window_button_width*(pinned.position-1)), y+button_shelf+gui_window_button_height, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	#endregion
	
}