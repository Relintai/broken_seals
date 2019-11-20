extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var spell_entry_container_path : NodePath
export (NodePath) var prev_button_path : NodePath
export (NodePath) var next_button_path : NodePath
export (NodePath) var spell_points_label_path : NodePath

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

func _ready() -> void:
	_spell_entries.clear()
	
	_spell_entry_container = get_node(spell_entry_container_path)

	for i in range(_spell_entry_container.get_child_count()):
		_spell_entries.append(_spell_entry_container.get_child(i))
		
	_prev_button = get_node(prev_button_path)
	_next_button = get_node(next_button_path)
	_spell_points_label = get_node(spell_points_label_path)
	
	_prev_button.connect("pressed", self, "dec_page")
	_next_button.connect("pressed", self, "inc_page")
		
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

	for i in range(len(_spell_entries)):
		var spindex : int = i + (_page * len(_spell_entries))

		if spindex >= _character_class.get_num_spells():
			_spell_entries[i].set_spell(_player, null)
			continue

		var spell : Spell = _character_class.get_spell(spindex)
		
		_spell_entries[i].set_spell(_player, spell)


func refresh_all() -> void:
	if _player == null:
		return

	_entity_data = _player.centity_data
	_character_class = _entity_data.entity_class_data

	if _character_class == null:
		return

	_max_pages = int(_character_class.get_num_spells() / len(_spell_entries))

	if _page > _max_pages:
		_page = _max_pages

	_spell_points_label.text = "Free spell points: " + str(_player.getc_free_spell_points())

	refresh_entries()
	

func _visibility_changed() -> void:
	if visible:
		refresh_all()

func set_player(p_player: Entity) -> void:
	if _player != null:
		_player.disconnect("cfree_spell_points_changed", self, "cfree_spell_points_changed")
	
	_player = p_player
	
	_player.connect("cfree_spell_points_changed", self, "cfree_spell_points_changed")
	
func cfree_spell_points_changed(entity: Entity, value: int) -> void:
	_spell_points_label.text = "Free spell points: " + str(_player.getc_free_spell_points())
