tool
extends VoxelChunkDefault
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

func _create_meshers():
	var mesher : TVVoxelMesher = TVVoxelMesher.new()
	mesher.base_light_value = 0.45
	mesher.ao_strength = 0.2
	mesher.uv_margin = Rect2(0.017, 0.017, 1 - 0.034, 1 - 0.034)
	mesher.lod_size = lod_size
	mesher.voxel_scale = voxel_scale
	add_mesher(mesher)
	
	#add_mesher(VoxelMesherCubic.new())
	
	_prop_texture_packer = TexturePacker.new()
	_prop_texture_packer.max_atlas_size = 1024
	_prop_texture_packer.margin = 1
	_prop_texture_packer.background_color = Color(0, 0, 0, 1)
	_prop_texture_packer.texture_flags = Texture.FLAG_MIPMAPS

func _build_phase(phase):
	if phase == VoxelChunkDefault.BUILD_PHASE_SETUP:
		._build_phase(phase)
		
	elif phase == VoxelChunkDefault.BUILD_PHASE_LIGHTS:
		clear_baked_lights()
		generate_random_ao()
		bake_lights()
		
		next_phase()
		
		#set_physics_process_internal(true)
#		active_build_phase_type = VoxelChunkDefault.BUILD_PHASE_TYPE_PHYSICS_PROCESS
		return
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
	else:
		._build_phase(phase)

func _prop_added(prop):
	pass
	
func generate_random_ao() -> void:
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 4
	noise.period = 30
	noise.persistence = 0.3

	for x in range(0, size_x + 1):
		for z in range(0, size_z + 1):
			for y in range(0, size_y + 1):
				var val : float = noise.get_noise_3d(x + (position_x * size_x), y + (position_y * size_y), z + (position_z * size_z)) 
			
				val *= 0.6
				
				if val > 1:
					val = 1
					
				if val < 0:
					val = -val

				set_voxel(int(val * 255.0), x, y, z, VoxelChunkDefault.DEFAULT_CHANNEL_RANDOM_AO)

