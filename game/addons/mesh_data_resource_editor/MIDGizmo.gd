tool
extends EditorSpatialGizmo

var MeshOutline = preload("res://addons/mesh_data_resource_editor/utilities/mesh_outline.gd")
var MeshDecompose = preload("res://addons/mesh_data_resource_editor/utilities/mesh_decompose.gd")
var MDRMeshUtils = preload("res://addons/mesh_data_resource_editor/utilities/mdred_mesh_utils.gd")

enum EditMode {
	EDIT_MODE_NONE = 0, 
	EDIT_MODE_TRANSLATE = 1, 
	EDIT_MODE_SCALE = 2, 
	EDIT_MODE_ROTATE = 3
}

enum AxisConstraint {
	X = 1 << 0, 
	Y = 1 << 1, 
	Z = 1 << 2,
}

enum SelectionMode {
	SELECTION_MODE_VERTEX = 0,
	SELECTION_MODE_EDGE = 1,
	SELECTION_MODE_FACE = 2,
}

enum PivotTypes {
	PIVOT_TYPE_AVERAGED = 0,
	PIVOT_TYPE_MDI_ORIGIN = 1,
	PIVOT_TYPE_WORLD_ORIGIN = 2,
}

enum HandleSelectionType {
	HANDLE_SELECTION_TYPE_FRONT = 0,
	HANDLE_SELECTION_TYPE_BACK = 1,
	HANDLE_SELECTION_TYPE_ALL = 2,
}

var gizmo_size = 3.0

var edit_mode : int = EditMode.EDIT_MODE_TRANSLATE
var pivot_type : int = PivotTypes.PIVOT_TYPE_AVERAGED
var axis_constraint : int = AxisConstraint.X | AxisConstraint.Y | AxisConstraint.Z
var selection_mode : int = SelectionMode.SELECTION_MODE_VERTEX
var handle_selection_type : int = HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT
var visual_indicator_outline : bool = true
var visual_indicator_seam : bool= true
var visual_indicator_handle : bool = true

var previous_point : Vector2
var _last_known_camera_facing : Vector3 = Vector3(0, 0, -1)

var _rect_drag : bool = false
var _rect_drag_start_point : Vector2 = Vector2()
var _rect_drag_min_ofset : float = 10

var _mdr : MeshDataResource = null

var _vertices : PoolVector3Array
var _indices : PoolIntArray
var _handle_points : PoolVector3Array
var _handle_to_vertex_map : Array
var _selected_points : PoolIntArray

var _mesh_outline_generator

var _handle_drag_op : bool = false
var _drag_op_orig_verices : PoolVector3Array = PoolVector3Array()
var _drag_op_indices : PoolIntArray = PoolIntArray()
var _drag_op_accumulator : Vector3 = Vector3()
var _drag_op_accumulator_quat : Quat = Quat()
var _drag_op_pivot : Vector3 = Vector3()

var _editor_plugin : EditorPlugin = null
var _undo_redo : UndoRedo = null

func _init():
	_mesh_outline_generator = MeshOutline.new()
	
func setup() -> void:
	get_spatial_node().connect("mesh_data_resource_changed", self, "on_mesh_data_resource_changed")
	on_mesh_data_resource_changed(get_spatial_node().mesh_data)

func set_editor_plugin(editor_plugin : EditorPlugin) -> void:
	_editor_plugin = editor_plugin
	
	_undo_redo = _editor_plugin.get_undo_redo()

func set_handle(index: int, camera: Camera, point: Vector2):
	var relative : Vector2 = point - previous_point
	
	if !_handle_drag_op:
		relative = Vector2()
		_handle_drag_op = true
		
		if edit_mode == EditMode.EDIT_MODE_SCALE:
			_drag_op_accumulator = Vector3(1, 1, 1)
		else:
			_drag_op_accumulator = Vector3()
			
		_drag_op_accumulator_quat = Quat()
		
		_drag_op_orig_verices = copy_mdr_verts_array()
		setup_op_drag_indices()
		_drag_op_pivot = get_drag_op_pivot()
	
	if edit_mode == EditMode.EDIT_MODE_NONE:
		return
	elif edit_mode == EditMode.EDIT_MODE_TRANSLATE:
		var ofs : Vector3 = Vector3()

		ofs = camera.get_global_transform().basis.x

		if (axis_constraint & AxisConstraint.X) != 0:
			ofs.x *= relative.x * 0.01
		else:
			ofs.x = 0
		
		if (axis_constraint & AxisConstraint.Y) != 0:
			ofs.y = relative.y * -0.01
		else:
			ofs.y = 0
		
		if (axis_constraint & AxisConstraint.Z) != 0:
			ofs.z *= relative.x * 0.01
		else:
			ofs.z = 0

		_drag_op_accumulator += ofs
		
		add_to_all_selected(_drag_op_accumulator)

		apply()
		redraw()
	elif edit_mode == EditMode.EDIT_MODE_SCALE:
		var r : float = ((relative.x + relative.y) * 0.05)
		
		var vs : Vector3 = Vector3()
		
		if (axis_constraint & AxisConstraint.X) != 0:
			vs.x = r
				
		if (axis_constraint & AxisConstraint.Y) != 0:
			vs.y = r
				
		if (axis_constraint & AxisConstraint.Z) != 0:
			vs.z = r
		
		_drag_op_accumulator += vs
		
		var b : Basis = Basis().scaled(_drag_op_accumulator) 
		var t : Transform = Transform(Basis(), _drag_op_pivot)
		t *= Transform(b, Vector3())
		t *= Transform(Basis(), _drag_op_pivot).inverse()

		mul_all_selected_with_transform(t)

		apply()
		redraw()
	elif edit_mode == EditMode.EDIT_MODE_ROTATE:
		var yrot : Quat = Quat(Vector3(0, 1, 0), relative.x * 0.01)
		var xrot : Quat = Quat(camera.get_global_transform().basis.x, relative.y * 0.01)

		_drag_op_accumulator_quat *= yrot
		_drag_op_accumulator_quat *= xrot
		_drag_op_accumulator_quat = _drag_op_accumulator_quat.normalized()

		var b : Basis = Basis(_drag_op_accumulator_quat)
		var t : Transform = Transform(Basis(), _drag_op_pivot)
		t *= Transform(b, Vector3())
		t *= Transform(Basis(), _drag_op_pivot).inverse()

		mul_all_selected_with_transform(t)

		apply()
		redraw()
		
	previous_point = point

#func commit_handle(index: int, restore, cancel: bool = false) -> void:
#	previous_point = Vector2()
#
#	print("MDR Editor: commit_handle test")

