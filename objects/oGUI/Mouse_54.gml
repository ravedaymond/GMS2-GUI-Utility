/// @description 
active_window = new GuiDynamicWindow("Window "+string(ds_list_size(windows)), mouse_gui_x, mouse_gui_y, 200, 300, sprNineSlice, sprTitleBar);
ds_list_add(windows, active_window);