tool
extends Object

static func get_handle_vertex_to_vertex_map() -> Array:
	return Array()

static func get_handle_edge_to_vertex_map() -> Array:
	return Array()
	
static func get_handle_face_to_vertex_map() -> Array:
	return Array()

static func calculate_map_midpoints(mesh : Array, vertex_map : Array) -> PoolVector3Array:
	return PoolVector3Array()
