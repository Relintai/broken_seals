extends Node

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

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

export(PackedScene) var player_scene : PackedScene
export(PackedScene) var networked_player_scene : PackedScene
export(PackedScene) var mob_scene : PackedScene
export(PackedScene) var player_display_scene : PackedScene
export(String) var spawn_parent_path : String = "/root/Main"
export(int) var default_level_override : int = 0

var _spawn_parent : Node = null

var _next_entity_guid : int = 0

var _players : Array
var _mobs : Array

func _ready():
	_spawn_parent = get_node(spawn_parent_path)

#    get_tree().connect("network_peer_connected", self, "_player_connected")
#    get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
#    get_tree().connect("connected_to_server", self, "_connected_ok")
#    get_tree().connect("connection_failed", self, "_connected_fail")
#    get_tree().connect("server_disconnected", self, "_server_disconnected")
	pass
	
func spawn_for(player : Entity, target: Entity) -> void:
#	print("spawnfor " + target.name)
	rpc_id(player.get_network_master(), "creceive_spawn_for", to_json(target.to_dict()), target.name, target.translation)
	
func despawn_for(player : Entity, target: Entity) -> void:
#	print("despawnfor " + target.name)
	rpc_id(player.get_network_master(), "creceive_despawn_for", target.get_path())
	
remote func creceive_spawn_for(data: String, global_name : String, position: Vector3) -> void:
#	print("recspawnfor " + global_name)
	var entity : Entity = networked_player_scene.instance()

	var spawn_parent = _spawn_parent.current_scene

	spawn_parent.add_child(entity)
	entity.owner = spawn_parent
	entity.name = str(global_name)
	entity.from_dict(parse_json(data))

	entity.translation = position
			
	Logger.info("Player spawned ")
	
	_players.append(entity)
	
remote func creceive_despawn_for(path : NodePath) -> void:
#	print("recdespawnfor " + path)
	var ent = get_node_or_null(path)
	
	if ent:
		ent.queue_free()

func spawn_networked_player_from_data(data : String, position : Vector3, network_owner : int) -> Entity:
	var entity : Entity = networked_player_scene.instance()

	_next_entity_guid += 1
	
	var spawn_parent = _spawn_parent.current_scene

	spawn_parent.add_child(entity)
	entity.owner = spawn_parent
	entity.name = str(network_owner)
	entity.from_dict(parse_json(data))
	
	entity.set_network_master(network_owner)
	entity.translation = position
			
	Logger.info("Player spawned ")
	
	_players.append(entity)
	
	rpc_id(network_owner, "spawn_owned_player", data, position)
	
	return entity
	
puppet func spawn_owned_player(data : String, position : Vector3) -> void:
	var entity : Entity = player_scene.instance()

	var spawn_parent = _spawn_parent.current_scene

	spawn_parent.add_child(entity)
	entity.owner = spawn_parent
	
	entity.from_dict(parse_json(data))
	entity.name = str(multiplayer.get_network_unique_id())
	entity.translation = position
	entity.set_network_master(multiplayer.get_network_unique_id())
			
	Logger.info("Player spawned ")


func load_player(file_name : String, position : Vector3, network_owner : int) -> Entity:
#	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
#
#	var cls : EntityData = Entities.get_player_character_data(class_id)
#
#	var class_profile : ClassProfile = Profiles.get_class_profile(class_id)
#
#	createinfo.entity_data = cls
#	createinfo.player_name = name
#	createinfo.level = class_profile.level
#	createinfo.xp = class_profile.xp
#	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	
	var entity : Entity = player_scene.instance()

	_next_entity_guid += 1

	var spawn_parent = _spawn_parent.current_scene

	spawn_parent.add_child(entity)
	entity.owner = spawn_parent

	entity.from_dict(load_file(file_name))

	entity.translation = position
#	entity.initialize(createinfo)
	entity.set_network_master(network_owner)
			
	Logger.info("Player spawned ")
	
	_players.append(entity)
	
	return entity

func spawn_display_player(name : String) -> Entity:
	var entity : Entity = player_display_scene.instance() as Entity
	
	entity.name = name
	
	Logger.info("Player Display spawned")

	return entity
	
func spawn_player_for_menu(class_id : int, name : String, parent : Node) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	var cls : EntityData = Entities.get_player_character_data(class_id)
	var class_profile : ClassProfile = Profiles.get_class_profile(class_id)
	
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = 1
	createinfo.xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	
	var entity : Entity = player_display_scene.instance() as Entity
	entity.initialize(createinfo)

	var level : int = class_profile.level

	if default_level_override > 0:
		level = default_level_override
	
	entity.slevelup(level - 1)

	parent.add_child(entity)
	entity.owner = parent
		
	return entity

