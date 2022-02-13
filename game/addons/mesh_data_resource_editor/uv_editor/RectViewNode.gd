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

var selected : bool = false

var _mdr : MeshDataResource = null
var _indices : PoolIntArray = PoolIntArray()
var _uvs : PoolVector2Array = PoolVector2Array()
var _base_rect : Rect2 = Rect2(0, 0, 100, 100)
var _uv_min : Vector2 = Vector2()
var _uv_max : Vector2 = Vector2()

var edited_resource_parent_size : Vector2 = Vector2()

var _edited_resource_rect_border_color : Color = Color(0.8, 0.8, 0.8, 0.5)
var _edited_resource_rect_color : Color = Color(0.5, 0.5, 0.5, 0.2)
var _edited_resource_rect_selected_border_color : Color = Color(0.9, 0.9, 0.9, 0.8)
var _edited_resource_rect_selected_color : Color = Color(0.5, 0.5, 0.5, 0.4)
var _edited_resource_uv_mesh_color : Color = Color(1, 1, 1, 1)
var _editor_rect_border_size : int = 2
var _edited_resource_font_color : Color = Color(0, 0, 0, 1)
var _editor_additional_text : String = ""

var drag_type : int
var drag_offset : Vector2
var drag_offset_far : Vector2

var _rect_scale : float = 1

func _draw():
	if selected:
		draw_rect(Rect2(Vector2(), get_size()), _edited_resource_rect_selected_color)
		draw_rect(Rect2(Vector2(), get_size()), _edited_resource_rect_selected_border_color, false, _editor_rect_border_size)
	else:
		draw_rect(Rect2(Vector2(), get_size()), _edited_resource_rect_color)
		draw_rect(Rect2(Vector2(), get_size()), _edited_resource_rect_border_color, false, _editor_rect_border_size)
	
	if _mdr && _uvs.size() > 0:
		var c : Color = _edited_resource_uv_mesh_color
		
		for i in range(0, len(_indices), 3):
			draw_line(_uvs[_indices[i]] * get_size(), _uvs[_indices[i + 1]] * get_size(), c, 1, false)
			draw_line(_uvs[_indices[i + 1]] * get_size(), _uvs[_indices[i + 2]] * get_size(), c, 1, false)
			draw_line(_uvs[_indices[i + 2]] * get_size(), _uvs[_indices[i]] * get_size(), c, 1, false)

func mirror_horizontal() -> void:
	var pia : PoolIntArray = PoolIntArray()
	for index in _indices:
		var found : bool = false
		
		for i in pia:
			if i == index:
				found = true
				break
		
		if found:
			continue
			
		pia.append(index)
		
		var uv : Vector2 = _uvs[index]
		uv.x = 1.0 - uv.x
		_uvs.set(index, uv)
		
	apply_uv()
	update()
	
func mirror_vertical() -> void:
	var pia : PoolIntArray = PoolIntArray()
	for index in _indices:
		var found : bool = false
		
		for i in pia:
			if i == index:
				found = true
				break
		
		if found:
			continue
			
		pia.append(index)
		
		var uv : Vector2 = _uvs[index]
		uv.y = 1.0 - uv.y
		_uvs.set(index, uv)
		
	apply_uv()
	update()
	
func rotate_uvs(amount : float) -> void:
	var t : Transform2D = Transform2D(deg2rad(amount), Vector2())
	
	var pia : PoolIntArray = PoolIntArray()
	for index in _indices:
		var found : bool = false
		
		for i in pia:
			if i == index:
				found = true
				break
		
		if found:
			continue
			
		pia.append(index)
		
		var uv : Vector2 = _uvs[index]
		uv = t.xform(uv)
		_uvs.set(index, uv)
	
	
	re_normalize_uvs()
	apply_uv()
	update()

func refresh() -> void:
	if !_mdr:
		return
	
	var rect : Rect2 = _base_rect
	rect.position *= _rect_scale
	rect.size *= _rect_scale
	
	rect_position = rect.position
	rect_size = rect.size
	
	update()

func set_editor_rect_scale(rect_scale) -> void:
	_rect_scale = rect_scale
	
	refresh()

func set_edited_resource(mdr : MeshDataResource, indices : PoolIntArray):
	_mdr = mdr
	_indices = indices
	_uvs.resize(0)
	
	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return
		
	# Make sure it gets copied
	_uvs.append_array(arrays[ArrayMesh.ARRAY_TEX_UV])

	set_up_base_rect()

	refresh()

