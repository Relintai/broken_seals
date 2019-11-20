extends Node

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var actionbar_scene

var _player : Entity


func set_player(p_player: Entity) -> void:
	if not _player == null:
		clear_actionbars()
		_player.disconnect("centity_data_changed", self, "_centity_data_changed")
		_player = null
	
	_player = p_player

	if _player == null:
		return
	
	_centity_data_changed(_player.centity_data)
	_player.connect("centity_data_changed", self, "_centity_data_changed")
	
func _centity_data_changed(cls: EntityData) -> void:
	clear_actionbars()

	if cls == null:
		return

	var abp = _player.get_action_bar_profile()

	for i in range(abp.get_action_bar_count()):
		var abe = abp.get_action_bar(i)
		var s = actionbar_scene.instance()
		
		add_child(s)
		
		s.set_actionbar_entry(abe, _player)
		
		s.owner = self
		

		
func clear_actionbars() -> void:
	var children = get_children()
	
	for c in children:
		c.queue_free()
		
	
