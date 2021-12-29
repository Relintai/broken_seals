tool
extends Object

static func add_box(mdr : MeshDataResource) -> void:
	var arrays : Array = mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		arrays.resize(ArrayMesh.ARRAY_MAX)
		
		arrays[ArrayMesh.ARRAY_VERTEX] = PoolVector3Array()
		arrays[ArrayMesh.ARRAY_NORMAL] = PoolVector3Array()
		arrays[ArrayMesh.ARRAY_TEX_UV] = PoolVector2Array()
		arrays[ArrayMesh.ARRAY_INDEX] = PoolIntArray()

	
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
	var arrays : Array = mdr.get_array()
	
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
