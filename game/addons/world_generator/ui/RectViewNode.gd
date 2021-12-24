tool
extends MarginContainer

enum DragType {
	DRAG_NONE = 0,
	DRAG_MOVE = 1,
	DRAG_RESIZE_TOP = 1 << 1,
	DRAG_RESIZE_RIGHT = 1 << 2,
	DRAG_RESIZE_BOTTOM = 1 << 3,
	DRAG_RESIZE_LEFT = 1 << 4
};

var edited_resource : WorldGenBaseResource = null

var drag_type : int
var drag_offset : Vector2
var drag_offset_far : Vector2

func _draw():
	draw_rect(Rect2(get_position(), get_size()), Color(1, 1, 1, 1))

func refresh() -> void:
	if !edited_resource:
		return
		
	var rect : Rect2 = edited_resource.get_rect()
	
	rect_position = rect.position
	rect_size = rect.size
	
	update()

func set_edited_resource(res : WorldGenBaseResource):
	edited_resource = res
	
	refresh()
	
#based on / ported from engine/scene/gui/dialogs.h and .cpp
func _notification(p_what : int) -> void:
	if (p_what == NOTIFICATION_MOUSE_EXIT):
			# Reset the mouse cursor when leaving the resizable window border.
			if (edited_resource && !edited_resource.locked && !drag_type):
				if (get_default_cursor_shape() != CURSOR_ARROW):
					set_default_cursor_shape(CURSOR_ARROW)

#based on / ported from engine/scene/gui/dialogs.h and .cpp
func _gui_input(p_event : InputEvent) -> void:
	if (p_event is InputEventMouseButton) && (p_event.get_button_index() == BUTTON_LEFT):
		var mb : InputEventMouseButton = p_event as InputEventMouseButton
		
		if (mb.is_pressed()):
			# Begin a possible dragging operation.
			drag_type = _drag_hit_test(Vector2(mb.get_position().x, mb.get_position().y))
			
			if (drag_type != DragType.DRAG_NONE):
				drag_offset = get_global_mouse_position() - get_position()
			
			drag_offset_far = get_position() + get_size() - get_global_mouse_position()
			
		elif (drag_type != DragType.DRAG_NONE && !mb.is_pressed()):
			# End a dragging operation.
			drag_type = DragType.DRAG_NONE

	if p_event is InputEventMouseMotion:
		var mm : InputEventMouseMotion = p_event as InputEventMouseMotion

		if (drag_type == DragType.DRAG_NONE):
			# Update the cursor while moving along the borders.
			var cursor = CURSOR_ARROW
			if (!edited_resource.locked):
				var preview_drag_type : int = _drag_hit_test(Vector2(mm.get_position().x, mm.get_position().y))
				
				var top_left : int = DragType.DRAG_RESIZE_TOP + DragType.DRAG_RESIZE_LEFT
				var bottom_right : int = DragType.DRAG_RESIZE_BOTTOM + DragType.DRAG_RESIZE_RIGHT
				var top_right : int = DragType.DRAG_RESIZE_TOP + DragType.DRAG_RESIZE_RIGHT
				var bottom_left : int = DragType.DRAG_RESIZE_BOTTOM + DragType.DRAG_RESIZE_LEFT
				
				match (preview_drag_type):
					DragType.DRAG_RESIZE_TOP:
						cursor = CURSOR_VSIZE
					DragType.DRAG_RESIZE_BOTTOM:
						cursor = CURSOR_VSIZE
					DragType.DRAG_RESIZE_LEFT:
						cursor = CURSOR_HSIZE
					DragType.DRAG_RESIZE_RIGHT:
						cursor = CURSOR_HSIZE
					top_left:
						cursor = CURSOR_FDIAGSIZE
					bottom_right:
						cursor = CURSOR_FDIAGSIZE
					top_right:
						cursor = CURSOR_BDIAGSIZE
					bottom_left:
						cursor = CURSOR_BDIAGSIZE
			
			if (get_cursor_shape() != cursor):
				set_default_cursor_shape(cursor);
			
		else:
			# Update while in a dragging operation.
			var global_pos : Vector2 = get_global_mouse_position()
			global_pos.y = max(global_pos.y, 0) # Ensure title bar stays visible.

			var rect : Rect2 = get_rect()
			var min_size : Vector2 = get_combined_minimum_size()

			if (drag_type == DragType.DRAG_MOVE):
				rect.position = global_pos - drag_offset
			else:
				if (drag_type & DragType.DRAG_RESIZE_TOP):
					var bottom : int = rect.position.y + rect.size.y
					var max_y : int = bottom - min_size.y
					rect.position.y = min(global_pos.y - drag_offset.y, max_y)
					rect.size.y = bottom - rect.position.y
				elif (drag_type & DragType.DRAG_RESIZE_BOTTOM):
					rect.size.y = global_pos.y - rect.position.y + drag_offset_far.y
				
				if (drag_type & DragType.DRAG_RESIZE_LEFT):
					var right : int = rect.position.x + rect.size.x
					var max_x : int = right - min_size.x
					rect.position.x = min(global_pos.x - drag_offset.x, max_x)
					rect.size.x = right - rect.position.x
				elif (drag_type & DragType.DRAG_RESIZE_RIGHT):
					rect.size.x = global_pos.x - rect.position.x + drag_offset_far.x

			set_size(rect.size)
			set_position(rect.position)

#based on / ported from engine/scene/gui/dialogs.h and .cpp
func _drag_hit_test(pos : Vector2) -> int:
	var drag_type : int = DragType.DRAG_NONE

	if (!edited_resource.locked):
		var scaleborder_size : int = 10 #get_constant("scaleborder_size", "WindowDialog")

		var rect : Rect2 = get_rect()

		if (pos.y < (scaleborder_size)):
			drag_type = DragType.DRAG_RESIZE_TOP
		elif (pos.y >= (rect.size.y - scaleborder_size)):
			drag_type = DragType.DRAG_RESIZE_BOTTOM
		
		if (pos.x < scaleborder_size):
			drag_type |= DragType.DRAG_RESIZE_LEFT
		elif (pos.x >= (rect.size.x - scaleborder_size)):
			drag_type |= DragType.DRAG_RESIZE_RIGHT
			
		if (drag_type == DragType.DRAG_NONE):
			drag_type = DragType.DRAG_MOVE

	return drag_type
