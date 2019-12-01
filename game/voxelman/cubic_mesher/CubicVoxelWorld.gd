extends VoxelWorld

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

# Copyright (c) 2019 Péter Magyar

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
	TEST, NORMAL
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
#			generate(chunk)
			pass
		else:
			generate_terrarin(chunk)
			
		generation_queue.remove(0)
		
		if generation_queue.empty():
			emit_signal("generation_finished")

func generate_terrarin(chunk : VoxelChunk) -> void:
	var buffer : VoxelChunk = chunk.get_buffer()
	buffer.create(int(size_x) + 3, int(size_y) + 3, int(size_z) + 3)
	
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
	
	for x in range(-1, size_x + 2):
		for z in range(-1, size_z + 2):
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
				buffer.set_voxel(randi() % 200 + 55, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
				
				seed(x + (chunk.position_x * chunk.size_x) + z + (chunk.position_z * chunk.size_z) + y + 1)
				buffer.set_voxel(1, x + 1, y + 2, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				buffer.set_voxel(randi() % 200 + 55, x + 1, y + 2, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
				
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
	chunk.draw_debug_voxel_lights()


func spawn_chunk(x : int, y : int, z : int, lod_size : int = 1) -> void:
	var name : String = "Chunk," + str(x) + "," + str(y) + "," + str(z)
	var chunk : VoxelChunk = VoxelChunk.new()
#	var chunk : VoxelChunk = MarchingCubesVoxelChunk.new()
	
	chunk.voxel_world = self
	chunk.set_chunk_position(x, y, z)
	chunk.library = library
	chunk.voxel_scale = voxel_scale
	chunk.lod_size = lod_size
	chunk.set_chunk_size(int(size_x), int(size_y), int(size_z))
	
	chunk.create_mesher()
	chunk.mesher.base_light_value = 0.6

	chunks[name] = chunk
	
	generation_queue.append(chunk)


func spawn() -> void:
	var hsize : int = 4
	
#	if gen_type == GenType.NORMAL:
	for x in range(-hsize, hsize):
		for z in range(-hsize, hsize):
			for y in range(1):
#				spawn_chunk(x, y, z, abs(int(ceil(x / 2))) + 1)
				spawn_chunk(x, y, z, 1)
	
#func set_player(p_player : Spatial) -> void:
#	player = p_player
	
#	if _spawned:
#		clear()
#
#	spawn()
#	pass
	
