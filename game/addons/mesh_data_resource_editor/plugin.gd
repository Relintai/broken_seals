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
		#m.print()
		m.unwrap()
		
	
	
	
	
class STriangle:
	var i1 : int = 0
	var i2 : int = 0
	var i3 : int = 0
	
	var index : int = 0
	
	var v1 : Vector3
	var v2 : Vector3
	var v3 : Vector3
	
	var vn1 : Vector3
	var vn2 : Vector3
	var vn3 : Vector3
	
	var uv1 : Vector2
	var uv2 : Vector2
	var uv3 : Vector2
	
	var n1 : Vector3
	var n2 : Vector3
	var n3 : Vector3
	
	var neighbour_v1_v2 : int = -1
	var neighbour_v2_v3 : int = -1
	var neighbour_v1_v3 : int = -1
	
	var face_normal : Vector3
	var basis : Basis
	
	func set_indices(pi1 : int, pi2 : int, pi3 : int, pindex : int):
		i1 = pi1
		i2 = pi2
		i3 = pi3
		index = pindex
		
	func set_vertices(pv1 : Vector3, pv2 : Vector3, pv3 : Vector3):
		v1 = pv1
		v2 = pv2
		v3 = pv3
		
	#for debugging
	func set_normals(pn1 : Vector3, pn2 : Vector3, pn3 : Vector3):
		n1 = pn1
		n2 = pn2
		n3 = pn3
		
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
		
	func project_vertices() -> void:
		vn3 = v3 - v2
		vn1 = v1 - v2
		vn2 = Vector3() #v2 - v2
		
		face_normal = vn1.cross(vn3).normalized()
		
		# face normal has to end up the y coordinate in the world coordinate system a.k.a 0 1 0 
		# then triangle is in x, z plane
		
		basis = Basis(vn1.normalized(), face_normal, vn3.normalized())
		basis = basis.orthonormalized()
		
		vn1 = basis.xform_inv(vn1)
		vn2 = basis.xform_inv(vn2)
		vn3 = basis.xform_inv(vn3)
		
		#these are not real uvs yet, just projections of the vertices to a 2d plane (v2 is at the origin)
		#where the plane is parallel to our triangle
		uv1 = Vector2(vn1.x, vn1.z)
		uv2 = Vector2(vn2.x, vn2.z)
		uv3 = Vector2(vn3.x, vn3.z)
	
	func has_edge(pi1 : int, pi2 : int):
		if i1 == pi1 || i2 == pi1 || i3 == pi1:
			if i1 == pi2 || i2 == pi2 || i3 == pi2:
				return true
				
		return false
		
	func print():
		print("[ Tri: " + str(i1) + ", " + str(i2) + ", " + str(i3) + ",  " + str(index) + " ]")
		
	func print_verts():
		print("[ Tri vets: " + str(v1) + ", " + str(v2) + ", " + str(v3) + " ]")
		
	func print_nverts():
		print("[ Tri nvets: " + str(vn1) + ", " + str(vn2) + ", " + str(vn3) + " ]")
		
	func print_uvs():
		print("[ Tri uvs: " + str(uv1) + ", " + str(uv2) + ", " + str(uv3) + " ]")
		
	func print_normals():
		print("[ Tri normals: " + str(n1) + ", " + str(n2) + ", " + str(n3) + " ]")
		
	func print_neighbours():
		print("[ Tri neighbours: " + str(neighbour_v1_v2) + ", " + str(neighbour_v2_v3) + ", " + str(neighbour_v1_v3) + " ]")

	
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
		project_vertices()
		find_neighbours()
		
	func project_vertices():
		for t in triangles:
			t.project_vertices()
		
	func find_neighbours():
		for i in range(triangles.size()):
			var t = triangles[i]
			
			t.neighbour_v1_v2 = find_neighbour(i, t.i1, t.i2)
			t.neighbour_v2_v3 = find_neighbour(i, t.i2, t.i3)
			t.neighbour_v1_v3 = find_neighbour(i, t.i1, t.i3)
		
	func find_neighbour(current_index : int, i1 : int, i2 : int):
		for i in range(triangles.size()):
			if current_index == i:
				continue
				
			if triangles[i].has_edge(i1, i2):
				return i
				
		return -1
		
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
	#for debugging
	var normals : PoolVector3Array = mesh[ArrayMesh.ARRAY_NORMAL]
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
		tri.set_vertices(vertices[indices[iit]], vertices[indices[iit + 1]], vertices[indices[iit + 2]])
		tri.set_normals(normals[indices[iit]], normals[indices[iit + 1]], normals[indices[iit + 2]])
		
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
