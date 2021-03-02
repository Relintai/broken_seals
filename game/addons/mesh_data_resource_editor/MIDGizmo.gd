tool
extends EditorSpatialGizmo

var gizmo_size = 3.0

var plugin

var vertices : PoolVector3Array
var indices : PoolIntArray
var selected_indices : PoolIntArray
var selected_vertices : PoolVector3Array

func set_handle(index: int, camera: Camera, point: Vector2):
	pass

func redraw():
	clear()
	
	var node : MeshDataInstance = get_spatial_node()
	
	if !node:
		return
		
	var mdr : MeshDataResource = node.mesh_data
	
	if !mdr:
		return
	
	var handles_material : SpatialMaterial = get_plugin().get_material("handles", self)
	
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
					selected_indices.append(closest_idx)
					selected_vertices.append(vertices[closest_idx])

					redraw()
				else:
					selected_indices.resize(0)
					selected_vertices.resize(0)
					
					redraw()
	return false


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if plugin:
			plugin.unregister_gizmo(self)
