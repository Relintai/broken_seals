tool
extends Reference

var _mdr : MeshDataResource

var lines : PoolVector3Array

func setup(mdr : MeshDataResource) -> void:
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
	
	var arr : Array = _mdr.array
	
	var vertices : PoolVector3Array = arr[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = arr[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		return

	if indices.size() % 3 == 0:
		for i in range(0, len(indices), 3):
			lines.append(vertices[indices[i]])
			lines.append(vertices[indices[i + 1]])
			
			lines.append(vertices[indices[i + 1]])
			lines.append(vertices[indices[i + 2]])
			
			lines.append(vertices[indices[i + 2]])
			lines.append(vertices[indices[i]])
			