func redraw():
	clear()
	
	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if !get_plugin():
		return
	
	var handles_material : SpatialMaterial = get_plugin().get_material("handles", self)
	var material = get_plugin().get_material("main", self)
	var seam_material = get_plugin().get_material("seam", self)
	
	_mesh_outline_generator.setup(_mdr)
	
	if selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		_mesh_outline_generator.generate_mark_edges(visual_indicator_outline, visual_indicator_handle)
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		_mesh_outline_generator.generate_mark_faces(visual_indicator_outline, visual_indicator_handle)
	else:
		_mesh_outline_generator.generate(visual_indicator_outline, visual_indicator_handle)
	
	if visual_indicator_outline || visual_indicator_handle:
		add_lines(_mesh_outline_generator.lines, material, false)
	
	if visual_indicator_seam:
		add_lines(_mesh_outline_generator.seam_lines, seam_material, false)
	
	if _selected_points.size() > 0:
		var vs : PoolVector3Array = PoolVector3Array()
		
		for i in _selected_points:
			vs.append(_handle_points[i])
		
		add_handles(vs, handles_material)

func apply() -> void:
	if !_mdr:
		return
	
	disable_change_event()
	
	var arrs : Array = _mdr.array
	arrs[ArrayMesh.ARRAY_VERTEX] = _vertices
	arrs[ArrayMesh.ARRAY_INDEX] = _indices
	_mdr.array = arrs
	
	enable_change_event()

func select_all() -> void:
	if _selected_points.size() == _handle_points.size():
		return
	
	_selected_points.resize(_handle_points.size())
	
	for i in range(_selected_points.size()):
		_selected_points[i] = i
	
	redraw()


func selection_click(index, camera, event) -> bool:
	if handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT:
		return selection_click_select_front_or_back(index, camera, event)
	elif handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_BACK:
		return selection_click_select_front_or_back(index, camera, event)
	else:
		return selection_click_select_through(index, camera, event)
		
	return false

func is_point_visible(point_orig : Vector3, camera_pos : Vector3, gt : Transform) -> bool:
	var point : Vector3 = gt.xform(point_orig)
	
	# go from the given point to the origin (camera_pos -> camera)
	var dir : Vector3 = camera_pos - point
	dir = dir.normalized()
	# Might need to reduce z fighting
	#point += dir * 0.5

	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		var v0 : Vector3 = _vertices[i0]
		var v1 : Vector3 = _vertices[i1]
		var v2 : Vector3 = _vertices[i2]
		
		v0 = gt.xform(v0)
		v1 = gt.xform(v1)
		v2 = gt.xform(v2)
		
		var res = Geometry.ray_intersects_triangle(point, dir, v0, v1, v2)

		if res is Vector3:
			return false
		
	return true


func selection_click_select_front_or_back(index, camera, event):
		var gt : Transform = get_spatial_node().global_transform
		var ray_from : Vector3 = camera.global_transform.origin
		var gpoint : Vector2 = event.get_position()
		var grab_threshold : float = 8

		# select vertex
		var closest_idx : int = -1
		var closest_dist : float = 1e10
					
		for i in range(_handle_points.size()):
			var vert_pos_3d : Vector3 = gt.xform(_handle_points[i])
			var vert_pos_2d : Vector2 = camera.unproject_position(vert_pos_3d)
			var dist_3d : float = ray_from.distance_to(vert_pos_3d)
			var dist_2d : float = gpoint.distance_to(vert_pos_2d)

			if (dist_2d < grab_threshold && dist_3d < closest_dist):
				var point_visible : bool = is_point_visible(_handle_points[i], ray_from, gt)
				
				if handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT:
					if !point_visible:
						continue
				elif handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_BACK:
					if point_visible:
						continue
				
				closest_dist = dist_3d
				closest_idx = i

		if (closest_idx >= 0):
			for si in range(_selected_points.size()):
				if _selected_points[si] == closest_idx:
					if event.alt || event.control:
						_selected_points.remove(si)
						return true
									
					return false
						
			if event.alt || event.control:
				return false
						
			if event.shift:
				_selected_points.append(closest_idx)
			else:
				# Select new point only
				_selected_points.resize(0)
				_selected_points.append(closest_idx)

			apply()
			redraw()
		else:
			# Don't unselect all if either control or shift is held down
			if event.shift || event.control || event.alt:
				return false
						
			if _selected_points.size() == 0:
				return false
						
			#Unselect all
			_selected_points.resize(0)

			redraw()

func selection_click_select_through(index, camera, event):
		var gt : Transform = get_spatial_node().global_transform
		var ray_from : Vector3 = camera.global_transform.origin
		var gpoint : Vector2 = event.get_position()
		var grab_threshold : float = 8

		# select vertex
		var closest_idx : int = -1
		var closest_dist : float = 1e10
					
		for i in range(_handle_points.size()):
			var vert_pos_3d : Vector3 = gt.xform(_handle_points[i])
			var vert_pos_2d : Vector2 = camera.unproject_position(vert_pos_3d)
			var dist_3d : float = ray_from.distance_to(vert_pos_3d)
			var dist_2d : float = gpoint.distance_to(vert_pos_2d)
						
			if (dist_2d < grab_threshold && dist_3d < closest_dist):
				closest_dist = dist_3d
				closest_idx = i

		if (closest_idx >= 0):
			for si in range(_selected_points.size()):
							
				if _selected_points[si] == closest_idx:
					if event.alt || event.control:
						_selected_points.remove(si)
						return true
									
					return false
						
			if event.alt || event.control:
				return false
						
			if event.shift:
				_selected_points.append(closest_idx)
			else:
				# Select new point only
				_selected_points.resize(0)
				_selected_points.append(closest_idx)

			apply()
			redraw()
		else:
			# Don't unselect all if either control or shift is held down
			if event.shift || event.control || event.alt:
				return false
						
			if _selected_points.size() == 0:
				return false
						
			#Unselect all
			_selected_points.resize(0)

			redraw()

func selection_drag(index, camera, event) -> void:
	if handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT:
		selection_drag_rect_select_front_back(index, camera, event)
	elif handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_BACK:
		selection_drag_rect_select_front_back(index, camera, event)
	else:
		selection_drag_rect_select_through(index, camera, event)

