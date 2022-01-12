extends CenterContainer

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

export(NodePath) var main_container_path : NodePath
export(NodePath) var popup_path : NodePath

export(NodePath) var aura_name_label_path : NodePath
export(NodePath) var aura_description_label_path : NodePath
export(NodePath) var icon_rect_path : NodePath
export(NodePath) var rank_label_path : NodePath
export(NodePath) var upgrade_button_path : NodePath

export(int) var culomn : int

var _main_container : Control
var _popup : PopupPanel

var _aura_name_label : Label
var _aura_description_label : Label
var _icon_rect : TextureRect
var _rank_label : Label
var _upgrade_button : Button

var _row : int
var _spec_index : int

var _player : Entity
var _spec : CharacterSpec

func _ready() -> void:
	_main_container = get_node(main_container_path) as Control
	_popup = get_node(popup_path) as PopupPanel
	
	_aura_name_label = get_node(aura_name_label_path) as Label
	_aura_description_label = get_node(aura_description_label_path) as Label
	_icon_rect = get_node(icon_rect_path) as TextureRect
	_rank_label = get_node(rank_label_path) as Label
	_upgrade_button = get_node(upgrade_button_path) as Button

func set_player(player : Entity, spec : CharacterSpec, spec_index : int, row : int, pculomn : int) -> void:
	if _player != null:
		_player.disconnect("cclass_talent_learned", self, "ctalent_learned")
		_player.disconnect("ccharacter_talent_learned", self, "ctalent_learned")
		_player.disconnect("cclass_talent_reset", self, "ctalent_reset")
		_player.disconnect("ccharacter_talent_reset", self, "ctalent_reset")
	
	_row = row
	_spec = spec
	_player = player
	_spec_index = spec_index
	culomn = pculomn
	
	_player.connect("cclass_talent_learned", self, "ctalent_learned")
	_player.connect("ccharacter_talent_learned", self, "ctalent_learned")
	_player.connect("cclass_talent_reset", self, "ctalent_reset")
	_player.connect("ccharacter_talent_reset", self, "ctalent_reset")
	
	refresh()

		
func refresh() -> void:
	if _spec.get_talent(_row, culomn, 0) == null:
		_main_container.hide()
		return
	
	var rank_count : int = 0
	var known_rank_count : int = 0
	
	for i in range(_spec.get_num_ranks(_row, culomn)):
		var a : Spell = _spec.get_talent(_row, culomn, i)
		
		if a == null:
			break
		
		if _player.class_talent_hasc(a.id):
			known_rank_count += 1
			
		rank_count += 1

	var ridx : int = known_rank_count - 1
	
	if rank_count == known_rank_count:
		_upgrade_button.hide()
	else:
		ridx += 1
	
		_upgrade_button.show()
	
	var aura : Spell = _spec.get_talent(_row, culomn, ridx)
		
	_aura_name_label.text = aura.text_name
	_aura_description_label.text = aura.aura_text_description
	_icon_rect.texture = aura.icon
	_rank_label.text = str(known_rank_count) + "/" + str(rank_count)
		
func open_popup() -> void:
	var p : Vector2 = rect_global_position
	p.x += rect_size.x
	
	_popup.popup(Rect2(p, _popup.rect_size))
	
func upgrade():
	_player.class_talent_crequest_learn(_spec_index, _row, culomn)
	
func ctalent_learned(entity: Entity, talent_id: int) -> void:
	refresh()
	
func ctalent_reset(entity: Entity) -> void:
	refresh()
