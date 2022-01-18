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
	indices.remove(i)
	indices.remove(i)
	indices.remove(i)

	arrays[ArrayMesh.ARRAY_INDEX] = indices
	
	mdr.set_array(arrays)

static func add_triangulated_mesh_from_points(mdr : MeshDataResource, selected_points : PoolVector3Array, last_known_camera_facing : Vector3) -> void:
	if selected_points.size() < 3:
		return
	
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var v0 : Vector3 = selected_points[0]
	var v1 : Vector3 = selected_points[1]

	for i in range(2, selected_points.size()):
		var v2 : Vector3 = selected_points[i]
		
		st.add_uv(Vector2(0, 1))
		st.add_vertex(v0)
		st.add_uv(Vector2(0.5, 0))
		st.add_vertex(v1)
		st.add_uv(Vector2(1, 1))
		st.add_vertex(v2)
		
		var flip : bool = is_normal_similar(v0, v1, v2, last_known_camera_facing)

		var im3 : int = (i - 2) * 3

		if !flip:
			st.add_index(im3)
			st.add_index(im3 + 1)
			st.add_index(im3 + 2)
		else:
			st.add_index(im3 + 2)
			st.add_index(im3 + 1)
			st.add_index(im3)

	st.generate_normals()
	
	merge_in_surface_tool(mdr, st)

# Appends a triangle to the mesh. It's created from miroring v2 to the ev0, and ev1 edge
static func append_triangle_to_tri_edge(mdr : MeshDataResource, ev0 : Vector3, ev1 : Vector3, v2 : Vector3) -> void:
	var vref : Vector3 = reflect_vertex(ev0, ev1, v2)

	add_triangle_at(mdr, ev1, ev0, vref, false)

static func add_triangle_at(mdr : MeshDataResource, v0 : Vector3, v1 : Vector3, v2 : Vector3, flip : bool = false) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	st.add_uv(Vector2(0, 1))
	st.add_vertex(v0)
	st.add_uv(Vector2(0.5, 0))
	st.add_vertex(v1)
	st.add_uv(Vector2(1, 1))
	st.add_vertex(v2)

	if !flip:
		st.add_index(0)
		st.add_index(1)
		st.add_index(2)
	else:
		st.add_index(2)
		st.add_index(1)
		st.add_index(0)

	st.generate_normals()
	
	merge_in_surface_tool(mdr, st)

static func add_triangle(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-0.5, -0.5, 0))
	st.add_uv(Vector2(0.5, 0))
	st.add_vertex(Vector3(0, 0.5, 0))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0.5, -0.5, 0))
		
	st.add_index(0)
	st.add_index(1)
	st.add_index(2)

	st.generate_normals()
	
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

	st.add_uv(Vector2(0, 1))
	st.add_vertex(v0)
	st.add_uv(Vector2(0, 0))
	st.add_vertex(v1)
	st.add_uv(Vector2(1, 0))
	st.add_vertex(v2)
	st.add_uv(Vector2(1, 1))
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

	st.generate_normals()
	
	merge_in_surface_tool(mdr, st)

static func add_quad(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-0.5, -0.5, 0))
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-0.5, 0.5, 0))
	st.add_uv(Vector2(1, 0))
	st.add_vertex(Vector3(0.5, 0.5, 0))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0.5, -0.5, 0))
		
	st.add_index(0)
	st.add_index(1)
	st.add_index(2)
	st.add_index(2)
	st.add_index(3)
	st.add_index(0)

	st.generate_normals()
	
	merge_in_surface_tool(mdr, st)
	
static func add_box(mdr : MeshDataResource) -> void:
	var st : SurfaceTool = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var sgn : float = 1

	#z
	for i in range(2):
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-0.5, -0.5, sgn * 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-0.5, 0.5, sgn * 0.5))
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(0.5, 0.5, sgn * 0.5))
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(0.5, -0.5, sgn * 0.5))
		
		sgn *= -1
	
	#x
	for i in range(2):
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(sgn * 0.5, -0.5, 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(sgn * 0.5, 0.5, 0.5))
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(sgn * 0.5, 0.5, -0.5))
		st.add_uv(Vector2(1, 1))
		st.add_vertex(Vector3(sgn * 0.5, -0.5, -0.5))
		
		sgn *= -1

	#y
	for i in range(2):
		st.add_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-0.5, sgn * 0.5, 0.5))
		st.add_uv(Vector2(0, 0))
		st.add_vertex(Vector3(-0.5, sgn * 0.5, -0.5))
		st.add_uv(Vector2(1, 0))
		st.add_vertex(Vector3(0.5, sgn * 0.5, -0.5))
		st.add_uv(Vector2(1, 1))
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
	
	st.generate_normals()
	
	merge_in_surface_tool(mdr, st)

static func merge_in_surface_tool(mdr : MeshDataResource, st : SurfaceTool, generate_normals_if_needed : bool = true, generate_tangents_if_needed : bool = true) -> void:
	var arrays : Array = get_arrays_prepared(mdr)
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
	
	if generate_normals_if_needed && arrays[ArrayMesh.ARRAY_NORMAL] == null:
		st.generate_normals()
	
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
			for i in range(merge_colors.size()):
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


static func generate_normals(mdr : MeshDataResource) -> void:
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