tool
extends Object

#you can use MeshUtils.merge_mesh_array(arr) to get optimalized handle points. Just get the vertices from it.

static func get_handle_vertex_to_vertex_map(arrays : Array, handle_points : PoolVector3Array) -> Array:
	var handle_to_vertex_map : Array
	
	#foreach handle points
		#get all equal approx vertex and put it into the map
	
	return handle_to_vertex_map

static func get_handle_edge_to_vertex_map() -> Array:
	return Array()
	
static func get_handle_face_to_vertex_map() -> Array:
	return Array()

static func calculate_map_midpoints(mesh : Array, vertex_map : Array) -> PoolVector3Array:
	return PoolVector3Array()
