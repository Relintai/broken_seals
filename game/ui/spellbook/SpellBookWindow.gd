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

var opener_button : BaseButton

export(NodePath) var spell_entry_container_path : NodePath
export(NodePath) var prev_button_path : NodePath
export(NodePath) var next_button_path : NodePath
export(NodePath) var spell_points_label_path : NodePath

export(bool) var show_not_learned : bool = true
export(bool) var show_not_learnable : bool = false

var _spell_entry_container : Node
var _spell_entries : Array

var _prev_button : Button
var _next_button : Button
var _spell_points_label : Label

var _player : Entity

var _page : int = 0
var _max_pages : int = 0
var _entity_data : EntityData
var _character_class : EntityClassData

var _spells : Array

func _ready() -> void:
	connect("visibility_changed", self, "on_visibility_changed")
	
	_spell_entries.clear()
	
	_spell_entry_container = get_node(spell_entry_container_path)

	for i in range(_spell_entry_container.get_child_count()):
		_spell_entries.append(_spell_entry_container.get_child(i))
		
	_prev_button = get_node(prev_button_path)
	_next_button = get_node(next_button_path)
	_spell_points_label = get_node(spell_points_label_path)
	
	_prev_button.connect("pressed", self, "dec_page")
	_next_button.connect("pressed", self, "inc_page")
	
	if ESS.use_spell_points:
		_spell_points_label.text = ""
		
	connect("visibility_changed", self, "_visibility_changed")

func inc_page() -> void:
	if _character_class == null:
		return
		
	_page += 1
	
	if _page > _max_pages:
		_page = _max_pages
	
	refresh_entries()
		
func dec_page() -> void:
	if _character_class == null:
		return
		
	_page -= 1
	
	if _page < 0:
		_page = 0
		
	refresh_entries()

func refresh_entries() -> void:
	if _character_class == null or _player == null:
		return

	var i : int = 0
	var n : int = 0
#	for n in range(len(_spell_entries)):
	while n < len(_spell_entries):
		var spindex : int = i + (_page * len(_spell_entries))

		if spindex >= _spells.size():
			_spell_entries[n].set_spell(_player, null)
			i += 1
			n += 1
			continue

		var spell : Spell = _spells[spindex]
		
		if not _player.spell_hasc(spell):
			if not show_not_learned:
				i += 1
				continue
			
			if not show_not_learnable:
				if spell.training_required_spell and not _player.spell_hasc(spell.training_required_spell):
						i += 1
						continue
				
		
		_spell_entries[n].set_spell(_player, spell)
		i += 1
		n += 1


func refresh_all() -> void:
	if _player == null:
		return

	if _character_class == null:
		return

	_max_pages = int(_character_class.get_num_spells() / len(_spell_entries))

	if _page > _max_pages:
		_page = _max_pages

	if ESS.use_spell_points:
		_spell_points_label.text = "Free spell points: " + str(_player.getc_free_spell_points())

	refresh_entries()
	

func _visibility_changed() -> void:
	if visible:
		refresh_all()

func set_player(p_player: Entity) -> void:
	if _player != null:
		_player.disconnect("cfree_spell_points_changed", self, "cfree_spell_points_changed")
		_player.disconnect("centity_data_changed", self, "centity_data_changed")
	
	_player = p_player
	
	_player.connect("cfree_spell_points_changed", self, "cfree_spell_points_changed")
	_player.connect("centity_data_changed", self, "centity_data_changed")
	
	if _player != null:
		centity_data_changed(_player.centity_data)
	else:
		centity_data_changed(null)
	
func cfree_spell_points_changed(entity: Entity, value: int) -> void:
	_spell_points_label.text = "Free spell points: " + str(_player.getc_free_spell_points())

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
	
	
class CustomSpellSorter:
	static func sort(a, b):
		var res = a.text_name.casecmp_to(b.text_name)
		
		if res == 0:
			if a.rank < b.rank:
				return true
			return false
		elif res == 1:
			return false
		
		return true
		

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
