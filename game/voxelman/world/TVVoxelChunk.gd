extends VoxelChunk
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

var lod_data : Array = [
	1, #CHUNK_INDEX_UP
	1, #CHUNK_INDEX_DOWN
	1, #CHUNK_INDEX_LEFT
	1, #CHUNK_INDEX_RIGHT
	1, #CHUNK_INDEX_FRONT
	1 #CHUNK_INDEX_BACK
]

func _ready():
	connect("visibility_changed", self, "visibility_changed")
	
	set_notify_transform(true)

func _create_meshers():
	var mesher : TVVoxelMesher = TVVoxelMesher.new()
	mesher.base_light_value = 0.45
	mesher.ao_strength = 0.2
	mesher.uv_margin = Rect2(0.017, 0.017, 1 - 0.034, 1 - 0.034)
	add_mesher(mesher)
	
	#add_mesher(VoxelMesherCubic.new())
	
	_prop_texture_packer = TexturePacker.new()
	_prop_texture_packer.max_atlas_size = 1024
	_prop_texture_packer.margin = 1
	_prop_texture_packer.background_color = Color(0, 0, 0, 1)
	_prop_texture_packer.texture_flags = Texture.FLAG_MIPMAPS

func _process_props():
	pass
	
func spawn_prop_entities(parent_transform : Transform, prop : PropData):
	for i in range(prop.get_prop_count()):
		var p : PropDataEntry = prop.get_prop(i)
	
		if p is PropDataEntity:
			var pentity : PropDataEntity = p as PropDataEntity
			
			if pentity.entity_data_id != 0:
				Entities.spawn_mob(pentity.entity_data_id, pentity.level, parent_transform.origin)

						
		if p is PropDataProp and p.prop != null:
			var vmanpp : PropDataProp = p as PropDataProp
			
			spawn_prop_entities(get_prop_mesh_transform(parent_transform * p.transform, vmanpp.snap_to_mesh, vmanpp.snap_axis), p.prop)

func build_phase_prop_mesh() -> void:
	for i in range(get_mesher_count()):
		get_mesher(i).reset()

	if get_prop_count() == 0:
		next_phase()
		return
		
	if get_prop_mesh_rid() == RID():
		allocate_prop_mesh()
		
#	if _prop_material == null:
#		_prop_material = SpatialMaterial.new()
#		_prop_material.flags_vertex_lighting = true
#		_prop_material.vertex_color_use_as_albedo = true
#		_prop_material.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
#		_prop_material.metallic = 0
		
		VisualServer.instance_geometry_set_material_override(get_prop_mesh_instance_rid(), library.get_prop_material().get_rid())
		
		for i in range(get_mesher_count()):
			get_mesher(i).material = _prop_material
		
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
			
			for i in range(get_mesher_count()):
				prop.prop.add_meshes_into(get_mesher(i), _prop_texture_packer, t, self)
			
		if prop.prop != null:
			var vmanpp : PropData = prop.prop as PropData
			var t : Transform = get_prop_transform(prop, vmanpp.snap_to_mesh, vmanpp.snap_axis)
			
			for i in range(get_mesher_count()):
				prop.prop.add_meshes_into(get_mesher(i), _prop_texture_packer, t, self)

	for i in range(get_mesher_count()):
		get_mesher(i).bake_colors(self)
		get_mesher(i).build_mesh_into(get_prop_mesh_rid())
		get_mesher(i).material = null
		
	if not _entities_spawned:
		for i in range(get_prop_count()):
			var prop : VoxelChunkPropData = get_prop(i)
			
			if prop.prop != null:
				spawn_prop_entities(get_prop_transform(prop, false, Vector3(0, -1, 0)), prop.prop)
	
	next_phase()
	
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

func get_prop_transform(prop : VoxelChunkPropData, snap_to_mesh: bool, snap_axis: Vector3) -> Transform:
	var pos : Vector3 = Vector3(prop.x * voxel_scale, prop.y * voxel_scale, prop.z * voxel_scale)
	
	var t : Transform = Transform(Basis(prop.rotation).scaled(prop.scale), pos)

	if snap_to_mesh:
		var global_pos : Vector3 = to_global(t.origin)
		var world_snap_axis : Vector3 = to_global(t.xform(snap_axis))
		var world_snap_dir : Vector3 = (world_snap_axis - global_pos) * 100
		
		var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
		var result : Dictionary = space_state.intersect_ray(global_pos - world_snap_dir, global_pos + world_snap_dir, [], 1)
		
		if result.size() > 0:
			t.origin = to_local(result["position"])
	
	return t
	
