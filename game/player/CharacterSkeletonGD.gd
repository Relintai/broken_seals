tool
extends CharacterSkeleton3D

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

export(bool) var refresh_in_editor : bool = false setget editor_build
export(bool) var automatic_build : bool = false
export(bool) var use_threads : bool = false

export(NodePath) var mesh_instance_path : NodePath
var mesh_instance : MeshInstance = null

export(NodePath) var skeleton_path : NodePath
var skeleton : Skeleton

export(Material) var material : Material = null
var _material : Material = null

export (NodePath) var left_hand_attach_point_path : NodePath
var left_hand_attach_point : CharacterSkeketonAttachPoint
export (NodePath) var right_hand_attach_point_path : NodePath
var right_hand_attach_point : CharacterSkeketonAttachPoint
export (NodePath) var torso_attach_point_path : NodePath
var torso_attach_point : CharacterSkeketonAttachPoint
export (NodePath) var root_attach_point_path : NodePath
var root_attach_point : CharacterSkeketonAttachPoint

export(Array, ItemVisual) var viss : Array

var _texture_packer : TexturePacker
var _textures : Array
var _texture : Texture

var mesh : ArrayMesh = null
var st : SurfaceTool = null

var _thread_done : bool = false
var _thread : Thread = null

var _editor_built : bool = false

func _ready():
	st = SurfaceTool.new()
	_texture_packer = TexturePacker.new()
#	_texture_packer.texture_flags = 0
	_texture_packer.texture_flags = Texture.FLAG_FILTER
	_texture_packer.max_atlas_size = 512
	
	skeleton = get_node(skeleton_path) as Skeleton
	mesh_instance = get_node(mesh_instance_path) as MeshInstance

	left_hand_attach_point = get_node(left_hand_attach_point_path) as CharacterSkeketonAttachPoint
	right_hand_attach_point = get_node(right_hand_attach_point_path) as CharacterSkeketonAttachPoint
	torso_attach_point = get_node(torso_attach_point_path) as CharacterSkeketonAttachPoint
	root_attach_point = get_node(root_attach_point_path) as CharacterSkeketonAttachPoint
	
	if not OS.can_use_threads():
		use_threads = false

	set_process(false)
			
#	if not Engine.is_editor_hint():
	for iv in viss:
		add_item_visual(iv as ItemVisual)
			
#func _exit_tree():
#	if _thread != null:
#		_thread.wait_to_finish()
		
func _process(delta):
	if use_threads and _thread_done:
		_thread.wait_to_finish()
		_thread = null
		finish_build_mesh()
		set_process(false)
		_thread_done = false
		

func _build_model():
	if Engine.is_editor_hint() and not refresh_in_editor:
		set_process(false)
		return
	
	if not automatic_build:
		set_process(false)
		return
	
	if use_threads:
		build_threaded()
	else:
		build()
		set_process(false)
		
	model_dirty = false
	
func build():
	setup_build_mesh()
	build_mesh("")
	finish_build_mesh()
	
func build_threaded():
	if _thread == null:
		_thread = Thread.new()
	
	setup_build_mesh()
	_thread.start(self, "build_mesh")
	set_process(true)
	
func build_mesh(data) -> void:
	sort_layers()

	prepare_textures()

	st.clear()
	st.set_material(_material)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var vertex_count : int = 0
	
	for bone_idx in range(EntityEnums.SKELETON_POINTS_MAX):
		for j in range(get_model_entry_count(bone_idx)):
			var entry : SkeletonModelEntry = get_model_entry(bone_idx, j)
			
			if entry.entry.get_mesh(gender) != null:
				var bt : Transform = skeleton.get_bone_global_pose(bone_idx)

				var arrays : Array = entry.entry.get_mesh(gender).array
	
				var vertices : PoolVector3Array = arrays[ArrayMesh.ARRAY_VERTEX] as PoolVector3Array
				var normals : PoolVector3Array = arrays[ArrayMesh.ARRAY_NORMAL] as PoolVector3Array
				var uvs : PoolVector2Array = arrays[ArrayMesh.ARRAY_TEX_UV] as PoolVector2Array
				
				var indices : PoolIntArray = arrays[ArrayMesh.ARRAY_INDEX] as PoolIntArray
	
				var bone_array : PoolIntArray = PoolIntArray()
				bone_array.append(bone_idx)
				
				var weights_array : PoolRealArray = PoolRealArray()
				weights_array.append(1.0)
				
				var ta : AtlasTexture = _textures[bone_idx]
				
				var tx : float = 0
				var ty : float = 0
				var tw : float = 1
				var th : float = 1
				
				if ta != null and _texture != null:
					var otw : float = _texture.get_width()
					var oth : float = _texture.get_height()
					
					tx = ta.region.position.x / otw
					ty = ta.region.position.y / oth
					tw = ta.region.size.x / otw
					th = ta.region.size.y / oth
					
				
				for i in range(len(vertices)):
					st.add_normal(bt.basis.xform(normals[i]))
					
					var uv : Vector2 = uvs[i]
					
					uv.x = tw * uv.x + tx
					uv.y = th * uv.y + ty
					
					st.add_uv(uv)
						
					st.add_bones(bone_array)
					st.add_weights(weights_array)
					st.add_vertex(bt.xform(vertices[i]))
	
				for i in range(len(indices)):
					st.add_index(vertex_count + indices[i])
	
				vertex_count += len(vertices)
	
	mesh = st.commit()
	mesh.surface_set_material(0, _material)

#	finish_build_mesh()
	_thread_done = true

func prepare_textures() -> void:
	_texture_packer.clear()
	
	_textures.clear()
	_textures.resize(EntityEnums.SKELETON_POINTS_MAX)
	
	for bone_idx in range(EntityEnums.SKELETON_POINTS_MAX):
		var texture : Texture
		
		for j in range(get_model_entry_count(bone_idx)):
			var entry : SkeletonModelEntry = get_model_entry(bone_idx, j)
			
			if entry.entry.get_texture(gender) != null:
				texture = _texture_packer.add_texture(entry.entry.get_texture(gender))
#				print(texture)
				break
			
		_textures[bone_idx] = texture
		
	_texture_packer.merge()
	
	if _material == null:
		_material = material.duplicate()
	
	var tex : Texture = _texture_packer.get_generated_texture(0)
	
	var mat : SpatialMaterial = _material as SpatialMaterial
	mat.albedo_texture = tex
	_texture = tex


func setup_build_mesh() -> void:
	if get_animation_tree() != null:
		get_animation_tree().active = false
	
	if get_animation_player() != null:
		get_animation_player().play("rest")
		get_animation_player().seek(0, true)
	
func finish_build_mesh() -> void:
	mesh_instance.mesh = mesh
		
	if get_animation_tree() != null:
		get_animation_tree().active = true
		

func clear_mesh() -> void:
	mesh = null
	
	if mesh_instance != null:
		mesh_instance.mesh = null

func editor_build(val : bool) -> void:
	if not is_inside_tree() or _editor_built:
		return

	if st == null:
		st = SurfaceTool.new()
		
	skeleton = get_node(skeleton_path) as Skeleton
	mesh_instance = get_node(mesh_instance_path) as MeshInstance
	
	if val:
		_editor_built = true
		build()
	else:
		clear_mesh()
		_editor_built = false
		
	refresh_in_editor = val
