extends VBoxContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var texture_rect_path : NodePath
export (NodePath) var tooltip_node_path : NodePath
export (NodePath) var time_label_path : NodePath

export (NodePath) var magic_bg_path : NodePath
export (NodePath) var bleed_bg_path : NodePath
export (NodePath) var poison_bg_path : NodePath
export (NodePath) var physical_bg_path : NodePath
export (NodePath) var curse_bg_path : NodePath

var texture_rect : TextureRect
var tooltip_node : Control
var time_label : Label

var magic_bg : Node
var bleed_bg : Node
var poison_bg : Node
var physical_bg : Node
var curse_bg : Node

var aura_data : AuraData

func _ready():
	set_process(false)
	
	texture_rect = get_node(texture_rect_path) as TextureRect
	tooltip_node = get_node(tooltip_node_path) as Control
	time_label = get_node(time_label_path) as Label
	
	magic_bg = get_node(magic_bg_path) as Node
	bleed_bg = get_node(bleed_bg_path) as Node
	poison_bg = get_node(poison_bg_path) as Node
	physical_bg = get_node(physical_bg_path) as Node
	curse_bg = get_node(curse_bg_path) as Node
	
func _process(delta):
#	if not aura_data.is_timed:
#		return
	
	time_label.text = str(int(aura_data.remaining_time)) + "s"
	
	if (aura_data.remaining_time <= 0):
		queue_free()
		
func set_aura_data(paura_data : AuraData):
	aura_data = paura_data
	
	if aura_data.is_timed:
		set_process(true)
		time_label.text = str(aura_data.remaining_time)
	else:
		set_process(false)
		time_label.text = ""
	
	tooltip_node.hint_tooltip = aura_data.aura.text_description
	texture_rect.texture = aura_data.aura.icon
	
	if aura_data.aura.debuff:
		var aura_type : int = aura_data.aura.aura_type
		
		if aura_type == SpellEnums.AURA_TYPE_MAGIC:
			magic_bg.visible = true
		elif aura_type == SpellEnums.AURA_TYPE_BLEED:
			bleed_bg.visible = true
		elif aura_type == SpellEnums.AURA_TYPE_CURSE:
			curse_bg.visible = true
		elif aura_type == SpellEnums.AURA_TYPE_PHYSICAL:
			physical_bg.visible = true
		elif aura_type == SpellEnums.AURA_TYPE_POISON:
			poison_bg.visible = true
	
func get_aura_data() -> AuraData:
	return aura_data