func selection_drag_rect_select_front_back(index, camera, event):
	var gt : Transform = get_spatial_node().global_transform
	var ray_from : Vector3 = camera.global_transform.origin
	
	var mouse_pos : Vector2 = event.get_position()
	var rect_size : Vector2 = _rect_drag_start_point - mouse_pos
	rect_size.x = abs(rect_size.x)
	rect_size.y = abs(rect_size.y)
	
	var rect : Rect2 = Rect2(_rect_drag_start_point, rect_size)
					
	# This is needed so selection works even when you drag from bottom to top, and from right to left
	var rect_ofs : Vector2 = _rect_drag_start_point - mouse_pos
				
	if rect_ofs.x > 0:
		rect.position.x -= rect_ofs.x
						
	if rect_ofs.y > 0:
		rect.position.y -= rect_ofs.y
					
	var selected : PoolIntArray = PoolIntArray()
					
	for i in range(_handle_points.size()):
		var vert_pos_3d : Vector3 = gt.xform(_handle_points[i])
		var vert_pos_2d : Vector2 = camera.unproject_position(vert_pos_3d)
						
		if rect.has_point(vert_pos_2d):
			var point_visible : bool = is_point_visible(_handle_points[i], ray_from, gt)
				
			if handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT:
				if !point_visible:
					continue
			elif handle_selection_type == HandleSelectionType.HANDLE_SELECTION_TYPE_BACK:
				if point_visible:
					continue
			
			selected.push_back(i)
						
	if event.alt || event.control:
		for isel in selected:
			for i in range(_selected_points.size()):
				if _selected_points[i] == isel:
					_selected_points.remove(i)
					break
		redraw()
						
		return
					
	if event.shift:
		for isel in selected:
			if !pool_int_arr_contains(_selected_points, isel):
				_selected_points.push_back(isel)
								
		redraw()
		return
						
	_selected_points.resize(0)
	_selected_points.append_array(selected)
					
	redraw()

func selection_drag_rect_select_through(index, camera, event):
	var gt : Transform = get_spatial_node().global_transform
	
	var mouse_pos : Vector2 = event.get_position()
	var rect_size : Vector2 = _rect_drag_start_point - mouse_pos
	rect_size.x = abs(rect_size.x)
	rect_size.y = abs(rect_size.y)
	
	var rect : Rect2 = Rect2(_rect_drag_start_point, rect_size)
					
	# This is needed so selection works even when you drag from bottom to top, and from right to left
	var rect_ofs : Vector2 = _rect_drag_start_point - mouse_pos
				
	if rect_ofs.x > 0:
		rect.position.x -= rect_ofs.x
						
	if rect_ofs.y > 0:
		rect.position.y -= rect_ofs.y
					
	var selected : PoolIntArray = PoolIntArray()
					
	for i in range(_handle_points.size()):
		var vert_pos_3d : Vector3 = gt.xform(_handle_points[i])
		var vert_pos_2d : Vector2 = camera.unproject_position(vert_pos_3d)
						
		if rect.has_point(vert_pos_2d):
			selected.push_back(i)
						
	if event.alt || event.control:
		for isel in selected:
			for i in range(_selected_points.size()):
				if _selected_points[i] == isel:
					_selected_points.remove(i)
					break
		redraw()
						
		return
					
	if event.shift:
		for isel in selected:
			if !pool_int_arr_contains(_selected_points, isel):
				_selected_points.push_back(isel)
								
		redraw()
		return
						
	_selected_points.resize(0)
	_selected_points.append_array(selected)
					
	redraw()

func forward_spatial_gui_input(index, camera, event):
	_last_known_camera_facing = camera.transform.basis.xform(Vector3(0, 0, -1))
	
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			if _handle_drag_op:
				if !event.is_pressed():
					_handle_drag_op = false
				
					# If a handle was being dragged only run these
					if _mdr && _mdr.array.size() == ArrayMesh.ARRAY_MAX && _mdr.array[ArrayMesh.ARRAY_VERTEX] != null && _mdr.array[ArrayMesh.ARRAY_VERTEX].size() == _drag_op_orig_verices.size():
						_undo_redo.create_action("Drag")
						_undo_redo.add_do_method(self, "apply_vertex_array", _mdr, _mdr.array[ArrayMesh.ARRAY_VERTEX])
						_undo_redo.add_undo_method(self, "apply_vertex_array", _mdr, _drag_op_orig_verices)
						_undo_redo.commit_action()
				
				# Dont consume the event here, because the handles will get stuck 
				# to the mouse pointer if we return true
				return false
		
			if !event.is_pressed():
				# See whether we should check for a click or a selection box
				var mouse_pos : Vector2 = event.get_position()
				var rect_size : Vector2 = _rect_drag_start_point - mouse_pos
				rect_size.x = abs(rect_size.x)
				rect_size.y = abs(rect_size.y)
				var had_rect_drag : bool = false

				if rect_size.x > _rect_drag_min_ofset || rect_size.y > _rect_drag_min_ofset:
					had_rect_drag = true
							
				if !had_rect_drag:
					return selection_click(index, camera, event)
				else:
					selection_drag(index, camera, event)
					# Always return false here, so the drag rect thing disappears in the editor
					return false
			else:
				# event is pressed
				_rect_drag = true
				_rect_drag_start_point = event.get_position()

	return false

func add_to_all_selected(ofs : Vector3) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v += ofs
		_handle_points.set(i, v)
	
	for indx in _drag_op_indices:
		var v : Vector3 = _drag_op_orig_verices[indx]
		v += ofs
		_vertices.set(indx, v)

func mul_all_selected_with_basis(b : Basis) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v = b * v
		_handle_points.set(i, v)
	
	for indx in _drag_op_indices:
		var v : Vector3 = _drag_op_orig_verices[indx]
		v = b * v
		_vertices.set(indx, v)

func mul_all_selected_with_transform(t : Transform) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v = t * v
		_handle_points.set(i, v)
	
	for indx in _drag_op_indices:
		var v : Vector3 = _drag_op_orig_verices[indx]
		v = t * v
		_vertices.set(indx, v)

func mul_all_selected_with_transform_acc(t : Transform) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v = t * v
		_handle_points.set(i, v)
	
	for indx in _drag_op_indices:
		var v : Vector3 = _vertices[indx]
		v = t * v
		_vertices.set(indx, v)

func set_translate() -> void:
	edit_mode = EditMode.EDIT_MODE_TRANSLATE
	
func set_scale() -> void:
	edit_mode = EditMode.EDIT_MODE_SCALE
	
func set_rotate() -> void:
	edit_mode = EditMode.EDIT_MODE_ROTATE

func set_edit_mode(em : int) -> void:
	edit_mode = em

func set_axis_x(on : bool) -> void:
	if on:
		axis_constraint |= AxisConstraint.X
	else:
		if (axis_constraint & AxisConstraint.X) != 0:
			axis_constraint ^= AxisConstraint.X
	
func set_axis_y(on : bool) -> void:
	if on:
		axis_constraint |= AxisConstraint.Y
	else:
		if (axis_constraint & AxisConstraint.Y) != 0:
			axis_constraint ^= AxisConstraint.Y
	
func set_axis_z(on : bool) -> void:
	if on:
		axis_constraint |= AxisConstraint.Z
	else:
		if (axis_constraint & AxisConstraint.Z) != 0:
			axis_constraint ^= AxisConstraint.Z

func set_selection_mode_vertex() -> void:
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		return
		
	selection_mode = SelectionMode.SELECTION_MODE_VERTEX
	_selected_points.resize(0)
	recalculate_handle_points()
	redraw()

func set_selection_mode_edge() -> void:
	if selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		return
		
	selection_mode = SelectionMode.SELECTION_MODE_EDGE
	_selected_points.resize(0)
	recalculate_handle_points()
	redraw()
			
