/// @description 
active_window = new GuiStaticWindow("Window "+string(ds_list_size(windows)), mouse_gui_x, mouse_gui_y, 400, 350, sprNineSlice, sprTitleBar);
ds_list_add(windows, active_window);