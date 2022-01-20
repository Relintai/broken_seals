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

#returns an array:
#index 0 is the handle_points
#index 1 is the handle_to_vertex_map
static func get_handle_edge_to_vertex_map(arrays : Array) -> Array:
	var handle_to_vertex_map : Array
	var handle_points : PoolVector3Array
	
	if arrays.size() != ArrayMesh.ARRAY_MAX || arrays[ArrayMesh.ARRAY_INDEX] == null:
		return [ handle_points, handle_to_vertex_map ] 
		
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	
	if vertices.size() == 0:
		return [ handle_points, handle_to_vertex_map ] 
	
	var arr : Array = Array()
	arr.resize(ArrayMesh.ARRAY_MAX)
	arr[ArrayMesh.ARRAY_VERTEX] = arrays[ArrayMesh.ARRAY_VERTEX]
	arr[ArrayMesh.ARRAY_INDEX] = arrays[ArrayMesh.ARRAY_INDEX]
	
	var optimized_arrays : Array = MeshUtils.merge_mesh_array(arr)
	var optimized_verts : PoolVector3Array = optimized_arrays[ArrayMesh.ARRAY_VERTEX]
	var optimized_indices : PoolIntArray = optimized_arrays[ArrayMesh.ARRAY_INDEX]

	var vert_to_optimized_vert_map : Array = get_handle_vertex_to_vertex_map(arrays, optimized_verts)

	var edge_map : Dictionary = Dictionary()
	
	for i in range(0, optimized_indices.size(), 3):
		for j in range(3):
			var i0 : int = optimized_indices[i + j]
			var i1 : int = optimized_indices[i + ((j + 1) % 3)]
			
			var ei0 : int = min(i0, i1)
			var ei1 : int = max(i0, i1)
			
			if !edge_map.has(ei0):
				edge_map[ei0] = PoolIntArray()
				
			var etm : PoolIntArray = edge_map[ei0]
			
			var found : bool = false
			for e in etm:
				if e == ei1:
					found = true
					break
			
			if !found:
				etm.append(ei1)
				edge_map[ei0] = etm
	
	for key in edge_map.keys():
		var indices : PoolIntArray = edge_map[key]
		
		for indx in indices:
			var ei0 : int = key
			var ei1 : int = indx
			
			var v0 : Vector3 = optimized_verts[ei0]
			var v1 : Vector3 = optimized_verts[ei1]
			
			var emid : Vector3 = lerp(v0, v1, 0.5)
			handle_points.append(emid)
			var hindx : int = handle_points.size() - 1
			
			var vm0 : PoolIntArray = vert_to_optimized_vert_map[ei0]
			var vm1 : PoolIntArray = vert_to_optimized_vert_map[ei1]
			
			var vm : PoolIntArray = PoolIntArray()
			vm.append_array(vm0)
			
			for vi in vm1:
				var found : bool = false
				for vit in vm:
					if vi == vit:
						found = true
						break
				
				if !found:
					vm.append(vi)
			
			handle_to_vertex_map.append(vm)
	
	return [ handle_points, handle_to_vertex_map ] 

#returns an array:
#index 0 is the handle_points
#index 1 is the handle_to_vertex_map
static func get_handle_face_to_vertex_map(arrays : Array) -> Array:
	var handle_to_vertex_map : Array
	var handle_points : PoolVector3Array
	
	if arrays.size() != ArrayMesh.ARRAY_MAX || arrays[ArrayMesh.ARRAY_INDEX] == null:
		return [ handle_points, handle_to_vertex_map ] 
		
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	
	if vertices.size() == 0:
		return [ handle_points, handle_to_vertex_map ] 
	
	var arr : Array = Array()
	arr.resize(ArrayMesh.ARRAY_MAX)
	arr[ArrayMesh.ARRAY_VERTEX] = arrays[ArrayMesh.ARRAY_VERTEX]
	arr[ArrayMesh.ARRAY_INDEX] = arrays[ArrayMesh.ARRAY_INDEX]
	
	var optimized_arrays : Array = MeshUtils.merge_mesh_array(arr)
	var optimized_verts : PoolVector3Array = optimized_arrays[ArrayMesh.ARRAY_VERTEX]
	var optimized_indices : PoolIntArray = optimized_arrays[ArrayMesh.ARRAY_INDEX]

	var vert_to_optimized_vert_map : Array = get_handle_vertex_to_vertex_map(arrays, optimized_verts)

	for i in range(0, optimized_indices.size(), 3):
		var i0 : int = optimized_indices[i + 0]
		var i1 : int = optimized_indices[i + 1]
		var i2 : int = optimized_indices[i + 2]
				
		var v0 : Vector3 = optimized_verts[i0]
		var v1 : Vector3 = optimized_verts[i1]
		var v2 : Vector3 = optimized_verts[i2]

		var pmid : Vector3 = v0 + v1 + v2
		pmid /= 3
		handle_points.append(pmid)
		
		var vm0 : PoolIntArray = vert_to_optimized_vert_map[i0]
		var vm1 : PoolIntArray = vert_to_optimized_vert_map[i1]
		var vm2 : PoolIntArray = vert_to_optimized_vert_map[i2]
		
		var vm : PoolIntArray = PoolIntArray()
		vm.append_array(vm0)

		for vi in vm1:
			var found : bool = false
			for vit in vm:
				if vi == vit:
					found = true
					break
				
			if !found:
				vm.append(vi)
				
		for vi in vm2:
			var found : bool = false
			for vit in vm:
				if vi == vit:
					found = true
					break
				
			if !found:
				vm.append(vi)
		
		handle_to_vertex_map.append(vm)
		
	return [ handle_points, handle_to_vertex_map ] 

static func calculate_map_midpoints(mesh : Array, vertex_map : Array) -> PoolVector3Array:
	return PoolVector3Array()

static func pool_int_arr_contains(arr : PoolIntArray, val : int) -> bool:
	for a in arr:
		if a == val:
			return true
			
	return false

static func partition_mesh(mdr : MeshDataResource) -> Array:
	var partitions : Array = Array()
	
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return partitions
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return partitions
	
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	
	var triangle_count : int = indices.size() / 3
	var processed_triangles : PoolIntArray = PoolIntArray()
	
	while triangle_count != processed_triangles.size():
		var partition : PoolIntArray = PoolIntArray()
		
		var first : bool = true
		var triangle_added : bool = true
		while triangle_added:
			triangle_added = false
			for i in range(indices.size()):
				var triangle_index : int = i / 3
				
				if pool_int_arr_contains(processed_triangles, triangle_index):
					continue
				
				if first:
					first = false
					
					# We have to be at the 0th index of a triangle
					partition.append(indices[i])
					partition.append(indices[i + 1])
					partition.append(indices[i + 2])
					
					triangle_added = true
					break
				
				var index : int = indices[i]
				
				if pool_int_arr_contains(partition, index):
					processed_triangles.append(triangle_index)
					
					var tri_start_index : int = i - (i % 3)

					var i0 : int = indices[tri_start_index]
					var i1 : int = indices[tri_start_index + 1]
					var i2 : int = indices[tri_start_index + 2]
					
					partition.append(i0)
					partition.append(i1)
					partition.append(i2)
					
					triangle_added = true
					break

			
		partitions.append(partition)
		
	
	return partitions
