tool
extends TerramanLevelGenerator


func _generate_chunk(chunk: TerraChunk) -> void:
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)
	
	var s : OpenSimplexNoise = OpenSimplexNoise.new()
	
	for x in range(chunk.data_size_x):
		for z in range(chunk.data_size_z):
			chunk.set_voxel(s.get_noise_2d(x, z) * 10.0, x, z, TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
