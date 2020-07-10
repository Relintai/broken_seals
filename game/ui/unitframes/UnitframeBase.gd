extends Container

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

export (NodePath) var name_text_path : NodePath
export (NodePath) var level_text_path : NodePath
export (NodePath) var health_range_path : NodePath
export (NodePath) var health_text_path : NodePath
export (NodePath) var resource_range_path : NodePath
export (NodePath) var resource_text_path : NodePath
export (NodePath) var xp_range_path : NodePath

var _name_text : Label
var _level_text : Label
var _health_range : Range
var _health_text : Label
var _resource_range : Range
var _resource_text : Label
var _xp_range : Range

var _player : Entity

var _mana : ManaResource
var _health : EntityResourceHealth

func _ready() -> void:
	_name_text = get_node(name_text_path)
	_level_text = get_node(level_text_path)
	_health_range = get_node(health_range_path)
	_health_text = get_node(health_text_path)
	_resource_range = get_node(resource_range_path)
	_resource_text = get_node(resource_text_path)
	_xp_range = get_node(xp_range_path)

func set_player(p_player: Entity) -> void:
	if not _player == null:
		_player.getc_health().disconnect("changed", self, "_on_player_health_changed")
		_player.disconnect("cname_changed", self, "cname_changed")
		_player.disconnect("con_level_up", self, "clevel_changed")
		_player.disconnect("con_level_changed", self, "clevel_changed")
		_player.disconnect("notification_cxp_gained", self, "notification_cxp_gained")
		_player.disconnect("centity_resource_added", self, "centity_resource_added")
		
		if _mana != null:
			_mana.disconnect("changed", self, "_on_mana_changed")
			_mana = null
		
		_player = null
	
	if p_player == null:
		return
	
	_player = p_player
	
	_player.connect("cname_changed", self, "cname_changed")
	_player.connect("notification_clevel_up", self, "clevel_changed")
	_player.connect("con_level_changed", self, "clevel_changed")
	_player.connect("notification_cxp_gained", self, "notification_cxp_gained")
	_player.connect("centity_resource_added", self, "centity_resource_added")
	
	for i in range(_player.resource_getc_count()):
		centity_resource_added(_player.resource_getc_index(i))
	
	_health = _player.getc_health()
	_on_player_health_changed()
	_health.connect("changed", self, "_on_player_health_changed")
	
	_name_text.text = _player.centity_name
	_level_text.text = str(_player.clevel)
	
	clevel_changed(_player, 0)
	notification_cxp_gained(_player, 0)
	
func centity_resource_added(res : EntityResource):
	if res is ManaResource:
		_mana = res as ManaResource

		_mana.connect("changed", self, "_on_mana_changed")
		_on_mana_changed()
	
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
	
func cname_changed(entity: Entity) -> void:
	_name_text.text = _player.centity_name

func clevel_changed(entity: Entity, value : int) -> void:
	_level_text.text = str(_player.clevel)
	
	var xpreq : int = ESS.get_character_xp(_player.clevel)
	
	if xpreq == 0:
		_xp_range.value = 0
		_xp_range.min_value = 0
		_xp_range.max_value = 1
		return
	
	_xp_range.min_value = 0
	_xp_range.max_value = xpreq

func notification_cxp_gained(entity: Entity, val: int) -> void:
	_xp_range.value = _player.cxp

