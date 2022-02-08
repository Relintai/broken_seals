extends Node

# Copyright (c) 2019-2021 Péter Magyar
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

export (int) var port : int = 23223

signal cplayer_master_created(player_master)
signal cplayer_master_destroyed(player_master)

signal splayer_master_created(player_master)
signal splayer_master_destroyed(player_master)

var splayers_dict : Dictionary = {}
var splayers_array : Array = []

var cplayers_dict : Dictionary = {}
var cplayers_array : Array = []

var _sseed : int
var _cseed : int

var local_player_master : PlayerMaster = PlayerMaster.new()

func _ready() -> void:
	#Temporary! REMOVE!
	get_multiplayer().allow_object_decoding = true
	
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	

func start_hosting(p_port : int = 0) -> int:
	if p_port == 0:
		p_port = port
	
	var peer : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	var err : int = peer.create_server(p_port, 32)
	
	if err:
		return err
	
	get_tree().set_network_peer(peer)
	
	_connected_to_server()
	
	return err
	
func start_hosting_websocket(p_port : int = 0) -> int:
	if p_port == 0:
		p_port = port
		
	var peer : WebSocketServer = WebSocketServer.new()
	var err : int = peer.listen(p_port, [], true)
	get_tree().set_network_peer(peer)
	
	_connected_to_server()
	
	return err
	
func connect_to_server(address : String = "127.0.0.1", p_port : int = 0) -> int:
	if p_port == 0:
		p_port = port
		
	var peer = NetworkedMultiplayerENet.new()
	var err : int = peer.create_client(address, p_port)
	get_tree().set_network_peer(peer)

	return err
	
func connect_to_server_websocket(address : String = "127.0.0.1", p_port : int = 0) -> int:
	if p_port == 0:
		p_port = port
		
	var peer = WebSocketClient.new()
	var err : int = peer.connect_to_url(address + ":" + str(p_port), [], true)
	get_tree().set_network_peer(peer)

	return err

func _network_peer_connected(id : int) -> void:
	Logger.verbose("NetworkManager peer connected " + str(id))
	
#	for p in splayers_array:
#		rpc_id(id, "cspawn_player", p.my_info, p.sid, p.player.translation)
	
	var pm : PlayerMaster = PlayerMaster.new()
	pm.sid = id
	
	splayers_array.append(pm)
	splayers_dict[id] = pm
	
	emit_signal("splayer_master_created", pm)
	
	rpc_id(id, "cset_seed", _sseed)

func _network_peer_disconnected(id : int) -> void:
	Logger.verbose("NetworkManager peer disconnected " + str(id))
	
	var player : PlayerMaster = splayers_dict[id]
	splayers_dict.erase(id)
	
	for pi in range(len(splayers_array)):
		if (splayers_array[pi] as PlayerMaster) == player:
			splayers_array.remove(pi)
			break
	
	if player:
		emit_signal("splayer_master_destroyed", player)

func _connected_to_server() -> void:
	Logger.verbose("NetworkManager _connected_to_server")
	
	var pm : PlayerMaster = PlayerMaster.new()
	pm.sid = get_tree().get_network_unique_id()
	
	local_player_master = pm
	
	emit_signal("cplayer_master_created", pm)
	
func _server_disconnected() -> void:
	Logger.verbose("_server_disconnected")
	
	# Server kicked us; show error and abort.
	
	for player in get_children():
		emit_signal("NetworkManager cplayer_master_destroyed", player)
		player.queue_free()

func _connection_failed() -> void:
	Logger.verbose("NetworkManager _connection_failed")
	
	pass # Could not even connect to server; abort.

func sset_seed(pseed):
	_sseed = pseed
	
	if multiplayer.has_network_peer() and multiplayer.is_network_server():
		rpc("cset_seed", _sseed)
	
remote func cset_seed(pseed):

	_cseed = pseed
	
	print("clientseed set")
	

func set_class():
	Logger.verbose("set_class")
	
	if not get_tree().is_network_server():
		rpc_id(1, "crequest_select_class", local_player_master.my_info)
	else:
		crequest_select_class(local_player_master.my_info)

remote func crequest_select_class(info : Dictionary) -> void:
	Logger.verbose("NetworkManager crequest_select_class")
	
	if get_tree().is_network_server():
		var sid : int =  get_tree().multiplayer.get_rpc_sender_id()
		
		if sid == 0:
			sid = 1
			
		rpc("cspawn_player", info, sid, Vector3(10, 10, 10))
		

remotesync func cspawn_player(info : Dictionary, sid : int, pos : Vector3):
	Logger.verbose("NetworkManager cspawn_player")
	
	if sid == get_tree().get_network_unique_id():
		local_player_master.player =  ESS.entity_spawner.spawn_player(info["selected_class"] as int, pos, info["name"] as String, str(sid), sid)
		call_deferred("set_terrarin_player")
		
		if get_tree().is_network_server() and not splayers_dict.has(sid):
			splayers_dict[sid] = local_player_master
			splayers_array.append(local_player_master)
	else:
		var pm : PlayerMaster = PlayerMaster.new()
		pm.sid = sid
		
		pm.player = ESS.entity_spawner.spawn_networked_player(info["selected_class"] as int, pos, info["name"] as String, str(sid), sid)
			
		if get_tree().is_network_server() and not splayers_dict.has(sid):
			splayers_dict[sid] = pm
			splayers_array.append(pm)
			
		cplayers_dict[sid] = pm
		cplayers_array.append(pm)
		

func upload_character(data : String) -> void:
	rpc_id(1, "sreceive_upload_character", data)
	
master func sreceive_upload_character(data: String) -> void:
	ESS.entity_spawner.load_uploaded_character(data, Vector3(0, 10, 0), multiplayer.get_rpc_sender_id())

func set_terrarin_player():
	Logger.verbose("NetworkManager cspawn_player")
	
	var terrarin : TerrainWorld = get_node("/root/main/World")
	
	terrarin.set_player(local_player_master.player.get_body() as Spatial)
