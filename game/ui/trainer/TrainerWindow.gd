extends Control

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

export(NodePath) var spell_entry_container_path : NodePath
export(NodePath) var learn_button_path : NodePath
export(NodePath) var cost_label_path : NodePath

export(NodePath) var spell_icon_path : NodePath
export(NodePath) var spell_name_label_path : NodePath
export(NodePath) var spell_description_label_path : NodePath
export(NodePath) var spell_requirements_label_path : NodePath

var _spell_entry_container : Node
var _spell_entries : Array

var _learn_button : Button
var _cost_label : Label

var _spell_icon : TextureRect
var _spell_name_label : Label
var _spell_description_label : Label
var _spell_requirements_label : Label

var _player : Entity

var _entity_data : EntityData
var _character_class : EntityClassData

var _spells : Array

var _spell_button_group : ButtonGroup

func _ready() -> void:
	_spell_button_group = ButtonGroup.new()
	
	_spell_entry_container = get_node(spell_entry_container_path)

	_spell_icon = get_node(spell_icon_path) as TextureRect
	_spell_name_label = get_node(spell_name_label_path) as Label
	_spell_description_label = get_node(spell_description_label_path) as Label
	_spell_requirements_label = get_node(spell_requirements_label_path) as Label

	_learn_button = get_node(learn_button_path)
	_cost_label = get_node(cost_label_path)

	_learn_button.connect("pressed", self, "learn")

	connect("visibility_changed", self, "_visibility_changed")

func learn() -> void:
	if _character_class == null:
		return
		
	if _player == null:
		return
		
	var b : Button = _spell_button_group.get_pressed_button()
	
	if b:
		var spell : Spell = b.get_meta("spell")
		
		_player.spell_learn_requestc(spell.id)
		
	refresh_entries()

func refresh_entries() -> void:
	if _character_class == null or _player == null:
		return
		
	for c in _spell_entry_container.get_children():
		c.queue_free()
		
	_spell_entries.clear()

	for s in _spells:
		var spell : Spell = s
		
		if !spell:
			continue
		
		if _player.spell_hasc(spell):
			continue
			
		var b : Button = Button.new()
		
		b.text = spell.text_name + " (rank " + str(spell.rank) + ")"
		b.set_meta("spell", spell)
		b.group = _spell_button_group
		b.toggle_mode = true
		b.connect("pressed", self, "_button_pressed")

		_spell_entries.append(b)
		_spell_entry_container.add_child(b)

	if _spell_entries.size() > 0:
		_spell_entries[0].pressed = true
		_button_pressed()

func refresh_all() -> void:
	if _player == null:
		return

	if _character_class == null:
		return

	refresh_entries()
	

func _visibility_changed() -> void:
	if visible:
		refresh_all()

func set_player(p_player: Entity) -> void:
	if _player != null:
		_player.disconnect("centity_data_changed", self, "centity_data_changed")
		_player.disconnect("onc_open_winow_request", self, "onc_open_winow_request")
	
	_player = p_player
	
	_player.connect("centity_data_changed", self, "centity_data_changed")
	_player.connect("onc_open_winow_request", self, "onc_open_winow_request")

	if _player != null:
		centity_data_changed(_player.centity_data)
	else:
		centity_data_changed(null)
	
func centity_data_changed(data: EntityData):
	_spells.clear()
	
	_entity_data = null
	_character_class = null
	
	if data == null:
		return
		
	_entity_data = _player.centity_data
	_character_class = _entity_data.entity_class_data
	
	if _character_class == null:
		return
		
	for i in range(_character_class.get_num_spells()):
		_spells.append(_character_class.get_spell(i))
		
	_spells.sort_custom(CustomSpellSorter, "sort")
	
	refresh_all()

func _button_pressed():
	var b : Button = _spell_button_group.get_pressed_button()
	
	if b && b.has_meta("spell"):
		var spell : Spell = b.get_meta("spell")
	
		_spell_icon.texture = spell.icon
		_spell_name_label.text = spell.text_name
		_spell_description_label.text = spell.text_description
		
		var req_str = "Required: "
		
		if spell.training_required_spell:
			req_str += spell.training_required_spell.text_name + " (rank " +  str(spell.training_required_spell.rank) + ") "
			
		if spell.level > 0:
			req_str += "level " + str(spell.level)
			
		_spell_requirements_label.text = req_str
		
		_cost_label.text = str(spell.get_training_cost())

	else:
		_spell_icon.texture = null
		_spell_name_label.text = ""
		_spell_description_label.text = ""
		_spell_requirements_label.text = ""
		
		_cost_label.text = "0"

		
	
class CustomSpellSorter:
	static func sort(a, b):
		if a.level < b.level:
			return true
		elif a.level > b.level:
			return false
		else:
			var res = a.text_name.casecmp_to(b.text_name)
			
			if res == 0:
				if a.rank < b.rank:
					return true
				return false
			elif res == 1:
				return false
			
			return true
		

func onc_open_winow_request(window_id : int) -> void:
	if window_id != EntityEnums.ENTITY_WINDOW_TRAINER:
		return
		
	show()

#	if player.has_signal("player_moved") && !player.is_connected("player_moved", self, "on_player_moved"):
#		player.connect("player_moved", self, "on_player_moved", [], CONNECT_ONESHOT)
