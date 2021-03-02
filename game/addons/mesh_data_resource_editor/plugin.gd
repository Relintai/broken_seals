tool
extends EditorPlugin

const MdiGizmoPlugin = preload("res://addons/mesh_data_resource_editor/MDIGizmoPlugin.gd")
const MDIEdGui = preload("res://addons/mesh_data_resource_editor/MDIEd.tscn")

var gizmo_plugin = MdiGizmoPlugin.new()
var mdi_ed_gui : Control

var active_gizmos : Array

func _enter_tree():
	print("_enter_tree")
	
	gizmo_plugin = MdiGizmoPlugin.new()
	mdi_ed_gui = MDIEdGui.instance()
	active_gizmos = []
	
	gizmo_plugin.plugin = self
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
	mdi_ed_gui.hide()
	
	add_spatial_gizmo_plugin(gizmo_plugin)
	
	set_input_event_forwarding_always_enabled()

func _exit_tree():
	print("_exit_tree")
	
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
	print("disable_plugin")
	
	if object is MeshDataInstance:
		return true
		
	return false
	
func make_visible(visible):
	print("make_visible")
	
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

func forward_spatial_gui_input(camera, event):
	for g in active_gizmos:
		if g.forward_spatial_gui_input(0, camera, event):
			return true
	
	return false

#func forward_spatial_gui_input(index, camera, event):
#	for g in active_gizmos:
#		if g.forward_spatial_gui_input(index, camera, event):
#			return true
#
#	return false
