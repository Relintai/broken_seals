tool
extends EditorPlugin

const BoneDock = preload( "BoneDock.tscn" )

var bone_dock_instance
var bone_editor

func _enter_tree( ):
	self.bone_dock_instance = BoneDock.instance( )
	self.add_control_to_container( CONTAINER_SPATIAL_EDITOR_MENU, self.bone_dock_instance )
	self.add_custom_type( "BoneEditor", "Spatial", preload("BoneEditor.gd"), preload("icon.png") )

func _exit_tree( ):
	self.remove_custom_type( "BoneEditor" )
	self.remove_control_from_container( CONTAINER_SPATIAL_EDITOR_MENU, self.bone_dock_instance )
	self.bone_dock_instance.queue_free( )

func handles( obj ):
	if obj is preload("BoneEditor.gd"):
		self.bone_editor = obj
		if self.bone_dock_instance != null:
			self.bone_dock_instance.bone_editor = obj
			self.bone_dock_instance.visible = true
		return true
	elif obj is preload("BoneHandle.gd"):
		self.bone_editor = obj.bone_editor
		if self.bone_dock_instance != null:
			self.bone_dock_instance.bone_editor = obj.bone_editor
			self.bone_dock_instance.visible = true
		return true

	self.bone_editor = null
	if self.bone_dock_instance != null:
		self.bone_dock_instance.bone_editor = null
		self.bone_dock_instance.visible = false

	return false

func get_plugin_name( ):
	return "Bone Editor"
