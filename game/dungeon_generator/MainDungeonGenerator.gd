tool
extends VoxelmanLevelGenerator
class_name MainDungeonGenerator

enum GenType {
	TEST = 0, NORMAL = 1, NOISE3D = 2, ANL = 3
}


export(MeshDataResource) var prop_mesht : MeshDataResource


export(int) var gen_type : int = GenType.NORMAL
export(int) var _level_seed : int
export(bool) var _spawn_mobs : bool

var _world : VoxelWorld

func setup(world : VoxelWorld, level_seed : int, spawn_mobs : bool) -> void:
	_level_seed = level_seed
	_world = world
	_spawn_mobs = spawn_mobs
	
func _generate_chunk(chunk : VoxelChunk) -> void:
	if gen_type == GenType.NORMAL:
		generate_terrarin(chunk)
	elif gen_type == GenType.NOISE3D:
		generate_noise3d_terrarin(chunk)
	else:
		generate_test(chunk)
			

func generate_terrarin(chunk : VoxelChunk) -> void:
	var buffer : VoxelChunk = chunk.get_buffer()
	buffer.create(int(chunk.size_x) + 1, int(chunk.size_y) + 1, int(chunk.size_z) + 1)
	
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 10 * _level_seed
	noise.octaves = 4
	noise.period = 180.0
	noise.persistence = 0.8
	
	var terr_noise : OpenSimplexNoise = OpenSimplexNoise.new()
	terr_noise.seed = 10 * 321 + 112 * _level_seed
	terr_noise.octaves = 4
	terr_noise.period = 20.0
	terr_noise.persistence = 0.9
	
	var det_noise : OpenSimplexNoise = OpenSimplexNoise.new()
	det_noise.seed = 10 * 3231 + 112 * _level_seed
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
#			var cmaxy : int = (chunk.position_y + 1) * chunk.size_y
			
			if v > chunk.size_y + 1:
				v = chunk.size_y + 1

			for y in range(0, v):
				seed(x + (chunk.position_x * chunk.size_x) + z + (chunk.position_z * chunk.size_z) + y + (chunk.position_y * chunk.size_y))
				
				if v < 2:
					buffer.set_voxel(1, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				elif v == 2:
					buffer.set_voxel(3, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				else:
					buffer.set_voxel(2, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
				
#				if y != v:
#					buffer.set_voxel(255, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#				else:
#					randi() % 50 + 205
				buffer.set_voxel(int(255.0 * (val - int(val)) / 180.0) * 180, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#				buffer.set_voxel(int(255.0 * (val - int(val))), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

#				buffer.set_voxel(255.0 * int(90 * (val - int(val))) / 200.0, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#				buffer.set_voxel(int(255.0 * (val - int(val)) / 180.0) * 180, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#				buffer.set_voxel(int(255.0 * (int((val - int(val) * 100.0)) / 100.0)), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
#				print(val)
#				buffer.set_voxel(int(255.0 * (val - int(val))), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

#	var t_noise : OpenSimplexNoise = OpenSimplexNoise.new()
#	t_noise.seed = 10 * 32331 + 1132
#	t_noise.octaves = 10
#	t_noise.period = 10.0
#	t_noise.persistence = 0.8
#
#	for x in range(0, chunk.size_x + 1):
#		for y in range(0, chunk.size_y + 1):
#			for z in range(0, chunk.size_z + 1):
#				var val : float = t_noise.get_noise_3d(
#					x + (chunk.position_x * chunk.size_x), 
#					y + (chunk.position_y * chunk.size_y), 
#					z + (chunk.position_z * chunk.size_z))
#
#				val *= val
#				val *= 100
#				val += 2
#
#				if val > 3 and buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) == 0:
#					buffer.set_voxel(2, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
#					buffer.set_voxel(int(255.0 * (val - int(val))), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

#	for x in range(0, chunk.size_x + 1):
#		for z in range(5, 7):
#			for y in range(0, 10):
#				var val : float = det_noise.get_noise_3d(
#					x + (chunk.position_x * chunk.size_x),
#					y + (chunk.position_y * chunk.size_y),
#					z + (chunk.position_z * chunk.size_z))
#
#				val *= 10
#
#				if val > 1:
#					val = 1
#
#				buffer.set_voxel(3, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
#
#				buffer.set_voxel(int(255.0 * val), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
#	var prop_data : VoxelChunkPropData = VoxelChunkPropData.new()
#	prop_data.x = 10
#	prop_data.y = 3
#	prop_data.z = 10
##	prop_data.rotation = Vector3(randi() % 360, randi() % 360, randi() % 360)
##	prop_data.scale = Vector3(2, 2, 2)
##	prop_data.mesh = prop_mesht
#	prop_data.prop = prop
	
#	chunk.add_prop(prop_data)

#	generate_caves(chunk)

	
#	for i in range(5):
#		#var light : VoxelLight = VoxelLight.new()
#		randomize()
#		var color : Color = Color(randf(), randf(), randf())
#		var size : int = randi() % 5 + 5
#		var lx : int = (chunk.position_x * chunk.size_x) + (randi() % (chunk.size_x - 3))
#		var ly : int = (chunk.position_y * chunk.size_y) + (randi() % 6)
#		var lz : int = (chunk.position_z * chunk.size_z) + (randi() % (chunk.size_z - 3))
##		light.set_world_position((chunk.position_x * chunk.size_x) + 10, (chunk.position_y * chunk.size_y) + 10, (chunk.position_z * chunk.size_z) + 10)
#		_world.add_light(lx, ly, lz, size, color)
	
#	chunk.bake_lights()
	
	chunk.build()
#	chunk.draw_debug_voxel_lights()
#	chunk.draw_debug_voxels(2000)
#	chunk.draw_debug_voxel_lights()

	if not Engine.editor_hint and chunk.position_y == 0 and _spawn_mobs:
		ESS.entity_spawner.spawn_mob(1, randi() % 3, Vector3(chunk.position_x * chunk.size_x * chunk.voxel_scale - chunk.size_x / 2,\
							(chunk.position_y + 1) * chunk.size_y * chunk.voxel_scale, \
							chunk.position_z * chunk.size_z * chunk.voxel_scale - chunk.size_z / 2))

func generate_caves(chunk : VoxelChunk) -> void:
	var buffer : VoxelChunk = chunk.get_buffer()

	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 1230 * 3241 + 16
	noise.octaves = 3
	noise.period = 20.0
	noise.persistence = 0.9

	for x in range(0, chunk.size_x + 1):
		for z in range(0, chunk.size_z + 1):
			for y in range(0, chunk.size_y + 1):
#				var val : float = noise.get_noise_2d(x + (chunk.position_x * chunk.size_x), z + (chunk.position_z * chunk.size_z))


				buffer.set_voxel(0, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)


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
#	chunk.draw_debug_voxels(2000)
#	chunk.draw_debug_voxel_lights()
	
	
func spawn_equiv_class(buffer : VoxelChunk, cls : int, x : int, y : int, z : int) -> void:
#	var size : int = 100
	
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_000:
		buffer.set_voxel(1, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_100:
		buffer.set_voxel(1, x + 1, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x + 1, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_001:
		buffer.set_voxel(1, x, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_101:
		buffer.set_voxel(1, x + 1, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x + 1, y, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_010:
		buffer.set_voxel(1, x, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_110:
		buffer.set_voxel(1, x + 1, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x + 1, y + 1, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_011:
		buffer.set_voxel(1, x, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
		
	if cls & VoxelMesherUVTransvoxel.VOXEL_ENTRY_MASK_111:
		buffer.set_voxel(1, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_TYPE)
		buffer.set_voxel(randi() % 255, x + 1, y + 1, z + 1, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
func generate_noise3d_terrarin(chunk : VoxelChunk) -> void:
	var buffer : VoxelChunk = chunk.get_buffer()
	buffer.create(int(chunk.size_x) + 1, int(chunk.size_y) + 1, int(chunk.size_z) + 1)
	
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = 10 * 321 + 112
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.9

	for x in range(0, chunk.size_x + 1):
		for y in range(0, chunk.size_y + 1):
			for z in range(0, chunk.size_z + 1):
				var val : float = noise.get_noise_3d(
					x + (chunk.position_x * chunk.size_x), 
					y + (chunk.position_y * chunk.size_y), 
					z + (chunk.position_z * chunk.size_z))
				
				val *= val
				val *= 100
				val += 2
				
				if val > 4:
					buffer.set_voxel(3, x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
					buffer.set_voxel(int(255.0 * (val - int(val))), x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
	
#	generate_random_ao(chunk)
	#warning-ignore:unused_variable
#	for i in range(5):
#		#var light : VoxelLight = VoxelLight.new()
#		randomize()
#		var color : Color = Color(randf(), randf(), randf())
#		var size : int = randi() % 5 + 5
#		var lx : int = (chunk.position_x * chunk.size_x) + (randi() % (chunk.size_x - 3))
#		var ly : int = (chunk.position_y * chunk.size_y) + (randi() % 6)
#		var lz : int = (chunk.position_z * chunk.size_z) + (randi() % (chunk.size_z - 3))
##		light.set_world_position((chunk.position_x * chunk.size_x) + 10, (chunk.position_y * chunk.size_y) + 10, (chunk.position_z * chunk.size_z) + 10)
#		_world.add_light(lx, ly, lz, size, color)
	
	chunk.bake_lights()
	
	chunk.build()

