tool
extends Control

var mesh_data_resource : MeshDataResource = null setget  set_mesh_data_resource

func set_mesh_data_resource(a : MeshDataResource):
	if mesh_data_resource:
		mesh_data_resource.disconnect("changed", self, "on_mdr_changed")
	
	mesh_data_resource = a
	
	if mesh_data_resource:
		mesh_data_resource.connect("changed", self, "on_mdr_changed")

	update()

func on_mdr_changed():
	update()

func _draw():
	if !mesh_data_resource:
		return
	
	var uvs : PoolVector2Array = mesh_data_resource.array[ArrayMesh.ARRAY_TEX_UV]
	var indices : PoolIntArray = mesh_data_resource.array[ArrayMesh.ARRAY_INDEX]
	
	if indices.size() % 3 == 0:
		for i in range(0, len(indices), 3):
			draw_line(uvs[indices[i]] * get_size(), uvs[indices[i + 1]] * get_size(), Color(1, 1, 1, 1), 1, false)
			draw_line(uvs[indices[i + 1]] * get_size(), uvs[indices[i + 2]] * get_size(), Color(1, 1, 1, 1), 1, false)
			draw_line(uvs[indices[i + 2]] * get_size(), uvs[indices[i]] * get_size(), Color(1, 1, 1, 1), 1, false)
			
			
	
