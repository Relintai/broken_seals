extends ESSEntitySpawner

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

export(PackedScene) var player_display_scene : PackedScene
export(String) var spawn_parent_path : String = "/root/Main"
export(int) var default_level_override : int = 0

var _spawn_parent : Node = null

var _next_entity_guid : int = 0

func _ready():
#	get_scene_tree().multiplayer.connect("network_peer_packet", self, "on_network_peer_packet")
	
#	ProfileManager.load()
#	ESS.load_resource_db()
#	ESS.get_resource_db().load_all()
#	ESS.connect("on_entity_spawn_requested", self, "on_entity_spawn_requested")
	
#    get_tree().connect("network_peer_connected", self, "_player_connected")
#    get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
#    get_tree().connect("connected_to_server", self, "_connected_ok")
#    get_tree().connect("connection_failed", self, "_connected_fail")
#    get_tree().connect("server_disconnected", self, "_server_disconnected")
	pass
	
func on_network_peer_packet(id : int, packet : PoolByteArray) ->void:
	#todo
	pass
	
func spawn_for(player : Entity, target: Entity) -> void:
	Logger.info("spawnfor " + target.name)
	rpc_id(player.get_network_master(), "creceive_spawn_for", to_json(target.to_dict()), target.name, target.translation)
	
func despawn_for(player : Entity, target: Entity) -> void:
	Logger.info("despawnfor " + target.name)
	rpc_id(player.get_network_master(), "creceive_despawn_for", target.get_path())
	
remote func creceive_spawn_for(data: String, global_name : String, position: Vector3) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()

	createinfo.player_name = global_name
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_NETWORKED
	createinfo.serialized_data = parse_json(data)
	createinfo.transform.origin = position
	
	ESS.request_entity_spawn(createinfo)
	
	Logger.info("Player spawned ")
	
	return createinfo.created_entity
	
remote func creceive_despawn_for(path : NodePath) -> void:
#	print("recdespawnfor " + path)
	var ent = get_tree().root.get_node_or_null(path)
	
	if ent:
		ent.queue_free()

puppet func spawn_owned_player(data : String, position : Vector3) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()

	createinfo.guid = multiplayer.get_network_unique_id()
#	createinfo.player_name = ""
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_PLAYER
	createinfo.serialized_data = parse_json(data)
	createinfo.transform.origin = position
	
	ESS.request_entity_spawn(createinfo)
	
	Logger.info("Player spawned ")
	
	return createinfo.created_entity

