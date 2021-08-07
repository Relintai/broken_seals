tool
extends Biome

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

export(PackedScene) var tree : PackedScene
export(PropData) var prop_tree : PropData

var terrarin_gen : BiomeTerrarinGenerator = BiomeTerrarinGenerator.new()

var voxel_scale : float = -1

func _setup():
	terrarin_gen.set_current_seed(current_seed)
	
	for i in range(get_building_count()):
		var d : Building = get_building(i)
		d.setup()
		
func _instance(p_seed, p_instance):
	p_instance.tree = tree
	p_instance.prop_tree = prop_tree
	
	return ._instance(p_seed, p_instance)
		
func _generate_terra_chunk(chunk, spawn_mobs):
	if voxel_scale < 0:
		voxel_scale = chunk.voxel_scale
	
		#todo generate this properly
		var entrance_position : Vector3 = Vector3(7, 5, 7)
	
		for i in range(get_building_count()):
			var d : Building = get_building(i)
			
			if d.has_method("has_entrance_position"):
				d.entrance_position.origin = entrance_position

				entrance_position = d.next_level_teleporter_position_data_space
				entrance_position *= voxel_scale

	#terrarin_gen.generate_simple_terrarin(chunk, spawn_mobs)
	gen_terra_chunk(chunk)
	
	for i in range(get_building_count()):
		get_building(i).generate_terra_chunk(chunk, spawn_mobs)

	if not Engine.editor_hint and spawn_mobs and randi() % 4 == 0:
		var level : int = 1
		
		if chunk.get_voxel_world().has_method("get_mob_level"):
			level  = chunk.get_voxel_world().get_mob_level()

		ESS.entity_spawner.spawn_mob(0, level, \
					Vector3(chunk.position_x * chunk.size_x * chunk.voxel_scale + chunk.size_x / 2,\
							100, \
							chunk.position_z * chunk.size_z * chunk.voxel_scale + chunk.size_z / 2))

func gen_terra_chunk(chunk: TerraChunk) -> void:
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)
	
	var s : FastNoise = FastNoise.new()
	s.set_noise_type(FastNoise.TYPE_SIMPLEX)
	s.set_seed(current_seed)
	
	var sdet : FastNoise = FastNoise.new()
	sdet.set_noise_type(FastNoise.TYPE_SIMPLEX)
	sdet.set_seed(current_seed)
	
	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			var vx : int = x + (chunk.position_x * chunk.size_x)
			var vz : int = z + (chunk.position_z * chunk.size_z)
			
			var val : float = (s.get_noise_2d(vx * 0.05, vz * 0.05) + 2)
			val *= val
			val *= 20.0
			val += abs(sdet.get_noise_2d(vx * 0.8, vz * 0.8)) * 20

			chunk.set_voxel(val, x, z, TerraChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)

			if val < 50:
				chunk.set_voxel(2, x, z, TerraChunkDefault.DEFAULT_CHANNEL_TYPE)
			elif val > 90:
				chunk.set_voxel(4, x, z, TerraChunkDefault.DEFAULT_CHANNEL_TYPE)
			else:
				#Todo use the prop system for this
				if randf() > 0.992:
#					var t = tree.instance()
#
#					var spat : Spatial = t as Spatial
#
#					spat.rotate(Vector3(0, 1, 0), randf() * PI)
#					spat.rotate(Vector3(1, 0, 0), randf() * 0.2 - 0.1)
#					spat.rotate(Vector3(0, 0, 1), randf() * 0.2 - 0.1)
#					spat.transform = spat.transform.scaled(Vector3(0.9 + 0.8 - randf(), 0.9 + 0.8 - randf(), 0.9 + 0.8 - randf()))
#					spat.transform.origin = Vector3((x + chunk.position_x * chunk.size_x) * chunk.voxel_scale, ((val - 2) / 255.0) * chunk.world_height * chunk.voxel_scale, (z + chunk.position_z * chunk.size_z) * chunk.voxel_scale)
#					chunk.voxel_world.call_deferred("add_child", spat)
					
					
					var tr : Transform = Transform()
					
					tr = tr.rotated(Vector3(0, 1, 0), randf() * PI)
					tr = tr.rotated(Vector3(1, 0, 0), randf() * 0.2 - 0.1)
					tr = tr.rotated(Vector3(0, 0, 1), randf() * 0.2 - 0.1)
					tr = tr.scaled(Vector3(0.9 + randf() * 0.2, 0.9 + randf() * 0.2, 0.9 + randf() * 0.2))
					tr.origin = Vector3((x + chunk.position_x * chunk.size_x), ((val - 2) / 255.0) * chunk.world_height, (z + chunk.position_z * chunk.size_z))

					chunk.voxel_world.prop_add(tr, prop_tree)
					
