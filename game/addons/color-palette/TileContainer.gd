tool
extends FlexGridContainer

signal grid_item_reordered(index_from, index_to)

var dragging: ColorRect = null
var drag_start_index = -1

func _gui_input(event):
	if event is InputEventMouseMotion and dragging != null:
#		Move the color rect as the user drags it for a live preview
		var mp = event.position
		for c in get_children():
			c = c as ColorRect
			if c.get_rect().has_point(mp):
				move_child(dragging, c.get_index())
		
	
#	When dragging finished
	if (event is InputEventMouseButton and 
			dragging != null and
			event.get_button_index() == 1 and
			event.is_pressed() == false):
				emit_signal("grid_item_reordered", 
						drag_start_index, 
						dragging.get_index())
								
				dragging = null