func load_player(file_name : String, position : Vector3, network_owner : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()

	createinfo.guid = _next_entity_guid
	_next_entity_guid += 1
#	createinfo.player_name = name
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_PLAYER
	createinfo.serialized_data = load_file(file_name)
	createinfo.transform.origin = position
	createinfo.networked = false
	Logger.info("Player spawned ")
	ESS.request_entity_spawn(createinfo)

	return createinfo.created_entity
	
func load_uploaded_character(data : String, position : Vector3, network_owner : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()

	createinfo.guid = _next_entity_guid
	_next_entity_guid += 1
#	createinfo.player_name = name
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_NETWORKED
	createinfo.serialized_data = parse_json(data)
	createinfo.transform.origin = position
	createinfo.networked = false
	Logger.info("Player spawned ")
	ESS.request_entity_spawn(createinfo)

	return createinfo.created_entity
	
func spawn_player_for_menu(class_id : int, name : String, parent : Node) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	var cls : EntityData = ESS.resource_db.get_entity_data(class_id)
	var class_profile : ClassProfile = ProfileManager.getc_player_profile().get_class_profile(cls.resource_path)

	var level : int = 1
	
	if default_level_override > 0:
		level = default_level_override
	
	createinfo.class_id = class_id
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = level
	createinfo.xp = 0
#	createinfo.class_xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_DISPLAY
	createinfo.networked =  false
	createinfo.parent_path = parent.get_path()

	ESS.request_entity_spawn(createinfo)
	
	Logger.info("Player spawned " + str(createinfo))
	
	return createinfo.created_entity
	
func spawn_display_player(file_name : String, node_path : NodePath) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()

	createinfo.guid = _next_entity_guid
	_next_entity_guid += 1
#	createinfo.player_name = name
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_DISPLAY
	createinfo.serialized_data = load_file(file_name)
	createinfo.parent_path = node_path
	
	Logger.info("Player spawned ")

	ESS.request_entity_spawn(createinfo)
	
	return createinfo.created_entity

func spawn_networked_player(class_id : int,  position : Vector3, name : String, node_name : String, sid : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	var cls : EntityData = ESS.resource_db.get_player_character_data(class_id)
	var class_profile : ClassProfile = ProfileManager.get_class_profile(class_id)
	
	var level : int = class_profile.level
	
	if default_level_override > 0:
		level = default_level_override
	
	createinfo.class_id = class_id
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = 1
#	createinfo.class_level = level
	createinfo.xp = 0
#	createinfo.class_xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_NETWORKED
	createinfo.network_owner = sid
	createinfo.transform.origin = position
	createinfo.networked =  false
	createinfo.transform.origin = position

	ESS.request_entity_spawn(createinfo)
	
	Logger.info("Player spawned " + str(createinfo))
	
	return createinfo.created_entity
	
func spawn_player(class_id : int,  position : Vector3, name : String, node_name : String, network_owner : int) -> Entity:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	var cls : EntityData = ESS.resource_db.get_player_character_data(class_id)
	var class_profile : ClassProfile = ProfileManager.get_class_profile(class_id)
	
	var level : int = class_profile.level

	if default_level_override > 0:
		level = default_level_override
	
	createinfo.class_id = class_id
	createinfo.entity_data = cls
	createinfo.player_name = name
	createinfo.level = 1
#	createinfo.class_level = level
	createinfo.xp = 0
#	createinfo.class_xp = class_profile.xp
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_PLAYER
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_PLAYER
	createinfo.network_owner = network_owner
	createinfo.transform.origin = position
	createinfo.networked =  false

	ESS.request_entity_spawn(createinfo)
	
	Logger.info("Player spawned " + str(createinfo))
	
	return createinfo.created_entity

	
func spawn_mob(class_id : int, level : int, position : Vector3) -> void:
	var createinfo : EntityCreateInfo = EntityCreateInfo.new()
	
	var cls : EntityData = ESS.get_resource_db().get_entity_data(class_id)
	
	createinfo.class_id = class_id
	createinfo.entity_data = cls
	createinfo.player_name = "Mob"
	createinfo.level = level
#	createinfo.class_level = level
	createinfo.entity_controller = EntityEnums.ENITIY_CONTROLLER_AI
	createinfo.entity_player_type = EntityEnums.ENTITY_PLAYER_TYPE_AI
	createinfo.transform.origin = position
	
	ESS.request_entity_spawn_deferred(createinfo)
	
	Logger.info("Mob spawned " + str(createinfo))
	
	#return createinfo.created_entity

	
func _request_entity_spawn(createinfo : EntityCreateInfo):
	var entity_node : Entity = null
	
	if createinfo.entity_player_type == EntityEnums.ENTITY_PLAYER_TYPE_DISPLAY:
		entity_node = player_display_scene.instance()
	else:
		if not createinfo.networked:
			if createinfo.entity_controller == EntityEnums.ENITIY_CONTROLLER_PLAYER:
				entity_node = PlayerGD.new()
			else:
				entity_node = MobGD.new()
		else:
			entity_node = NetworkedPlayerGD.new()
		
	if entity_node == null:
		print("EntityManager: entity node is null")
		return null
		
	entity_node.set_transform_3d(createinfo.transform)

	if (createinfo.parent_path == ""):
		if _spawn_parent == null:
			_spawn_parent = get_tree().root.get_node(spawn_parent_path)
		
		if _spawn_parent.current_scene != null:
			var spawn_parent = _spawn_parent.current_scene

			spawn_parent.add_child(entity_node)
	else:
		get_tree().root.get_node(createinfo.parent_path).add_child(entity_node)

	entity_node.setup(createinfo)
	
	createinfo.created_entity = entity_node
	
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
