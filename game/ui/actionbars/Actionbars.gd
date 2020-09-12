extends Node

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

export(PackedScene) var actionbar_scene

var _player : Entity
var _abp : ActionBarProfile

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
	if _abp != null:
		_abp.disconnect("changed", self, "on_changed")
	
	clear_actionbars()

	if cls == null:
		return

	_abp = _player.get_action_bar_profile()
	
	for i in range(_abp.get_action_bar_count()):
		var abe = _abp.get_action_bar(i)
		var s = actionbar_scene.instance()
		
		add_child(s)
		
		s.set_actionbar_entry(abe, _player)
		
		s.owner = self
		
		
func clear_actionbars() -> void:
	var children = get_children()
	
	for c in children:
		c.queue_free()
		
	
