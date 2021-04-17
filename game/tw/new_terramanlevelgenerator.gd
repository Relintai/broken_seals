tool
extends TerramanLevelGenerator


func _generate_chunk(chunk: TerraChunk) -> void:
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)
	
	var s : OpenSimplexNoise = OpenSimplexNoise.new()
	
	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			var vx : int = x + (chunk.position_x * chunk.size_x)
			var vz : int = z + (chunk.position_z * chunk.size_z)
			
			chunk.set_voxel((s.get_noise_2d(vx, vz) + 2) * 10.0, x, z, TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
