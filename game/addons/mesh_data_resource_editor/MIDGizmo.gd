tool
extends EditorSpatialGizmo

var MeshOutline = preload("res://addons/mesh_data_resource_editor/utilities/mesh_outline.gd")
var MeshDecompose = preload("res://addons/mesh_data_resource_editor/utilities/mesh_decompose.gd")

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

var gizmo_size = 3.0

var edit_mode : int = EditMode.EDIT_MODE_TRANSLATE
var axis_constraint : int = AxisConstraint.X | AxisConstraint.Y | AxisConstraint.Z
var selection_mode : int = SelectionMode.SELECTION_MODE_VERTEX
var previous_point : Vector2
var is_dragging : bool = false

var _mdr : MeshDataResource = null

var _vertices : PoolVector3Array
var _handle_points : PoolVector3Array
var _handle_to_vertex_map : Array
var _selected_points : PoolIntArray

var _mesh_outline_generator

func _init():
	_mesh_outline_generator = MeshOutline.new()
	
func setup() -> void:
	get_spatial_node().connect("mesh_data_resource_changed", self, "on_mesh_data_resource_changed")
	on_mesh_data_resource_changed(get_spatial_node().mesh_data)

func set_handle(index: int, camera: Camera, point: Vector2):
	var relative : Vector2 = point - previous_point
	
	if !is_dragging:
		relative = Vector2()
		is_dragging = true
	
	if edit_mode == EditMode.EDIT_MODE_NONE:
		return
	elif edit_mode == EditMode.EDIT_MODE_TRANSLATE:
		var ofs : Vector3 = Vector3()

		if (axis_constraint & AxisConstraint.X) != 0:
			ofs.x = relative.x * 0.001 * sign(camera.get_global_transform().basis.z.z)
				
		if (axis_constraint & AxisConstraint.Y) != 0:
			ofs.y = relative.y * -0.001
				
		if (axis_constraint & AxisConstraint.Z) != 0:
			ofs.z = relative.x * 0.001  * -sign(camera.get_global_transform().basis.z.x)

		add_to_all_selected(ofs)

		recalculate_handle_points()
		apply()
		redraw()
	elif edit_mode == EditMode.EDIT_MODE_SCALE:
		var r : float = 1.0 + ((relative.x + relative.y) * 0.05)
		
		var vs : Vector3 = Vector3()
		
		if (axis_constraint & AxisConstraint.X) != 0:
			vs.x = r
				
		if (axis_constraint & AxisConstraint.Y) != 0:
			vs.y = r
				
		if (axis_constraint & AxisConstraint.Z) != 0:
			vs.z = r
		
		var b : Basis = Basis().scaled(vs) 
		
		mul_all_selected_with_basis(b)

		recalculate_handle_points()
		apply()
		redraw()
	elif edit_mode == EditMode.EDIT_MODE_ROTATE:
		print("MDR Editor: ROTATE NYI")
		
		
	previous_point = point

func commit_handle(index: int, restore, cancel: bool = false) -> void:
	previous_point = Vector2()
	
	print("MDR Editor: commit_handle test")

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
	
	_mesh_outline_generator.setup(_mdr)
	add_lines(_mesh_outline_generator.lines, material, false)

	if _selected_points.size() > 0:
		var vs : PoolVector3Array = PoolVector3Array()
		
		for i in _selected_points:
			vs.append(_handle_points[i])
		
		add_handles(vs, handles_material)

func apply() -> void:
	if !_mdr:
		return
		
	var arrs : Array = _mdr.array
	arrs[ArrayMesh.ARRAY_VERTEX] = _vertices
	_mdr.array = arrs

func forward_spatial_gui_input(index, camera, event):
	if event is InputEventMouseButton:
		var gt : Transform = get_spatial_node().global_transform
		var ray_from : Vector3 = camera.global_transform.origin
		var gpoint : Vector2 = event.get_position()
		var grab_threshold : float = 8

		if event.get_button_index() == BUTTON_LEFT:
			if event.is_pressed():
				var mouse_pos = event.get_position()
				
