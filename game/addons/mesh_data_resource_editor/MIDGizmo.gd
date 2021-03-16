tool
extends EditorSpatialGizmo

enum EditMode {
	NONE, TRANSLATE, SCALE, ROTATE
}

enum AxisConstraint {
	X = 1 << 0, 
	Y = 1 << 1, 
	Z = 1 << 2,
}

var gizmo_size = 3.0

var plugin

var vertices : PoolVector3Array
var indices : PoolIntArray
var selected_indices : PoolIntArray
var selected_vertices : PoolVector3Array
var selected_vertices_original : PoolVector3Array

var edit_mode = EditMode.TRANSLATE
var axis_constraint = AxisConstraint.X | AxisConstraint.Y | AxisConstraint.Z
var previous_point : Vector2
var is_dragging : bool = false

func set_handle(index: int, camera: Camera, point: Vector2):
	var relative : Vector2 = point - previous_point
	
	if !is_dragging:
		relative = Vector2()
		is_dragging = true
	
	if edit_mode == EditMode.NONE:
		return
	elif edit_mode == EditMode.TRANSLATE:
		for i in selected_indices:
			var v : Vector3 = vertices[i]

			if (axis_constraint & AxisConstraint.X) != 0:
				v.x += relative.x * 0.001 * sign(camera.get_global_transform().basis.z.z)
				
			if (axis_constraint & AxisConstraint.Y) != 0:
				v.y += relative.y * -0.001
				
			if (axis_constraint & AxisConstraint.Z) != 0:
				v.z += relative.x * 0.001  * -sign(camera.get_global_transform().basis.z.x)

			vertices.set(i, v)

		redraw()
	elif edit_mode == EditMode.SCALE:
		var r : float = 1.0 + ((relative.x + relative.y) * 0.05)
		
		var vs : Vector3 = Vector3()
		
		if (axis_constraint & AxisConstraint.X) != 0:
			vs.x = r
				
		if (axis_constraint & AxisConstraint.Y) != 0:
			vs.y = r
				
		if (axis_constraint & AxisConstraint.Z) != 0:
			vs.z = r
		
		var b : Basis = Basis().scaled(vs) 
		
		for i in selected_indices:
			var v : Vector3 = vertices[i]
			
			v = b * v

			vertices.set(i, v)

		redraw()
	elif edit_mode == EditMode.ROTATE:
		print("ROTATE")
		
		
	previous_point = point

func commit_handle(index: int, restore, cancel: bool = false) -> void:
	previous_point = Vector2()
	
	print("commit")

func redraw():
	clear()
	
	var node : MeshDataInstance = get_spatial_node()
	
	if !node:
		return
		
	var mdr : MeshDataResource = node.mesh_data
	
	if !mdr:
		return
	
	var handles_material : SpatialMaterial = get_plugin().get_material("handles", self)
	
	if vertices.size() == 0:
		vertices = mdr.array[ArrayMesh.ARRAY_VERTEX]

	var material = get_plugin().get_material("main", self)
	var indices : PoolIntArray = mdr.array[ArrayMesh.ARRAY_INDEX]
	
	var lines : PoolVector3Array = PoolVector3Array()
	
	if vertices.size() % 3 == 0:
		for i in range(0, len(vertices), 3):
			lines.append(vertices[i])
			lines.append(vertices[i + 1])
			
			lines.append(vertices[i + 1])
			lines.append(vertices[i + 2])
			
			lines.append(vertices[i + 2])
			lines.append(vertices[i])
			
	add_lines(lines, material, false)
	
	var vs : PoolVector3Array = PoolVector3Array()
	
	for i in selected_indices:
		vs.append(vertices[i])
	
	add_handles(vs, handles_material)

func forward_spatial_gui_input(index, camera, event):
	if event is InputEventMouseButton:
		var gt : Transform = get_spatial_node().global_transform
		var ray_from : Vector3 = camera.global_transform.origin
		var gpoint : Vector2 = event.get_position()
		var grab_threshold : float = 8
#		var grab_threshold : float = 4 * EDSCALE;

		if event.get_button_index() == BUTTON_LEFT:
			if event.is_pressed():
				var mouse_pos = event.get_position()
				
#				if (_gizmo_select(p_index, _edit.mouse_pos)) 
#					return true;

				# select vertex
				var closest_idx : int = -1
				var closest_dist : float = 1e10
				
				var vertices_size : int = vertices.size()
				for i in range(vertices_size):
					var vert_pos_3d : Vector3 = gt.xform(vertices[i])
					var vert_pos_2d : Vector2 = camera.unproject_position(vert_pos_3d)
					var dist_3d : float = ray_from.distance_to(vert_pos_3d)
					var dist_2d : float = gpoint.distance_to(vert_pos_2d)
					
					if (dist_2d < grab_threshold && dist_3d < closest_dist):
						closest_dist = dist_3d;
						closest_idx = i;

				if (closest_idx >= 0):
					for si in selected_indices:
						if si == closest_idx:
							return false
					
					var cv : Vector3 = vertices[closest_idx]
					selected_vertices.append(cv)
					selected_indices.append(closest_idx)
					
					selected_vertices_original.append(cv)
					
					#also find and mark duplicate vertices, but not as handles
					for k in range(vertices.size()):
						if k == closest_idx:
							continue
							
						var vn : Vector3 = vertices[k]
						
						if is_equal_approx(cv.x, vn.x) && is_equal_approx(cv.y, vn.y) && is_equal_approx(cv.z, vn.z):
							selected_indices.append(k)
							selected_vertices_original.append(vn)

					redraw()
				else:
					selected_indices.resize(0)
					selected_vertices.resize(0)
					
					selected_vertices_original.resize(0)
					
					redraw()
			else:
				is_dragging = false
					
#	elif event is InputEventMouseMotion:
#		if edit_mode == EditMode.NONE:
#			return false
#		elif edit_mode == EditMode.TRANSLATE:
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
#		elif edit_mode == EditMode.SCALE:
#			print("SCALE")
#		elif edit_mode == EditMode.ROTATE:
#			print("ROTATE")
					
	return false

func translate_key_pressed(on : bool) -> void:
	if on:
		edit_mode = EditMode.TRANSLATE
	
func scale_key_pressed(on : bool) -> void:
	if on:
		edit_mode = EditMode.SCALE
	
func rotate_key_pressed(on : bool) -> void:
	if on:
		edit_mode = EditMode.ROTATE
	
func axis_key_x(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.X) != 0:
			axis_constraint ^= AxisConstraint.X
		else:
			axis_constraint |= AxisConstraint.X
	
func axis_key_y(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.Y) != 0:
			axis_constraint ^= AxisConstraint.Y
		else:
			axis_constraint |= AxisConstraint.Y
	
func axis_key_z(on : bool) -> void:
	if on:
		if (axis_constraint & AxisConstraint.Z) != 0:
			axis_constraint ^= AxisConstraint.Z
		else:
			axis_constraint |= AxisConstraint.Z

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if plugin:
			plugin.unregister_gizmo(self)
