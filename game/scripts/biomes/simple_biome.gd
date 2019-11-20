extends Biome

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _generate_chunk(chunk: VoxelChunk, spawn_mobs: bool) -> void:
#	var chunk : VoxelChunk = chunk.get_chunk()
	
	generate_terrarin(chunk, spawn_mobs)

func generate_terrarin(chunk : VoxelChunk, spawn_mobs: bool) -> void:
#	chunk.create(int(chunk.size_x) + 1, int(chunk.size_y) + 1, int(chunk.size_z) + 1)
	chunk.set_size(int(chunk.size_x), int(chunk.size_y), int(chunk.size_z), 0, 1)
	
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 10 * current_seed
	noise.octaves = 4
	noise.period = 180.0
	noise.persistence = 0.8
	
	var terr_noise : OpenSimplexNoise = OpenSimplexNoise.new()
	terr_noise.seed = 10 * 321 + 112 * current_seed
	terr_noise.octaves = 4
	terr_noise.period = 20.0
	terr_noise.persistence = 0.9
	
	var det_noise : OpenSimplexNoise = OpenSimplexNoise.new()
	det_noise.seed = 10 * 3231 + 112 * current_seed
	det_noise.octaves = 6
	det_noise.period = 10.0
	det_noise.persistence = 0.3
	
	for x in range(0, chunk.size_x + 1):
		for z in range(0, chunk.size_z + 1):
			var val : float = noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))
			val *= val
			val *= 100
			val += 2
			
			var tv : float = terr_noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))
			tv *= tv * tv
			val += tv * 2
			
			var dval : float = noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))
			
			val += dval * 6
			
			var v : int = (int(val))
			
			v -= chunk.position_y * (chunk.size_y)

			if v > chunk.size_y + 1:
				v = chunk.size_y + 1

			for y in range(0, v):
				seed(x + (chunk.position_x * chunk.size_x) + z + (chunk.position_z * chunk.size_z) + y + (chunk.position_y * chunk.size_y))
				
				if v < 2:
					chunk.set_voxel(1, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				elif v == 2:
					chunk.set_voxel(3, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				else:
					chunk.set_voxel(2, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				
				chunk.set_voxel(int(255.0 * (val - int(val)) / 180.0) * 180, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

#	chunk.build()

	if not Engine.editor_hint and chunk.position_y == 0 and spawn_mobs:
		Entities.spawn_mob(1, randi() % 3, Vector3(chunk.position_x * chunk.size_x * chunk.voxel_scale - chunk.size_x / 2,\
							(chunk.position_y + 1) * chunk.size_y * chunk.voxel_scale, \
							chunk.position_z * chunk.size_z * chunk.voxel_scale - chunk.size_z / 2))

