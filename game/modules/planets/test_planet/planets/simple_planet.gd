tool
extends Planet

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

func _setup():
	if data == null:
		return
		
	if data.get_biome_data_count() == 0:
		return
		
	var bdata : BiomeData = data.get_biome_data(0)
		
	var b : Biome
	
	if bdata.target_script != null:
		b = bdata.target_script.new()
		
		if b == null:
			print("biome is null. wrong type? " + bdata.resource_path)
			return
	elif bdata.target_class_name != "":
		if not ClassDB.class_exists(bdata.target_class_name):
			print("class doesnt exists" + bdata.resource_path)
			return
		
		b = ClassDB.instance(bdata.target_class_name)
	else:
		b = Biome.new()
	
	b.current_seed = current_seed
	b.data = bdata
	b.setup()
	add_biome(b)

func _setup_library(library):
	._setup_library(library)
	
	for i in range(get_biome_count()):
		var b : Biome = get_biome(i)
		
		if b != null:
			b.setup_library(library)

func _generate_chunk(chunk, spawn_mobs):
	if (get_biome_count() == 0):
		return
		
	var b : Biome = get_biome(0)
	
	b.generate_chunk(chunk, spawn_mobs)
