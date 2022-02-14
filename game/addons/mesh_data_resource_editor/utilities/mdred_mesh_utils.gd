tool
extends Object

static func remove_triangle(mdr : MeshDataResource, triangle_index : int) -> void:
	if triangle_index < 0:
		return
	
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]

	# Just remove that triangle
	var i : int = triangle_index * 3
	
	var i0 : int = indices[i]
	var i1 : int = indices[i + 1]
	var i2 : int = indices[i + 2]
	
	remove_seam_not_ordered(mdr, i0, i1)
	remove_seam_not_ordered(mdr, i1, i2)
	remove_seam_not_ordered(mdr, i2, i0)
	
	indices.remove(i)
	indices.remove(i)
	indices.remove(i)

	arrays[ArrayMesh.ARRAY_INDEX] = indices
	
	mdr.set_array(arrays)

static func add_triangulated_mesh_from_points_delaunay(mdr : MeshDataResource, selected_points : PoolVector3Array, last_known_camera_facing : Vector3) -> bool:
	if selected_points.size() < 3:
		return false
		
	var tetrahedrons : PoolIntArray = MeshUtils.delaunay3d_tetrahedralize(selected_points)
	
	if tetrahedrons.size() == 0:
		# try randomly displacing the points a bit, it can help
		var rnd_selected_points : PoolVector3Array = PoolVector3Array()
		rnd_selected_points.append_array(selected_points)
		
		for i in range(rnd_selected_points.size()):
			rnd_selected_points[i] = rnd_selected_points[i] + (Vector3(randf(),randf(), randf()) * 0.1)
		
		tetrahedrons = MeshUtils.delaunay3d_tetrahedralize(rnd_selected_points)
		
		if tetrahedrons.size() == 0:
			print("add_triangulated_mesh_from_points_delaunay: tetrahedrons.size() == 0!")
			return false

	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(0, tetrahedrons.size(), 4):
		var i0 : int = tetrahedrons[i]
		var i1 : int = tetrahedrons[i + 1]
		var i2 : int = tetrahedrons[i + 2]
		var i3 : int = tetrahedrons[i + 3]
		
		var v0 : Vector3 = selected_points[i0]
		var v1 : Vector3 = selected_points[i1]
		var v2 : Vector3 = selected_points[i2]
		var v3 : Vector3 = selected_points[i3]
	
		var flip : bool = is_normal_similar(v0, v1, v2, last_known_camera_facing)
		
		var normal : Vector3 = get_face_normal(v0, v1, v2, flip)

		st.add_uv(Vector2(0, 1))
		st.add_normal(normal)
		st.add_vertex(v0)
		st.add_uv(Vector2(0.5, 0))
		st.add_normal(normal)
		st.add_vertex(v1)
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(v2)
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(v3)
		
		var im3 : int = i

		if !flip:
			st.add_index(im3 + 0)
			st.add_index(im3 + 1)
			st.add_index(im3 + 2)
			
			st.add_index(im3 + 0)
			st.add_index(im3 + 2)
			st.add_index(im3 + 3)
		else:
			st.add_index(im3 + 3)
			st.add_index(im3 + 2)
			st.add_index(im3 + 0)
			
			st.add_index(im3 + 2)
			st.add_index(im3 + 1)
			st.add_index(im3 + 0)
	
	merge_in_surface_tool(mdr, st)
	
	return true

static func add_triangulated_mesh_from_points(mdr : MeshDataResource, selected_points : PoolVector3Array, last_known_camera_facing : Vector3) -> void:
	if selected_points.size() < 3:
		return
	
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var v0 : Vector3 = selected_points[0]
	var v1 : Vector3 = selected_points[1]

	for i in range(2, selected_points.size()):
		var v2 : Vector3 = selected_points[i]
	
		var flip : bool = is_normal_similar(v0, v1, v2, last_known_camera_facing)
		
		var normal : Vector3 = get_face_normal(v0, v1, v2, flip)

		st.add_uv(Vector2(0, 1))
		st.add_normal(normal)
		st.add_vertex(v0)
		st.add_uv(Vector2(0.5, 0))
		st.add_normal(normal)
		st.add_vertex(v1)
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(v2)
		
		var im3 : int = (i - 2) * 3

		if !flip:
			st.add_index(im3)
			st.add_index(im3 + 1)
			st.add_index(im3 + 2)
		else:
			st.add_index(im3 + 2)
			st.add_index(im3 + 1)
			st.add_index(im3)
	
	merge_in_surface_tool(mdr, st)

# Appends a triangle to the mesh. It's created from miroring v2 to the ev0, and ev1 edge
static func append_triangle_to_tri_edge(mdr : MeshDataResource, ev0 : Vector3, ev1 : Vector3, v2 : Vector3) -> void:
	var vref : Vector3 = reflect_vertex(ev0, ev1, v2)

	add_triangle_at(mdr, ev1, ev0, vref, false)

static func add_triangle_at(mdr : MeshDataResource, v0 : Vector3, v1 : Vector3, v2 : Vector3, flip : bool = false) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var normal : Vector3 = get_face_normal(v0, v1, v2, flip)

	st.add_uv(Vector2(0, 1))
	st.add_normal(normal)
	st.add_vertex(v0)
	st.add_uv(Vector2(0.5, 0))
	st.add_normal(normal)
	st.add_vertex(v1)
	st.add_uv(Vector2(1, 1))
	st.add_normal(normal)
	st.add_vertex(v2)

	if !flip:
		st.add_index(0)
		st.add_index(1)
		st.add_index(2)
	else:
		st.add_index(2)
		st.add_index(1)
		st.add_index(0)

	merge_in_surface_tool(mdr, st)

