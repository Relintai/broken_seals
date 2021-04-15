extends VoxelMesherCubic
class_name GDCubicVoxelMesher

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

# Copyright (c) 2019-2021 Péter Magyar

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

var count : int = 0

func _add_chunk(chunk : VoxelChunk) -> void:
	chunk.generate_ao();
	
	var x_size : int = chunk.get_size_x() - 1
	var y_size : int = chunk.get_size_y() - 1
	var z_size : int = chunk.get_size_z() - 1
	
	var lod_size : float = 1
	var voxel_size : float = 1
	
	var cube_points : VoxelCubePoints = VoxelCubePoints.new()
	
	var tile_uv_size : float = 1/4.0
	var base_light : Color = Color(0.4, 0.4, 0.4)
	
	for y in range(chunk.get_margin_start() + lod_size, y_size, lod_size):
		for z in range(chunk.get_margin_start() + lod_size, z_size, lod_size):
			for x in range(chunk.get_margin_start() + lod_size, x_size, lod_size):
				
				cube_points.setup(chunk, x, y, z, lod_size)

				if not cube_points.has_points():
					continue
					
				for face in range(VoxelCubePoints.VOXEL_FACE_COUNT):
					if not cube_points.is_face_visible(face):
						continue

					add_indices(get_vertex_count() + 2)
					add_indices(get_vertex_count() + 1)
					add_indices(get_vertex_count() + 0)
					add_indices(get_vertex_count() + 3)
					add_indices(get_vertex_count() + 2)
					add_indices(get_vertex_count() + 0)

					var vertices : Array = [
						cube_points.get_point_for_face(face, 0),
						cube_points.get_point_for_face(face, 1),
						cube_points.get_point_for_face(face, 2),
						cube_points.get_point_for_face(face, 3)
					]

					var normals : Array = [
						(vertices[3] - vertices[0]).cross(vertices[1] - vertices[0]),
						(vertices[0] - vertices[1]).cross(vertices[2] - vertices[1]),
						(vertices[1] - vertices[2]).cross(vertices[3] - vertices[2]),
						(vertices[2] - vertices[3]).cross(vertices[0] - vertices[3])
					]

					var face_light_direction : Vector3 = cube_points.get_face_light_direction(face)

					for i in range(4):
						add_normal(normals[i])
					
						var light : Color = cube_points.get_face_point_light_color(face, i)
						light += base_light

						var NdotL : float = clamp(normals[i].dot(face_light_direction), 0, 1.0)

						light *= NdotL
						
						light -= cube_points.get_face_point_ao_color(face, i) * ao_strength
						add_color(light)
						
						light.r = clamp(light.r, 0, 1.0)
						light.g = clamp(light.g, 0, 1.0)
						light.b = clamp(light.b, 0, 1.0)

						add_uv((cube_points.get_point_uv_direction(face, i) + Vector2(0.5, 0.5)) * Vector2(tile_uv_size, tile_uv_size))
						
						add_vertex((vertices[i] * voxel_size + Vector3(x, y, z)) * voxel_scale)

	
