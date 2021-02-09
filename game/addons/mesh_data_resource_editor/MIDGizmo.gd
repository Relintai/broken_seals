tool
extends EditorSpatialGizmo

var gizmo_size = 3.0

func set_handle(index: int, camera: Camera, point: Vector2):
	#print(index)
	#print(point)
	
	
	
	pass

func redraw():
	#print("MIDGizmo redraw")
		
	clear()
	
	var node : MeshDataInstance = get_spatial_node()
	
	if !node:
		return
		
	var mdr : MeshDataResource = node.mesh_data
	
	if !mdr:
		return
	
	var handles_material : SpatialMaterial = get_plugin().get_material("handles", self)
	
	var handles : PoolVector3Array = mdr.array[ArrayMesh.ARRAY_VERTEX]
	add_handles(handles, handles_material)
	
	var material = get_plugin().get_material("main", self)
	var lines : PoolVector3Array = PoolVector3Array()
	var indices : PoolIntArray = mdr.array[ArrayMesh.ARRAY_INDEX]
	
	if indices.size() % 3 == 0:
		for i in range(0, len(indices), 3):
			lines.append(handles[i])
			lines.append(handles[i + 1])
			
			lines.append(handles[i + 1])
			lines.append(handles[i + 2])
			
			lines.append(handles[i + 2])
			lines.append(handles[i])
			
		
	
	add_lines(lines, material, false)

