extends UnitFrame

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (PackedScene) var aura_entry_scene : PackedScene

export (NodePath) var name_text_path : NodePath
export (NodePath) var health_range_path : NodePath
export (NodePath) var health_text_path : NodePath
export (NodePath) var aura_grid_path : NodePath

var _name_text : Label
var _health_range : Range
var _health_text : Label
var _aura_grid : GridContainer

var _player : Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_name_text = get_node(name_text_path) as Label
	_health_range = get_node(health_range_path) as Range
	_health_text = get_node(health_text_path) as Label
	_aura_grid = get_node(aura_grid_path) as GridContainer

func set_player(p_player : Entity) -> void:
	if not _player == null and is_instance_valid(_player):
		_player.get_health().disconnect("c_changed", self, "_on_player_health_changed")
		_player.disconnect("caura_added", self, "on_caura_added")
		_player.disconnect("caura_removed", self, "on_caura_removed")
		_player.disconnect("cdied", self, "cdied")
		
		for a in _aura_grid.get_children():
			_aura_grid.remove_child(a)
			a.queue_free();
		
		_player = null
		set_process(false)
	
	if p_player == null:
		hide()
		return
		
	_player = p_player
	
	for index in range(_player.cget_aura_count()):
		var aura : AuraData = _player.cget_aura(index)
		
		on_caura_added(aura)
		
	
	_player.connect("caura_added", self, "on_caura_added")
	_player.connect("caura_removed", self, "on_caura_removed")
	_player.connect("cdied", self, "cdied")
	
	var health = _player.get_health()
	_on_player_health_changed(health)
	health.connect("c_changed", self, "_on_player_health_changed")
	
	_name_text.text = _player.centity_name
	
	set_process(true)
	show()

func on_caura_added(aura_data : AuraData) -> void:
	var created_node : Node = aura_entry_scene.instance()
	
	_aura_grid.add_child(created_node)
	created_node.owner = _aura_grid
	
	created_node.set_aura_data(aura_data)
	
func on_caura_removed(aura_data : AuraData) -> void:
	for bn in _aura_grid.get_children():
		if bn.get_aura_data() == aura_data:
			_aura_grid.remove_child(bn)
			bn.queue_free()
			return
	
func _on_player_health_changed(health : Stat) -> void:
	if health.cmax == 0:
		_health_range.min_value = 0
		_health_range.max_value = 1
		_health_range.value = 0
		
		_health_text.text = ""
		
		return
	
	_health_range.min_value = 0
	_health_range.max_value = health.cmax
	_health_range.value = health.ccurrent
	
	_health_text.text = str(health.ccurrent) + "/" + str(health.cmax)
	
func cdied(entity : Entity) -> void:
	set_player(null)
