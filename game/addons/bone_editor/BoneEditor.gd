tool
extends Spatial

export(NodePath) var control_skeleton:NodePath setget set_control_skeleton
export(NodePath) var edit_animation_player:NodePath setget set_edit_animation_player
export(bool) var enabled:bool = true
var skeleton:Skeleton = null
var animation_player:AnimationPlayer = null
var first_call:bool = true
var bone_handle_nodes:Array = []

func _ready( ):
	pass

func set_control_skeleton( path:NodePath ):
	control_skeleton = path

	if self.first_call:
		return

	var node:Node = self.get_node( control_skeleton )
	if node is Skeleton:
		self.skeleton = node
	else:
		self.skeleton = null
		push_error( str(path) + " does not Skeleton!" )

	self._generate_bone_handles( )

func set_edit_animation_player( path:NodePath ):
	edit_animation_player = path

	if self.first_call:
		return

	var node:Node = self.get_node( edit_animation_player )
	if node is AnimationPlayer:
		self.animation_player = node
	else:
		self.animation_player = null
		push_error( str(path) + " does not Animation Player!" )

func _generate_bone_handles( ):
	for child in self.get_children( ):
		self.remove_child( child )

	if self.skeleton == null:
		return

	self.bone_handle_nodes = []
	var bone_handle: = preload( "BoneHandle.tscn" )
	for bone_id in range( self.skeleton.get_bone_count( ) ):
		var bone_name:String = self.skeleton.get_bone_name( bone_id )
		var bone_handle_node:BoneHandle = bone_handle.instance( )

		bone_handle_node.bone_editor = self
		bone_handle_node.name = bone_name
		bone_handle_node.skeleton = self.skeleton
		bone_handle_node.bone_id = bone_id
		bone_handle_node.bone_name = bone_name

		var parent_bone_id:int = self.skeleton.get_bone_parent( bone_id )
		if parent_bone_id == -1:
			self.add_child( bone_handle_node )
		else:
			self.bone_handle_nodes[parent_bone_id].add_child( bone_handle_node )

		if Engine.editor_hint == true:
			var tree:SceneTree = self.get_tree( )
			if tree != null:
				if tree.edited_scene_root != null:
					bone_handle_node.set_owner( tree.edited_scene_root )

		self.bone_handle_nodes.append( bone_handle_node )

func _process( delta:float ):
	if self.first_call:
		self.first_call = false
		self.set_control_skeleton( self.control_skeleton )
		self.set_edit_animation_player( self.edit_animation_player )

	for handle_bone in self.bone_handle_nodes:
		handle_bone.enabled = self.enabled

func init_poses( ):
	for handle_bone in self.bone_handle_nodes:
		handle_bone.init_pose( )

func load_poses( ):
	if self.animation_player == null:
		push_error( "Animation player is null." )
		return

	var assigned_animation:String = self.animation_player.assigned_animation
	var animation:Animation = self.animation_player.get_animation( assigned_animation )

	var time:float = self.animation_player.current_animation_position

	for track_idx in animation.get_track_count( ):
		var target_bone:BoneHandle = null
		for handle_bone in self.bone_handle_nodes:
			var path:NodePath = NodePath( "%s:%s" % [ self.get_node( self.animation_player.root_node ).get_path_to( self.skeleton ), handle_bone.name ] )
			if animation.track_get_path( track_idx ) == path:
				target_bone = handle_bone
				break
		if target_bone == null:
			continue

		var bone:Array = animation.transform_track_interpolate( track_idx, time )
		target_bone.set_pose( Basis( bone[1] ), bone[0] )

func save_poses( ):
	if self.animation_player == null:
		push_error( "Animation player is null." )
		return

	var assigned_animation:String = self.animation_player.assigned_animation
	var animation:Animation = self.animation_player.get_animation( assigned_animation )

	if animation == null:
		push_error( "animation does not selected on Animation player." )
		return

	# 足りないボーンがあれば追加する
	self._add_bone_tracks( animation )
	# ポーズを保存
	self._save_poses_to_animation( animation )

func _add_bone_tracks( animation:Animation ):
	var founded_bone_tracks:Array = []

	for track_idx in animation.get_track_count( ):
		founded_bone_tracks.append( animation.track_get_path( track_idx ) )

	for handle_bone in self.bone_handle_nodes:
		var path:NodePath = NodePath( "%s:%s" % [ self.get_node( self.animation_player.root_node ).get_path_to( self.skeleton ), handle_bone.name ] )
		if founded_bone_tracks.find( path ) == -1:
			var new_track_idx:int = animation.add_track( Animation.TYPE_TRANSFORM )
			animation.track_set_path( new_track_idx, path )
			print( "added new track for ", path )

func _save_poses_to_animation( animation:Animation ):
	var time:float = self.animation_player.current_animation_position

	for track_idx in animation.get_track_count( ):
		var target_bone:BoneHandle = null
		for handle_bone in self.bone_handle_nodes:
			var path:NodePath = NodePath( "%s:%s" % [ self.get_node( self.animation_player.root_node ).get_path_to( self.skeleton ), handle_bone.name ] )
			if animation.track_get_path( track_idx ) == path:
				target_bone = handle_bone
				break
		if target_bone == null:
			continue

		# すでに同じ位置にモノが存在するなら削除する
		for key_idx in animation.track_get_key_count( track_idx ):
			if animation.track_get_key_time( track_idx, key_idx ) == time:
				animation.track_remove_key( track_idx, key_idx )
				break

		animation.transform_track_insert_key(
			track_idx,
			time,
			target_bone.pose.origin,
			target_bone.pose.basis.get_rotation_quat( ),
			target_bone.pose.basis.get_scale( )
		)
		print( "* added new key for ", target_bone.name )
