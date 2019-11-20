extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var icon_path : NodePath
export (NodePath) var name_label_path : NodePath
#export (NodePath) var description_label_path : NodePath
export (NodePath) var known_label_path : NodePath
export (NodePath) var learn_button_path : NodePath
export (NodePath) var spell_button_path : NodePath
export (NodePath) var popup_path : NodePath


var _icon : TextureRect
var _name_label : Label
#var _description_label : RichTextLabel
var _spell_button : Button
var _popup : Popup

var _spell : Spell
var _player : Entity

func _ready() -> void:
	_icon = get_node(icon_path) as TextureRect
	_name_label = get_node(name_label_path) as Label
#	_description_label = get_node(description_label_path) as RichTextLabel
	_spell_button = get_node(spell_button_path) as Button
	_popup = get_node(popup_path) as Popup
	
func set_spell(p_player : Entity, p_spell: Spell) -> void:
	
	if _player != null:
		_player.disconnect("cspell_added", self, "cspell_added")
		_player.disconnect("cspell_removed", self, "cspell_removed")
	
	_spell = p_spell
	_player = p_player
	
	_player.connect("cspell_added", self, "cspell_added")
	_player.connect("cspell_removed", self, "cspell_removed")
	
#	_icon.set_spell(_spell)
	_spell_button.set_spell(_spell)
	_popup.set_spell(_spell)
	
	if not _spell == null:
		if _player.hasc_spell(p_spell):
			get_node(known_label_path).show()
			get_node(learn_button_path).hide()
		else:
			get_node(known_label_path).hide()
			get_node(learn_button_path).show()
		
		_icon.texture = _spell.icon
		_name_label.text = _spell.text_name + " (Rank " + str(_spell.rank) + ")"
	else:
		_icon.texture = null
		
		_name_label.text = "....."

func learn_spell() -> void:
	if _player == null or _spell == null:
		return
		
	if _player.cfree_spell_points <= 0:
		return
		
	_player.crequest_spell_learn(_spell.id)

func cspell_added(entity: Entity, spell: Spell) -> void:
	if spell == _spell:
		get_node(known_label_path).show()
		get_node(learn_button_path).hide()

func cspell_removed(entity: Entity, spell: Spell) -> void:
	if spell == _spell:
		get_node(known_label_path).hide()
		get_node(learn_button_path).show()

func spell_button_pressed() -> void:
	var pos : Vector2 = _spell_button.rect_global_position
	pos.x += _spell_button.rect_size.x
	
	_popup.popup(Rect2(pos, _popup.rect_size))
