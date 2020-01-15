extends VoxelMesherTransvoxel
class_name TVVoxelMesher

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

var transition_sides : int = 0

const VOXEL_CHUNK_SIDE_FRONT : int = 1 << 0
const VOXEL_CHUNK_SIDE_BACK : int = 1 << 1
const VOXEL_CHUNK_SIDE_LEFT : int = 1 << 2
const VOXEL_CHUNK_SIDE_RIGHT : int = 1 << 3
const VOXEL_CHUNK_SIDE_TOP : int = 1 << 4
const VOXEL_CHUNK_SIDE_BOTTOM : int = 1 << 5

enum {
	CHUNK_INDEX_UP = 0,
	CHUNK_INDEX_DOWN = 1,
	CHUNK_INDEX_LEFT = 2,
	CHUNK_INDEX_RIGHT = 3,
	CHUNK_INDEX_FRONT = 4,
	CHUNK_INDEX_BACK = 5,
}

var lod_data : Array = [
		1, #CHUNK_INDEX_UP
		1, #CHUNK_INDEX_DOWN
		1, #CHUNK_INDEX_LEFT
		1, #CHUNK_INDEX_RIGHT
		1, #CHUNK_INDEX_FRONT
		1 #CHUNK_INDEX_BACK
]

const TEXTURE_SCALE = 2

