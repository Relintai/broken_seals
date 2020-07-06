tool
extends VoxelChunkMarchingCubes
class_name TVVoxelChunk

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

# Copyright (c) 2019-2020 Péter Magyar

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

var _prop_texture_packer : TexturePacker
var _textures : Array
var _prop_material : SpatialMaterial
var _entities_spawned : bool

var _prop_mesh_instance_rid : RID
var _prop_mesh_rid : RID

#func _init():
#	add_mesh_data_resource(get_transform().scaled(Vector3(10, 10, 10)), ResourceLoader.load("res://modules/species/Human/Female/character_models/huf_calf_left.gltf"))
#	add_mesh_data_resource(get_transform().translated(Vector3(0, 4, 0)), ResourceLoader.load("res://modules/species/Human/Female/character_models/huf_calf_left.gltf"))


func _create_meshers():
	prop_mesher = TVVoxelMesher.new()
	prop_mesher.base_light_value = 0.45
	prop_mesher.ao_strength = 0.2
	prop_mesher.uv_margin = Rect2(0.017, 0.017, 1 - 0.034, 1 - 0.034)
	prop_mesher.lod_size = lod_size
	prop_mesher.voxel_scale = voxel_scale
	prop_mesher.build_flags = build_flags
	prop_mesher.texture_scale = 3
	
	var mesher : TVVoxelMesher = TVVoxelMesher.new()
	mesher.base_light_value = 0.45
	mesher.ao_strength = 0.2
	mesher.uv_margin = Rect2(0.017, 0.017, 1 - 0.034, 1 - 0.034)
	mesher.lod_size = lod_size
	mesher.voxel_scale = voxel_scale
	mesher.build_flags = build_flags
	mesher.texture_scale = 3
	add_mesher(mesher)
	
	#add_mesher(VoxelMesherCubic.new())
	
	_prop_texture_packer = TexturePacker.new()
	_prop_texture_packer.max_atlas_size = 1024
	_prop_texture_packer.margin = 1
	_prop_texture_packer.background_color = Color(0, 0, 0, 1)
	_prop_texture_packer.texture_flags = Texture.FLAG_MIPMAPS


#func _build_phase(phase):
#	if phase == VoxelChunkDefault.BUILD_PHASE_SETUP:
#		._build_phase(phase)
#
#	elif phase == VoxelChunkDefault.BUILD_PHASE_LIGHTS:
#		clear_baked_lights()
#		generate_random_ao(123)
#		bake_lights()
#
#		next_phase()
		
		#set_physics_process_internal(true)