static func add_triangle(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var normal : Vector3 = get_face_normal(Vector3(-0.5, -0.5, 0), Vector3(0, 0.5, 0), Vector3(0.5, -0.5, 0))
	
	st.add_uv(Vector2(0, 1))
	st.add_normal(normal)
	st.add_vertex(Vector3(-0.5, -0.5, 0))
	st.add_uv(Vector2(0.5, 0))
	st.add_normal(normal)
	st.add_vertex(Vector3(0, 0.5, 0))
	st.add_uv(Vector2(1, 1))
	st.add_normal(normal)
	st.add_vertex(Vector3(0.5, -0.5, 0))
		
	st.add_index(0)
	st.add_index(1)
	st.add_index(2)
	
	merge_in_surface_tool(mdr, st)

# Appends a quad to the mesh. It's created to the opposite side of v2 to the ev0, and ev1 edge
static func append_quad_to_tri_edge(mdr : MeshDataResource, ev0 : Vector3, ev1 : Vector3, v2 : Vector3) -> void:
	var vref : Vector3 = reflect_vertex(ev0, ev1, v2)
	var vproj : Vector3 = (vref - ev0).project(ev1 - ev0)
	var eoffs : Vector3 = (vref - ev0) - vproj
	
	var qv0 : Vector3 = ev0
	var qv1 : Vector3 = ev0 + eoffs
	var qv2 : Vector3 = ev1 + eoffs
	var qv3 : Vector3 = ev1

	add_quad_at(mdr, qv0, qv1, qv2, qv3, false)

static func add_quad_at(mdr : MeshDataResource, v0 : Vector3, v1 : Vector3, v2 : Vector3, v3 : Vector3, flip : bool = false) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var normal : Vector3 = get_face_normal(v0, v1, v2, flip)

	st.add_uv(Vector2(0, 1))
	st.add_normal(normal)
	st.add_vertex(v0)
	st.add_uv(Vector2(0, 0))
	st.add_normal(normal)
	st.add_vertex(v1)
	st.add_uv(Vector2(1, 0))
	st.add_normal(normal)
	st.add_vertex(v2)
	st.add_uv(Vector2(1, 1))
	st.add_normal(normal)
	st.add_vertex(v3)
	

	if !flip:
		st.add_index(0)
		st.add_index(1)
		st.add_index(2)
		
		st.add_index(0)
		st.add_index(2)
		st.add_index(3)
	else:
		st.add_index(2)
		st.add_index(1)
		st.add_index(0)
		
		st.add_index(3)
		st.add_index(2)
		st.add_index(0)

	merge_in_surface_tool(mdr, st)

static func add_quad(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	var normal : Vector3 = get_face_normal(Vector3(-0.5, -0.5, 0), Vector3(-0.5, 0.5, 0), Vector3(0.5, 0.5, 0))
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	st.add_uv(Vector2(0, 1))
	st.add_normal(normal)
	st.add_vertex(Vector3(-0.5, -0.5, 0))
	st.add_uv(Vector2(0, 0))
	st.add_normal(normal)
	st.add_vertex(Vector3(-0.5, 0.5, 0))
	st.add_uv(Vector2(1, 0))
	st.add_normal(normal)
	st.add_vertex(Vector3(0.5, 0.5, 0))
	st.add_uv(Vector2(1, 1))
	st.add_normal(normal)
	st.add_vertex(Vector3(0.5, -0.5, 0))
		
	st.add_index(0)
	st.add_index(1)
	st.add_index(2)
	st.add_index(2)
	st.add_index(3)
	st.add_index(0)

	merge_in_surface_tool(mdr, st)
	
static func add_box(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	var normal : Vector3 = Vector3()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var sgn : float = 1

	#z
	for i in range(2):
		normal = get_face_normal(Vector3(-0.5, -0.5, sgn * 0.5), Vector3(-0.5, 0.5, sgn * 0.5), Vector3(0.5, 0.5, sgn * 0.5), sgn < 0)
		
		st.add_uv(Vector2(0, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(-0.5, -0.5, sgn * 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(-0.5, 0.5, sgn * 0.5))
		st.add_uv(Vector2(1, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(0.5, 0.5, sgn * 0.5))
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(0.5, -0.5, sgn * 0.5))
		
		sgn *= -1
	
	#x
	for i in range(2):
		normal = get_face_normal(Vector3(sgn * 0.5, -0.5, 0.5), Vector3(sgn * 0.5, 0.5, 0.5), Vector3(sgn * 0.5, 0.5, -0.5), sgn < 0)
		
		st.add_uv(Vector2(0, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(sgn * 0.5, -0.5, 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(sgn * 0.5, 0.5, 0.5))
		st.add_uv(Vector2(1, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(sgn * 0.5, 0.5, -0.5))
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(sgn * 0.5, -0.5, -0.5))
		
		sgn *= -1

	#y
	for i in range(2):
		normal = get_face_normal(Vector3(-0.5, sgn * 0.5, 0.5), Vector3(-0.5, sgn * 0.5, -0.5), Vector3(0.5, sgn * 0.5, -0.5), sgn < 0)
		
		st.add_uv(Vector2(0, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(-0.5, sgn * 0.5, 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(-0.5, sgn * 0.5, -0.5))
		st.add_uv(Vector2(1, 0))
		st.add_normal(normal)
		st.add_vertex(Vector3(0.5, sgn * 0.5, -0.5))
		st.add_uv(Vector2(1, 1))
		st.add_normal(normal)
		st.add_vertex(Vector3(0.5, sgn * 0.5, 0.5))
		
		
		sgn *= -1
	
	var ind : int = 0
	
	for i in range(3):
		st.add_index(ind + 0)
		st.add_index(ind + 1)
		st.add_index(ind + 2)
		st.add_index(ind + 2)
		st.add_index(ind + 3)
		st.add_index(ind + 0)
		
		ind += 4
		
		st.add_index(ind + 0)
		st.add_index(ind + 2)
		st.add_index(ind + 1)
		st.add_index(ind + 0)
		st.add_index(ind + 3)
		st.add_index(ind + 2)
		
		ind += 4
	
	merge_in_surface_tool(mdr, st)

static func merge_in_surface_tool(mdr : MeshDataResource, st : SurfaceTool, generate_normals_if_needed : bool = true, generate_tangents_if_needed : bool = true) -> void:
	var arrays : Array = get_arrays_prepared(mdr)
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	if generate_normals_if_needed && arrays[ArrayMesh.ARRAY_NORMAL] == null:
		#st.generate_normals()
		generate_normals_mdr(mdr)
	
	if generate_tangents_if_needed && arrays[ArrayMesh.ARRAY_TANGENT] == null:
		st.generate_tangents()
	
	merge_in_arrays(mdr, st.commit_to_arrays())

static func merge_in_arrays(mdr : MeshDataResource, merge : Array) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	var vertices : PoolVector3Array
	var normals : PoolVector3Array
	var tangents : PoolRealArray
	var colors : PoolColorArray
	var uv : PoolVector2Array
	var uv2 : PoolVector2Array
	var bones : PoolRealArray
	var weights : PoolRealArray
	var indices : PoolIntArray

	if arrays[ArrayMesh.ARRAY_VERTEX] != null:
		vertices = arrays[ArrayMesh.ARRAY_VERTEX]
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		normals = arrays[ArrayMesh.ARRAY_NORMAL]
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		tangents = arrays[ArrayMesh.ARRAY_TANGENT]
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		colors = arrays[ArrayMesh.ARRAY_COLOR]
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		uv = arrays[ArrayMesh.ARRAY_TEX_UV]
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		uv2 = arrays[ArrayMesh.ARRAY_TEX_UV2]
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		bones = arrays[ArrayMesh.ARRAY_BONES]
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		weights = arrays[ArrayMesh.ARRAY_WEIGHTS]
	
	if arrays[ArrayMesh.ARRAY_INDEX] != null:
		indices = arrays[ArrayMesh.ARRAY_INDEX]
	
	var merge_vertices : PoolVector3Array
	var merge_normals : PoolVector3Array
	var merge_tangents : PoolRealArray
	var merge_colors : PoolColorArray
	var merge_uv : PoolVector2Array
	var merge_uv2 : PoolVector2Array
	var merge_bones : PoolRealArray
	var merge_weights : PoolRealArray
	var merge_indices : PoolIntArray

	if merge[ArrayMesh.ARRAY_VERTEX] != null:
		merge_vertices = merge[ArrayMesh.ARRAY_VERTEX]
		
	if merge[ArrayMesh.ARRAY_NORMAL] != null:
		merge_normals = merge[ArrayMesh.ARRAY_NORMAL]
		
	if merge[ArrayMesh.ARRAY_TANGENT] != null:
		merge_tangents = merge[ArrayMesh.ARRAY_TANGENT]
		
	if merge[ArrayMesh.ARRAY_COLOR] != null:
		merge_colors = merge[ArrayMesh.ARRAY_COLOR]
	
	if merge[ArrayMesh.ARRAY_TEX_UV] != null:
		merge_uv = merge[ArrayMesh.ARRAY_TEX_UV]
		
	if merge[ArrayMesh.ARRAY_TEX_UV2] != null:
		merge_uv2 = merge[ArrayMesh.ARRAY_TEX_UV2]
		
	if merge[ArrayMesh.ARRAY_BONES] != null:
		merge_bones = merge[ArrayMesh.ARRAY_BONES]
		
	if merge[ArrayMesh.ARRAY_WEIGHTS] != null:
		merge_weights = merge[ArrayMesh.ARRAY_WEIGHTS]
	
	if merge[ArrayMesh.ARRAY_INDEX] != null:
		merge_indices = merge[ArrayMesh.ARRAY_INDEX]
	
	#merge
	var ovc : int = vertices.size()
	vertices.append_array(merge_vertices)
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		if merge_vertices.size() != merge_normals.size():
			for i in range(merge_vertices.size()):
				normals.append(Vector3())
		else:
			normals.append_array(merge_normals)
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		if merge_vertices.size() != merge_tangents.size() * 4:
			for i in range(merge_vertices.size()):
				merge_tangents.append(0)
				merge_tangents.append(0)
				merge_tangents.append(0)
				merge_tangents.append(0)
		else:
			tangents.append_array(merge_tangents)
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		if merge_vertices.size() != merge_colors.size():
			for i in range(merge_vertices.size()):
				colors.append(Color())
		else:
			colors.append_array(merge_colors)

	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		if merge_vertices.size() != merge_uv.size():
			for i in range(merge_vertices.size()):
				uv.append(Vector2())
		else:
			uv.append_array(merge_uv)

	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		if merge_vertices.size() != merge_uv2.size():
			for i in range(merge_vertices.size()):
				uv2.append(Vector2())
		else:
			uv2.append_array(merge_uv2)

	if arrays[ArrayMesh.ARRAY_BONES] != null:
		if merge_vertices.size() != merge_bones.size() * 4:
			for i in range(merge_vertices.size()):
				bones.append(0)
				bones.append(0)
				bones.append(0)
				bones.append(0)
		else:
			bones.append_array(merge_bones)

	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		if merge_vertices.size() != merge_weights.size() * 4:
			for i in range(merge_vertices.size()):
				weights.append(0)
				weights.append(0)
				weights.append(0)
				weights.append(0)
		else:
			weights.append_array(merge_weights)

	for i in range(merge_indices.size()):
		merge_indices[i] += ovc
		
	indices.append_array(merge_indices)
	
	#write back
	
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		arrays[ArrayMesh.ARRAY_NORMAL] = normals
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		arrays[ArrayMesh.ARRAY_TANGENT] = tangents
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		arrays[ArrayMesh.ARRAY_COLOR] = colors
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV] = uv
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV2] = uv2
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		arrays[ArrayMesh.ARRAY_BONES] = bones
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		arrays[ArrayMesh.ARRAY_WEIGHTS] = weights

	arrays[ArrayMesh.ARRAY_INDEX] = indices
	
	mdr.set_array(arrays)

static func get_arrays_prepared(mdr : MeshDataResource) -> Array:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
		arrays[ArrayMesh.ARRAY_VERTEX] = PoolVector3Array()
		arrays[ArrayMesh.ARRAY_NORMAL] = PoolVector3Array()
		arrays[ArrayMesh.ARRAY_TEX_UV] = PoolVector2Array()
		arrays[ArrayMesh.ARRAY_INDEX] = PoolIntArray()
		
	return arrays

# There are probably better ways to do this
static func should_flip_reflected_triangle(v0 : Vector3, v1 : Vector3, v2 : Vector3) -> bool:
	var reflected : Vector3 = reflect_vertex(v0, v1, v2)
	var nn : Vector3 = get_face_normal(v0, v1, v2)

	return should_triangle_flip(v0, v1, reflected, nn)

static func reflect_vertex(v0 : Vector3, v1 : Vector3, v2 : Vector3) -> Vector3:
	return (v2 - v0).reflect((v1 - v0).normalized()) + v0

static func get_face_normal_arr_ti(verts : PoolVector3Array, indices : PoolIntArray, triangle_index : int, flipped : bool = false) -> Vector3:
	return get_face_normal_arr(verts, indices, triangle_index * 3, flipped)

static func get_face_normal_arr(verts : PoolVector3Array, indices : PoolIntArray, index : int, flipped : bool = false) -> Vector3:
	var v0 : Vector3 = verts[indices[index]]
	var v1 : Vector3 = verts[indices[index + 1]]
	var v2 : Vector3 = verts[indices[index + 2]]
	
	return get_face_normal(v0, v1, v2, flipped)

static func get_face_normal(v0 : Vector3, v1 : Vector3, v2 : Vector3, flipped : bool = false) -> Vector3:
	if !flipped:
		return Plane(v0, v1, v2).normal
	else:
		return Plane(v2, v1, v0).normal

static func should_triangle_flip(v0 : Vector3, v1 : Vector3, v2 : Vector3, similar_dir_normal : Vector3) -> bool:
	var normal : Vector3 = get_face_normal(v0, v1, v2)
	
	var ndns : float = normal.dot(similar_dir_normal)
	
	return ndns < 0

static func is_normal_similar(v0 : Vector3, v1 : Vector3, v2 : Vector3, similar_dir_normal : Vector3) -> bool:
	var normal : Vector3  = get_face_normal(v0, v1, v2)
	
	var ndns : float = normal.dot(similar_dir_normal)
	
	return ndns >= 0

static func is_direction_similar(d0 : Vector3, d1 : Vector3) -> bool:
	var ndns : float = d0.dot(d1)
	return ndns >= 0

static func flip_triangle_ti(mdr : MeshDataResource, triangle_index : int) -> void:
	flip_triangle(mdr, triangle_index * 3)

static func flip_triangle(mdr : MeshDataResource, index : int) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]

	var i0 : int = indices[index]
	var i2 : int = indices[index + 2]
	
	indices[index] = i2
	indices[index + 2] = i0

	arrays[ArrayMesh.ARRAY_INDEX] = indices
	
	mdr.set_array(arrays)

static func add_into_surface_tool(mdr : MeshDataResource, st : SurfaceTool) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	var vertices : PoolVector3Array
	var normals : PoolVector3Array
	var tangents : PoolRealArray
	var colors : PoolColorArray
	var uv : PoolVector2Array
	var uv2 : PoolVector2Array
	var bones : PoolRealArray
	var weights : PoolRealArray
	var indices : PoolIntArray

	if arrays[ArrayMesh.ARRAY_VERTEX] != null:
		vertices = arrays[ArrayMesh.ARRAY_VERTEX]
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		normals = arrays[ArrayMesh.ARRAY_NORMAL]
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		tangents = arrays[ArrayMesh.ARRAY_TANGENT]
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		colors = arrays[ArrayMesh.ARRAY_COLOR]
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		uv = arrays[ArrayMesh.ARRAY_TEX_UV]
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		uv2 = arrays[ArrayMesh.ARRAY_TEX_UV2]
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		bones = arrays[ArrayMesh.ARRAY_BONES]
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		weights = arrays[ArrayMesh.ARRAY_WEIGHTS]
	
	if arrays[ArrayMesh.ARRAY_INDEX] != null:
		indices = arrays[ArrayMesh.ARRAY_INDEX]
	
	for i in range(vertices.size()):
		if normals.size() > 0:
			st.add_normal(normals[i])
			
		if tangents.size() > 0:
			var ti : int = i * 4
			st.add_tangent(Plane(tangents[ti], tangents[ti + 1], tangents[ti + 2], tangents[ti + 3]))
		
		if colors.size() > 0:
			st.add_color(colors[i])
			
		if uv.size() > 0:
			st.add_uv(uv[i])
			
		if uv2.size() > 0:
			st.add_uv2(uv2[i])
		
		if bones.size() > 0:
			var bi : int = i * 4
			
			var pia : PoolIntArray = PoolIntArray()
			
			pia.append(bones[bi])
			pia.append(bones[bi + 1])
			pia.append(bones[bi + 1])
			pia.append(bones[bi + 1])
			
			st.add_bones(pia)
		
		if weights.size() > 0:
			var bi : int = i * 4
			
			var pia : PoolIntArray = PoolIntArray()
			
			pia.append(bones[bi])
			pia.append(bones[bi + 1])
			pia.append(bones[bi + 2])
			pia.append(bones[bi + 3])
			
			st.add_weight(pia)
		
		st.add_vertex(vertices[i])

	for ind in indices:
		st.add_index(ind)

static func generate_normals_arrs(arrays : Array) -> Array:
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return arrays
	
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	var normals : PoolVector3Array = PoolVector3Array()
	normals.resize(vertices.size())
	var nc : PoolIntArray = PoolIntArray()
	nc.resize(vertices.size())
	
	for i in range(vertices.size()):
		nc[i] = 0
	
	for i in range(0, indices.size(), 3):
		var i0 : int = indices[i]
		var i1 : int = indices[i + 1]
		var i2 : int = indices[i + 2]
		
		var v0 : Vector3 = vertices[i0]
		var v1 : Vector3 = vertices[i1]
		var v2 : Vector3 = vertices[i2]
		
		var n = Plane(v0, v1, v2).normal
		
		if n.is_equal_approx(Vector3()):
			print("Warning face's normal is zero! " + str(Vector3(i0, i1, i2)))
			n = Vector3(0, 0, 1)
		
		if nc[i0] == 0:
			nc[i0] = 1
			normals[i0] = n
		else:
			normals[i0] = lerp(normals[i0], n, 0.5).normalized()
			
		if nc[i1] == 0:
			nc[i1] = 1
			normals[i1] = n
		else:
			normals[i1] = lerp(normals[i1], n, 0.5).normalized()
			
		if nc[i2] == 0:
			nc[i2] = 1
			normals[i2] = n
		else:
			normals[i2] = lerp(normals[i2], n, 0.5).normalized()
	
	arrays[ArrayMesh.ARRAY_NORMAL] = normals

	return arrays
	

static func generate_normals_mdr(mdr : MeshDataResource) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	var normals : PoolVector3Array = PoolVector3Array()
	normals.resize(vertices.size())
	var nc : PoolIntArray = PoolIntArray()
	nc.resize(vertices.size())
	
	for i in range(vertices.size()):
		nc[i] = 0
	
	for i in range(0, indices.size(), 3):
		var i0 : int = indices[i]
		var i1 : int = indices[i + 1]
		var i2 : int = indices[i + 2]
		
		var v0 : Vector3 = vertices[i0]
		var v1 : Vector3 = vertices[i1]
		var v2 : Vector3 = vertices[i2]
		
		var n = Plane(v0, v1, v2).normal
		
		if n.is_equal_approx(Vector3()):
			print("Warning face's normal is zero! " + str(Vector3(i0, i1, i2)))
			n = Vector3(0, 0, 1)
		
		if nc[i0] == 0:
			nc[i0] = 1
			normals[i0] = n
		else:
			normals[i0] = lerp(normals[i0], n, 0.5).normalized()
			
		if nc[i1] == 0:
			nc[i1] = 1
			normals[i1] = n
		else:
			normals[i1] = lerp(normals[i1], n, 0.5).normalized()
			
		if nc[i2] == 0:
			nc[i2] = 1
			normals[i2] = n
		else:
			normals[i2] = lerp(normals[i2], n, 0.5).normalized()
			
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	mdr.array = arrays
	
# Apparently surfacetool adds more verts during normal generation
# Keeping this here for now
static func generate_normals_surface_tool(mdr : MeshDataResource) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var st : SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	add_into_surface_tool(mdr, st)
	
	st.generate_normals()
	
	mdr.array = st.commit_to_arrays()

static func generate_tangents(mdr : MeshDataResource) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return
		
	var st : SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	add_into_surface_tool(mdr, st)
	
	st.generate_tangents()
	
	mdr.array = st.commit_to_arrays()

static func remove_used_vertices(arrays : Array) -> Array:
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return arrays
	
	if arrays[ArrayMesh.ARRAY_VERTEX] == null || arrays[ArrayMesh.ARRAY_INDEX] == null:
		return arrays
	
	var vert_size : int = arrays[ArrayMesh.ARRAY_VERTEX].size()
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	var unused_indices : PoolIntArray = PoolIntArray()
	
	for i in range(vert_size):
		if !pool_int_arr_contains(indices, i):
			unused_indices.append(i)
	
	remove_vertices(arrays, unused_indices)
	
	return arrays
	

static func remove_vertices(arrays : Array, indices : PoolIntArray) -> Array:
	if indices.size() == 0:
		return arrays
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	
	var normals : PoolVector3Array
	var tangents : PoolRealArray
	var colors : PoolColorArray
	var uv : PoolVector2Array
	var uv2 : PoolVector2Array
	var bones : PoolRealArray
	var weights : PoolRealArray

	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		normals = arrays[ArrayMesh.ARRAY_NORMAL]
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		tangents = arrays[ArrayMesh.ARRAY_TANGENT]
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		colors = arrays[ArrayMesh.ARRAY_COLOR]
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		uv = arrays[ArrayMesh.ARRAY_TEX_UV]
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		uv2 = arrays[ArrayMesh.ARRAY_TEX_UV2]
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		bones = arrays[ArrayMesh.ARRAY_BONES]
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		weights = arrays[ArrayMesh.ARRAY_WEIGHTS]
	
	for index in indices:
		vertices.remove(index)
		
		if arrays[ArrayMesh.ARRAY_NORMAL] != null:
			normals.remove(index)
			
		if arrays[ArrayMesh.ARRAY_TANGENT] != null:
			var tindex : int = index * 4
			
			tangents.remove(tindex)
			tangents.remove(tindex)
			tangents.remove(tindex)
			tangents.remove(tindex)
			
		if arrays[ArrayMesh.ARRAY_COLOR] != null:
			colors.remove(index)

		if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
			uv.remove(index)

		if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
			uv2.remove(index)

		if arrays[ArrayMesh.ARRAY_BONES] != null:
			bones.remove(index)
			bones.remove(index)
			bones.remove(index)
			bones.remove(index)

		if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
			weights.remove(index)
			weights.remove(index)
			weights.remove(index)
			weights.remove(index)

	#write back
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		arrays[ArrayMesh.ARRAY_NORMAL] = normals
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		arrays[ArrayMesh.ARRAY_TANGENT] = tangents
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		arrays[ArrayMesh.ARRAY_COLOR] = colors
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV] = uv
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV2] = uv2
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		arrays[ArrayMesh.ARRAY_BONES] = bones
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		arrays[ArrayMesh.ARRAY_WEIGHTS] = weights
	
	if arrays[ArrayMesh.ARRAY_INDEX] == null:
		return arrays
	
	#udpate indices
	var arr_indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	
	var max_index : int = find_max(indices)
		
	for k in range(indices.size()):
		for i in range(arr_indices.size()):
			var ai : int = arr_indices[i]
			
			if ai >= max_index:
				arr_indices[i] = ai - 1
				
		max_index = find_max_capped(indices, max_index)
	
	arrays[ArrayMesh.ARRAY_INDEX] = arr_indices
	
	return arrays

static func find_max(arr : PoolIntArray) -> int:
	var m : int = arr[0]
	
	for v in arr:
		if v > m:
			m = v
			
	return m

static func find_max_capped(arr : PoolIntArray, last : int) -> int:
	var m : int = 0
	
	for v in arr:
		if v < last:
			m = v
			break
	
	for v in arr:
		if v > m && v < last:
			m = v
			
	return m

static func order_seam_indices(arr : PoolIntArray) -> PoolIntArray:
	var ret : PoolIntArray = PoolIntArray()
	
	if arr.size() == 0:
		return ret
	
	for i in range(0, arr.size(), 2):
		var index0 : int = arr[i]
		var index1 : int = arr[i + 1]
		
		if index0 > index1:
			var t : int = index1
			index1 = index0
			index0 = t
		
		ret.push_back(index0)
		ret.push_back(index1)
	
	return ret 

static func add_seam_not_ordered(mdr : MeshDataResource, index0 : int, index1 : int) -> void:
	if index0 > index1:
		add_seam(mdr, index1, index0)
	else:
		add_seam(mdr, index0, index1)

static func remove_seam_not_ordered(mdr : MeshDataResource, index0 : int, index1 : int) -> void:
	if index0 > index1:
		remove_seam(mdr, index1, index0)
	else:
		remove_seam(mdr, index0, index1)

static func has_seam(mdr : MeshDataResource, index0 : int, index1 : int) -> bool:
	var seams : PoolIntArray = mdr.seams
	
	for i in range(0, seams.size(), 2):
		if seams[i] == index0 && seams[i + 1] == index1:
			return true
	
	return false

static func add_seam(mdr : MeshDataResource, index0 : int, index1 : int) -> void:
	if has_seam(mdr, index0, index1):
		return
		
	var seams : PoolIntArray = mdr.seams
	seams.push_back(index0)
	seams.push_back(index1)
	mdr.seams = seams

static func remove_seam(mdr : MeshDataResource, index0 : int, index1 : int) -> void:
	if !has_seam(mdr, index0, index1):
		return
		
	var seams : PoolIntArray = mdr.seams
	
	for i in range(0, seams.size(), 2):
		if seams[i] == index0 && seams[i + 1] == index1:
			seams.remove(i)
			seams.remove(i)
			mdr.seams = seams
			return

static func is_verts_equal(v0 : Vector3, v1 : Vector3) -> bool:
	return is_equal_approx(v0.x, v1.x) && is_equal_approx(v0.y, v1.y) && is_equal_approx(v0.z, v1.z)


static func points_to_seams(mdr : MeshDataResource, points : PoolVector3Array) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_VERTEX] == null:
		return
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	var seams : PoolIntArray = PoolIntArray()
	
	for i in range(0, points.size(), 2):
		var p0 : Vector3 = points[i]
		var p1 : Vector3 = points[i + 1]
		
		for j in range(0, indices.size(), 3):
			var v0 : Vector3 = vertices[indices[j]]
			var v1 : Vector3 = vertices[indices[j + 1]]
			var v2 : Vector3 = vertices[indices[j + 2]]
			
			var p0_index : int = -1
			
			if is_verts_equal(p0, v0):
				p0_index = indices[j]
			elif is_verts_equal(p0, v1):
				p0_index = indices[j + 1]
			elif is_verts_equal(p0, v2):
				p0_index = indices[j + 2]
			
			if p0_index == -1:
				continue
			
			var p1_index : int = -1
			
			if is_verts_equal(p1, v0):
				p1_index = indices[j]
			elif is_verts_equal(p1, v1):
				p1_index = indices[j + 1]
			elif is_verts_equal(p1, v2):
				p1_index = indices[j + 2]
			
			if p1_index == -1:
				continue
				
			if p0_index == p1_index:
				continue
				
			if p0_index > p1_index:
				var t : int = p0_index
				p0_index = p1_index
				p1_index = t
				
			seams.push_back(p0_index)
			seams.push_back(p1_index)
			break
			
	mdr.seams = seams

static func seams_to_points(mdr : MeshDataResource) -> PoolVector3Array:
	var points : PoolVector3Array = PoolVector3Array()
	
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return points
		
	if arrays[ArrayMesh.ARRAY_VERTEX] == null:
		return points
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var seams : PoolIntArray = mdr.seams
	
	for s in seams:
		points.push_back(vertices[s])
	
	return points

static func is_matching_seam(i0 : int, i1: int, si0 : int, si1: int) -> bool:
	if i0 > i1:
		var t : int = i0
		i0 = i1
		i1 = t
		
	return (i0 == si0) && (i1 == si1)

static func pool_int_arr_contains(arr : PoolIntArray, val : int) -> bool:
	for a in arr:
		if a == val:
			return true
			
	return false


class SeamTriangleHelper:
	var i0 : int = 0
	var i1 : int = 0
	var i2 : int = 0
	var orig_index : int = 0
	var index_index : int = 0
	
	var side_index_1 : int = 0
	var side_index_2 : int = 0
	var side_index_1_cut : bool = false
	var side_index_2_cut : bool = false
	
	var processed : bool = false
	
	func get_other_side_index(index : int) -> int:
		if side_index_1 == index:
			return side_index_2
		else:
			return side_index_1
	
	func get_side_index(i : int) -> int:
		if i == 1:
			return side_index_1
		else:
			return side_index_2
			
	func get_side_index_cut() -> int:
		if side_index_1_cut && side_index_2_cut:
			return 3
		elif side_index_1_cut:
			return 1
		elif side_index_2_cut:
			return 2
		else:
			return 0
			
	func get_opposite_side_index_cut() -> int:
		if side_index_1_cut && side_index_2_cut:
			return 3
		elif side_index_1_cut:
			return 2
		elif side_index_2_cut:
			return 1
		else:
			return 0
			
	func is_side_index_cut(i : int) -> bool:
		if i == 1:
			return side_index_1_cut
		else:
			return side_index_2_cut
	
	func is_the_same(h : SeamTriangleHelper) -> bool:
		return is_triangle(h.i0, h.i1, h.i2)
	
	func is_triangle(pi0 : int, pi1 : int, pi2 : int) -> bool:
		if pi0 == i0 || pi0 == i1 || pi0 == i2:
			if pi1 == i0 || pi1 == i1 || pi1 == i2:
				if pi2 == i0 || pi2 == i1 || pi2 == i2:
					return true
		
		return false
	
	func is_neighbour_to(index : int) -> bool:
		return (side_index_1 == index) || (side_index_2 == index)
		
	func needs_to_be_cut_near(index : int) -> bool:
		if (side_index_1 == index):
			return side_index_1_cut
			
		if (side_index_2 == index):
			return side_index_2_cut
			
		return false
		
	func has_cut() -> bool:
		return side_index_1_cut || side_index_2_cut
		
	func both_sides_need_cut() -> bool:
		return side_index_1_cut && side_index_2_cut
	
	func setup(pi0 : int, pi1 : int, pi2 : int, porig_ind : int, pindex_index : int, seams : PoolIntArray) -> void:
		processed = false
		i0 = pi0
		i1 = pi1
		i2 = pi2
		orig_index = porig_ind
		index_index = pindex_index
		
		if porig_ind == pi0:
			side_index_1 = pi1
			side_index_2 = pi2
		elif porig_ind == pi1:
			side_index_1 = pi0
			side_index_2 = pi2
		elif porig_ind == pi2:
			side_index_1 = pi1
			side_index_2 = pi0
			
		determine_cuts(seams)
	
	func determine_cuts(seams : PoolIntArray) -> void:
		if orig_index < side_index_1:
			side_index_1_cut = check_cut(orig_index, side_index_1, seams)
		else:
			side_index_1_cut = check_cut(side_index_1, orig_index, seams)
			
		if orig_index < side_index_2:
			side_index_2_cut = check_cut(orig_index, side_index_2, seams)
		else:
			side_index_2_cut = check_cut(side_index_2, orig_index, seams)
		
	func check_cut(ind0 : int, ind1 : int, seams : PoolIntArray) -> bool:
		for stind in range(0, seams.size(), 2):
			var si0 : int = seams[stind]
			var si1 : int = seams[stind + 1]
			
			if (si0 == ind0) && (si1 == ind1):
				return true
				
		return false
		
	func _to_string():
		return "[ TRI: " + str(i0) + ", " + str(i1) + ", " + str(i2) + " ]"

static func apply_seam(mdr : MeshDataResource) -> void:
	var points : PoolVector3Array = PoolVector3Array()
	
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_VERTEX] == null:
		return
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]
	var new_indices : PoolIntArray = PoolIntArray()
	new_indices.append_array(indices)

	var seams : PoolIntArray = mdr.seams
	
	# Duplication happens later, as it requires lots of logic
	var duplicate_verts_indices : PoolIntArray = PoolIntArray()
	var new_vert_size : int = vertices.size()
	
	for i in range(vertices.size()):
		# first check if vertex is a part of at least 2 edge seams
		var test_seam_count : int = 0
		for s in seams:
			if s == i:
				test_seam_count += 1
				
				if test_seam_count >= 2:
					break
				
		if test_seam_count < 2:
			continue
		
		# Collect all triangles that use this vertex as SeamTriangleHelpers
		var triangles : Array = Array()
		for j in range(indices.size()):
			var i0 : int = indices[j]
			
			if i0 != i:
				continue

			var tri_j_offset : int = j % 3
			var tri_start_index : int = j - tri_j_offset

			var i1 : int = indices[tri_start_index + ((tri_j_offset + 1) % 3)]
			var i2 : int = indices[tri_start_index + ((tri_j_offset + 2) % 3)]

			var s : SeamTriangleHelper = SeamTriangleHelper.new()
			s.setup(i0, i1, i2, i0, j, seams)
			triangles.push_back(s)
		
		var triangle_arrays : Array = Array()
		while true:
			# First find a triangle that needs to be cut
			var tri : SeamTriangleHelper = null
			var tri_index : int = -1
			for it in range(triangles.size()):
				tri = triangles[it]
				
				if tri.has_cut() && !tri.processed:
					tri_index = it
					break
					
			if tri_index == -1:
				#done
				break
			
			tri.processed = true

			if tri.both_sides_need_cut():
				triangle_arrays.push_back([ tri ])
				continue
			
			var collected_triangles : Array = Array()
			collected_triangles.push_back(tri)
			
			# Find all neighbours and set them to processed + update the index for them
			#var side_index : int = tri.get_side_index_cut()
			var neighbour_tri : SeamTriangleHelper = tri
			var find_neighbour_for_edge_index : int = tri.get_opposite_side_index_cut()
			var find_neighbour_for_edge : int = neighbour_tri.get_side_index(find_neighbour_for_edge_index)
			var tri_found : bool = true
			while tri_found:
				tri_found = false
				
				for ntri in triangles:
					if ntri.processed:
						continue
						
					if ntri.is_the_same(neighbour_tri):
						continue
						
					if ntri.is_neighbour_to(find_neighbour_for_edge):
						neighbour_tri = ntri
						find_neighbour_for_edge = neighbour_tri.get_other_side_index(find_neighbour_for_edge)

						neighbour_tri.processed = true
						tri_found = true
						collected_triangles.push_back(neighbour_tri)
						
						if neighbour_tri.has_cut():
							# Done with this "strip"
							tri_found = false

						break
						
			triangle_arrays.push_back(collected_triangles)
		
		# triangle_arrays is guaranteed to have at least 2 entries
		# Skip processing the first strip, so we don't create unused verts
		for tind in range(1, triangle_arrays.size()):
			var tris : Array = triangle_arrays[tind]

			duplicate_verts_indices.push_back(tris[0].orig_index)

			for tri in tris:
				new_indices[tri.index_index] = new_vert_size
			
			new_vert_size += 1

	arrays[ArrayMesh.ARRAY_INDEX] = new_indices

	mdr.array = seam_apply_duplicate_vertices(arrays, duplicate_verts_indices)


static func apply_seam_old(mdr : MeshDataResource) -> void:
	var points : PoolVector3Array = PoolVector3Array()
	
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_VERTEX] == null:
		return
	
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX]

	var seams : PoolIntArray = mdr.seams
	
	# Duplication happens later, as it requires lots of logic
	var duplicate_verts_indices : PoolIntArray = PoolIntArray()
	var new_vert_size : int = vertices.size()
	
	for i in range(0, seams.size(), 2):
		var si0 : int = seams[i]
		var si1 : int = seams[i + 1]
		
		var first : bool = true
		for j in range(0, indices.size(), 3):
			var i0 : int = indices[j]
			var i1 : int = indices[j + 1]
			var i2 : int = indices[j + 2]
			
			var edge_int_tri_index : int = -1
			
			if is_matching_seam(i0, i1, si0, si1):
				edge_int_tri_index = 0
			elif is_matching_seam(i1, i2, si0, si1):
				edge_int_tri_index = 1
			elif is_matching_seam(i2, i0, si0, si1):
				edge_int_tri_index = 2
			
			if edge_int_tri_index == -1:
				continue
				
			if first:
				# Only split away the subsequent tris
				first = false
				continue
			
			if edge_int_tri_index == 0:
				duplicate_verts_indices.push_back(i0)
				duplicate_verts_indices.push_back(i1)
				
				indices.push_back(new_vert_size)
				indices.push_back(new_vert_size + 1)
				indices.push_back(i2)
			elif edge_int_tri_index == 1:
				duplicate_verts_indices.push_back(i1)
				duplicate_verts_indices.push_back(i2)
				
				indices.push_back(i0)
				indices.push_back(new_vert_size)
				indices.push_back(new_vert_size + 1)
			elif edge_int_tri_index == 2:
				duplicate_verts_indices.push_back(i0)
				duplicate_verts_indices.push_back(i2)
				
				indices.push_back(new_vert_size)
				indices.push_back(i1)
				indices.push_back(new_vert_size + 1)
			
			indices.remove(j)
			indices.remove(j)
			indices.remove(j)
			j -= 3
			
			new_vert_size += 2
	
	arrays[ArrayMesh.ARRAY_INDEX] = indices
	#mdr.array = arrays
	
	mdr.array = seam_apply_duplicate_vertices(arrays, duplicate_verts_indices)