func set_up_base_rect() -> void:
	_base_rect = Rect2()
	
	if !_mdr:
		return
		
	if _uvs.size() == 0:
		return
	
	var vmin : Vector2 = _uvs[_indices[0]]
	var vmax : Vector2 = vmin
	for i in range(1, _indices.size()):
		var uv : Vector2 = _uvs[_indices[i]]
		
		if uv.x < vmin.x:
			vmin.x = uv.x
		
		if uv.x > vmax.x:
			vmax.x = uv.x
		
		if uv.y < vmin.y:
			vmin.y = uv.y
		
		if uv.y > vmax.y:
			vmax.y = uv.y
			
	_base_rect = Rect2(vmin.x, vmin.y, vmax.x - vmin.x, vmax.y - vmin.y)
	_base_rect.position *= edited_resource_parent_size
	_base_rect.size *= edited_resource_parent_size
	
	_uv_min = vmin
	_uv_max = vmax
	
	normalize_uvs()

func re_normalize_uvs() -> void:
	if _uvs.size() == 0:
		return
	
	var vmin : Vector2 = _uvs[_indices[0]]
	var vmax : Vector2 = vmin
	for i in range(1, _indices.size()):
		var uv : Vector2 = _uvs[_indices[i]]
		
		if uv.x < vmin.x:
			vmin.x = uv.x
		
		if uv.x > vmax.x:
			vmax.x = uv.x
		
		if uv.y < vmin.y:
			vmin.y = uv.y
		
		if uv.y > vmax.y:
			vmax.y = uv.y
	
	var xmm : float = vmax.x - vmin.x
	var ymm : float = vmax.y - vmin.y
	
	if xmm == 0:
		xmm = 0.0000001
		
	if ymm == 0:
		ymm = 0.0000001
	
	for i in range(_uvs.size()):
		var uv : Vector2 = _uvs[i]
		
		uv.x -= vmin.x
		uv.x /= xmm
		
		uv.y -= vmin.y
		uv.y /= ymm
		
		_uvs[i] = uv

func normalize_uvs() -> void:
	var xmm : float = _uv_max.x - _uv_min.x
	var ymm : float = _uv_max.y - _uv_min.y
	
	if xmm == 0:
		xmm = 0.0000001
		
	if ymm == 0:
		ymm = 0.0000001
	
	for i in range(_uvs.size()):
		var uv : Vector2 = _uvs[i]
		
		uv.x -= _uv_min.x
		uv.x /= xmm
		
		uv.y -= _uv_min.y
		uv.y /= ymm
		
		_uvs[i] = uv

func apply_uv() -> void:
	if !_mdr:
		return
	
	var rect : Rect2 = get_rect()
	
	#rect needs to be converted back
	rect.position /= _rect_scale
	rect.size /= _rect_scale
	rect.position /= edited_resource_parent_size
	rect.size /= edited_resource_parent_size
	
	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return
		
	var uvs : PoolVector2Array = arrays[ArrayMesh.ARRAY_TEX_UV]
		
	for index in _indices:
		var uv : Vector2 = _uvs[index]
		
		uv = uv * rect.size + rect.position
		
		uvs[index] = uv
	
	_uv_min = rect.position
	_uv_max = rect.position + rect.size
	
	_base_rect = get_rect()
	
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	_mdr.array = arrays


#based on / ported from engine/scene/gui/dialogs.h and .cpp
func _notification(p_what : int) -> void:
	if (p_what == NOTIFICATION_MOUSE_EXIT):
			# Reset the mouse cursor when leaving the resizable window border.
			if (_mdr && !drag_type):
				if (get_default_cursor_shape() != CURSOR_ARROW):
					set_default_cursor_shape(CURSOR_ARROW)

#based on / ported from engine/scene/gui/dialogs.h and .cpp
func _gui_input(p_event : InputEvent) -> void:
	if (p_event is InputEventMouseButton) && (p_event.get_button_index() == BUTTON_LEFT):
		var mb : InputEventMouseButton = p_event as InputEventMouseButton
		
		if (mb.is_pressed()):
			get_parent().set_selected(self)
			
			# Begin a possible dragging operation.
			drag_type = _drag_hit_test(Vector2(mb.get_position().x, mb.get_position().y))
			
			if (drag_type != DragType.DRAG_NONE):
				drag_offset = get_global_mouse_position() - get_position()
			
			drag_offset_far = get_position() + get_size() - get_global_mouse_position()
			
		elif (drag_type != DragType.DRAG_NONE && !mb.is_pressed()):
			# End a dragging operation.
			
			apply_uv()
			
			drag_type = DragType.DRAG_NONE

	if p_event is InputEventMouseMotion:
		var mm : InputEventMouseMotion = p_event as InputEventMouseMotion

		if (drag_type == DragType.DRAG_NONE):
			# Update the cursor while moving along the borders.
			var cursor = CURSOR_ARROW

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

	var scaleborder_size : int = 5 #get_constant("scaleborder_size", "WindowDialog")

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

func set_selected(val : bool) -> void:
	selected = val
	update()