#		active_build_phase_type = VoxelChunkDefault.BUILD_PHASE_TYPE_PHYSICS_PROCESS
#		return
#	elif phase == VoxelChunkDefault.BUILD_PHASE_TERRARIN_MESH:
#		for i in range(get_mesher_count()):
#			var mesher : VoxelMesher = get_mesher(i)
#			mesher.bake_colors(self)
#
#		for i in range(get_mesher_count()):
#			var mesher : VoxelMesher = get_mesher(i)
#			mesher.set_library(library)
#
#		var mesh_rid : RID = get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 0)
#
#		if mesh_rid == RID():
#			create_meshes(MESH_INDEX_TERRARIN, lod_num + 1)
#			mesh_rid = get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 0)
#
#		var mesher : VoxelMesher = null
#		for i in range(get_mesher_count()):
#			var m : VoxelMesher = get_mesher(i)
#
#			if mesher == null:
#				mesher = m
#				continue
#
#			mesher.set_material(library.material)
#			mesher.add_mesher(m)
#
#		if (mesh_rid != RID()):
#			VisualServer.mesh_clear(mesh_rid)
#
#		if mesher.get_vertex_count() == 0:
#			next_phase()
#			return true
#
#		if (mesh_rid == RID()):
#			create_meshes(MESH_INDEX_TERRARIN, lod_num + 1)
#			mesh_rid = get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 0)
#
#		var arr : Array = mesher.build_mesh()
#
#		VisualServer.mesh_add_surface_from_arrays(mesh_rid, VisualServer.PRIMITIVE_TRIANGLES, arr)
#
#		if library.get_material(0) != null:
#			VisualServer.mesh_surface_set_material(mesh_rid, 0, library.get_material(0).get_rid())
#
##		VisualServer.instance_set_visible(get_mesh_instance_rid(), false)
#
#		if generate_lod and lod_num >= 1:
#			#for lod 1 just remove uv2
#
#			arr[VisualServer.ARRAY_TEX_UV2] = null
#
#			VisualServer.mesh_add_surface_from_arrays(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 1), VisualServer.PRIMITIVE_TRIANGLES, arr)
#
#			if library.get_material(1) != null:
#				VisualServer.mesh_surface_set_material(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 1), 0, library.get_material(1).get_rid())
#
#			if lod_num >= 2:
#				arr = merge_mesh_array(arr)
#
#				VisualServer.mesh_add_surface_from_arrays(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 2), VisualServer.PRIMITIVE_TRIANGLES, arr)
#
#				if library.get_material(2) != null:
#					VisualServer.mesh_surface_set_material(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 2), 0, library.get_material(2).get_rid())
#
#			if lod_num >= 3:
#				var mat : ShaderMaterial = library.get_material(0) as ShaderMaterial
#				var tex : Texture = mat.get_shader_param("texture_albedo")
#
#				arr = bake_mesh_array_uv(arr, tex)
#				arr[VisualServer.ARRAY_TEX_UV] = null
#
#				VisualServer.mesh_add_surface_from_arrays(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 3), VisualServer.PRIMITIVE_TRIANGLES, arr)
#
#				if library.get_material(3) != null:
#					VisualServer.mesh_surface_set_material(get_mesh_rid_index(MESH_INDEX_TERRARIN, MESH_TYPE_INDEX_MESH, 3), 0, library.get_material(3).get_rid())
##			if lod_num > 4:
##					var fqms : FastQuadraticMeshSimplifier = FastQuadraticMeshSimplifier.new()
##					fqms.initialize(merged)
##
##					var arr_merged_simplified : Array = merged
#
##					for i in range(2, _lod_meshes.size()):
##						fqms.simplify_mesh(arr_merged_simplified[0].size() * 0.8, 7)
##						arr_merged_simplified = fqms.get_arrays()
#
##						if arr_merged_simplified[0].size() == 0:
##							break
#
##						VisualServer.mesh_add_surface_from_arrays(_lod_meshes[i], VisualServer.PRIMITIVE_TRIANGLES, arr_merged_simplified)
#
##						if library.get_material(i) != null:
##							VisualServer.mesh_surface_set_material(_lod_meshes[i], 0, library.get_material(i).get_rid())
#
#		next_phase();
#
#		return
#	else:
#		._build_phase(phase)



func spawn_prop_entities(parent_transform : Transform, prop : PropData):
	for i in range(prop.get_prop_count()):
		var p : PropDataEntry = prop.get_prop(i)
	
		if p is PropDataEntity:
			var pentity : PropDataEntity = p as PropDataEntity
			
			if pentity.entity_data_id != 0:
				ESS.spawn_mob(pentity.entity_data_id, pentity.level, parent_transform.origin)

						
		if p is PropDataProp and p.prop != null:
			var vmanpp : PropDataProp = p as PropDataProp
			
			spawn_prop_entities(get_prop_mesh_transform(parent_transform * p.transform, vmanpp.snap_to_mesh, vmanpp.snap_axis), p.prop)

func build_phase_prop_mesh() -> void:
	if get_prop_count() == 0:
#		next_phase()
		return
		
	if _prop_mesh_rid == RID():
		allocate_prop_mesh()
		
	if _prop_material == null:
		_prop_material = SpatialMaterial.new()
		_prop_material.flags_vertex_lighting = true
		_prop_material.vertex_color_use_as_albedo = true
		_prop_material.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
		_prop_material.metallic = 0
		
		VisualServer.instance_geometry_set_material_override(_prop_mesh_instance_rid, _prop_material.get_rid())
		
		get_prop_mesher().material = _prop_material
		
	for i in range(get_prop_count()):
		var prop : VoxelChunkPropData = get_prop(i)
		
		if prop.mesh != null and prop.mesh_texture != null:
			var at : AtlasTexture = _prop_texture_packer.add_texture(prop.mesh_texture)
			_textures.append(at)
			
		if prop.prop != null:
			prop.prop.add_textures_into(_prop_texture_packer)
	
	if _prop_texture_packer.get_texture_count() > 0:
		_prop_texture_packer.merge()
		
		_prop_material.albedo_texture = _prop_texture_packer.get_generated_texture(0)
		
	for i in range(get_prop_count()):
		var prop : VoxelChunkPropData = get_prop(i)
		
		if prop.mesh != null:
			var t : Transform = get_prop_transform(prop, prop.snap_to_mesh, prop.snap_axis)
			
			prop.prop.add_meshes_into(get_prop_mesher(), _prop_texture_packer, t, get_voxel_world())
			
		if prop.prop != null:
			var vmanpp : PropData = prop.prop as PropData
			var t : Transform = get_prop_transform(prop, vmanpp.snap_to_mesh, vmanpp.snap_axis)
			
			prop.prop.add_meshes_into(get_prop_mesher(), _prop_texture_packer, t, get_voxel_world())

	get_prop_mesher().bake_colors(self)
	get_prop_mesher().build_mesh_into(_prop_mesh_rid)
	get_prop_mesher().material = null
		
	if not _entities_spawned:
		for i in range(get_prop_count()):
			var prop : VoxelChunkPropData = get_prop(i)
			
			if prop.prop != null:
				spawn_prop_entities(get_prop_transform(prop, false, Vector3(0, -1, 0)), prop.prop)
	
