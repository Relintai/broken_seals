extends Dungeon

export (EntityData) var trainer : EntityData

func _instance(p_seed, p_instance):
	._instance(p_seed, p_instance)
	
	p_instance.trainer = trainer
	
	return p_instance

func _generate_chunk(chunk : VoxelChunk, spawn_mobs : bool):
	if trainer == null:
		return
	
	if chunk.position_x == 0 && chunk.position_y == 0 && chunk.position_z == 0:
		var pos : Vector3 = Vector3(4 * chunk.voxel_scale, 8 * chunk.voxel_scale, 4 * chunk.voxel_scale)
		
		ESS.entity_spawner.spawn_mob(trainer.id, 1, pos)

