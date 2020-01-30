tool
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

export(Array, MeshDataResource) var meshes : Array

export(bool) var editor_generate : bool = false setget set_editor_generate, get_editor_generate
export(bool) var show_loading_screen : bool = true
export(bool) var generate_on_ready : bool = false

var initial_generation : bool = true

var spawned : bool = false

var _editor_generate : bool

var _player_file_name : String
var _player : Entity

func _ready():
	if generate_on_ready and not Engine.is_editor_hint():
		
		if level_generator != null:
			level_generator.setup(self, 80, false, library)
		
		spawn()

#func _process(delta : float) -> void:
#	if not generation_queue.empty():
#		var chunk : VoxelChunk = generation_queue.front()

#		refresh_chunk_lod_level_data(chunk)

#		level_generator.generate_chunk(chunk)

#		generation_queue.remove(0)
#
#		if generation_queue.empty():
#			emit_signal("generation_finished")
#			initial_generation = false
#
#			if show_loading_screen and not Engine.editor_hint:
#				get_node("..").hide_loading_screen()

func _generation_finished():
	initial_generation = false
	
#	for i in range(get_chunk_count()):
#		get_chunk_index(i).draw_debug_voxels(555555)
			
	if show_loading_screen and not Engine.editor_hint:
		get_node("..").hide_loading_screen()
		
	#TODO hack, do this properly
	if _player:
		_player.set_physics_process(true)

func _prepare_chunk_for_generation(chunk):
	refresh_chunk_lod_level_data(chunk)

func refresh_chunk_lod_level_data(chunk : VoxelChunk) -> void:
	var cpx : int = chunk.position_x
	var cpy : int = chunk.position_y
	var cpz : int = chunk.position_z
	
	var chunk_lod : int = chunk.lod_size
	
	var carr : Array = [
		get_chunk_lod_level(cpx, cpy + 1, cpz, chunk_lod), #CHUNK_INDEX_UP
		get_chunk_lod_level(cpx, cpy - 1, cpz, chunk_lod), #CHUNK_INDEX_DOWN
		get_chunk_lod_level(cpx + 1, cpy, cpz, chunk_lod), #CHUNK_INDEX_LEFT
		get_chunk_lod_level(cpx - 1, cpy, cpz, chunk_lod), #CHUNK_INDEX_RIGHT
		get_chunk_lod_level(cpx, cpy, cpz - 1, chunk_lod), #CHUNK_INDEX_FRONT
		get_chunk_lod_level(cpx, cpy, cpz + 1, chunk_lod) #CHUNK_INDEX_BACK
	]
	
	chunk.lod_data = carr
				

func get_chunk_lod_level(x : int, y : int, z : int, default : int) -> int:
#	var key : String = str(x) + "," + str(y) + "," + str(z)
	
	var ch : VoxelChunk = get_chunk(x, y, z)
	
	if ch == null:
		return default
	
	return ch.lod_size

func _create_chunk(x : int, y : int, z : int, pchunk : Node) -> VoxelChunk:
	var chunk : VoxelChunk = TVVoxelChunk.new()
	
	chunk.lod_size = 1
	
	return ._create_chunk(x, y, z, chunk)
	
func spawn() -> void:
	for x in range(-chunk_spawn_range, chunk_spawn_range):
		for z in range(-chunk_spawn_range, chunk_spawn_range):
			for y in range(-1, 2):
				create_chunk(x, y, z)

	set_process(true)
	
	
func get_editor_generate() -> bool:
	return _editor_generate
	
func set_editor_generate(value : bool) -> void:
	if value:
		library.refresh_rects()
		
		level_generator.setup(self, current_seed, false, library)
		spawn()
	else:
		spawned = false
		clear()
		
	_editor_generate = value
	
func add_light(x : int, y : int, z : int, size : int, color : Color) -> void:
	var chunkx : int = int(x / chunk_size_x)
	var chunky : int = int(y / chunk_size_y)
	var chunkz : int = int(z / chunk_size_z)
	
	var light : VoxelLight = VoxelLight.new()
	light.color = color
	light.size = size
	light.set_world_position(x, y, z)
	
	for xx in range(chunkx - 1, chunkx + 1):
		for yy in range(chunky - 1, chunky + 1):
			for zz in range(chunkz - 1, chunkz + 1):
				var chunk : VoxelChunk = get_chunk(xx, yy, zz)
				
				if chunk == null:
					continue
				
				chunk.add_voxel_light(light)


func setup_client_seed(pseed : int) -> void:
#	_player_file_name = ""
#	_player = null
	
	Server.sset_seed(pseed)
	
	if level_generator != null:
		level_generator.setup(self, pseed, false, library)
	
	spawn()

func load_character(file_name : String) -> void:
	_player_file_name = file_name
	_player = Entities.load_player(file_name, Vector3(5, 30, 5), 1) as Entity
	#TODO hack, do this properly
	_player.set_physics_process(false)
	
	Server.sset_seed(_player.sseed)
	
	if level_generator != null:
		level_generator.setup(self, _player.sseed, true, library)
	
	spawn()
	
func needs_loading_screen() -> bool:
	return show_loading_screen

func save() -> void:
	if _player == null or _player_file_name == "":
		return

	Entities.save_player(_player, _player_file_name)