func set_selection_mode_face() -> void:
	if selection_mode == SelectionMode.SELECTION_MODE_FACE:
		return
		
	selection_mode = SelectionMode.SELECTION_MODE_FACE
	_selected_points.resize(0)
	recalculate_handle_points()
	redraw()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if self != null && get_plugin():
			get_plugin().unregister_gizmo(self)

func recalculate_handle_points() -> void:
	if !_mdr:
		_handle_points.resize(0)
		_handle_to_vertex_map.resize(0)
		return
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		_handle_points.resize(0)
		_handle_to_vertex_map.resize(0)
		return
	
	var arr : Array = Array()
	arr.resize(ArrayMesh.ARRAY_MAX)
	arr[ArrayMesh.ARRAY_VERTEX] = mdr_arr[ArrayMesh.ARRAY_VERTEX]
	arr[ArrayMesh.ARRAY_INDEX] = mdr_arr[ArrayMesh.ARRAY_INDEX]
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		var merged_arrays : Array = MeshUtils.merge_mesh_array(arr)
		_handle_points = merged_arrays[ArrayMesh.ARRAY_VERTEX]
		_handle_to_vertex_map = MeshDecompose.get_handle_vertex_to_vertex_map(mdr_arr, _handle_points)
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		var result : Array = MeshDecompose.get_handle_edge_to_vertex_map(arr)
		
		_handle_points = result[0]
		_handle_to_vertex_map = result[1]
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		var result : Array = MeshDecompose.get_handle_face_to_vertex_map(arr)
		
		_handle_points = result[0]
		_handle_to_vertex_map = result[1]
		
func on_mesh_data_resource_changed(mdr : MeshDataResource) -> void:
	if _mdr:
		_mdr.disconnect("changed", self, "on_mdr_changed")
	
	_mdr = mdr
	
	if _mdr && _mdr.array.size() == ArrayMesh.ARRAY_MAX && _mdr.array[ArrayMesh.ARRAY_VERTEX] != null:
		_vertices = _mdr.array[ArrayMesh.ARRAY_VERTEX]
		_indices = _mdr.array[ArrayMesh.ARRAY_INDEX]
	else:
		_vertices.resize(0)
		_indices.resize(0)
	
	if _mdr:
		_mdr.connect("changed", self, "on_mdr_changed")
	
	recalculate_handle_points()
	redraw()

func on_mdr_changed() -> void:
	if _mdr && _mdr.array.size() == ArrayMesh.ARRAY_MAX && _mdr.array[ArrayMesh.ARRAY_VERTEX] != null:
		_vertices = _mdr.array[ArrayMesh.ARRAY_VERTEX]
		_indices = _mdr.array[ArrayMesh.ARRAY_INDEX]
	else:
		_vertices.resize(0)
		_indices.resize(0)
	
	recalculate_handle_points()
	redraw()

func disable_change_event() -> void:
	_mdr.disconnect("changed", self, "on_mdr_changed")

func enable_change_event(update : bool = true) -> void:
	_mdr.connect("changed", self, "on_mdr_changed")
		
	if update:
		on_mdr_changed()

func add_triangle() -> void:
	if _mdr:
		var orig_arr = copy_arrays(_mdr.array)
		MDRMeshUtils.add_triangle(_mdr)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Add Triangle")

func add_quad() -> void:
	if _mdr:
		var orig_arr = copy_arrays(_mdr.array)
		MDRMeshUtils.add_quad(_mdr)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Add Quad")

func is_verts_equal(v0 : Vector3, v1 : Vector3) -> bool:
	return is_equal_approx(v0.x, v1.x) && is_equal_approx(v0.y, v1.y) && is_equal_approx(v0.z, v1.z)

func find_other_vertex_for_edge(edge : int, v0 : Vector3) -> Vector3:
	var ps : PoolIntArray = _handle_to_vertex_map[edge]

	var vert : Vector3 = Vector3()

	for i in range(ps.size()):
		vert = _vertices[ps[i]]

		if !is_verts_equal(v0, vert):
			return vert
	
	return v0

func split_edge_indices(edge : int) -> Array:
	var ps : PoolIntArray = _handle_to_vertex_map[edge]
	
	if ps.size() == 0:
		return [  ]

	var v0 : Vector3 = _vertices[ps[0]]
	
	var v0ei : PoolIntArray = PoolIntArray()
	v0ei.append(ps[0])
	var v1ei : PoolIntArray = PoolIntArray()

	for i in range(1, ps.size()):
		var vert : Vector3 = _vertices[ps[i]]

		if is_verts_equal(v0, vert):
			v0ei.append(ps[i])
		else:
			v1ei.append(ps[i])
	
	return [ v0ei, v1ei ]

func pool_int_arr_contains(arr : PoolIntArray, val : int) -> bool:
	for a in arr:
		if a == val:
			return true
			
	return false
	

func find_triangles_for_edge(edge : int) -> PoolIntArray:
	var eisarr : Array = split_edge_indices(edge)
	
	if eisarr.size() == 0:
		return PoolIntArray()
	
	# these should have the same size
	var v0ei : PoolIntArray = eisarr[0]
	var v1ei : PoolIntArray = eisarr[1]
	
	var res : PoolIntArray = PoolIntArray()
	
	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		if pool_int_arr_contains(v0ei, i0) || pool_int_arr_contains(v0ei, i1) || pool_int_arr_contains(v0ei, i2):
			if pool_int_arr_contains(v1ei, i0) || pool_int_arr_contains(v1ei, i1) || pool_int_arr_contains(v1ei, i2):
				res.append(i / 3)
	
	return res

func find_first_triangle_for_edge(edge : int) -> int:
	var eisarr : Array = split_edge_indices(edge)

	if eisarr.size() == 0:
		return -1
	
	# these should have the same size
	var v0ei : PoolIntArray = eisarr[0]
	var v1ei : PoolIntArray = eisarr[1]
	
	var res : PoolIntArray = PoolIntArray()
	
	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		if pool_int_arr_contains(v0ei, i0) || pool_int_arr_contains(v0ei, i1) || pool_int_arr_contains(v0ei, i2):
			if pool_int_arr_contains(v1ei, i0) || pool_int_arr_contains(v1ei, i1) || pool_int_arr_contains(v1ei, i2):
				return i / 3
	
	return -1

