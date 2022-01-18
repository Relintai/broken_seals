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

var gizmo_size = 3.0

var edit_mode : int = EditMode.EDIT_MODE_TRANSLATE
var axis_constraint : int = AxisConstraint.X | AxisConstraint.Y | AxisConstraint.Z
var selection_mode : int = SelectionMode.SELECTION_MODE_VERTEX
var previous_point : Vector2
var is_dragging : bool = false
var _last_known_camera_facing : Vector3 = Vector3(0, 0, -1)

var _mdr : MeshDataResource = null

var _vertices : PoolVector3Array
var _indices : PoolIntArray
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
	var seam_material = get_plugin().get_material("seam", self)
	
	_mesh_outline_generator.setup(_mdr)
	
	if selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		_mesh_outline_generator.generate_mark_edges()
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		_mesh_outline_generator.generate_mark_faces()
	else:
		_mesh_outline_generator.generate()
	
	add_lines(_mesh_outline_generator.lines, material, false)
	add_lines(_mesh_outline_generator.seam_lines, seam_material, false)
	
	if _selected_points.size() > 0:
		var vs : PoolVector3Array = PoolVector3Array()
		
		for i in _selected_points:
			vs.append(_handle_points[i])
		
		add_handles(vs, handles_material)

func apply() -> void:
	if !_mdr:
		return
	
	_mdr.disconnect("changed", self, "on_mdr_changed")
	
	var arrs : Array = _mdr.array
	arrs[ArrayMesh.ARRAY_VERTEX] = _vertices
	arrs[ArrayMesh.ARRAY_INDEX] = _indices
	_mdr.array = arrs
	
	_mdr.connect("changed", self, "on_mdr_changed")

func forward_spatial_gui_input(index, camera, event):
	_last_known_camera_facing = camera.transform.basis.xform(Vector3(0, 0, -1))
	
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

func add_triangle() -> void:
	if _mdr:
		MDRMeshUtils.add_triangle(_mdr)

func add_quad() -> void:
	if _mdr:
		MDRMeshUtils.add_quad(_mdr)

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
		_mdr.disconnect("changed", self, "on_mdr_changed")
		
		for sp in _selected_points:
			add_triangle_to_edge(sp)
			
		_selected_points.resize(0)
		_mdr.connect("changed", self, "on_mdr_changed")
		on_mdr_changed()
	else:
		add_triangle()
		
func add_quad_at() -> void:
	if !_mdr:
		return
	
	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		#todo
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		_mdr.disconnect("changed", self, "on_mdr_changed")
		
		for sp in _selected_points:
			add_quad_to_edge(sp)
		
		_selected_points.resize(0)
		_mdr.connect("changed", self, "on_mdr_changed")
		on_mdr_changed()
	else:
		add_triangle()

func add_box() -> void:
	if _mdr:
		MDRMeshUtils.add_box(_mdr)

func split():
	pass

func disconnect_action():
	pass

func create_face():
	if !_mdr:
		return
		
	if _selected_points.size() <= 2:
		return

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		_mdr.disconnect("changed", self, "on_mdr_changed")
		
		var points : PoolVector3Array = PoolVector3Array()
		
		for sp in _selected_points:
			points.push_back(_handle_points[sp])
			
		MDRMeshUtils.add_triangulated_mesh_from_points(_mdr, points, _last_known_camera_facing)
		
		_selected_points.resize(0)
		_mdr.connect("changed", self, "on_mdr_changed")
		on_mdr_changed()
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
		if _mdr:
			_mdr.disconnect("changed", self, "on_mdr_changed")
	
		for sp in _selected_points:
			var triangle_index : int = find_first_triangle_index_for_face(sp)
			
			MDRMeshUtils.remove_triangle(_mdr, triangle_index)

		_selected_points.resize(0)
		
		if _mdr:
			_mdr.connect("changed", self, "on_mdr_changed")
			
		on_mdr_changed()
	
func generate_normals():
	if !_mdr:
		return
		
	MDRMeshUtils.generate_normals(_mdr)

func generate_tangents():
	if !_mdr:
		return
		
	MDRMeshUtils.generate_tangents(_mdr)

func remove_doubles():
	if !_mdr:
		return
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	var merged_arrays : Array = MeshUtils.remove_doubles(mdr_arr)
	
	_mdr.array = merged_arrays
		
func merge_optimize():
	if !_mdr:
		return
	
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
	var merged_arrays : Array = MeshUtils.merge_mesh_array(mdr_arr)
	
	_mdr.array = merged_arrays

func onnect_to_first_selected():
	if !_mdr:
		return
		
	if _selected_points.size() < 2:
		return
		
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
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
		
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass
		
func connect_to_last_selected():
	if !_mdr:
		return
		
	if _selected_points.size() < 2:
		return
		
	var mdr_arr : Array = _mdr.array
	
	if mdr_arr.size() != ArrayMesh.ARRAY_MAX || mdr_arr[ArrayMesh.ARRAY_VERTEX] == null || mdr_arr[ArrayMesh.ARRAY_VERTEX].size() == 0:
		return
	
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

func order_seam_indices(arr : PoolIntArray) -> PoolIntArray:
	var ret : PoolIntArray = PoolIntArray()
	
	if arr.size() == 0:
		return ret
	
	for i in range(0, arr.size(), 2):
		var index0 : int = arr[i]
		var index1 : int = arr[i + 1]
		
		if index0 > index1:
			var t : int = index1
			index1 = index0
			index0 = t
		
		ret.push_back(index0)
		ret.push_back(index1)
	
	return ret 
	
func has_seam(index0 : int, index1 : int) -> bool:
	var seams : PoolIntArray = _mdr.seams
	
	for i in range(0, seams.size(), 2):
		if seams[i] == index0 && seams[i + 1] == index1:
			return true
	
	return false

func add_seam(index0 : int, index1 : int) -> void:
	if has_seam(index0, index1):
		return
		
	var seams : PoolIntArray = _mdr.seams
	seams.push_back(index0)
	seams.push_back(index1)
	_mdr.seams = seams

func remove_seam(index0 : int, index1 : int) -> void:
	if !has_seam(index0, index1):
		return
		
	var seams : PoolIntArray = _mdr.seams
	
	for i in range(0, seams.size(), 2):
		if seams[i] == index0 && seams[i + 1] == index1:
			seams.remove(i)
			seams.remove(i)
			_mdr.seams = seams
			return

func mark_seam():
	if !_mdr:
		return
		
	if _selected_points.size() == 0:
		return

	if selection_mode == SelectionMode.SELECTION_MODE_VERTEX:
		pass
	elif selection_mode == SelectionMode.SELECTION_MODE_EDGE:
		_mdr.disconnect("changed", self, "on_mdr_changed")
		
		for se in _selected_points:
			var eis : PoolIntArray = order_seam_indices(get_first_index_pair_for_edge(se))
			
			if eis.size() == 0:
				continue
				
			add_seam(eis[0], eis[1])
		
		_mdr.connect("changed", self, "on_mdr_changed")
		on_mdr_changed()
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
		_mdr.disconnect("changed", self, "on_mdr_changed")
		
		for se in _selected_points:
			var eis : PoolIntArray = order_seam_indices(get_all_index_pairs_for_edge(se))
			
			if eis.size() == 0:
				continue
				
			remove_seam(eis[0], eis[1])
		
		_mdr.connect("changed", self, "on_mdr_changed")
		on_mdr_changed()
	elif selection_mode == SelectionMode.SELECTION_MODE_FACE:
		pass
