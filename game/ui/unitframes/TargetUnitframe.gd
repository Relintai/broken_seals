extends VBoxContainer

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

export (PackedScene) var aura_entry_scene : PackedScene

export (NodePath) var name_text_path : NodePath
export (NodePath) var health_range_path : NodePath
export (NodePath) var health_text_path : NodePath
export (NodePath) var resource_range_path : NodePath
export (NodePath) var resource_text_path : NodePath
export (NodePath) var aura_grid_path : NodePath

var _name_text : Label
var _health_range : Range
var _health_text : Label
var _resource_range : Range
var _resource_text : Label
var _aura_grid : GridContainer

var _player : Entity
var _mana : ManaResource
var _health : EntityResourceHealth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_name_text = get_node(name_text_path) as Label
	_health_range = get_node(health_range_path) as Range
	_health_text = get_node(health_text_path) as Label
	_resource_range = get_node(resource_range_path) as Range
	_resource_text = get_node(resource_text_path) as Label
	_aura_grid = get_node(aura_grid_path) as GridContainer

func set_player(p_player : Entity) -> void:
	if not _player == null and is_instance_valid(_player):
		_player.getc_health().disconnect("changed", self, "_on_player_health_changed")
		_player.disconnect("notification_caura", self, "on_notification_caura")
		_player.disconnect("diecd", self, "diecd")
		_player.disconnect("centity_resource_added", self, "centity_resource_added")
		
		if _mana != null:
			_mana.disconnect("changed", self, "_on_mana_changed")
			_mana = null
		
		for a in _aura_grid.get_children():
			_aura_grid.remove_child(a)
			a.queue_free();
		
		_player = null
		set_process(false)
	
	if p_player == null:
		hide()
		return
		
	_player = p_player
	
	for index in range(_player.aura_getc_count()):
		var aura : AuraData = _player.aura_getc(index)
		
		on_notification_caura(SpellEnums.NOTIFICATION_AURA_ADDED, aura)
		
	_player.connect("notification_caura", self, "on_notification_caura")
	_player.connect("diecd", self, "diecd", [], CONNECT_DEFERRED)
	_player.connect("centity_resource_added", self, "centity_resource_added")
	
	for i in range(_player.resource_getc_count()):
		centity_resource_added(_player.resource_getc_index(i))
	
	_health = _player.getc_health()
	_on_player_health_changed()
	_health.connect("changed", self, "_on_player_health_changed")
	
	_name_text.text = _player.centity_name
	
	set_process(true)
	show()
	
func centity_resource_added(res : EntityResource):
	if res is ManaResource:
		_mana = res as ManaResource
		_mana.connect("changed", self, "_on_mana_changed")
		_on_mana_changed()
	
func _on_mana_changed() -> void:
	if _mana.max_value == 0:
		_resource_range.min_value = 0
		_resource_range.max_value = 1
		_resource_range.value = 0
		
		_resource_text.text = ""
		
		return
		
	_resource_range.min_value = 0
	_resource_range.max_value = _mana.max_value
	_resource_range.value = _mana.current_value
	
	_resource_text.text = str(_mana.current_value) + "/" + str(_mana.max_value)

func on_notification_caura(what : int, aura_data : AuraData) -> void:
	if what == SpellEnums.NOTIFICATION_AURA_ADDED:
		var created_node : Node = aura_entry_scene.instance()
		
		_aura_grid.add_child(created_node)
		created_node.owner = _aura_grid
		
		created_node.set_aura_data(aura_data)
	elif what == SpellEnums.NOTIFICATION_AURA_REMOVED:
		for bn in _aura_grid.get_children():
			if bn.get_aura_data() == aura_data:
				_aura_grid.remove_child(bn)
				bn.queue_free()
				return
	
func _on_player_health_changed() -> void:
	if _health.max_value == 0:
		_health_range.min_value = 0
		_health_range.max_value = 1
		_health_range.value = 0
		
		_health_text.text = ""
		
		return
	
	_health_range.min_value = 0
	_health_range.max_value = _health.max_value
	_health_range.value = _health.current_value
	
	_health_text.text = str(_health.current_value) + "/" + str(_health.max_value)
	
func diecd(entity : Entity) -> void:
	set_player(null)
