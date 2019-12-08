tool
extends DungeonRoom

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _setup():
	sizex = 4
	sizey = 4
	sizez = 4
	
func _generate_chunk(chunk : VoxelChunk, spawn_mobs: bool) -> void:
	if chunk.position_x != 0 or chunk.position_z != 0:
		return
	
	var hs : int = chunk.get_size_y() / 2 - sizex / 2
	
	if chunk.position_y == 0:
		for y in range(0, 4):
			for x in range(-4, 5):
				for z in range(-4, 5):
					if chunk.get_voxel(hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0:
						chunk.set_voxel(4, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
						
		
		for x in range(-5, 5):
			for z in  [-5, 4]:
				for y in range(0, randi() % 5):
					if chunk.get_voxel(hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE) == 0:
						chunk.set_voxel(4, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
						chunk.set_voxel(10, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
						
		for x in [-5, 5]:
			for z in range(-5, 4):
				for y in range(0, randi() % 5):
					if chunk.get_voxel(hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE) == 0:
						chunk.set_voxel(4, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					chunk.set_voxel(10, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
#		var num  : int = randi() % 10 + 7
#		for i in range(num):
#			var x : int = randi() % 12 - 6
#			var z : int = randi() % 12 - 6
#
#			for y in range(4, 1, -1):
#				if chunk.get_voxel(hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0:
#					chunk.set_voxel(1, hs + x, y + 1, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
#					chunk.set_voxel(100, hs + x, y + 1, hs + z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#					break
		
		for y in range(chunk.data_size_y):
			for x in range(0, 2):
				for z in range(0, 2):
					chunk.set_voxel(0, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					
		for y in range(3, chunk.get_size_y() / 2):
			chunk.set_voxel(4, hs, y, hs, VoxelChunk.DEFAULT_CHANNEL_TYPE)
			chunk.set_voxel((16 - y) * 8, hs, y, hs, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
			
	if chunk.position_y == -1:
		for y in range(chunk.get_size_y() - sizey - 1, chunk.get_size_y()):
			for x in range(hs - 1, hs + sizex + 1):
				for z in range(hs - 1, hs  + sizez + 1):
					chunk.set_voxel(4, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					chunk.set_voxel(255, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
					
		for y in range(chunk.get_size_y() - sizey + 1, chunk.data_size_y):
			for x in range(0, 2):
				for z in range(0, 2):
					chunk.set_voxel(0, hs + x, y, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					

		for y in range(chunk.get_size_y() - sizey, chunk.get_size_y() - 1):
			for x in range(hs, hs + sizex):
				for z in range(hs, hs  + sizez):
					chunk.set_voxel(0, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					
		for x in range(0, 2):
			for z in range(0, 2):
				chunk.set_voxel(3, hs + x, chunk.get_size_y() - sizey, hs + z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				chunk.set_voxel(30, x, chunk.get_size_y() - sizey, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
					

