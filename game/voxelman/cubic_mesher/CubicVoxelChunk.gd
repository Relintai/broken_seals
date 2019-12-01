extends VoxelChunk
class_name CubicVoxelChunk

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

var lod_data : Array = [
		1, #CHUNK_INDEX_UP
		1, #CHUNK_INDEX_DOWN
		1, #CHUNK_INDEX_LEFT
		1, #CHUNK_INDEX_RIGHT
		1, #CHUNK_INDEX_FRONT
		1 #CHUNK_INDEX_BACK
]

func _create_mesher():
	mesher = VoxelMesherCubic.new()
#	mesher = CubicVoxelMesher.new()
#	mesher.base_light_value = 0.45
#	mesher.ao_strength = 0.05
#	mesher.ao_strength = 0.2
