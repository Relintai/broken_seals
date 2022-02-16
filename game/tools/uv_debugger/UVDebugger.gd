tool
extends Control

var _texture : Texture
var _indices : PoolIntArray = PoolIntArray()
var _uvs : PoolVector2Array = PoolVector2Array()

func _draw():
	if _texture:
		draw_texture_rect_region(_texture, Rect2(Vector2(), get_size()), Rect2(Vector2(), _texture.get_size()))
		
	if _uvs.size() > 0:
		var c : Color = Color(1, 1, 1, 1)
		
		for i in range(0, len(_indices), 3):
			draw_line(_uvs[_indices[i]] * get_size(), _uvs[_indices[i + 1]] * get_size(), c, 1, false)
			draw_line(_uvs[_indices[i + 1]] * get_size(), _uvs[_indices[i + 2]] * get_size(), c, 1, false)
			draw_line(_uvs[_indices[i + 2]] * get_size(), _uvs[_indices[i]] * get_size(), c, 1, false)

func set_texture(texture : Texture) -> void:
	_texture = texture
	update()

func setup_from_mdr(mdr : MeshDataResource):
	setup_from_arrays(mdr.array)
	
func setup_from_arrays(arrays : Array):
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return

	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return

	_uvs = arrays[ArrayMesh.ARRAY_TEX_UV]
	_indices = arrays[ArrayMesh.ARRAY_INDEX]

	update()
