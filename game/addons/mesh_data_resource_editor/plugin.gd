tool
extends EditorPlugin

const MdiGizmoPlugin = preload("res://addons/mesh_data_resource_editor/MDIGizmoPlugin.gd")
const MDIEdGui = preload("res://addons/mesh_data_resource_editor/MDIEd.tscn")

var gizmo_plugin = MdiGizmoPlugin.new()
var mdi_ed_gui : Control

var active_gizmos : Array

var current_mesh_data_instance : MeshDataInstance = null

func _enter_tree():
	#print("_enter_tree")
	
	gizmo_plugin = MdiGizmoPlugin.new()
	mdi_ed_gui = MDIEdGui.instance()
	mdi_ed_gui.plugin = self
	active_gizmos = []
	
	gizmo_plugin.plugin = self
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
	mdi_ed_gui.hide()
	
	add_spatial_gizmo_plugin(gizmo_plugin)
	
	set_input_event_forwarding_always_enabled()

func _exit_tree():
	#print("_exit_tree")
	
	remove_spatial_gizmo_plugin(gizmo_plugin)
	#remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
	mdi_ed_gui.queue_free()
	pass
	
#func enable_plugin():
#	print("enable_plugin")
#	pass
#
#func disable_plugin():
#	print("disable_plugin")
#	remove_spatial_gizmo_plugin(gizmo_plugin)
#	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
#	mdi_ed_gui.queue_free()

func handles(object):
	#print("disable_plugin")
	
	if object is MeshDataInstance:
		return true
		
	return false

func edit(object):
	var mdi : MeshDataInstance = object as MeshDataInstance
	
	current_mesh_data_instance = mdi
	
	if mdi:
		mdi_ed_gui.set_mesh_data_resource(mdi.mesh_data)

func make_visible(visible):
	#print("make_visible")
	
	if visible:
		mdi_ed_gui.show()
	else:
		#mdi_ed_gui.hide()
		#figure out how to hide it when something else gets selected, don't hide on unselect
		pass

func get_plugin_name():
	return "mesh_data_resource_editor"
	

#func forward_spatial_gui_input(camera, event):
#	return forward_spatial_gui_input(0, camera, event)

func register_gizmo(gizmo):
	active_gizmos.append(gizmo)
	
func unregister_gizmo(gizmo):
	for i in range(active_gizmos.size()):
		if active_gizmos[i] == gizmo:
			active_gizmos.remove(i)
			return

func set_translate(on : bool) -> void:
	for g in active_gizmos:
		g.set_translate(on)
	
func set_scale(on : bool) -> void:
	for g in active_gizmos:
		g.set_scale(on)
	
func set_rotate(on : bool) -> void:
	for g in active_gizmos:
		g.set_rotate(on)
	
func set_axis_x(on : bool) -> void:
	for g in active_gizmos:
		g.set_axis_x(on)
	
func set_axis_y(on : bool) -> void:
	for g in active_gizmos:
		g.set_axis_y(on)
	
func set_axis_z(on : bool) -> void:
	for g in active_gizmos:
		g.set_axis_z(on)

func uv_unwrap() -> void:
	var mdr : MeshDataResource = null
	
	if current_mesh_data_instance && current_mesh_data_instance.mesh_data:
		#current_mesh_data_instance.mesh_data.uv_unwrap()
		mdr = current_mesh_data_instance.mesh_data
		
	if !mdr:
		return
		
	var mesh : Array = mdr.get_array()
	
	# partition the meshes along the already existing seams (no new vertices)
	var partitioned_meshes : Array = partition_mesh(mesh)
	
	for m in partitioned_meshes:
		m.print()
		#m.unwrap()
		
	
	
	
	
class STriangle:
	var i1 : int = 0
	var i2 : int = 0
	var i3 : int = 0
	var index : int = 0
	
	func set_indices(pi1 : int, pi2 : int, pi3 : int, pindex : int):
		i1 = pi1
		i2 = pi2
		i3 = pi3
		index = pindex
		
	func is_neighbour(pi1 : int, pi2 : int, pi3 : int) -> bool:
		var c : int = 0
		
		if i1 == pi1 || i1 == pi2 || i1 == pi3:
			c += 1
			
		if i2 == pi1 || i2 == pi2 || i2 == pi3:
			c += 1
			
		if i3 == pi1 || i3 == pi2 || i3 == pi3:
			c += 1
			
		if c >= 1:
			return true
		else:
			return false
		
	func print():
		print("[ Tri: " + str(i1) + ", " + str(i2) + ", " + str(i3) + ",  " + str(index) + ", ]")
	
class SMesh:
	var indices : PoolIntArray
	var vertices : PoolVector3Array
	var uvs : PoolVector2Array
	var triangles : Array
	
	func is_triangle_neighbour(tri : STriangle) -> bool:
		for t in triangles:
			if t.is_neighbour(tri.i1, tri.i2, tri.i3):
				return true
		
		return false
		
	func try_to_merge(o : SMesh) -> bool:
		for t in o.triangles:
			if is_triangle_neighbour(t):
				triangles.append_array(o.triangles)
				return true
				
		return false
		
	func unwrap():
		pass
		
	func print():
		print("[ SMesh:")
		
		for t in triangles:
			t.print()
		
		print("]")
		
	
func partition_mesh(mesh : Array) -> Array:
	var meshes : Array = Array()
	
	if mesh.size() != ArrayMesh.ARRAY_MAX:
		return meshes
	
	var vertices : PoolVector3Array = mesh[ArrayMesh.ARRAY_VERTEX]
	var indices : PoolIntArray = mesh[ArrayMesh.ARRAY_INDEX]
	
	if vertices.size() == 0:
		return meshes
		
	if indices.size() == 0:
		return meshes

	var tricount : int = indices.size() / 3
	
	for it in range(tricount):
		var iit : int = it * 3
		
		var tri : STriangle = STriangle.new()
		tri.set_indices(indices[iit], indices[iit + 1], indices[iit + 2], it)
		
		var found : bool = false
		for m in meshes:
			if m.is_triangle_neighbour(tri):
				m.triangles.append(tri)
				found = true
				break
				
		if !found:
			var sm : SMesh = SMesh.new()
			sm.triangles.append(tri)
			
			meshes.append(sm)

	var changed : bool = true
	while changed:
		changed = false
		
		for i in range(meshes.size() - 1):
			if meshes[i].try_to_merge(meshes[i + 1]):
				changed = true
				meshes.remove(i + 1)
				break

	for m in meshes:
		m.vertices = vertices
		m.indices = indices
		m.uvs.resize(vertices.size())

	return meshes

#func forward_spatial_gui_input(camera, event):
#	for g in active_gizmos:
#		if g.forward_spatial_gui_input(0, camera, event):
#			return true
#
#	return false

func forward_spatial_gui_input(index, camera, event):
	for g in active_gizmos:
		if g.forward_spatial_gui_input(index, camera, event):
			return true

	return false
