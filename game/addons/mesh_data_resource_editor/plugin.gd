tool
extends EditorPlugin

const MdiGizmoPlugin = preload("res://addons/mesh_data_resource_editor/MDIGizmoPlugin.gd")

var gizmo_plugin = MdiGizmoPlugin.new()

func _enter_tree():
	add_spatial_gizmo_plugin(gizmo_plugin)

func _exit_tree():
	remove_spatial_gizmo_plugin(gizmo_plugin)
