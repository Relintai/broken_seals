tool
extends Object

#you can use MeshUtils.merge_mesh_array(arr) to get optimalized handle points. Just get the vertices from it.

static func get_handle_vertex_to_vertex_map(arrays : Array, handle_points : PoolVector3Array) -> Array:
	var handle_to_vertex_map : Array
	handle_to_vertex_map.resize(handle_points.size())
	
	if handle_points.size() == 0:
		return handle_to_vertex_map
	
	if arrays.size() != ArrayMesh.ARRAY_MAX || arrays[ArrayMesh.ARRAY_INDEX] == null:
		return handle_to_vertex_map
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	
	if vertices.size() == 0:
		return handle_to_vertex_map

	for i in range(handle_points.size()):
		var hv : Vector3 = handle_points[i]
		var iarr : PoolIntArray = PoolIntArray()

		#find all verts that have the same position as the handle
		for j in range(vertices.size()):
			var vn : Vector3 = vertices[j]
						
			if is_equal_approx(hv.x, vn.x) && is_equal_approx(hv.y, vn.y) && is_equal_approx(hv.z, vn.z):
				iarr.append(j)
				
		handle_to_vertex_map[i] = iarr

	return handle_to_vertex_map

static func get_handle_edge_to_vertex_map() -> Array:
	return Array()
	
static func get_handle_face_to_vertex_map() -> Array:
	return Array()

static func calculate_map_midpoints(mesh : Array, vertex_map : Array) -> PoolVector3Array:
	return PoolVector3Array()
