extends Control

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

var opener_button : BaseButton

export(PackedScene) var spec_scene : PackedScene
export(PackedScene) var spec_switcher_scene : PackedScene
export(NodePath) var spec_container_path : NodePath
export(NodePath) var spec_switcher_path : NodePath

var _spec_container : Node
var _spec_switcher_container : Node

var _data : EntityData
var _player : Entity

func _ready():
	connect("visibility_changed", self, "on_visibility_changed")
	
	_spec_container = get_node(spec_container_path)
	_spec_switcher_container = get_node(spec_switcher_path)

func set_player(player : Entity) -> void:
	if _player != null:
		_player.disconnect("centity_data_changed", self, "centity_data_changed")
	
	_player = player
	
	if _player == null:
		return
	
	_player.connect("centity_data_changed", self, "centity_data_changed")
	
	centity_data_changed(_player.centity_data)

		
func select_spec(index : int) -> void:
	for ch in _spec_container.get_children():
		ch.hide()
	
	if _spec_container.get_child_count() <= index:
		return
	
	_spec_container.get_child(index).show()

func centity_data_changed(data: EntityData) -> void:
	if _data == data:
		return
		
	_data = data
	
	for ch in _spec_container.get_children():
		ch.queue_free()
		_spec_container.remove_child(ch)
		
	for ch in _spec_switcher_container.get_children():
		ch.queue_free()
	
	if data == null or data.entity_class_data == null:
		return

	var cd : EntityClassData = data.entity_class_data
	
	for i in range(cd.get_num_specs()):
		var spec : CharacterSpec = cd.get_spec(i)
		
		if spec == null:
			continue
			
#		var b : Node = spec_switcher_scene.instance()
#		_spec_switcher_container.add_child(b)
#		b.owner = _spec_switcher_container
#		b.set_spec_index(self, i)
			
		var s : Node = spec_scene.instance()
		_spec_container.add_child(s)
		s.owner = _spec_container
		
		if spec.text_name != "":
			s.name = spec.text_name
		
		s.set_spec(_player, spec, i)

func on_visibility_changed():
	if opener_button:
		if visible && !opener_button.pressed:
			opener_button.pressed = true
			return
			
		if !visible && opener_button.pressed:
			opener_button.pressed = false

func _on_button_toggled(button_pressed):
	if button_pressed:
		if !visible:
			show()
	else:
		if visible:
			hide()