# This will not touch the indices!
static func seam_apply_duplicate_vertices(arrays : Array, duplicate_verts_indices : PoolIntArray) -> Array:
	var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]
	
	var normals : PoolVector3Array
	var tangents : PoolRealArray
	var colors : PoolColorArray
	var uv : PoolVector2Array
	var uv2 : PoolVector2Array
	var bones : PoolRealArray
	var weights : PoolRealArray

	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		normals = arrays[ArrayMesh.ARRAY_NORMAL]
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		tangents = arrays[ArrayMesh.ARRAY_TANGENT]
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		colors = arrays[ArrayMesh.ARRAY_COLOR]
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		uv = arrays[ArrayMesh.ARRAY_TEX_UV]
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		uv2 = arrays[ArrayMesh.ARRAY_TEX_UV2]
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		bones = arrays[ArrayMesh.ARRAY_BONES]
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		weights = arrays[ArrayMesh.ARRAY_WEIGHTS]
	

	for index in duplicate_verts_indices:
		vertices.push_back(vertices[index])
		
		if arrays[ArrayMesh.ARRAY_NORMAL] != null:
			normals.push_back(normals[index])
			
		if arrays[ArrayMesh.ARRAY_TANGENT] != null:
			tangents.push_back(tangents[index])
			tangents.push_back(tangents[index + 1])
			tangents.push_back(tangents[index + 2])
			tangents.push_back(tangents[index + 3])
			
		if arrays[ArrayMesh.ARRAY_COLOR] != null:
			colors.push_back(colors[index])

		if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
			uv.push_back(uv[index])

		if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
			uv2.push_back(uv2[index])

		if arrays[ArrayMesh.ARRAY_BONES] != null:
			bones.push_back(bones[index])
			bones.push_back(bones[index + 1])
			bones.push_back(bones[index + 2])
			bones.push_back(bones[index + 3])

		if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
			weights.push_back(weights[index])
			weights.push_back(weights[index + 1])
			weights.push_back(weights[index + 2])
			weights.push_back(weights[index + 3])

	#write back
	
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		
	if arrays[ArrayMesh.ARRAY_NORMAL] != null:
		arrays[ArrayMesh.ARRAY_NORMAL] = normals
		
	if arrays[ArrayMesh.ARRAY_TANGENT] != null:
		arrays[ArrayMesh.ARRAY_TANGENT] = tangents
		
	if arrays[ArrayMesh.ARRAY_COLOR] != null:
		arrays[ArrayMesh.ARRAY_COLOR] = colors
	
	if arrays[ArrayMesh.ARRAY_TEX_UV] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV] = uv
		
	if arrays[ArrayMesh.ARRAY_TEX_UV2] != null:
		arrays[ArrayMesh.ARRAY_TEX_UV2] = uv2
		
	if arrays[ArrayMesh.ARRAY_BONES] != null:
		arrays[ArrayMesh.ARRAY_BONES] = bones
		
	if arrays[ArrayMesh.ARRAY_WEIGHTS] != null:
		arrays[ArrayMesh.ARRAY_WEIGHTS] = weights

	return arrays