func add_triangle_to_edge(edge : int) -> void:
	var triangle_index : int = find_first_triangle_for_edge(edge)
	
	var inds : int = triangle_index * 3
	
	var ti0 : int = _indices[inds]
	var ti1 : int = _indices[inds + 1]
	var ti2 : int = _indices[inds + 2]
	
	var ps : PoolIntArray = _handle_to_vertex_map[edge]
	
	if ps.size() == 0:
		return
		
	var ei0 : int = 0
	var ei1 : int = 0
	var erefind : int = 0
	
	if !pool_int_arr_contains(ps, ti0):
		ei0 = ti1
		ei1 = ti2
		erefind = ti0
	elif !pool_int_arr_contains(ps, ti1):
		ei0 = ti0
		ei1 = ti2
		erefind = ti1
	elif !pool_int_arr_contains(ps, ti2):
		ei0 = ti0
		ei1 = ti1
		erefind = ti2
		
	var fo : Vector3 = MDRMeshUtils.get_face_normal(_vertices[ti0], _vertices[ti1], _vertices[ti2])
	var fn : Vector3 = MDRMeshUtils.get_face_normal(_vertices[ei0], _vertices[ei1], _vertices[erefind])
	
	if fo.dot(fn) < 0:
		var t : int = ei0
		ei0 = ei1
		ei1 = t
	
	MDRMeshUtils.append_triangle_to_tri_edge(_mdr, _vertices[ei0], _vertices[ei1], _vertices[erefind])

func add_quad_to_edge(edge : int) -> void:
	var triangle_index : int = find_first_triangle_for_edge(edge)
	
	var inds : int = triangle_index * 3
	
	var ti0 : int = _indices[inds]
	var ti1 : int = _indices[inds + 1]
	var ti2 : int = _indices[inds + 2]
	
	var ps : PoolIntArray = _handle_to_vertex_map[edge]
	
	if ps.size() == 0:
		return
		
	var ei0 : int = 0
	var ei1 : int = 0
	var erefind : int = 0
	
	if !pool_int_arr_contains(ps, ti0):
		ei0 = ti1
		ei1 = ti2
		erefind = ti0
	elif !pool_int_arr_contains(ps, ti1):
		ei0 = ti0
		ei1 = ti2
		erefind = ti1
	elif !pool_int_arr_contains(ps, ti2):
		ei0 = ti0
		ei1 = ti1
		erefind = ti2
		
	var fo : Vector3 = MDRMeshUtils.get_face_normal(_vertices[ti0], _vertices[ti1], _vertices[ti2])
	var fn : Vector3 = MDRMeshUtils.get_face_normal(_vertices[ei0], _vertices[ei1], _vertices[erefind])
	
	if fo.dot(fn) < 0:
		var t : int = ei0
		ei0 = ei1
		ei1 = t
	
	MDRMeshUtils.append_quad_to_tri_edge(_mdr, _vertices[ei0], _vertices[ei1], _vertices[erefind])

func add_triangle_at() -> void:
	if !_mdr:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		#todo
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		disable_change_event()
		var orig_arr = copy_arrays(_mdr.array)
		
		for sp in _selected_points:
			add_triangle_to_edge(sp)
		
		_selected_points.resize(0)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Add Triangle At")
		enable_change_event()
	else:
		add_triangle()
		
func add_quad_at() -> void:
	if !_mdr:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		#todo
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		disable_change_event()
		var orig_arr = copy_arrays(_mdr.array)
		
		for sp in _selected_points:
			add_quad_to_edge(sp)
		
		_selected_points.resize(0)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Add Quad At")
		enable_change_event()
	else:
		add_quad()

func extrude() -> void:
	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX || _mdr.array[ArrayMesh.ARRAY_VERTEX] == null:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		disable_change_event()
		var orig_arr = copy_arrays(_mdr.array)
		var original_size : int = orig_arr[ArrayMesh.ARRAY_VERTEX].size()
		
		for sp in _selected_points:
			add_quad_to_edge(sp)

		var arr : Array = _mdr.array
		
		# Note: This algorithm depends heavily depends on the inner workings of add_quad_to_edge!
		var new_verts : PoolVector3Array = arr[ArrayMesh.ARRAY_VERTEX]
		
		# every 4 vertex is a quad
		# 1 ---- 2
		# |      |
		# |      |
		# 0 ---- 3
		# vertex 1, and 2 are the created new ones, 0, and 3 are duplicated from the original edge
		
		# Don't reallocate it every time
		var found_verts : PoolIntArray = PoolIntArray()
		
		# Go through every new created 0th vertex
		for i in range(original_size, new_verts.size(), 4):
			var v0 : Vector3 = new_verts[i]
			
			found_verts.resize(0)
			
			# Find a pair for it (has to be the 3th).
			for j in range(original_size, new_verts.size(), 4):
				if i == j:
					continue
				
				# +3 offset to 3rd vert
				var v3 : Vector3 = new_verts[j + 3]

				if is_verts_equal(v0, v3):
					# +2 offset to 2rd vert
					found_verts.append(j + 2)
			
			if found_verts.size() == 0:
				continue
			
			# Also append the first vertex index to simplify logic
			found_verts.append(i + 1)
			
			# Calculate avg
			var vavg : Vector3 = Vector3()
			for ind in found_verts:
				vavg += new_verts[ind]
				
			vavg /= found_verts.size()
			
			# set back
			for ind in found_verts:
				new_verts[ind] = vavg

		arr[ArrayMesh.ARRAY_VERTEX] = new_verts
		_mdr.array = arr
		
		_selected_points.resize(0)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Extrude")
		enable_change_event()
		
		# The selection alo will take care of the duplicates
		var new_handle_points : PoolVector3Array = PoolVector3Array()
		for i in range(original_size, new_verts.size(), 4):
			var vavg : Vector3 = new_verts[i + 1]
			vavg += new_verts[i + 2]
			vavg /= 2
			
			new_handle_points.append(vavg)
		
		select_handle_points(new_handle_points)
	else:
		add_quad()

func add_box() -> void:
	if _mdr:
		var orig_arr = copy_arrays(_mdr.array)
		MDRMeshUtils.add_box(_mdr)
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Add Box")
		
func split():
	pass

func disconnect_action():
	pass

func get_first_triangle_index_for_vertex(indx : int) -> int:
	for i in range(_indices.size()):
		if _indices[i] == indx:
			return i / 3
			
	return -1
	