func get_prop_mesh_transform(base_transform : Transform, snap_to_mesh: bool, snap_axis: Vector3) -> Transform:
	if snap_to_mesh:
		var pos : Vector3 = to_global(base_transform.origin)
		var world_snap_axis : Vector3 = to_global(base_transform.xform(snap_axis))
		var world_snap_dir : Vector3 = (world_snap_axis - pos) * 100
		
		var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
		var result : Dictionary = space_state.intersect_ray(pos - world_snap_dir, pos + world_snap_dir, [], 1)
		
		if result.size() > 0:
			base_transform.origin = to_local(result["position"])

	return base_transform

func _build_phase(phase):
	if phase == VoxelChunk.BUILD_PHASE_LIGHTS:
		clear_baked_lights()
		generate_random_ao()
		bake_lights()
		set_physics_process_internal(true)
		return false
	elif phase == VoxelChunk.BUILD_PHASE_TERRARIN_MESH:
		for i in range(get_mesher_count()):
			var mesher : VoxelMesher = get_mesher(i)
			mesher.bake_colors(self)
			
		for i in range(get_mesher_count()):
			var mesher : VoxelMesher = get_mesher(i)
			mesher.set_library(library)
		
		if get_mesh_rid() == RID():
			allocate_main_mesh()

		var mesher : VoxelMesher = null
		for i in range(get_mesher_count()):
			var m : VoxelMesher = get_mesher(i)
			
			if mesher == null:
				mesher = m
				continue

			mesher.set_material(library.material)
			mesher.add_mesher(m)

		VisualServer.mesh_clear(get_mesh_rid())

		if mesher.get_vertex_count() == 0:
			next_phase()
			return true

		var arr : Array = mesher.build_mesh()

		VisualServer.mesh_add_surface_from_arrays(get_mesh_rid(), VisualServer.PRIMITIVE_TRIANGLES, arr)

		if library.material != null:
			VisualServer.mesh_surface_set_material(get_mesh_rid(), 0, library.material.get_rid())

		next_phase();

		return true;
	elif phase == VoxelChunk.BUILD_PHASE_PROP_MESH:
		set_physics_process_internal(true)
		return false
	elif phase == VoxelChunk.BUILD_PHASE_FINALIZE:
		_notification(NOTIFICATION_TRANSFORM_CHANGED)
		
		return ._build_phase(phase)
	else:
		return ._build_phase(phase)

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

				set_voxel(int(val * 255.0), x, y, z, VoxelChunk.DEFAULT_CHANNEL_RANDOM_AO)

func _physics_process(delta):
	if current_build_phase == VoxelChunk.BUILD_PHASE_LIGHTS:
		build_phase_lights()
		set_physics_process_internal(false)
		next_phase()
		
	elif current_build_phase == VoxelChunk.BUILD_PHASE_PROP_MESH:
		build_phase_prop_mesh()
		set_physics_process_internal(false)
		next_phase()

func visibility_changed() -> void:
	if get_mesh_instance_rid() != RID():
		VisualServer.instance_set_visible(get_mesh_instance_rid(), visible)
			
	if get_prop_mesh_instance_rid() != RID():
		VisualServer.instance_set_visible(get_prop_mesh_instance_rid(), visible)
			
		
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if get_mesh_instance_rid() != RID():
			VisualServer.instance_set_transform(get_mesh_instance_rid(), transform)
			
		if get_prop_mesh_instance_rid() != RID():
			VisualServer.instance_set_transform(get_prop_mesh_instance_rid(), transform)
			
		if get_body_rid() != RID():
			PhysicsServer.body_set_state(get_body_rid(), PhysicsServer.BODY_STATE_TRANSFORM, transform)
			
		if get_prop_body_rid() != RID():
			PhysicsServer.body_set_state(get_prop_body_rid(), PhysicsServer.BODY_STATE_TRANSFORM, transform)

#func _draw_debug_voxel_lights(debug_drawer):
#	for light in _lightsarr:
#		var pos_x = (light.get_world_position_x() - (size_x * position_x)) ;
#		var pos_y = (light.get_world_position_y() - (size_y * position_y)) ;
#		var pos_z = (light.get_world_position_z() - (size_z * position_z)) ;
##		print(Vector3(pos_x, pos_y, pos_z))
#		draw_cross_voxels_fill(Vector3(pos_x, pos_y, pos_z), 1)
