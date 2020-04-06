extends VoxelMesherUVTransvoxel
class_name TVVoxelMesher

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


const TEXTURE_SCALE = 4

func get_voxel_type_array(chunk : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> Array:
	var arr : Array = [
		chunk.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE),
		chunk.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	]

	return arr

func get_case_code_from_arr(data : Array) -> int:
	var case_code : int = 0
	
	if (data[0] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_000
		
	if (data[1] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_010
		
	if (data[2] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_001
		
	if (data[3] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_011
		
	if (data[4] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_100
		
	if (data[5] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_110
		
	if (data[6] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_101
		
	if (data[7] != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_111
		
	return case_code

func get_case_code(chunk : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> int:
	var case_code : int = 0
	
	if (chunk.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_000
		
	if (chunk.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_010
		
	if (chunk.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_001
		
	if (chunk.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_011
		
	if (chunk.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_100
		
	if (chunk.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_110
		
	if (chunk.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_101
		
	if (chunk.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_111
		
	return case_code
	
func get_voxel_type(chunk : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> int:
	var type : int = 0
	
	type = chunk.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = chunk.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = chunk.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = chunk.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
	
	type = chunk.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)

	if type != 0:
		return type
			
	type = chunk.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = chunk.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	if type != 0:
		return type
		
	type = chunk.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE)
	
	return type
	
func n_add_chunk(chunk : VoxelChunk) -> void:
	chunk.generate_ao()
	
	var x_size : int = chunk.get_size_x()
	var y_size : int = chunk.get_size_y()
	var z_size : int = chunk.get_size_z()
	
	for y in range(0, y_size, lod_size):
		for z in range(0, z_size, lod_size):
			for x in range(0, x_size, lod_size):
				
				var type_arr : Array = get_voxel_type_array(chunk, x, y, z, lod_size)
				var case_code : int = get_case_code_from_arr(type_arr)
				
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
				
				var carr : Dictionary = Dictionary()
				
				for t in type_arr:
					if carr.has(t):
						carr[t] += 1
					else:
						carr[t] = 1

				var type_id1 : int = -1
				var type_id1c : int = -1
				var type_id2 : int = -1
				var type_id2c : int = -1
				
				for k in carr.keys():
					if k == 0:
						continue
					
					var c : int = carr[k]
					
					if type_id1c == -1:
						type_id1 = k
						type_id1c = c
						continue
						
					if c > type_id1c:
						type_id1 = k
						type_id1c = c
						
				for k in carr.keys():
					if k == 0:
						continue
						
					var c : int = carr[k]
					
					if type_id2c == -1:
						type_id2 = k
						type_id2c = c
						continue

					if c > type_id2c and k != type_id1:
						type_id2 = k
						type_id2c = c
				
				var surface_ratio : float = 1
				
				if type_id1 != type_id2:
					surface_ratio = float(type_id1c) / float(type_id2c) / 8.0
					
				var surface1 : VoxelSurface = library.get_voxel_surface(type_id1)
				var surface2 : VoxelSurface = library.get_voxel_surface(type_id2)
				
#				if type_id1 == 0:
#					print(type_id1)
#
#				if type_id2 == 0:
#					print("asd" + str(type_id2))
				
				for i in range(vertex_count):
					var fv : int = get_regular_vertex_data_first_vertex(case_code, i)
					var sv : int = get_regular_vertex_data_second_vertex(case_code, i)
					
					var offs0 : Vector3 = corner_id_to_vertex(fv) * lod_size
					var offs1 : Vector3 = corner_id_to_vertex(sv) * lod_size
					
					var type : int = chunk.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_TYPE)

					var fill : int = 0
					
					var vert_pos : Vector3
					var vert_dir : Vector3
					
					if type == 0:
						fill = chunk.get_voxel(int(x + offs1.x), int(y + offs1.y), int(z + offs1.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)

						vert_pos = get_regular_vertex_second_position(case_code, i)
						vert_dir = get_regular_vertex_first_position(case_code, i)
					else:
						fill = chunk.get_voxel(int(x + offs0.x), int(y + offs0.y), int(z + offs0.z), VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL)
					
						vert_pos = get_regular_vertex_first_position(case_code, i)
						vert_dir = get_regular_vertex_second_position(case_code, i)
					
					vert_dir = vert_dir - vert_pos

					vert_pos += vert_dir * (fill / 256.0)
					
					temp_verts.append(vert_pos)
					
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
					
					if (bx + 0.0001 > by and bx + 0.0001 > bz):
						var uv : Vector2 = Vector2(s.x, t.x)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
					
						add_uv(surface1.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
						add_uv2(surface2.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
					elif (bz + 0.0001 > bx and bz + 0.0001 > by):
						var uv : Vector2 = Vector2(s.z, t.z)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
						
						add_uv(surface1.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
						add_uv2(surface2.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_SIDE, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
					else:
						var uv : Vector2 = Vector2(s.y, t.y)
						var umargin : Rect2 = uv_margin
						uv.x *= umargin.size.x
						uv.y *= umargin.size.y
						
						uv.x += umargin.position.x
						uv.y += umargin.position.y
						
						add_uv(surface1.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_TOP, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
						add_uv2(surface2.transform_uv_scaled(VoxelSurface.VOXEL_SIDE_TOP, uv, x % TEXTURE_SCALE, z % TEXTURE_SCALE, TEXTURE_SCALE))
						
				for i in range(len(temp_verts)):
					var vert_pos : Vector3 = temp_verts[i] as Vector3
					
					vert_pos *= float(lod_size)
					vert_pos += Vector3(x, y, z)
					
					var normal : Vector3 = temp_normals[i] as Vector3
					
					#var vpx : int = int(vert_pos.x)
					#var vpy : int = int(vert_pos.y)
					#var vpz : int = int(vert_pos.z)
					
					add_color(Color(1, 1, 1, surface_ratio))
					vert_pos *= float(voxel_scale)
					
					add_normal(normal)
					add_vertex(vert_pos)
					
					
