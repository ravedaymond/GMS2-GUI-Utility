/// @description 

global.gui_window_title_font = fntGUItitle;
global.gui_window_body_font = fntGUIbody;
global.gui_window_xscale = 1;
global.gui_window_yscale = 1;
#macro gui_window_button_width 24
#macro gui_window_button_height 24

#macro gui_static "GuiStaticWindow"
#macro gui_dynamic "GuiDynamicWindow"

#macro mouse_gui_x window_mouse_get_x()
#macro mouse_gui_y window_mouse_get_y()

windows = ds_list_create();
active_window = undefined;

grabbed = false;
grab_xdiff = 0;
grab_ydiff = 0;

resizing = false;