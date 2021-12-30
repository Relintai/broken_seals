tool
extends Reference

var _mdr : MeshDataResource

var lines : PoolVector3Array

func setup(mdr : MeshDataResource) -> void:
	lines.resize(0)
	
	_mdr = mdr

	refresh()

func refresh():
	lines.resize(0)

	if !_mdr:
		return
	
	if _mdr.array.size() != ArrayMesh.ARRAY_MAX:
		return
	
	if _mdr.array[ArrayMesh.ARRAY_VERTEX] == null || _mdr.array[ArrayMesh.ARRAY_INDEX] == null:
		return
	
	var vertices : PoolVector3Array = _mdr.array[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = _mdr.array[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		vertices = _mdr.array[ArrayMesh.ARRAY_VERTEX]

	if indices.size() % 3 == 0:
		for i in range(0, len(indices), 3):
			lines.append(vertices[indices[i]])
			lines.append(vertices[indices[i + 1]])
			
			lines.append(vertices[indices[i + 1]])
			lines.append(vertices[indices[i + 2]])
			
			lines.append(vertices[indices[i + 2]])
			lines.append(vertices[indices[i]])
			
