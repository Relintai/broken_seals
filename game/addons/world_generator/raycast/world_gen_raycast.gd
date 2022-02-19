tool
extends Reference
class_name WorldGenRaycast

var current_index : int = -1
var base_resources : Array = Array()
var local_positions : PoolVector2Array = PoolVector2Array()
var local_uvs : PoolVector2Array = PoolVector2Array()

func get_local_position() -> Vector2:
	return local_positions[current_index]

func get_local_uv() -> Vector2:
	return local_uvs[current_index]

# WorldGenBaseResource (can't explicitly add -> cyclic dependency)
func get_resource():
	return base_resources[current_index]

func next() -> bool:
	current_index += 1
	
	return base_resources.size() > current_index
	
func size() -> int:
	return base_resources.size()

# base_resource -> WorldGenBaseResource
func add_data(base_resource, local_pos : Vector2, local_uv : Vector2) -> void:
	base_resources.append(base_resource)
	local_positions.append(local_pos)
	local_uvs.append(local_uv)