func create_face():
	if !_mdr:
		return
		
	if _selected_points.size() <= 2:
		return

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		disable_change_event()
		
		var orig_arr = copy_arrays(_mdr.array)
		
		var points : PoolVector3Array = PoolVector3Array()
		
		for sp in _selected_points:
			points.push_back(_handle_points[sp])
		
		if points.size() == 3:
			var i0 : int = _handle_to_vertex_map[_selected_points[0]][0]
			var i1 : int = _handle_to_vertex_map[_selected_points[1]][0]
			var i2 : int = _handle_to_vertex_map[_selected_points[2]][0]
			
			var v0 : Vector3 = points[0]
			var v1 : Vector3 = points[1]
			var v2 : Vector3 = points[2]
			
			var tfn : Vector3 = Vector3()
			
			if orig_arr[ArrayMesh.ARRAY_NORMAL] != null && orig_arr[ArrayMesh.ARRAY_NORMAL].size() == orig_arr[ArrayMesh.ARRAY_VERTEX].size():
				var normals : PoolVector3Array = orig_arr[ArrayMesh.ARRAY_NORMAL]
				
				tfn += normals[i0]
				tfn += normals[i1]
				tfn += normals[i2]
				tfn /= 3
				tfn = tfn.normalized()
			else:
				tfn = MDRMeshUtils.get_face_normal(_vertices[i0], _vertices[i1], _vertices[i2])

			var flip : bool = !MDRMeshUtils.should_triangle_flip(v0, v1, v2, tfn)
			
			MDRMeshUtils.add_triangle_at(_mdr, v0, v1, v2, flip)
			add_mesh_change_undo_redo(orig_arr, _mdr.array, "Create Face")
			enable_change_event()
			return
		
		if !MDRMeshUtils.add_triangulated_mesh_from_points_delaunay(_mdr, points, _last_known_camera_facing):
			enable_change_event()
			return
		
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Create Face")
		
		#_selected_points.resize(0)
		enable_change_event()
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass

func split_face_indices(face : int) -> Array:
	var ps : PoolIntArray = _handle_to_vertex_map[face]
	
	if ps.size() == 0:
		return [  ]

	var v0 : Vector3 = _vertices[ps[0]]
	var v1 : Vector3 = Vector3()
	var v1found : bool = false
	
	var v0ei : PoolIntArray = PoolIntArray()
	v0ei.append(ps[0])
	var v1ei : PoolIntArray = PoolIntArray()
	var v2ei : PoolIntArray = PoolIntArray()

	for i in range(1, ps.size()):
		var vert : Vector3 = _vertices[ps[i]]

		if is_verts_equal(v0, vert):
			v0ei.append(ps[i])
		else:
			if v1found:
				if is_verts_equal(v1, vert):
					v1ei.append(ps[i])
				else:
					v2ei.append(ps[i])
			else:
				v1found = true
				v1 = _vertices[ps[i]]
				v1ei.append(ps[i])
	
	return [ v0ei, v1ei, v2ei ]

func find_first_triangle_index_for_face(face : int) -> int:
	var split_indices_arr : Array = split_face_indices(face)
	
	if split_indices_arr.size() == 0:
		return -1
		
	var v0ei : PoolIntArray = split_indices_arr[0]
	var v1ei : PoolIntArray = split_indices_arr[1]
	var v2ei : PoolIntArray = split_indices_arr[2]
	var tri_index : int = -1
	
	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		if pool_int_arr_contains(v0ei, i0) || pool_int_arr_contains(v0ei, i1) || pool_int_arr_contains(v0ei, i2):
			if pool_int_arr_contains(v1ei, i0) || pool_int_arr_contains(v1ei, i1) || pool_int_arr_contains(v1ei, i2):
				if pool_int_arr_contains(v2ei, i0) || pool_int_arr_contains(v2ei, i1) || pool_int_arr_contains(v2ei, i2):
					return i / 3
	
	return -1

func delete_selected() -> void:
	if !_mdr:
		return
		
	if _selected_points.size() == 0:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		#todo
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		#todo
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		disable_change_event()
		
		var orig_arr = copy_arrays(_mdr.array)
		
		var triangle_indexes : Array = Array()
		for sp in _selected_points:
			var triangle_index : int = find_first_triangle_index_for_face(sp)
			triangle_indexes.append(triangle_index)
			
		#delete in reverse triangle index order
		triangle_indexes.sort()

		for i in range(triangle_indexes.size() - 1, -1, -1):
			var triangle_index : int = triangle_indexes[i]
			MDRMeshUtils.remove_triangle(_mdr, triangle_index)

		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Delete")

		_selected_points.resize(0)
		enable_change_event()

func generate_normals():
	if !_mdr:
		return

	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	var orig_arr = copy_arrays(_mdr.array)
	var orig_seams = copy_pool_int_array(_mdr.seams)
	
	var seam_points : PoolVector3Array = MDRMeshUtils.seams_to_points(_mdr)
	MDRMeshUtils.generate_normals_mdr(_mdr)
	MDRMeshUtils.points_to_seams(_mdr, seam_points)
	
	add_mesh_seam_change_undo_redo(orig_arr, orig_seams, _mdr.array, _mdr.seams, "Generate Normals")
	enable_change_event()

func generate_tangents():
	if !_mdr:
		return
		
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
		
	disable_change_event()
	var orig_arr = copy_arrays(_mdr.array)
	var orig_seams = copy_pool_int_array(_mdr.seams)
	
	var seam_points : PoolVector3Array = MDRMeshUtils.seams_to_points(_mdr)
	MDRMeshUtils.generate_tangents(_mdr)
	MDRMeshUtils.points_to_seams(_mdr, seam_points)
	
	add_mesh_seam_change_undo_redo(orig_arr, orig_seams, _mdr.array, _mdr.seams, "Generate Tangents")
	enable_change_event()

func remove_doubles():
	if !_mdr:
		return
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	var orig_arr = copy_arrays(_mdr.array)
	var orig_seams = copy_pool_int_array(_mdr.seams)
	
	var seam_points : PoolVector3Array = MDRMeshUtils.seams_to_points(_mdr)
	
	var merged_arrays : Array = MeshUtils.remove_doubles(mdr_arr)
	_mdr.array = merged_arrays
	MDRMeshUtils.points_to_seams(_mdr, seam_points)
	
	add_mesh_seam_change_undo_redo(orig_arr, orig_seams, _mdr.array, _mdr.seams, "Remove Doubles")
	enable_change_event()
		
func merge_optimize():
	if !_mdr:
		return
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	var orig_arr = copy_arrays(_mdr.array)
	var orig_seams = copy_pool_int_array(_mdr.seams)
	
	var seam_points : PoolVector3Array = MDRMeshUtils.seams_to_points(_mdr)
	
	var merged_arrays : Array = MeshUtils.merge_mesh_array(mdr_arr)
	_mdr.array = merged_arrays
	MDRMeshUtils.points_to_seams(_mdr, seam_points)
	
	add_mesh_seam_change_undo_redo(orig_arr, orig_seams, _mdr.array, _mdr.seams, "Merge Optimize")
	enable_change_event()
	
func connect_to_first_selected():
	if !_mdr:
		return
		
	if _selected_points.size() < 2:
		return
		
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	
	var orig_arr = copy_arrays(_mdr.array)
	
	var vertices : PoolVector3Array = mdr_arr[ArrayMesh.ARRAY_VERTEX]

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		var mpos : Vector3 = _handle_points[_selected_points[0]]
		
		for i in range(1, _selected_points.size()):
			var ps : PoolIntArray = _handle_to_vertex_map[_selected_points[i]]
			
			for indx in ps:
				vertices[indx] = mpos
				
		_selected_points.resize(0)
				
		mdr_arr[ArrayMesh.ARRAY_VERTEX] = vertices
		_mdr.array = mdr_arr
		
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Connect to first selected")
		enable_change_event()
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass

