tool
extends DungeonRoom

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _setup():
	sizex = 5
	sizey = 5
	sizez = 5
	
func _generate_chunk(chunk : VoxelChunk, spawn_mobs: bool) -> void:
	if chunk.position_x != 0 or chunk.position_z != 0:
		return
	
	if chunk.position_y == 0:
		for y in range(chunk.get_size_y()):
			chunk.set_voxel(0, 10, y, 10, VoxelChunk.DEFAULT_CHANNEL_TYPE)
			
	if chunk.position_y == -1:
		var hs : int = chunk.get_size_y() / 2 - sizex / 2
		
		for y in range(chunk.get_size_y() / 2, chunk.get_size_y()):
			chunk.set_voxel(0, 10, y, 10, VoxelChunk.DEFAULT_CHANNEL_TYPE)
			
		for y in range(hs, hs * 2):
			for x in range(hs, hs * 2):
				for z in range(hs, hs * 2):
					chunk.set_voxel(0, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)

