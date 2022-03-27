tool
extends ThreadPoolJob

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

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

var final_mesh : ArrayMesh

var _textures : Array
var material_cache : ESSMaterialCache = null
var material : Material

var data : Array

signal finished

func _execute():
	prepare_textures()

	final_mesh = null
	
	var mm : MeshMerger = MeshMerger.new()
	mm.format = ArrayMesh.ARRAY_FORMAT_VERTEX | ArrayMesh.ARRAY_FORMAT_COLOR | ArrayMesh.ARRAY_FORMAT_BONES | ArrayMesh.ARRAY_FORMAT_INDEX | ArrayMesh.ARRAY_FORMAT_NORMAL | ArrayMesh.ARRAY_FORMAT_TEX_UV | ArrayMesh.ARRAY_FORMAT_WEIGHTS
	var bones : PoolIntArray = PoolIntArray()
	bones.resize(4)
	bones[0] = 1
	bones[1] = 0
	bones[2] = 0
	bones[3] = 0
	var bonew : PoolRealArray = PoolRealArray()
	bonew.resize(4)
	bonew[0] = 1
	bonew[1] = 0
	bonew[2] = 0
	bonew[3] = 0

	for ddict in data:
		var bone_name : String = ddict["bone_name"]
		var bone_idx : int = ddict["bone_idx"]
		var texture : Texture = ddict["texture"]
		#var atlas_texture : AtlasTexture = ddict["atlas_texture"]
		var transform : Transform = ddict["transform"]
		var mesh : MeshDataResource = ddict["mesh"]
				
		var rect : Rect2 = material_cache.texture_get_uv_rect(texture)
		
		bones[0] = bone_idx
		
		mm.add_mesh_data_resource_bone(mesh, bones, bonew, transform, rect)
	
	var arr : Array = mm.build_mesh()

	var mesh : ArrayMesh = ArrayMesh.new()
	# No octahedral compression for skinned meshes for now. Can cause bugs on some gpus
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr, [],  ArrayMesh.ARRAY_COMPRESS_NORMAL | ArrayMesh.ARRAY_COMPRESS_TANGENT | ArrayMesh.ARRAY_COMPRESS_COLOR | ArrayMesh.ARRAY_COMPRESS_TEX_UV | ArrayMesh.ARRAY_COMPRESS_TEX_UV2 | ArrayMesh.ARRAY_COMPRESS_WEIGHTS)
	
	#debug_arrays = arr.duplicate(true)
	
	mesh.surface_set_material(0, material_cache.material_lod_get(0))
	final_mesh = mesh

	emit_signal("finished")
#	call_deferred("emit_signal", "finished")
	complete = true

func prepare_textures() -> void:
	if !material_cache.initialized:
		initialize_material_cache()
	
	var curr_tex_index : int = 0
	for i in range(data.size()):
		var ddict : Dictionary = data[i]
		var textures : Array = ddict["textures"]
		
		var texture : Texture = null
		var tcount : int = 0
		for j in range(textures.size()):
			if textures[j]:
				tcount += 1
		
		if tcount > 1:
			# merged texture. We need to get the texture itself
			texture = material_cache.texture_get(curr_tex_index)
		else:
			for j in range(textures.size() - 1, -1, -1):
				if textures[j]:
					texture = textures[j]
					break

		ddict["texture"] = texture
		data[i] = ddict
		
		if texture != null:
			curr_tex_index += 1

func initialize_material_cache() -> void:
	if !material_cache.initialized:
		material_cache.mutex_lock()
		
		#got initialized before we got the lock
		#No need to have the lock anymore
		if material_cache.initialized:
			material_cache.mutex_unlock()
			return
	
	var lmerger : TextureLayerMerger = TextureLayerMerger.new()
	
	for i in range(data.size()):
		var ddict : Dictionary = data[i]
		var textures : Array = ddict["textures"]
		
		var texture : Texture = null
		var tcount : int = 0
		for j in range(textures.size()):
			if textures[j]:
				tcount += 1
		
		if tcount > 1:
			for j in range(textures.size() - 1, -1, -1):
				if textures[j]:
					lmerger.add_texture(textures[j])
					break
			
			lmerger.merge()
			texture = lmerger.get_result_as_texture()
			lmerger.clear()
		else:
			for j in range(textures.size() - 1, -1, -1):
				if textures[j]:
					texture = textures[j]
					break

		if texture != null:
			material_cache.texture_add(texture)

	material_cache.refresh_rects()
	material_cache.mutex_unlock()

func reset():
	complete = false
	final_mesh = null
	_textures.clear()
	material_cache = null
	material = null
	data.clear()
