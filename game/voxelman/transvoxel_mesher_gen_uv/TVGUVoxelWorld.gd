extends VoxelWorld

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

enum GenType {
	TEST, NORMAL, NOISE3D
}

signal generation_finished

export(int) var gen_type : int = GenType.NORMAL

export(Array, MeshDataResource) var meshes : Array

var chunks : Dictionary = Dictionary()
var spawned : bool = false

var generation_queue : Array

func _ready() -> void:
	spawn()

func _process(delta : float) -> void:
	if not generation_queue.empty():
		var chunk : VoxelChunk = generation_queue.front()
		
		if gen_type == GenType.NORMAL:
#			
			generate_terrarin(chunk)
		elif gen_type == GenType.NOISE3D:
#			generate(chunk)
			pass
		else:
			generate_test(chunk)
			
		generation_queue.remove(0)
		
		if generation_queue.empty():
			emit_signal("generation_finished")

func generate_terrarin(chunk : VoxelChunk) -> void:
	var buffer : VoxelChunk = chunk.get_buffer()
	buffer.create(int(chunk_size_x) + 3, int(chunk_size_y) + 3, int(chunk_size_z) + 3)
	
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 10
	noise.octaves = 4
	noise.period = 200.0
	noise.persistence = 0.8
	
	var terr_noise : OpenSimplexNoise = OpenSimplexNoise.new()
	terr_noise.seed = 10 * 321 + 112
	terr_noise.octaves = 4
	terr_noise.period = 20.0
	terr_noise.persistence = 0.9
	
	for x in range(-1, chunk_size_x + 2):
		for z in range(-1, chunk_size_z + 2):
			var val : float = noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))
			val *= val
			val *= 100
			val += 2
			
			var tv : float = terr_noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))
			val += tv * 2
			
			var v : int = (int(val))

			for y in range(-1, v):
				seed(x + (chunk.position_x * chunk.size_x) + z + (chunk.position_z * chunk.size_z) + y)
				buffer.set_voxel(1, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				buffer.set_voxel(randi() % 50 + 205, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
				
				seed(x + (chunk.position_x * chunk.size_x) + z + (chunk.position_z * chunk.size_z) + y + 1)
				buffer.set_voxel(1, x + 1, y + 2, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				buffer.set_voxel(randi() % 50 + 205, x + 1, y + 2, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
				
	for i in range(5):
		var light : VoxelLight = VoxelLight.new()
		randomize()
		light.color = Color(randf(), randf(), randf())
		light.size = randi() % 5 + 5
		light.set_world_position((chunk.position_x * chunk.size_x) + (randi() % chunk.size_x), (chunk.position_y * chunk.size_y) + (randi() % 6), (chunk.position_z * chunk.size_z) + (randi() % chunk.size_z))
		chunk.add_voxel_light(light)
	

#	var light : VoxelLight = VoxelLight.new()
#	light.color = Color(1.0, 0, 0)
#	light.size = 10
#	light.set_world_position((chunk.position_x * chunk.size_x) + (2), (chunk.position_y * chunk.size_y) + (7), (chunk.position_z * chunk.size_z) + (1))
#	chunk.add_voxel_light(light)

#	for x in range(16):
#		for z in range(16):	
	
#	chunk.add_prop(Transform(Basis().scaled(Vector3(0.2, 0.2, 0.2)), Vector3(2, 5, 0) * voxel_scale), meshes[0])

#	chunk.add_prop(Transform(Basis(), Vector3(4, 3, 5) * voxel_scale), meshes[0])
	
	chunk.bake_lights()
	
	chunk.build()
#	chunk.draw_debug_voxels(2000)
#	chunk.draw_debug_voxel_lights()


func spawn_chunk(x : int, y : int, z : int, lod_size : int = 1) -> void:
	var name : String = "Chunk," + str(x) + "," + str(y) + "," + str(z)
#	var chunk : VoxelChunk = VoxelChunk.new()
	var chunk : VoxelChunk = TVGUVoxelChunk.new()
	
	chunk.voxel_world = self
	chunk.set_chunk_position(x, y, z)
	chunk.library = library
	chunk.voxel_scale = voxel_scale
	chunk.lod_size = lod_size
	chunk.set_chunk_size(int(chunk_size_x), int(chunk_size_y), int(chunk_size_z))
	
	chunk.create_mesher()
	chunk.mesher.base_light_value = 0.6

	chunks[name] = chunk
	
	generation_queue.append(chunk)


func spawn() -> void:
	var hsize : int = 4
	
	if gen_type == GenType.NORMAL or gen_type == GenType.NOISE3D:
		for x in range(-hsize, hsize):
			for z in range(-hsize, hsize):
				for y in range(1):
#					spawn_chunk(x, y, z, abs(int(ceil(x / 2))) + 1)
					spawn_chunk(x, y, z, 1)
	else:
		spawn_chunk(0, 0, 0, 1)
	
#func set_player(p_player : Spatial) -> void:
#	player = p_player
	
#	if _spawned:
#		clear()
#
#	spawn()
#	pass
	
func generate_test(chunk : VoxelChunk) ->void:
	var buffer : VoxelChunk = chunk.get_buffer()
	
	buffer.create(40, 40, 40)
	
	var i : int = 1

	for y in range(4):
		for z in range(8):
			for x in range(8):
				spawn_equiv_class(buffer, i, x * 4 + 1, y * 4 + 1, z * 4 + 1)
				i += 1

#	spawn_equiv_class(buffer,127, 4, 4, 4)

	chunk.build()
	chunk.draw_debug_voxels(2000)
#	chunk.draw_debug_voxel_lights()
	
	
func spawn_equiv_class(buffer : VoxelChunk, cls : int, x : int, y : int, z : int) -> void:
	
	
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_000:
		buffer.set_voxel(1, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_100:
		buffer.set_voxel(1, x + 1, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x + 1, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_001:
		buffer.set_voxel(1, x, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_101:
		buffer.set_voxel(1, x + 1, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x + 1, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_010:
		buffer.set_voxel(1, x, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_110:
		buffer.set_voxel(1, x + 1, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x + 1, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_011:
		buffer.set_voxel(1, x, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherTransvoxel.VOXEL_ENTRY_MASK_111:
		buffer.set_voxel(1, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(255, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	

	
