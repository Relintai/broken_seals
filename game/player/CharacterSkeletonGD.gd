tool
extends CharacterSkeleton3D

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019-2021 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

var job_script = preload("res://player/CharacterSkeletonMeshJob.gd")

export(bool) var refresh_in_editor : bool = false setget editor_build
export(bool) var automatic_build : bool = false
export(bool) var use_lod : bool = true

export(NodePath) var mesh_instance_path : NodePath
var mesh_instance : MeshInstance = null

export(NodePath) var skeleton_path : NodePath
var skeleton : Skeleton

export(Array, ModelVisual) var viss : Array

var meshes : Array

var _current_lod_level : int = 0

var _generating : bool = false

var _mesh_job : ThreadPoolJob = null
var _material_cache : ESSMaterialCache = null

var bone_names = {
	0: "root",
	1: "pelvis",
	2: "spine",
	3: "spine_1",
	4: "spine_2",
	5: "neck",
	6: "head",
	
	7: "left_clavicle",
	8: "left_upper_arm",
	9: "left_forearm",
	10: "left_hand",
	11: "left_thunb_base",
	12: "left_thumb_end",
	13: "left_fingers_base",
	14: "left_fingers_end",
	
	15: "right_clavicle",
	16: "right_upper_arm",
	17: "right_forearm",
	18: "right_hand",
	19: "right_thumb_base",
	20: "right_thumb_head",
	21: "right_fingers_base",
	22: "right_fingers_head",
	
	23: "left_thigh",
	24: "left_calf",
	25: "left_foot",
	
	26: "right_thigh",
	27: "right_calf",
	28: "right_foot",
}


var _textures : Array
var _texture : Texture

var _editor_built : bool = false
var sheathed : bool = true

func _enter_tree():
	_mesh_job = job_script.new()
	_mesh_job.use_lod = use_lod
	_mesh_job.connect("finished", self, "job_finished")
	
	meshes.resize(3)
	
	skeleton = get_node(skeleton_path) as Skeleton
	mesh_instance = get_node(mesh_instance_path) as MeshInstance

	set_process(false)
	
	if Engine.editor_hint:
		return
			
#	if not Engine.is_editor_hint():
	for iv in viss:
		add_model_visual(iv as ModelVisual)

	call_deferred("sheath", sheathed)
	
	if automatic_build:
		call_deferred("build_model")

func _build_model():
	if _generating:
		return
		
	_generating = true
	
	if Engine.is_editor_hint() and not refresh_in_editor:
		set_process(false)
		return
	
	if not automatic_build:
		set_process(false)
		return
	
	build()
	set_process(false)
		
	model_dirty = false
	
func build():
	setup_build_mesh()
	
	sort_layers()
	
	var data : Array = Array()

	for skele_point in range(ESS.skeletons_bones_index_get(entity_type).count(',') + 1):
		var bone_name : String = get_bone_name(skele_point)

		if bone_name == "":
			print("Bone name error")
			continue
		
		var bone_idx : int = skeleton.find_bone(bone_name)
		
		var abi_dict : Dictionary = Dictionary()
		
		for abti in range(bone_additional_mesh_transform_count):
			var obi : int = bone_additional_mesh_transform_bone_index_get(abti)
			var bin = get_bone_name(obi)
			var bi : int = skeleton.find_bone(bin)
						
			abi_dict[bi] = bone_additional_mesh_transform_transform_get(abti) * bone_additional_mesh_transform_user_transform_get(abti)

		var ddict : Dictionary = Dictionary()
		for j in range(get_model_entry_count(skele_point)):
			var entry : SkeletonModelEntry = get_model_entry(skele_point, j)
			
			for k in range(entry.entry.size):
				if entry.entry.get_mesh(k):
					ddict["bone_name"] = bone_name
					ddict["bone_idx"] = bone_idx
					
					var global_pose = skeleton.get_bone_global_pose(bone_idx)
					
					ddict["transform"] = skeleton.get_bone_global_pose(bone_idx)
					
					if abi_dict.has(bone_idx):
						global_pose *= abi_dict[bone_idx]
					
