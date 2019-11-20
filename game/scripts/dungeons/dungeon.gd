tool
extends Dungeon

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _setup():
	if data.get_dungeon_start_room_data_count() == 0:
		return
		
	var drd : DungeonRoomData = data.get_dungeon_start_room_data(0)
	
	var dung : DungeonRoom
	if drd.target_script != null:
		dung = drd.target_script.new()
		
		if dung == null:
			print("drd is null. wrong type? " + drd.resource_path)
			return
	elif drd.target_class_name != "":
		if not ClassDB.class_exists(drd.target_class_name):
			print("class doesnt exists" + drd.resource_path)
			return
		
		dung = ClassDB.instance(drd.target_class_name)
	else:
		dung = DungeonRoom.new()
	
	dung.posx = posx
	dung.posy = posy
	dung.posz = posz
	dung.current_seed = current_seed
	dung.data = drd
	dung.setup()

	add_dungeon_start_room(dung)

func _setup_library(library):
	._setup_library(library)
	
	for i in range(get_dungeon_start_room_count()):
		get_dungeon_start_room(i).setup_library(library)

func _generate_chunk(chunk, spawn_mobs):
	for i in range(get_dungeon_start_room_count()):
		get_dungeon_start_room(i).generate_chunk(chunk, spawn_mobs)
