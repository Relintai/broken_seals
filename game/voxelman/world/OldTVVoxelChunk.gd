extends VoxelChunkDefault
#class_name TVVoxelChunk

var _prop_texture_packer : TexturePacker
var _textures : Array
var _prop_material : SpatialMaterial
var _entities_spawned : bool

func _create_meshers():
	_prop_texture_packer = TexturePacker.new()
	_prop_texture_packer.max_atlas_size = 1024
	_prop_texture_packer.margin = 1
	_prop_texture_packer.background_color = Color(0, 0, 0, 1)
	_prop_texture_packer.texture_flags = Texture.FLAG_MIPMAPS

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
	for i in range(get_mesher_count()):
		get_mesher(i).reset()

	if get_prop_count() == 0:
		next_phase()
		return
		
#	if get_prop_mesh_rid() == RID():
#		allocate_prop_mesh()
		
	if _prop_material == null:
		_prop_material = SpatialMaterial.new()
		_prop_material.flags_vertex_lighting = true
		_prop_material.vertex_color_use_as_albedo = true
		_prop_material.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
		_prop_material.metallic = 0
		
#		VisualServer.instance_geometry_set_material_override(get_prop_mesh_instance_rid(), _prop_material.get_rid())
		
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
			
			for j in range(get_mesher_count()):
				prop.prop.add_meshes_into(get_mesher(j), _prop_texture_packer, t, get_voxel_world())
			
		if prop.prop != null:
			var vmanpp : PropData = prop.prop as PropData
			var t : Transform = get_prop_transform(prop, vmanpp.snap_to_mesh, vmanpp.snap_axis)
			
			for j in range(get_mesher_count()):
				prop.prop.add_meshes_into(get_mesher(j), _prop_texture_packer, t, get_voxel_world())

	for i in range(get_mesher_count()):
		get_mesher(i).bake_colors(self)
#		get_mesher(i).build_mesh(get_prop_mesh_rid())
		get_mesher(i).material = null
		
	if not _entities_spawned:
		for i in range(get_prop_count()):
			var prop : VoxelChunkPropData = get_prop(i)
			
			if prop.prop != null:
				spawn_prop_entities(get_prop_transform(prop, false, Vector3(0, -1, 0)), prop.prop)
	
	next_phase()
	

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

func _build_phase(phase):
	if phase == VoxelChunk.BUILD_PHASE_PROP_MESH:
		set_physics_process(true)

func _physics_process(delta):
	if current_build_phase == VoxelChunk.BUILD_PHASE_PROP_MESH:
		build_phase_prop_mesh()
		set_physics_process(false)
		next_phase()

#func visibility_changed() -> void:
#	if get_prop_mesh_instance_rid() != RID():
#		VisualServer.instance_set_visible(get_prop_mesh_instance_rid(), visible)
#
#
#func _notification(what: int) -> void:
#	if what == NOTIFICATION_TRANSFORM_CHANGED:
#		if get_prop_mesh_instance_rid() != RID():
#			VisualServer.instance_set_transform(get_prop_mesh_instance_rid(), transform)
#
#		if get_prop_body_rid() != RID():
#			PhysicsServer.body_set_state(get_prop_body_rid(), PhysicsServer.BODY_STATE_TRANSFORM, transform)

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
