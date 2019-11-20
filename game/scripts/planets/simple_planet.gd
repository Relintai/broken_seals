tool
extends Planet

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