func get_case_code(buffer : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> int:
	var case_code : int = 0
	
	if (buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_000
		
	if (buffer.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_010
		
	if (buffer.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_001
		
	if (buffer.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_011
		
	if (buffer.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_100
		
	if (buffer.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_110
		
	if (buffer.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_101
		
	if (buffer.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_111
		
	return case_code
	
func get_voxel_type(buffer : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> int:
	var type : int = 0
	
	type = buffer.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = buffer.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = buffer.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = buffer.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
	
	type = buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)

	if type != 0:
		return type
			
	type = buffer.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = buffer.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = buffer.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	return type
	
func _add_chunk(buffer : VoxelChunk) -> void:
	var b : bool = true
	
	for l in lod_data:
		if l != 1:
			b = false
			break
		
	if lod_size == 1 and b:
		add_buffer_normal(buffer)
	else:
		add_buffer_lod(buffer)

func add_buffer_normal(buffer : VoxelChunk) -> void:	
	buffer.generate_ao()
	
	var x_size : int = buffer.get_size_x()
	var y_size : int = buffer.get_size_y()
	var z_size : int = buffer.get_size_z()
	
	for y in range(0, y_size, lod_size):
		for z in range(0, z_size, lod_size):
			for x in range(0, x_size, lod_size):
				
				var case_code : int = get_case_code(buffer, x, y, z, lod_size)
				
				if case_code == 0 or case_code == 255:
					continue

				var regular_cell_class : int = get_regular_cell_class(case_code)

				var cell_data : TransvoxelCellData = get_regular_cell_data(regular_cell_class)

				var index_count : int = cell_data.get_triangle_count() * 3
				var vertex_count : int = cell_data.get_vertex_count()
					
				for i in range(index_count):
					var ind : int = get_vertex_count() + cell_data.get_vertex_index(i)
					add_indices(ind)

				var temp_verts : Array = Array()
				
				var type_id : int = get_voxel_type(buffer, x, y, z, lod_size)
				
				var surface : VoxelSurface = library.get_voxel_surface(type_id)
				
				for i in range(vertex_count):
					var fv : int = get_regular_vertex_data_first_vertex(case_code, i)
					var sv : int = get_regular_vertex_data_second_vertex(case_code, i)
					
					var offs0 : Vector3 = corner_id_to_vertex(fv) * lod_size
					var offs1 : Vector3 = corner_id_to_vertex(sv) * lod_size
					
					var type0 : int = buffer.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_TYPE)
#					var type1 : int = buffer.get_voxel(int(x + offs1.x), int(y + offs1.y), int(z + offs1.z), VoxelChunk.DEFAULT_CHANNEL_TYPE)
					
					var fill : int = 0
					
					var vert_pos : Vector3
					var vert_dir : Vector3
					
					if type0 == 0:
						fill = buffer.get_voxel(int(x + offs1.x), int(y + offs1.y), int(z + offs1.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

						vert_pos = get_regular_vertex_second_position(case_code, i)
						vert_dir = get_regular_vertex_first_position(case_code, i)
					else:
						fill = buffer.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
					
						vert_pos = get_regular_vertex_first_position(case_code, i)
						vert_dir = get_regular_vertex_second_position(case_code, i)
					
					vert_dir = vert_dir - vert_pos

					vert_pos += vert_dir * (fill / 256.0)
					
					temp_verts.append(vert_pos)
					
#					if regular_uv_entries.size() > uvs[i]:
#						add_uv(Vector2(regular_uv_entries[uvs[i]][0], regular_uv_entries[uvs[i]][1]));
					
#					add_uv(Vector2(0, 0))

				var temp_normals : Array = Array()
				
				#warning-ignore:unused_variable
				for i in range(len(temp_verts)):
					temp_normals.append(Vector3())
				
				#generate normals
				for i in range(0, index_count, 3):
						var indices : Array = [
							cell_data.get_vertex_index(i),
							cell_data.get_vertex_index(i + 1),
							cell_data.get_vertex_index(i + 2)
						]
						
						var vertices : Array = [
							temp_verts[indices[0]],
							temp_verts[indices[1]],
							temp_verts[indices[2]],
						]
						
						temp_normals[indices[0]] += (vertices[1] - vertices[0]).cross(vertices[0] - vertices[2])
						temp_normals[indices[1]] += (vertices[2] - vertices[1]).cross(vertices[1] - vertices[0])
						temp_normals[indices[2]] += (vertices[2] - vertices[1]).cross(vertices[2] - vertices[0])

				for i in range(len(temp_verts)):
					temp_normals[i] = (temp_normals[i] as Vector3).normalized()

				for cvi in range(len(temp_verts)):
					var vertex : Vector3 = temp_verts[cvi]
					var normal : Vector3 = temp_normals[cvi]
					
					var s : Vector3 = Vector3()
					var t : Vector3 = Vector3()
					t.x = vertex.z
					t.y = vertex.z
					t.z = vertex.y
					
					s.x = vertex.y
					s.y = vertex.x
					s.z = vertex.x
						
					var bx : float = abs(normal.x)
					var by : float = abs(normal.y)
					var bz : float = abs(normal.z)
					
#					if case_code == 7 and cvi == 0:
#						print(str(bx) + " " + str(by) + " " + str(bz))
#						add_uv(surface.transform_uv(VoxelSurface.VOXEL_SIDE_SIDE, Vector2(s.z, t.z)))

					if (bx + 0.0001 > by and bx + 0.0001 > bz):
						var uv : Vector2 = Vector2(s.x, t.x)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
					
						add_uv(surface.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
					elif (bz + 0.0001 > bx and bz + 0.0001 > by):
						var uv : Vector2 = Vector2(s.z, t.z)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
						
						add_uv(surface.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
					else:
						var uv : Vector2 = Vector2(s.y, t.y)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
						
						add_uv(surface.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_TOP, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))

				for i in range(len(temp_verts)):

					var vert_pos : Vector3 = temp_verts[i] as Vector3
					
					vert_pos *= float(lod_size)
					vert_pos += Vector3(x, y, z)
					
					var normal : Vector3 = temp_normals[i] as Vector3
					
					var vpx : int = int(vert_pos.x)
					var vpy : int = int(vert_pos.y)
					var vpz : int = int(vert_pos.z)
					
					var light : Color = Color(buffer.get_voxel(vpx, vpy, vpz, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R) / 255.0, buffer.get_voxel(vpx, vpy, vpz, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G) / 255.0, buffer.get_voxel(vpx, vpy, vpz, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B) / 255.0)
					var ao : float = (buffer.get_voxel(vpx, vpy, vpz, VoxelChunk.DEFAULT_CHANNEL_AO) / 255.0) * ao_strength
					var rao : float = (buffer.get_voxel(vpx, vpy, vpz, VoxelChunk.DEFAULT_CHANNEL_RANDOM_AO) / 255.0)
					ao += rao
					
					light.r += base_light_value
					light.g += base_light_value
					light.b += base_light_value

					light.r -= ao
					light.g -= ao
					light.b -= ao
						
					light.r = clamp(light.r, 0, 1.0)
					light.g = clamp(light.g, 0, 1.0)
					light.b = clamp(light.b, 0, 1.0)
					
#					if regular_cell_class == 11:
#						print("asd")
#					if case_code == 112 + 2:
##						print(regular_cell_class)
##						print("asd")
#						light.r = 1
#						light.g = 1
#						light.b = 1
						
					
					add_color(light)

					vert_pos *= float(voxel_scale)
					
					add_normal(normal)
					add_vertex(vert_pos)
					
				
#				if case_code == 7:
#
#					#reset
#					set_regular_vertex_data(case_code, 2, 0x3304)
#
#					set_regular_vertex_data(case_code, 3, 0x2315)
#					set_regular_vertex_data(case_code, 4, 0x4113)
#					set_regular_vertex_data(case_code, 5, 0x1326)
#
#					set_regular_vertex_data(case_code, 6, 0x3304)
#					set_regular_vertex_data(case_code, 7, 0x2315)
#					set_regular_vertex_data(case_code, 8, 0x2315)
					
func add_buffer_lod(buffer : VoxelChunk) -> void:
	if lod_data[CHUNK_INDEX_UP] < lod_size:
#		generate_side_lod_mesh(0,   buffer)
		pass

#	CHUNK_INDEX_DOWN = 1,
#	CHUNK_INDEX_LEFT = 2,
#	CHUNK_INDEX_RIGHT = 3,
#	CHUNK_INDEX_FRONT = 4,
#	CHUNK_INDEX_BACK = 5,
	
	#generate_main_lod_mesh(buffer)
	
func generate_side_lod_mesh(sx : int, ex : int, sy : int, ey : int, sz : int, ez : int, buffer : VoxelChunk) -> void:
	pass
	
func generate_main_lod_mesh(buffer : VoxelChunk) -> void:
	buffer.generate_ao()
	
	var x_size : int = buffer.get_size_x() - 1
	var y_size : int = buffer.get_size_y() - 1
	var z_size : int = buffer.get_size_z() - 1
	
	for y in range(0, y_size, lod_size):
		for z in range(0, z_size, lod_size):
			for x in range(0, x_size, lod_size):
				
				var case_code : int = get_case_code(buffer, x, y, z, lod_size)
				
				if case_code == 0 or case_code == 255:
					continue
				
				var regular_cell_class : int = get_regular_cell_class(case_code)

				var cell_data : TransvoxelCellData = get_regular_cell_data(regular_cell_class)

				var index_count : int = cell_data.get_triangle_count() * 3
				var vertex_count : int = cell_data.get_vertex_count()
				
				for i in range(index_count):
					var ind : int = get_vertex_count() + cell_data.get_vertex_index(i)
					add_indices(ind)

				var temp_verts : Array = Array()

				for i in range(vertex_count):
					var fv : int = get_regular_vertex_data_first_vertex(case_code, i)
					var sv : int = get_regular_vertex_data_second_vertex(case_code, i)
					
					var offs0 : Vector3 = corner_id_to_vertex(fv) * lod_size
					var offs1 : Vector3 = corner_id_to_vertex(sv) * lod_size
					
					var type0 : int = buffer.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_TYPE)
#					var type1 : int = buffer.get_voxel(int(x + offs1.x), int(y + offs1.y), int(z + offs1.z), VoxelChunk.DEFAULT_CHANNEL_TYPE)
					
					var fill : int = 0
					
					var vert_pos : Vector3
					var vert_dir : Vector3
					
					if type0 == 0:
						fill = buffer.get_voxel(int(x + offs1.x), int(y + offs1.y), int(z + offs1.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

						vert_pos = get_regular_vertex_second_position(case_code, i)
						vert_dir = get_regular_vertex_first_position(case_code, i)
					else:
						fill = buffer.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
					
						vert_pos = get_regular_vertex_first_position(case_code, i)
						vert_dir = get_regular_vertex_second_position(case_code, i)
					
					vert_dir = vert_dir - vert_pos

					vert_pos += vert_dir * (fill / 256.0)
					
					temp_verts.append(vert_pos)
					
#					if regular_uv_entries.size() > uvs[i]:
#						add_uv(Vector2(regular_uv_entries[uvs[i]][0], regular_uv_entries[uvs[i]][1]));
					
#					add_uv(Vector2(0, 0))

				var temp_normals : Array = Array()
				
				#warning-ignore:unused_variable
				for i in range(len(temp_verts)):
					temp_normals.append(Vector3())
				
				#generate normals
				for i in range(0, index_count, 3):
						var indices : Array = [
							cell_data.get_vertex_index(i),
							cell_data.get_vertex_index(i + 1),
							cell_data.get_vertex_index(i + 2)
						]
						
						var vertices : Array = [
							temp_verts[indices[0]],
							temp_verts[indices[1]],
							temp_verts[indices[2]],
						]
						
						temp_normals[indices[0]] += (vertices[1] - vertices[0]).cross(vertices[0] - vertices[2])
						temp_normals[indices[1]] += (vertices[2] - vertices[1]).cross(vertices[1] - vertices[0])
						temp_normals[indices[2]] += (vertices[2] - vertices[1]).cross(vertices[2] - vertices[0])

				for i in range(len(temp_verts)):
					temp_normals[i] = (temp_normals[i] as Vector3).normalized()

				for cvi in range(len(temp_verts)):
					var vertex : Vector3 = temp_verts[cvi]
					var normal : Vector3 = temp_normals[cvi]
					
					var s : Vector3 = Vector3()
					var t : Vector3 = Vector3()
					t.x = vertex.z
					t.y = vertex.z
					t.z = vertex.y
					
					s.x = vertex.y
					s.y = vertex.x
					s.z = vertex.x
						
					var bx : float = abs(normal.x)
					var by : float = abs(normal.y)
					var bz : float = abs(normal.z)

					if (bx > by and bx > bz):
						add_uv(Vector2(s.x, t.x))
					elif (bz > bx and bz > by):
						add_uv(Vector2(s.z, t.z))
					else:
						add_uv(Vector2(s.y, t.y))

				for i in range(len(temp_verts)):

					var vert_pos : Vector3 = temp_verts[i] as Vector3
					
					vert_pos *= float(lod_size)
					vert_pos += Vector3(x, y, z)
					
					var normal : Vector3 = temp_normals[i] as Vector3
					
					vert_pos *= float(voxel_scale)
					
					add_normal(normal)
					add_vertex(vert_pos)