#					for abti in range(bone_model_additional_mesh_transform_count):
#						var bin = get_bone_name(bone_model_additional_mesh_transform_bone_index_get(abti))
#						var bi : int = skeleton.find_bone(bin)
#
#						if bone_idx == bi:
#							global_pose *= bone_model_additional_mesh_transform_bone_transform_get(abti)
#							break
#
					ddict["transform"] = global_pose
									
					ddict["mesh"] = entry.entry.get_mesh(k)
		
		var texture_layer_array : Array = Array()
		texture_layer_array.resize(ESS.texture_layers.count(",") + 1)
		var texture_used : bool = false
		
		for j in range(get_model_entry_count(skele_point)):
			var entry : SkeletonModelEntry = get_model_entry(skele_point, j)
			
			var layer : int = entry.entry.override_layer
			
			if texture_layer_array.size() <= layer || texture_layer_array[layer]:
				continue
			
			for k in range(entry.entry.size):
				if entry.entry.get_texture(k):
					texture_layer_array[layer] = entry.entry.get_texture(k)
					texture_used = true
					break
		
		if texture_used:
			ddict["textures"] = texture_layer_array
			
		if !ddict.empty():
			data.append(ddict)
	
	_mesh_job.data = data
	_material_cache= ESS.material_cache_get(data.hash())
	 
	if _material_cache.material_get_num() == 0:
		#lock just in case
		_material_cache.mutex_lock()

		if _material_cache.material_get_num() == 0:
			#this has to be done on the main thread!
			_material_cache.initial_setup_default()
		
		_material_cache.mutex_unlock()
	
	_mesh_job.material_cache = _material_cache
	
	finish_build_mesh()
	
	ThreadPool.add_job(_mesh_job)
#	_mesh_job.execute()

func setup_build_mesh() -> void:
	if mesh_instance != null:
		mesh_instance.hide()
	
	if get_animation_tree() != null:
		get_animation_tree().active = false
	
	if get_animation_player() != null:
		get_animation_player().play("rest")
		get_animation_player().seek(0, true)
	
func finish_build_mesh() -> void:
	mesh_instance.mesh = null
#	mesh_instance.mesh = meshes[_current_lod_level]
		
	if get_animation_tree() != null:
		get_animation_tree().active = true
		
	if mesh_instance != null:
		mesh_instance.show()
	
	_generating = false	
	
func job_finished():
	meshes = _mesh_job.meshes
	mesh_instance.mesh = meshes[_current_lod_level]
	
	if !mesh_instance.is_software_skinning_enabled():
		mesh_instance.initialize_skinning(true, true)

func clear_mesh() -> void:
	meshes.clear()
	meshes.resize(3)
	
	if mesh_instance != null:
		mesh_instance.mesh = null

func editor_build(val : bool) -> void:
	if not is_inside_tree():
		return

	skeleton = get_node(skeleton_path) as Skeleton
	mesh_instance = get_node(mesh_instance_path) as MeshInstance
	
	if val:
		_editor_built = true
		build()
	else:
		clear_mesh()
		_editor_built = false
		
	refresh_in_editor = val

func get_bone_name(skele_point : int) -> String:
	if bone_names.has(skele_point):
		return bone_names[skele_point]
		
	return ""
	
func _common_attach_point_index_get(point):
	if point == EntityEnums.COMMON_SKELETON_POINT_LEFT_HAND:
		return 0
	elif point == EntityEnums.COMMON_SKELETON_POINT_ROOT:
		return 3
	elif point == EntityEnums.COMMON_SKELETON_POINT_SPINE_2:
		return 6
	elif point == EntityEnums.COMMON_SKELETON_POINT_RIGHT_HAND:
		return 1
	elif point == EntityEnums.COMMON_SKELETON_POINT_BACK:
		return 6
	elif point == EntityEnums.COMMON_SKELETON_POINT_RIGHT_HIP:
		return 4
	elif point == EntityEnums.COMMON_SKELETON_POINT_WEAPON_LEFT:
		return 7
	elif point == EntityEnums.COMMON_SKELETON_POINT_WEAPON_LEFT_BACK:
		return 9
	elif point == EntityEnums.COMMON_SKELETON_POINT_WEAPON_RIGHT:
		return 8
	elif point == EntityEnums.COMMON_SKELETON_POINT_WEAPON_RIGHT_BACK:
		return 10
	elif point == EntityEnums.COMMON_SKELETON_POINT_WEAPON_LEFT_SHIELD:
		return 11
		
	return 3
	
func set_lod_level(level : int) -> void:
	if _current_lod_level == level:
		return
		
	if meshes.size() == 0:
		return
	
	if level < 0:
		return
		
	if level >= meshes.size():
		level = meshes.size() - 1
		
	_current_lod_level = level
	
	mesh_instance.mesh = meshes[_current_lod_level]
	
	if !mesh_instance.is_software_skinning_enabled():
		mesh_instance.initialize_skinning(true, true)
	
		

func toggle_sheath():
	sheathed = not sheathed
	sheath(sheathed)
		

	
func sheath(on : bool) -> void:
	var pos = 0
	
	if not on:
		pos = 1
	
	attach_point_node_get(7).set_node_position(pos)
	attach_point_node_get(8).set_node_position(pos)
	attach_point_node_get(9).set_node_position(pos)
	attach_point_node_get(10).set_node_position(pos)
	attach_point_node_get(11).set_node_position(pos)
