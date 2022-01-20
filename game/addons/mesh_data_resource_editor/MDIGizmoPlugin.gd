tool
extends EditorSpatialGizmoPlugin

const MDIGizmo = preload("res://addons/mesh_data_resource_editor/MIDGizmo.gd")

var plugin

func _init():
	create_material("main", Color(0.7, 0.7, 0.7))
	create_material("seam", Color(1, 0, 0), false, true)
	create_handle_material("handles")

func get_name():
	return "MDIGizmo"

func get_priority():
	return 100

func create_gizmo(spatial):
	if spatial is MeshDataInstance:
		var gizmo = MDIGizmo.new()
		
		gizmo.set_editor_plugin(plugin)
		gizmo.set_spatial_node(spatial)
		gizmo.setup()
		plugin.register_gizmo(gizmo)
		
		return gizmo
	else:
		return null

func is_handle_highlighted(gizmo, index):
	pass
