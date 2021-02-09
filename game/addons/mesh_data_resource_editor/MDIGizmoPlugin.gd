tool
extends EditorSpatialGizmoPlugin

const MDIGizmo = preload("res://addons/mesh_data_resource_editor/MIDGizmo.gd")

func _init():
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")

func get_name():
	return "MDIGizmo"

func get_priority():
	return 100

func create_gizmo(spatial):
	if spatial is MeshDataInstance:
		print("new gizmo")
		return MDIGizmo.new()
	else:
		return null
