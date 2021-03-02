tool
extends EditorSpatialGizmo

enum EditMode {
	NONE, TRANSLATE, SCALE, ROTATE
}

enum AxisConstraint {
	X, Y, Z
}

var gizmo_size = 3.0

var plugin

var vertices : PoolVector3Array
var indices : PoolIntArray
var selected_indices : PoolIntArray
var selected_vertices : PoolVector3Array
var selected_vertices_original : PoolVector3Array

var edit_mode = EditMode.NONE
var axis_constraint = AxisConstraint.NONE

func set_handle(index: int, camera: Camera, point: Vector2):
	print("set_handle")
	
	edit_mode = EditMode.NONE

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
	#add_handles(vertices, handles_material)
	
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
	
	add_handles(selected_vertices, handles_material)

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
					
	elif event is InputEventMouseMotion:
		if edit_mode == EditMode.NONE:
			return false
		elif edit_mode == EditMode.TRANSLATE:
			for i in selected_indices:
				var v : Vector3 = vertices[i]
					
				if axis_constraint == AxisConstraint.X:
					v.x += event.relative.x * -0.001
				elif axis_constraint == AxisConstraint.Y:
					v.y += event.relative.y * 0.001
				elif axis_constraint == AxisConstraint.Z:
					v.z += event.relative.x * 0.001
					
				vertices.set(i, v)
				
			redraw()
		elif edit_mode == EditMode.SCALE:
			print("SCALE")
		elif edit_mode == EditMode.ROTATE:
			print("ROTATE")
					
	return false

func translate_request(on : bool) -> void:
	if on:
		edit_mode = EditMode.TRANSLATE
	
func scale_request(on : bool) -> void:
	if on:
		edit_mode = EditMode.SCALE
	
func rotate_request(on : bool) -> void:
	if on:
		edit_mode = EditMode.ROTATE
	
func axis_key_x(on : bool) -> void:
	if on:
		axis_constraint = AxisConstraint.X
	
func axis_key_y(on : bool) -> void:
	if on:
		axis_constraint = AxisConstraint.Y
	
func axis_key_z(on : bool) -> void:
	if on:
		axis_constraint = AxisConstraint.Z

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if plugin:
			plugin.unregister_gizmo(self)