func connect_to_avg():
	if !_mdr:
		return
		
	if _selected_points.size() < 2:
		return
		
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	var orig_arr = copy_arrays(_mdr.array)
	
	var vertices : PoolVector3Array = mdr_arr[ArrayMesh.ARRAY_VERTEX]

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		var mpos : Vector3 = Vector3()
		
		for sp in _selected_points:
			mpos += _handle_points[sp]
			
		mpos /= _selected_points.size()
		
		for i in range(_selected_points.size()):
			var ps : PoolIntArray = _handle_to_vertex_map[_selected_points[i]]
			
			for indx in ps:
				vertices[indx] = mpos
				
		_selected_points.resize(0)
				
		mdr_arr[ArrayMesh.ARRAY_VERTEX] = vertices
		_mdr.array = mdr_arr
		
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Connect to average")
		enable_change_event()
		
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass
		
func connect_to_last_selected():
	if !_mdr:
		return
		
	if _selected_points.size() < 2:
		return
	
	var orig_arr = copy_arrays(_mdr.array)
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	disable_change_event()
	
	var vertices : PoolVector3Array = mdr_arr[ArrayMesh.ARRAY_VERTEX]

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		var mpos : Vector3 = _handle_points[_selected_points[_selected_points.size() - 1]]
		
		for i in range(0, _selected_points.size() - 1):
			var ps : PoolIntArray = _handle_to_vertex_map[_selected_points[i]]
			
			for indx in ps:
				vertices[indx] = mpos
				
		_selected_points.resize(0)
				
		mdr_arr[ArrayMesh.ARRAY_VERTEX] = vertices
		_mdr.array = mdr_arr
		
		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Connect to last selected")
		enable_change_event()
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass

func get_first_index_pair_for_edge(edge : int) -> PoolIntArray:
	var ret : PoolIntArray = PoolIntArray()
	
	var eisarr : Array = split_edge_indices(edge)

	if eisarr.size() == 0:
		return ret
	
	# these should have the same size
	var v0ei : PoolIntArray = eisarr[0]
	var v1ei : PoolIntArray = eisarr[1]
	
	var res : PoolIntArray = PoolIntArray()
	
	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		if pool_int_arr_contains(v0ei, i0) || pool_int_arr_contains(v0ei, i1) || pool_int_arr_contains(v0ei, i2):
			if pool_int_arr_contains(v1ei, i0) || pool_int_arr_contains(v1ei, i1) || pool_int_arr_contains(v1ei, i2):
				
				if pool_int_arr_contains(v0ei, i0):
					ret.push_back(i0)
				elif pool_int_arr_contains(v0ei, i1):
					ret.push_back(i1)
				elif pool_int_arr_contains(v0ei, i2):
					ret.push_back(i2)
				
				if pool_int_arr_contains(v1ei, i0):
					ret.push_back(i0)
				elif pool_int_arr_contains(v1ei, i1):
					ret.push_back(i1)
				elif pool_int_arr_contains(v1ei, i2):
					ret.push_back(i2)
				
				return ret
				
	return ret

func get_all_index_pairs_for_edge(edge : int) -> PoolIntArray:
	var ret : PoolIntArray = PoolIntArray()
	
	var eisarr : Array = split_edge_indices(edge)

	if eisarr.size() == 0:
		return ret
	
	# these should have the same size
	var v0ei : PoolIntArray = eisarr[0]
	var v1ei : PoolIntArray = eisarr[1]
	
	var res : PoolIntArray = PoolIntArray()
	
	for i in range(0, _indices.size(), 3):
		var i0 : int = _indices[i]
		var i1 : int = _indices[i + 1]
		var i2 : int = _indices[i + 2]
		
		if pool_int_arr_contains(v0ei, i0) || pool_int_arr_contains(v0ei, i1) || pool_int_arr_contains(v0ei, i2):
			if pool_int_arr_contains(v1ei, i0) || pool_int_arr_contains(v1ei, i1) || pool_int_arr_contains(v1ei, i2):
				
				if pool_int_arr_contains(v0ei, i0):
					ret.push_back(i0)
				elif pool_int_arr_contains(v0ei, i1):
					ret.push_back(i1)
				elif pool_int_arr_contains(v0ei, i2):
					ret.push_back(i2)
				
				if pool_int_arr_contains(v1ei, i0):
					ret.push_back(i0)
				elif pool_int_arr_contains(v1ei, i1):
					ret.push_back(i1)
				elif pool_int_arr_contains(v1ei, i2):
					ret.push_back(i2)
				
	return ret


func mark_seam():
	if !_mdr:
		return
		
	if _selected_points.size() == 0:
		return

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		disable_change_event()
		
		var prev_seams : PoolIntArray = copy_pool_int_array(_mdr.seams)
		
		for se in _selected_points:
			var eis : PoolIntArray = MDRMeshUtils.order_seam_indices(get_first_index_pair_for_edge(se))
			
			if eis.size() == 0:
				continue
				
			MDRMeshUtils.add_seam(_mdr, eis[0], eis[1])
		
		_undo_redo.create_action("mark_seam")
		_undo_redo.add_do_method(self, "set_seam", _mdr, copy_pool_int_array(_mdr.seams))
		_undo_redo.add_undo_method(self, "set_seam", _mdr, prev_seams)
		_undo_redo.commit_action()
		
		enable_change_event()
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass

func unmark_seam():
	if !_mdr:
		return
		
	if _selected_points.size() == 0:
		return
		
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		disable_change_event()
		
		var prev_seams : PoolIntArray = copy_pool_int_array(_mdr.seams)
		
		for se in _selected_points:
			var eis : PoolIntArray = MDRMeshUtils.order_seam_indices(get_all_index_pairs_for_edge(se))
			
			if eis.size() == 0:
				continue
				
			MDRMeshUtils.remove_seam(_mdr, eis[0], eis[1])
		
		_undo_redo.create_action("unmark_seam")
		_undo_redo.add_do_method(self, "set_seam", _mdr, copy_pool_int_array(_mdr.seams))
		_undo_redo.add_undo_method(self, "set_seam", _mdr, prev_seams)
		_undo_redo.commit_action()
		
		enable_change_event()
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass

func set_seam(mdr : MeshDataResource, arr : PoolIntArray) -> void:
	mdr.seams = arr

func apply_seam():
	if !_mdr:
		return
	
	disable_change_event()
	
	var orig_arr : Array = copy_arrays(_mdr.array)
	MDRMeshUtils.apply_seam(_mdr)
	add_mesh_change_undo_redo(orig_arr, _mdr.array, "apply_seam")
	
	enable_change_event()

