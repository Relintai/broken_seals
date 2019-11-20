extends VoxelChunk
class_name CubicVoxelChunk

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

var lod_data : Array = [
		1, #CHUNK_INDEX_UP
		1, #CHUNK_INDEX_DOWN
		1, #CHUNK_INDEX_LEFT
		1, #CHUNK_INDEX_RIGHT
		1, #CHUNK_INDEX_FRONT
		1 #CHUNK_INDEX_BACK
]

func _create_mesher():
	mesher = VoxelMesherCubic.new()
#	mesher = CubicVoxelMesher.new()
#	mesher.base_light_value = 0.45
#	mesher.ao_strength = 0.05
#	mesher.ao_strength = 0.2
