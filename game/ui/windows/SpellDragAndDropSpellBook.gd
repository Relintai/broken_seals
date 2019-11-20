extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var spell

func set_spell(p_spell):
	spell = p_spell
		
func get_drag_data(pos):
	if spell == null:
		return null
	
	var tr = TextureRect.new()
	tr.texture = spell.icon
	tr.expand = true
	
#	tr.rect_size = rect_size
	tr.rect_size = Vector2(45, 45)
	set_drag_preview(tr)

	var esd = ESDragAndDrop.new()
	
	esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_SPELL
	esd.item_id = spell.id

	return esd
