tool
extends EditorSpatialGizmoPlugin

const BoneGizmo = preload("res://addons/gdpose/bonegizmo.gd")

func get_name():
	return "BoneGizmo"

func get_priority():
	return 100

func create_gizmo(spatial):
	if spatial is Skeleton:
		return BoneGizmo.new()
	else:
		return null

func _init():
	create_material("skeleton", Color(0.6, 0.6, 0.0))
	create_material("selected", Color(1.0, 1.0, 0.0))
	create_handle_material("handles")