func spawn_networked_player(class_id : int,  position : Vector3, name : String, node_name : String, sid : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	
	var cls : EntityData = Entities.get_entity_data(class_id)
	
	var class_profile : ClassProfile = Profiles.get_class_profile(class_id)
	
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = 1
	createinfo.xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	
	var entity : Entity = spawn(createinfo, true, position, node_name)
	
	var level : int = class_profile.level
	
	if default_level_override > 0:
		level = default_level_override
	
	entity.slevelup(level - 1)
	
	if get_tree().is_network_server():
		entity.set_network_master(sid)

	Logger.info("Player spawned " + str(createinfo))
	
	_players.append(entity)
	
	return entity
	
func spawn_player(class_id : int,  position : Vector3, name : String, node_name : String, network_owner : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	
	var cls : EntityData = Entities.get_player_character_data(class_id)
	
	var class_profile : ClassProfile = Profiles.get_class_profile(class_id)
	
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = 1
	createinfo.xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	
	var entity : Entity = spawn(createinfo, false, position, node_name)
	
	var level : int = class_profile.level
	
	if default_level_override > 0:
		level = default_level_override
	
	entity.slevelup(level - 1)
	
	entity.set_network_master(network_owner)
			
	Logger.info("Player spawned " + str(createinfo))
	
	_players.append(entity)
	
	return entity
	
func spawn_mob(class_id : int, level : int, position : Vector3) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	
	var cls : EntityData = Entities.get_entity_data(class_id)
	
	if cls == null:
		print("clsnull")
	
	createinfo.entity_data = cls
	createinfo.player_name = "Mob"
	createinfo.level = 1

	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_AI
	
	var entity : Entity = spawn(createinfo, false, position)
	
	if default_level_override > 0:
		level = default_level_override
	
	entity.slevelup(level - 1)
	
	Logger.info("Mob spawned " + str(createinfo))
	
	_mobs.append(entity)
	
	return entity
	
func spawn(createinfo : EntityCreateInfo, networked : bool, position : Vector3, node_name : String = "") -> Entity:
	var entity_node : Entity = null
	
	if not networked:
		if createinfo.entity_controller == EntityEnums.ENITIY_CONTROLLER_PLAYER:
			entity_node = player_scene.instance()
		else:
			entity_node = mob_scene.instance()
	else:
		entity_node = networked_player_scene.instance()
		
	if entity_node == null:
		print("EntityManager: entity node is null")
		return null
	
	if node_name == "":
		entity_node.name += "_" + str(_next_entity_guid)
	else:
		entity_node.name = node_name
		
	_next_entity_guid += 1

	var spawn_parent = _spawn_parent.current_scene

	spawn_parent.add_child(entity_node)
	entity_node.owner = spawn_parent

	entity_node.translation = position
		
	entity_node.initialize(createinfo)
	
	return entity_node
		
		
func _player_connected(id):
	pass # Will go unused; not useful here.

func _player_disconnected(id):
	#player_info.erase(id) # Erase player from info.
	pass

func _connected_ok():
	# Only called on clients, not server. Send my ID and info to all the other peers.
	#rpc("register_player", get_tree().get_network_unique_id(), my_info)
	pass

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(id, info):
	# Store the info
#    player_info[id] = info
	# If I'm the server, let the new guy know about existing players.
#    if get_tree().is_network_server():
#        # Send my info to new player
#        rpc_id(id, "register_player", 1, my_info)
#        # Send the info of existing players
#        for peer_id in player_info:
#            rpc_id(id, "register_player", peer_id, player_info[peer_id])

	# Call function to update lobby UI here
	pass

func load_file(file_name : String) -> Dictionary:
	
	var f : File = File.new()
			
	if f.open("user://characters/" + file_name, File.READ) == OK:
		var st : String = f.get_as_text()
		f.close()
				
		var json_err : String = validate_json(st)
				
		if json_err != "":
			Logger.error("Save corrupted! " + file_name)
			Logger.error(json_err)
			return Dictionary()
				
		var p = parse_json(st)
				
		if typeof(p) != TYPE_DICTIONARY:
			Logger.error("Save corrupted! Not Dict! " + file_name)
			return Dictionary()
			
		if p is Dictionary:
			return p as Dictionary
		
	return Dictionary()

func save_player(player: Entity, file_name : String) -> void:
	var f : File = File.new()
			
	if f.open("user://characters/" + file_name, File.WRITE) == OK:
		f.store_string(to_json(player.to_dict()))
		f.close()
