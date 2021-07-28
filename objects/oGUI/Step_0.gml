/// @description Control GUI Windows
if(!ds_list_empty(windows)) {
	// Ensure active_window is assigned if a window exists.
	if(active_window == undefined) {
		active_window = windows[| ds_list_size(windows)-1];	
	}
	// If we are already interacting, ignore interaction checks
	if(!grabbed && !resizing) {
		#region Assign active_window
		/* 
			If the cursor is over the active_window, do nothing.
			
			If the cursor is not over the active_window, then for every known
			window check that the cursor is over them and that the left mouse
			button was pressed. If those conditions are true, assign that window
			as the active_window.
			
			Mouse check in first evaluation position for GML to get early kickout.
		*/
		if(!active_window.mouseOver(mouse_gui_x, mouse_gui_y)) {
			var i=ds_list_size(windows)-1;
			repeat(ds_list_size(windows)) {
				var _window = windows[|i];
				if(_window.mouseOver(mouse_gui_x, mouse_gui_y) && mouse_check_button_pressed(mb_left)) {
					console_log("active window change", _window.name);
					active_window = _window;
					ds_list_delete(windows, i);
					ds_list_add(windows, _window);
					break;
				}
				i--;
			}
		}
		#endregion;
		/*
			If the active_window is clicked on in the close region,
			delete the struct reference from active_window and remove
			the window from the ds_list.
			
			Needs to be last function in line. -- Update: Does it? Moved it ahead of any grabbing so that it would not grab a closed window. Need to stress test.
		*/
		if(active_window.mouseClose(mouse_gui_x, mouse_gui_y)) {
			console_log("closed window", active_window.name);
			delete active_window;
			ds_list_delete(windows, ds_list_size(windows)-1);
		}
		
		#region Check for interaction with active_window
		// Allow resize and moving for only dynamic windows
		if(instanceof(active_window) == gui_dynamic) {
			/*
				If the mouse is clicked while over the overlap lock button,
				toggle the value of overlap.
			*/
			if(active_window.mouseOverlap(mouse_gui_x, mouse_gui_y)) {
				console_log("overlap locked window", active_window.name);
			} 
			/*
				If the mouse is clicked while over the pinned button,
				toggle the value of pinned.
			*/
			else if(active_window.mousePinned(mouse_gui_x, mouse_gui_y)) {
				console_log("pinned window", active_window.name);	
			} 
			/*
				If the mouse is clicked while over the reset button,
				call the reset() function for the active_window.
			*/
			else if(active_window.mouseReset(mouse_gui_x, mouse_gui_y)) {
				console_log("reset window", active_window.name);
				active_window.resetSize();
			} 
			/*
				If the active_window is grabbed in the title region, set 
				grabbed=true and record the inital difference between the 
				mouse x,y and the window x,y to use as offset when moving.
				
				Is the final check to prevent dragging while clicking window buttons.
			*/
			else if(active_window.mouseGrab(mouse_gui_x, mouse_gui_y)) {
				console_log("moving window", active_window.name);
				grabbed = true;
				grab_xdiff = mouse_gui_x-active_window.x;
				grab_ydiff = mouse_gui_y-active_window.y;
				window_set_cursor(cr_size_all);
			}
			/*
				If the active_window is grabbed in the resize region, set 
				resizing=true.
			*/
			if(active_window.mouseResize(mouse_gui_x, mouse_gui_y)) {
				console_log("resizing window", active_window.name);
				resizing = true;
				window_set_cursor(cr_size_nwse);
			}
		}
		#endregion
	}
} else {
	/* Ensure active_window is undefined if there are no windows.*/
	active_window = undefined;	
}

#region Move active_window
if(grabbed) {
	var x_prev = active_window.x;
	var y_prev = active_window.y;
	active_window.x = mouse_gui_x-grab_xdiff;
	active_window.x = clamp(active_window.x, active_window.margin, window_get_width()-(active_window.width+active_window.margin));
	active_window.y = mouse_gui_y-grab_ydiff;
	active_window.y = clamp(active_window.y, active_window.margin, window_get_height()-(active_window.height+active_window.margin));
	var i = 0;
	repeat(ds_list_size(windows)) {
		var _w = windows[|i];
		if(active_window != _w && ((instanceof(active_window) == gui_dynamic && instanceof(_w) == gui_dynamic) && (active_window.overlap.enabled || _w.overlap.enabled))) { //  &&
			/**
			
			The problem with the collision is that left/right is being checked prior to up/down, and not simultaneously. Due to the way moving the windows works (without different speed values like moving
			a character), as soon as it starts to slide right while in the same recatangle_in_rectangle collision box it will clip to the x side it is expecting to be encountering.
			
			Eg. When "touching" either the bottom or the top of another window while moving right will place it on the left side of the window; while moving left it will place it on the right.

			*/
			if((x_prev+active_window.width) <= _w.x) { // Moving Right; Collision with active windows right edge and other windows left edge
				if(active_window.x2() > _w.x && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.x = _w.x-active_window.width;
				}
				window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			}
			if(x_prev >= _w.x2()) { // Moving Left; Collision with active windows left edge and other windows right edge
				if(active_window.x < _w.x2() && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.x = _w.x2();
				}
				window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			}
			if((y_prev+active_window.height) <= _w.y) { // Moving Down; Collision with active windows bottom edge and other windows top edge
				if(active_window.y2() > _w.y && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.y = _w.y-active_window.height;
				}
				window_mouse_set(mouse_gui_x, clamp(mouse_gui_y, active_window.y, active_window.y2()));
			}
			if(y_prev >= _w.y2()) { // Moving Up; Collision with active windows top edge and other windows bottom edge
				if(active_window.y < _w.y2() && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.y = _w.y2();
				}
				window_mouse_set(mouse_gui_x, clamp(mouse_gui_y, active_window.y, active_window.y2()));
			}
		}
		i++;
	}
}
#endregion

#region End active_window interaction
if(mouse_check_button_released(mb_left)) {
	if(grabbed) {
		grabbed = false;
	}
	if(resizing) {
		resizing = false;
		active_window.width -= active_window.x2()-clamp(mouse_gui_x, active_window.x+active_window.min_width, window_get_width()-(active_window.margin));
		if(active_window.width < active_window.min_width) {
			active_window.width = active_window.min_width;
		}
		active_window.height -= active_window.y2()-clamp(mouse_gui_y, active_window.y+active_window.min_height, window_get_height()-(active_window.margin));
		if(active_window.height < active_window.min_height) {
			active_window.height = active_window.min_height;
		}
	}
	window_set_cursor(cr_default);
}
#endregion

#region /**** DEMO PURPOSES ONLY ****/
if(keyboard_check_pressed(vk_escape)) {
	game_restart();
}
#endregion