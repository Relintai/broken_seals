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
	
	var uvs : PoolVector2Array = MeshUtils.uv_unwrap(mesh)
	
	mesh[ArrayMesh.ARRAY_TEX_UV] = uvs

	mdr.set_array(mesh)
	
	if mdr:
		mdi_ed_gui.set_mesh_data_resource(mdr)
	
	
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
