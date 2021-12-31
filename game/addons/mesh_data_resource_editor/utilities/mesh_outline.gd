tool
extends Reference

var _mdr : MeshDataResource

var lines : PoolVector3Array

func setup(mdr : MeshDataResource) -> void:
	_mdr = mdr

func generate():
	lines.resize(0)

	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX:
		return
	
	if _mdr.array[ArrayMesh.ARRAY_VERTEX] == null || _mdr.array[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var arr : Array = _mdr.array
	
	var vertices : PoolVector3Array = arr[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arr[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		return

	if indices.size() % 3 == 0:
		for i in range(0, indices.size(), 3):
			for j in range(3):
				lines.append(vertices[indices[i + j]])
				lines.append(vertices[indices[i + ((j + 1) % 3)]])
			
func generate_mark_edges():
	lines.resize(0)

	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX:
		return
	
	if _mdr.array[ArrayMesh.ARRAY_VERTEX] == null || _mdr.array[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var arr : Array = _mdr.array
	
	var vertices : PoolVector3Array = arr[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arr[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		return

	if indices.size() % 3 == 0:
		for i in range(0, indices.size(), 3):
			for j in range(3):
				var i0 : int = indices[i + j]
				var i1 : int = indices[i + ((j + 1) % 3)]
				
				var v0 : Vector3 = vertices[i0]
				var v1 : Vector3 = vertices[i1]
				
				lines.append(v0)
				lines.append(v1)
				
				var pmid : Vector3 = lerp(v0, v1, 0.5)
				var l : float = (v0 - v1).length() / 20.0
				
				lines.append(pmid + Vector3(l, 0, 0))
				lines.append(pmid + Vector3(-l, 0, 0))
				lines.append(pmid + Vector3(0, 0, l))
				lines.append(pmid + Vector3(0, 0, -l))
				lines.append(pmid + Vector3(0, l, 0))
				lines.append(pmid + Vector3(0, -l, 0))

func generate_mark_faces():
	lines.resize(0)

	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX:
		return
	
	if _mdr.array[ArrayMesh.ARRAY_VERTEX] == null || _mdr.array[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var arr : Array = _mdr.array
	
	var vertices : PoolVector3Array = arr[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arr[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		return

	if indices.size() % 3 != 0:
		return
		
	for i in range(0, indices.size(), 3):
		for j in range(3):
			lines.append(vertices[indices[i + j]])
			lines.append(vertices[indices[i + ((j + 1) % 3)]])

	for i in range(0, indices.size(), 3):
			var i0 : int = indices[i + 0]
			var i1 : int = indices[i + 1]
			var i2 : int = indices[i + 2]
				
			var v0 : Vector3 = vertices[i0]
			var v1 : Vector3 = vertices[i1]
			var v2 : Vector3 = vertices[i2]

			var pmid : Vector3 = v0 + v1 + v2
			pmid /= 3
			var l : float = (v0 - v1).length() / 20.0
				
			lines.append(pmid + Vector3(l, 0, 0))
			lines.append(pmid + Vector3(-l, 0, 0))
			lines.append(pmid + Vector3(0, 0, l))
			lines.append(pmid + Vector3(0, 0, -l))
			lines.append(pmid + Vector3(0, l, 0))
			lines.append(pmid + Vector3(0, -l, 0))
