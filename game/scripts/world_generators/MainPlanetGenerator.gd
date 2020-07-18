tool
extends VoxelmanLevelGenerator
class_name MainPlanetGenerator

# Copyright (c) 2019-2020 Péter Magyar
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

const planet_folder : String = "res://modules/planets"

export(int) var _force_planet : int = -1
export(int) var _level_seed : int
export(bool) var _spawn_mobs : bool
export(PlanetData) var planet : PlanetData = null

var _world : VoxelWorld
var _planet : Planet
var _library : VoxelmanLibrary

func setup(world : VoxelWorld, level_seed : int, spawn_mobs : bool, library: VoxelmanLibrary) -> void:
	_level_seed = level_seed
	_world = world
	_spawn_mobs = spawn_mobs
	_library = library
	
	if planet != null:
		_planet = planet.instance()
		_planet.current_seed = _level_seed
		_planet.setup()
		
#		This crashes, still need to figure out why
#		_planet.setup_library(_library)
	
#	create_planet()
	
func _generate_chunk(chunk : VoxelChunk) -> void:
	if _planet == null:
		return
	
	_planet.generate_chunk(chunk, _spawn_mobs)

func create_planet():
	var planet_files : Array = get_planets(planet_folder)
	
	if planet_files.size() == 0:
		return
	
	var ind : int
	if _force_planet == -1:
		seed(_level_seed)
		ind = randi() % planet_files.size()
	else:
		ind = _force_planet
	
	var planet_data : PlanetData = ResourceLoader.load(planet_files[ind], "PlanetData")
	
	if planet_data == null:
		print("planet_data is null!")
		return
		
	print("planet loaded: " + planet_data.resource_path)

	_planet = planet_data.instance()
		
	_planet.current_seed = _level_seed
	_planet.data = planet_data
	_planet.setup()
	_planet.setup_library(_library)

func get_planets(path : String, root : bool = true) -> Array:
	var planet_files : Array = Array()
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir():
				planet_files.append(path + "/" + file_name)
			else:
				if root:
					var l : Array = get_planets(path + "/" + file_name, false)
					
					for i in l:
						planet_files.append(i)

			file_name = dir.get_next()
			
	return planet_files