#	next_phase()
	

func get_prop_transform(prop : VoxelChunkPropData, snap_to_mesh: bool, snap_axis: Vector3) -> Transform:
	var pos : Vector3 = Vector3(prop.x * voxel_scale, prop.y * voxel_scale, prop.z * voxel_scale)
	
	var t : Transform = Transform(Basis(prop.rotation).scaled(prop.scale), pos)

	if snap_to_mesh:
		var global_pos : Vector3 = get_voxel_world().to_global(t.origin)
		var world_snap_axis : Vector3 = get_voxel_world().to_global(t.xform(snap_axis))
		var world_snap_dir : Vector3 = (world_snap_axis - global_pos) * 100
		
		var space_state : PhysicsDirectSpaceState = get_voxel_world().get_world().direct_space_state
		var result : Dictionary = space_state.intersect_ray(global_pos - world_snap_dir, global_pos + world_snap_dir, [], 1)
		
		if result.size() > 0:
			t.origin = get_voxel_world().to_local(result["position"])
	
	return t
	
func get_prop_mesh_transform(base_transform : Transform, snap_to_mesh: bool, snap_axis: Vector3) -> Transform:
	if snap_to_mesh:
		var pos : Vector3 = get_voxel_world().to_global(base_transform.origin)
		var world_snap_axis : Vector3 = get_voxel_world().to_global(base_transform.xform(snap_axis))
		var world_snap_dir : Vector3 = (world_snap_axis - pos) * 100
		
		var space_state : PhysicsDirectSpaceState = get_voxel_world().get_world().direct_space_state
		var result : Dictionary = space_state.intersect_ray(pos - world_snap_dir, pos + world_snap_dir, [], 1)
		
		if result.size() > 0:
			base_transform.origin = get_voxel_world().to_local(result["position"])

	return base_transform

#func _build_phase(phase):
#	if phase == VoxelChunkDefault.BUILD_PHASE_COLLIDER:
#		active_build_phase_type = VoxelChunkDefault.BUILD_PHASE_TYPE_PHYSICS_PROCESS
#		return
#	elif phase == VoxelChunkDefault.BUILD_PHASE_PROP_MESH:
#		next_phase()
#		return
#
#	._build_phase(phase)


#func _build_phase_physics_process(phase):
#	if phase == VoxelChunkDefault.BUILD_PHASE_PROP_SETUP:
##		add_prop(ResourceLoader.load("res://prop_tool/ToolTes2at.tres"))
#		build_phase_prop_mesh()
#		active_build_phase_type = VoxelChunkDefault.BUILD_PHASE_TYPE_NORMAL
#		next_phase()
#		return
#
#	._build_phase_physics_process(phase)
#

func build_phase_lights() -> void:
	var vl : VoxelLight = VoxelLight.new()
	
	for i in range(get_prop_count()):
		var prop : VoxelChunkPropData = get_prop(i)
		
		if prop.light == null and prop.prop == null:
			continue
		
		var t : Transform = get_prop_transform(prop, prop.snap_to_mesh, prop.snap_axis)
		
		if prop.light != null:
			var pl : PropDataLight = prop.light
			
			vl.set_world_position(prop.x + position_x * size_x, prop.y +  position_y * size_y, prop.z +  position_z * size_z)
			vl.color = pl.light_color
			vl.size = pl.light_size

			bake_light(vl)
			
		if prop.prop != null:
			prop.prop.add_prop_lights_into(self, t, true)

func allocate_prop_mesh():
	pass
