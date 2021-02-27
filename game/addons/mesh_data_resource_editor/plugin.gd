tool
extends EditorPlugin

const MdiGizmoPlugin = preload("res://addons/mesh_data_resource_editor/MDIGizmoPlugin.gd")

var gizmo_plugin = MdiGizmoPlugin.new()

var active_gizmos : Array = []

func _enter_tree():
	gizmo_plugin.plugin = self
	
	add_spatial_gizmo_plugin(gizmo_plugin)
	
	set_input_event_forwarding_always_enabled()

func _exit_tree():
	remove_spatial_gizmo_plugin(gizmo_plugin)

#func forward_spatial_gui_input(camera, event):
#	return forward_spatial_gui_input(0, camera, event)

func register_gizmo(gizmo):
	active_gizmos.append(gizmo)
	
func unregister_gizmo(gizmo):
	for i in range(active_gizmos.size()):
		if active_gizmos[i] == gizmo:
			active_gizmos.remove(i)
			return

func forward_spatial_gui_input(index, camera, event):
	for g in active_gizmos:
		if g.forward_spatial_gui_input(index, camera, event):
			return true
	
	return false
