tool
extends EditorPlugin

const BoneGizmoPlugin = preload("res://addons/gdpose/bonegizmoplugin.gd")
const SkeletonPopup = preload("res://addons/gdpose/SkeletonPopup.tscn")

var skeleton_popup_instance
var bone_gizmo = BoneGizmoPlugin.new()

func get_plugin_name():
	return "GD Pose Plugin"

func _enter_tree():
	# Initialization of the plugin goes here.
	add_spatial_gizmo_plugin(bone_gizmo)
	
	# add our menu
	skeleton_popup_instance = SkeletonPopup.instance()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, skeleton_popup_instance)
	skeleton_popup_instance.visible = false

func _exit_tree():
	remove_spatial_gizmo_plugin(bone_gizmo)
	if skeleton_popup_instance:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, skeleton_popup_instance)
		skeleton_popup_instance.queue_free()
		skeleton_popup_instance = null

func make_visible(visible):
	if skeleton_popup_instance:
		skeleton_popup_instance.visible = visible

func handles(object):
	return object is Skeleton

func edit(object):
	var skeleton : Skeleton = object
	if skeleton_popup_instance:
		skeleton_popup_instance.edit(skeleton)