func clean_mesh():
	if !_mdr:
		return
	
	var arrays : Array = _mdr.array
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return arrays
	
	if arrays[ArrayMesh.ARRAY_VERTEX] == null || arrays[ArrayMesh.ARRAY_INDEX] == null:
		return arrays
	
	var old_vert_size : int = arrays[ArrayMesh.ARRAY_VERTEX].size()
	
	disable_change_event()
	
	var orig_arr : Array = copy_arrays(arrays)
	arrays = MDRMeshUtils.remove_used_vertices(arrays)
	var new_vert_size : int = arrays[ArrayMesh.ARRAY_VERTEX].size()
	add_mesh_change_undo_redo(orig_arr, arrays, "clean_mesh")
	
	enable_change_event()
	
	var d : int = old_vert_size - new_vert_size
	
	print("MDRED: Removed " + str(d) + " unused vertices.")

func uv_unwrap() -> void:
	if !_mdr:
		return

	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
		
	disable_change_event()
	
	var uvs : PoolVector2Array = MeshUtils.uv_unwrap(mdr_arr)
	
	if uvs.size() != mdr_arr[ArrayMesh.ARRAY_VERTEX].size():
		print("Error: Could not unwrap mesh!")
		enable_change_event(false)
		return
		
	var orig_arr : Array = copy_arrays(mdr_arr)
	
	mdr_arr[ArrayMesh.ARRAY_TEX_UV] = uvs
	
	add_mesh_change_undo_redo(orig_arr, mdr_arr, "uv_unwrap")
	enable_change_event()

func flip_selected_faces() -> void:
	if !_mdr:
		return
		
	if _selected_points.size() == 0:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		disable_change_event()
		
		var orig_arr = copy_arrays(_mdr.array)
		
		for sp in _selected_points:
			var triangle_index : int = find_first_triangle_index_for_face(sp)
			
			MDRMeshUtils.flip_triangle_ti(_mdr, triangle_index)

		add_mesh_change_undo_redo(orig_arr, _mdr.array, "Flip Faces")

		enable_change_event()

func add_mesh_change_undo_redo(orig_arr : Array, new_arr : Array, action_name : String) -> void:
	_undo_redo.create_action(action_name)
	var nac : Array = copy_arrays(new_arr)
	_undo_redo.add_do_method(self, "apply_mesh_change", _mdr, nac)
	_undo_redo.add_undo_method(self, "apply_mesh_change", _mdr, orig_arr)
	_undo_redo.commit_action()

func add_mesh_seam_change_undo_redo(orig_arr : Array, orig_seams : PoolIntArray, new_arr : Array, new_seams : PoolIntArray, action_name : String) -> void:
	_undo_redo.create_action(action_name)
	var nac : Array = copy_arrays(new_arr)
	
	_undo_redo.add_do_method(self, "apply_mesh_change", _mdr, nac)
	_undo_redo.add_undo_method(self, "apply_mesh_change", _mdr, orig_arr)
	
	_undo_redo.add_do_method(self, "set_seam", _mdr, copy_pool_int_array(new_seams))
	_undo_redo.add_undo_method(self, "set_seam", _mdr, orig_seams)
	
	_undo_redo.commit_action()

func apply_mesh_change(mdr : MeshDataResource, arr : Array) -> void:
	if !mdr:
		return
		
	mdr.array = copy_arrays(arr)

func apply_vertex_array(mdr : MeshDataResource, verts : PoolVector3Array) -> void:
	if !mdr:
		return
		
	var mdr_arr : Array = mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX:
		return
	
	mdr_arr[ArrayMesh.ARRAY_VERTEX] = verts
	mdr.array = mdr_arr

func copy_arrays(arr : Array) -> Array:
	return arr.duplicate(true)

func copy_pool_int_array(pia : PoolIntArray) -> PoolIntArray:
	var ret : PoolIntArray = PoolIntArray()
	ret.resize(pia.size())
	
	for i in range(pia.size()):
		ret[i] = pia[i]
	
	return ret

func copy_mdr_verts_array() -> PoolVector3Array:
	var ret : PoolVector3Array = PoolVector3Array()
	
	if !_mdr:
		return ret

	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return ret
	
	var vertices : PoolVector3Array = mdr_arr[ArrayMesh.ARRAY_VERTEX]
	ret.append_array(vertices)
	
	return ret

func setup_op_drag_indices() -> void:
	_drag_op_indices.resize(0)
	
	for sp in _selected_points:
		var pi : PoolIntArray = _handle_to_vertex_map[sp]
		
		for indx in pi:
			if !pool_int_arr_contains(_drag_op_indices, indx):
				_drag_op_indices.append(indx)

func get_drag_op_pivot() -> Vector3:
	if pivot_type == PivotTypes.PIVOT_TYPE_AVERAGED:
		var avg : Vector3 = Vector3()
		
		for indx in _drag_op_indices:
			avg += _vertices[indx]
			
		avg /= _drag_op_indices.size()

		return avg
	elif pivot_type == PivotTypes.PIVOT_TYPE_MDI_ORIGIN:
		return Vector3()
	elif pivot_type == PivotTypes.PIVOT_TYPE_WORLD_ORIGIN:
		return get_spatial_node().to_local(Vector3())
	
	return Vector3()

func select_handle_points(points : PoolVector3Array) -> void:
	_selected_points.resize(0)
	
	for p in points:
		for i in range(_handle_points.size()):
			if is_verts_equal(p, _handle_points[i]):
				if !pool_int_arr_contains(_selected_points, i):
					_selected_points.push_back(i)

	redraw()

func set_pivot_averaged():
	pivot_type = PivotTypes.PIVOT_TYPE_AVERAGED

func set_pivot_mdi_origin():
	pivot_type = PivotTypes.PIVOT_TYPE_MDI_ORIGIN

func set_pivot_world_origin():
	pivot_type = PivotTypes.PIVOT_TYPE_WORLD_ORIGIN

func transfer_state_from(other) -> void:
	edit_mode = other.edit_mode
	pivot_type = other.pivot_type
	axis_constraint = other.axis_constraint
	selection_mode = other.selection_mode
	handle_selection_type = other.handle_selection_type
	
	visual_indicator_outline = other.visual_indicator_outline
	visual_indicator_seam = other.visual_indicator_seam
	visual_indicator_handle = other.visual_indicator_handle

func visual_indicator_outline_set(on : bool):
	visual_indicator_outline = on
	redraw()

func visual_indicator_seam_set(on : bool):
	visual_indicator_seam = on
	redraw()

func visual_indicator_handle_set(on : bool):
	visual_indicator_handle = on
	redraw()

func handle_selection_type_front():
	handle_selection_type = HandleSelectionType.HANDLE_SELECTION_TYPE_FRONT
		
func handle_selection_type_back():
	handle_selection_type = HandleSelectionType.HANDLE_SELECTION_TYPE_BACK
		
func handle_selection_type_all():
	handle_selection_type = HandleSelectionType.HANDLE_SELECTION_TYPE_ALL

