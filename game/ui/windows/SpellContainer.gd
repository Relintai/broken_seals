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

export(NodePath) var icon_path : NodePath
export(NodePath) var name_label_path : NodePath
#export(NodePath) var description_label_path : NodePath
export(NodePath) var known_label_path : NodePath
export(NodePath) var learn_button_path : NodePath
export(NodePath) var spell_button_path : NodePath
export(NodePath) var popup_path : NodePath

export(Color) var known_color : Color = Color.white
export(Color) var not_known_color : Color = Color.gray
export(Color) var unlearnable_color : Color = Color.gray

var _icon : TextureRect
var _name_label : Label
#var _description_label : RichTextLabel
var _spell_button : Button
var _popup : Popup

var _spell : Spell
var _player : Entity

var _spell_known : bool 

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
		_spell_known = _player.spell_hasc(p_spell)
		
		_icon.texture = _spell.icon
		_name_label.text = _spell.text_name + " (Rank " + str(_spell.rank) + ")"
	else:
		_icon.texture = null
		
		_name_label.text = "....."
		
	update_spell_indicators()

func learn_spell() -> void:
	if _player == null or _spell == null:
		return
		
	if _player.cfree_spell_points <= 0:
		return
		
	_player.spell_learn_requestc(_spell.id)

func cspell_added(entity: Entity, spell: Spell) -> void:
	if spell == _spell:
		_spell_known = true
		
	update_spell_indicators()

func cspell_removed(entity: Entity, spell: Spell) -> void:
	if spell == _spell:
		_spell_known = false
		
	update_spell_indicators()

func spell_button_pressed() -> void:
	var pos : Vector2 = _spell_button.rect_global_position
	pos.x += _spell_button.rect_size.x
	
	_popup.popup(Rect2(pos, _popup.rect_size))

func update_spell_indicators():
	if ESS.use_spell_points:
		if _spell_known:
			get_node(known_label_path).show()
			get_node(learn_button_path).hide()
			
			modulate = known_color
		else:
			if _spell != null:
				if _spell.training_required_spell:
					if not _player.spell_hasc(_spell.training_required_spell):
						
						if ESS.use_spell_points:
							get_node(known_label_path).hide()
							get_node(learn_button_path).show()
			
						modulate = unlearnable_color
						
						return
			
			if ESS.use_spell_points:
				get_node(known_label_path).hide()
				get_node(learn_button_path).show()
			
			modulate = not_known_color
	else:
		get_node(known_label_path).hide()
		get_node(learn_button_path).hide()
			
		if _spell_known:
			modulate = known_color
		else:
			if _spell != null:
				if _spell.training_required_spell:
					if not _player.spell_hasc(_spell.training_required_spell):

						modulate = unlearnable_color
						
						return
			
			modulate = not_known_color
		
		
