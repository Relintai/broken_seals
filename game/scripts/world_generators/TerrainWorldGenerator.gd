tool
extends TerrainLevelGenerator
class_name TerrainWorldGenerator

# Copyright (c) 2019-2021 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(int) var _level_seed : int
export(bool) var _spawn_mobs : bool
export(Resource) var world_gen_world : Resource = null

var _world : TerrainWorld
var _library : TerrainLibrary

func setup(world : TerrainWorld, level_seed : int, spawn_mobs : bool, library: TerrainLibrary) -> void:
	_level_seed = level_seed
	_spawn_mobs = spawn_mobs
	_library = library
	
	if world_gen_world != null:
		world_gen_world.setup_terra_library(_library, _level_seed)
		_library.refresh_rects()

func get_spawn_chunk_position() -> Vector2:
	if world_gen_world != null:
		var spawners : Array = world_gen_world.get_spawn_positions()
		
		if spawners.size() > 0:
			var v : Vector2 = spawners[0][1]
			return v
		
	return Vector2()

func _generate_chunk(chunk : TerrainChunk) -> void:
	if world_gen_world == null:
		return
	
	world_gen_world.generate_terra_chunk(chunk, _level_seed, _spawn_mobs)