#				if (_gizmo_select(p_index, _edit.mouse_pos)) 
#					return true;

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
					for si in _selected_points:
						if si == closest_idx:
							return false
					
					_selected_points.append(closest_idx)

					apply()
					redraw()
				else:
					if _selected_points.size() == 0:
						return false
					
					_selected_points.resize(0)

					redraw()
			else:
				is_dragging = false
					
#	elif event is InputEventMouseMotion:
#		if edit_mode == EditMode.EDIT_MODE_NONE:
#			return false
#		elif edit_mode == EditMode.EDIT_MODE_TRANSLATE:
#			for i in selected_indices:
#				var v : Vector3 = vertices[i]
#
#				if axis_constraint == AxisConstraint.X:
#					v.x += event.relative.x * -0.001
#				elif axis_constraint == AxisConstraint.Y:
#					v.y += event.relative.y * 0.001
#				elif axis_constraint == AxisConstraint.Z:
#					v.z += event.relative.x * 0.001
#
#				vertices.set(i, v)
#
#			redraw()
#		elif edit_mode == EditMode.EDIT_MODE_SCALE:
#			print("SCALE")
#		elif edit_mode == EditMode.EDIT_MODE_ROTATE:
#			print("ROTATE")
					
	return false

func add_to_all_selected(ofs : Vector3) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v += ofs
		_handle_points.set(i, v)
	
	for i in _selected_points:
		var ps : PoolIntArray = _handle_to_vertex_map[i]
		
		for j in ps:
			var v : Vector3 = _vertices[j]
			v += ofs
			_vertices.set(j, v)

func mul_all_selected_with_basis(b : Basis) -> void:
	for i in _selected_points:
		var v : Vector3 = _handle_points[i]
		v = b * v
		_handle_points.set(i, v)
	
	for i in _selected_points:
		var ps : PoolIntArray = _handle_to_vertex_map[i]
		
		for j in ps:
			var v : Vector3 = _vertices[j]
			v = b * v
			_vertices.set(j, v)

func set_translate(on : bool) -> void:
	if on:
		edit_mode = EditMode.EDIT_MODE_TRANSLATE
	
func set_scale(on : bool) -> void:
	if on:
		edit_mode = EditMode.EDIT_MODE_SCALE
	
func set_rotate(on : bool) -> void:
	if on:
		edit_mode = EditMode.EDIT_MODE_ROTATE
	
func set_axis_x(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.X) != 0:
			axis_constraint ^= AxisConstraint.X
		else:
			axis_constraint |= AxisConstraint.X
	
func set_axis_y(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.Y) != 0:
			axis_constraint ^= AxisConstraint.Y
		else:
			axis_constraint |= AxisConstraint.Y
	
func set_axis_z(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.Z) != 0:
			axis_constraint ^= AxisConstraint.Z
		else:
			axis_constraint |= AxisConstraint.Z

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if self != null && get_plugin():
			get_plugin().unregister_gizmo(self)

#todo if selection type changed recalc handles aswell
	#add method recalc handles -> check for type
func recalculate_handle_points() -> void:
	if !_mdr:
		_handle_points.resize(0)
		_handle_to_vertex_map.resize(0)

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
		_handle_to_vertex_map = MeshDecompose.get_handle_vertex_to_vertex_map(arr, _handle_points)
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		var result : Array = MeshDecompose.get_handle_edge_to_vertex_map(arr)
		
		_handle_points = result[0]
		_handle_to_vertex_map = result[1]
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		#todo
		var merged_arrays : Array = MeshUtils.merge_mesh_array(arr)
		_handle_points = merged_arrays[ArrayMesh.ARRAY_VERTEX]
		_handle_to_vertex_map = MeshDecompose.get_handle_vertex_to_vertex_map(arr, _handle_points)

func on_mesh_data_resource_changed(mdr : MeshDataResource) -> void:
	_mdr = mdr
	
	if _mdr && _mdr.array.size() == ArrayMesh.ARRAY_MAX && _mdr.array[ArrayMesh.ARRAY_VERTEX] != null:
		_vertices = _mdr.array[ArrayMesh.ARRAY_VERTEX]
	else:
		_vertices.resize(0)
	
	recalculate_handle_points()
	redraw()
