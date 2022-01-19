tool
extends Control

var mesh_data_resource : MeshDataResource = null setget  set_mesh_data_resource
var background_texture : Texture = null

func set_mesh_data_resource(a : MeshDataResource):
	if mesh_data_resource:
		mesh_data_resource.disconnect("changed", self, "on_mdr_changed")
	
	mesh_data_resource = a
	
	if mesh_data_resource:
		mesh_data_resource.connect("changed", self, "on_mdr_changed")

	update()
	
func set_mesh_data_instance(a : MeshDataInstance):
	if !a:
		background_texture = null
	
	background_texture = a.texture

func on_mdr_changed():
	update()

func _draw():
	if background_texture:
		draw_texture_rect_region(background_texture, Rect2(Vector2(), get_size()), Rect2(Vector2(), background_texture.get_size()))
	
	if !mesh_data_resource:
		return
		
	if mesh_data_resource.array.size() != ArrayMesh.ARRAY_MAX:
		return
		
	var uvs : PoolVector2Array = mesh_data_resource.array[ArrayMesh.ARRAY_TEX_UV]
	var indices : PoolIntArray = mesh_data_resource.array[ArrayMesh.ARRAY_INDEX]
	
	if indices.size() % 3 == 0:
		for i in range(0, len(indices), 3):
			var c : Color = Color(1, 1, 1, 1)
			
			if uvs[indices[i]].is_equal_approx(Vector2()) || uvs[indices[i + 1]].is_equal_approx(Vector2()):
				c = Color(1, 0, 0, 1)
			else:
				c = Color(1, 1, 1, 1)
				
			draw_line(uvs[indices[i]] * get_size(), uvs[indices[i + 1]] * get_size(), c, 1, false)

			if uvs[indices[i + 1]].is_equal_approx(Vector2()) || uvs[indices[i + 2]].is_equal_approx(Vector2()):
				c = Color(1, 0, 0, 1)
			else:
				c = Color(1, 1, 1, 1)
				
			draw_line(uvs[indices[i + 1]] * get_size(), uvs[indices[i + 2]] * get_size(), c, 1, false)
				
			if uvs[indices[i + 2]].is_equal_approx(Vector2()) || uvs[indices[i]].is_equal_approx(Vector2()):
				c = Color(1, 0, 0, 1)
			else:
				c = Color(1, 1, 1, 1)

			draw_line(uvs[indices[i + 2]] * get_size(), uvs[indices[i]] * get_size(), c, 1, false)
