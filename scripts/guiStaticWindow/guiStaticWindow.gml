/// @description Create a basic GUI static window
/// @param _name Name of window.
/// @param _x Initial x position (top left)
/// @param _y Initial y position (top left)
/// @param _w Default width
/// @param _h Default height
function GuiStaticWindow(_name, _xstart, _ystart, _default_width, _default_height, _nine_slice_sprite, _title_bar_sprite) constructor {
	name = _name;
	x = _xstart;
	y = _ystart;
	depth = -y;
	def_width = _default_width;
	def_height = _default_height;
	width = _default_width;
	height = _default_height;
	sprite = _nine_slice_sprite;
	title = _title_bar_sprite;
	title_height = sprite_get_height(_title_bar_sprite);
	padding = title_height/3;
	margin = padding;
	
	close = {
		sprite: sprButtonClose,
		position: 1,
		hover: false
	}
	
	button_shelf = 5;
	border = 2;
	scroll_bar = 5;
	
	static xscale = 1;
	static yscale = 1;
	
	static setXscale = function(_xscale) {
		xscale = _xscale;	
	}
	
	static setYscale = function(_yscale) {
		yscale = _yscale;	
	}
	
	static x2 = function() {
		return x+width;
	}
	
	static y2 = function() {
		return y+height;
	}
	
	static mouseOver = function(_mx, _my) {
		return point_in_rectangle(_mx, _my, x, y, x2(), y2());
	}
	
	#region Close Button
	static hoverClose = function(_mx, _my) {
		close.hover = point_in_rectangle(_mx, _my, x2()-padding-gui_window_button_width*close.position, y+button_shelf, x2()-padding-(gui_window_button_width*(close.position-1)), y+button_shelf+gui_window_button_height);
		return close.hover;
	}
	
	static mouseClose = function(_mx, _my) {
		return hoverClose(_mx, _my) && mouse_check_button_pressed(mb_left);
	}
	
	static drawButtonClose = function() {
		draw_sprite_ext(close.sprite, close.hover ? 1:0, x2()-padding-(gui_window_button_width*close.position), y+button_shelf, xscale, yscale, 0, c_white, 1);
	}
	#endregion
	
	static draw = function() {
		drawWindow();
		drawTitleBar();
		drawTitleName();
		drawButtonClose();
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
	
	static drawWindow = function() {
		NineSliceBoxStretched(sprite, x, y, x2(), y2(), 0);
	}
	
	static drawTitleBar = function() {
		NineSliceBoxStretched(title, x, y, x2(), y+title_height, 0);
	}
	
	static drawTitleName = function() {
		draw_set_color(c_black);
		draw_set_font(global.gui_window_title_font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(x+padding, y+(padding*0.5), name);
	}
	
	#region Debugging Functions
	static debugDrawCloseButton = function() {
		draw_set_color(c_red);
		draw_set_alpha(0.7);
		draw_rectangle(x2()-padding-(gui_window_button_width*close.position), y+button_shelf, x2()-padding-(gui_window_button_width*(close.position-1)), y+button_shelf+gui_window_button_height, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	
	static debugDrawContentArea = function() {
		draw_rectangle(x+padding, y+title_height+padding, x2()-padding, y2()-padding, false);
	}
	#endregion
	
}