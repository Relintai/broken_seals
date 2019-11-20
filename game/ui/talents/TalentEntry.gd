extends CenterContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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

func set_player(player : Entity, spec : CharacterSpec, spec_index : int, row : int) -> void:
	if _player != null:
		_player.disconnect("ctalent_learned", self, "ctalent_learned")
		_player.disconnect("ctalent_reset", self, "ctalent_reset")
	
	_row = row
	_spec = spec
	_player = player
	_spec_index = spec_index
	
	_player.connect("ctalent_learned", self, "ctalent_learned")
	_player.connect("ctalent_reset", self, "ctalent_reset")
	
	refresh()

		
func refresh() -> void:
	var tr : TalentRowData = _spec.get_talent_row(_row)
	
	if tr.get_talent(culomn, 0) == null:
		_main_container.hide()
		return
	
	var rank_count : int = 0
	var known_rank_count : int = 0
	
	for i in range(TalentRowData.MAX_TALENTS_PER_ENTRY):
		var a : Aura = tr.get_talent(culomn, i)
		
		if a == null:
			break
		
		if _player.hasc_talent(a.id):
			known_rank_count += 1
			
		rank_count += 1

	var ridx : int = known_rank_count - 1
	
	if rank_count == known_rank_count:
		_upgrade_button.hide()
	else:
		ridx += 1
	
		_upgrade_button.show()
	
	var aura : Aura = tr.get_talent(culomn, ridx)
		
	_aura_name_label.text = aura.text_name
	_aura_description_label.text = aura.text_description
	_icon_rect.texture = aura.icon
	_rank_label.text = str(known_rank_count) + "/" + str(rank_count)
		
func open_popup() -> void:
	var p : Vector2 = rect_global_position
	p.x += rect_size.x
	
	_popup.popup(Rect2(p, _popup.rect_size))
	
func upgrade():
	_player.crequest_talent_learn(_spec_index, _row, culomn)
	
func ctalent_learned(entity: Entity, talent_id: int) -> void:
	refresh()
	
func ctalent_reset(entity: Entity) -> void:
	refresh()
