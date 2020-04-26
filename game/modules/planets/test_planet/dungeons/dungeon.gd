tool
extends Dungeon

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
