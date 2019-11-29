extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var button_path : NodePath
export (NodePath) var icon_path : NodePath

export (NodePath) var cooldown_indicator_path : NodePath
export (NodePath) var cooldown_text_path : NodePath

export (NodePath) var stack_counter : NodePath
var _stack_counter : Label

var _tooltip : Popup

var button : Button
var icon_rect : TextureRect
var cooldown_indicator : TextureProgress
var cooldown_text : Label

var slot_id : int = 0
var item : ItemInstance
var player : Entity

var spell_id : int = 0
#var spell_type : int = 0

var cd : Cooldown = null

var has_gcd : bool = false
var gcd : float = 0.0

func _ready() -> void:
	button = get_node(button_path) as Button
	icon_rect = get_node(icon_path) as TextureRect
	
	cooldown_indicator = get_node(cooldown_indicator_path) as TextureProgress
	cooldown_text = get_node(cooldown_text_path) as Label
	
	_stack_counter = get_node(stack_counter) as Label
	
	button.connect("pressed", self, "_on_button_pressed")
	
#func _exit_tree():
#	if item != null:
#		item.disconnect("stack_size_changed", self, "stack_size_changed")

func _process(delta : float) -> void:
	if cd == null and gcd < 0.001:
		set_process(false)
		hide_cooldown_timer()
		return
		
	if gcd > 0.001:
		gcd -= delta
		
		if gcd < 0:
			gcd = 0
		
	var value : float = gcd
		
	if cd != null and cd.remaining > value:
		value = cd.remaining
	
	set_cooldown_time(value) 

func set_cooldown_time(time : float) -> void:
	cooldown_indicator.value = time
	cooldown_text.text = str(int(time))

func show_cooldown_timer(max_time : float) -> void:
	if cooldown_indicator.visible and cooldown_indicator.max_value < max_time:
		cooldown_indicator.max_value = max_time
	
	if not cooldown_indicator.visible:
		cooldown_indicator.max_value = max_time
	
	cooldown_indicator.show()
	cooldown_text.show()
	
func hide_cooldown_timer() -> void:
	cooldown_indicator.hide()
	cooldown_text.hide()

func set_item_instance(pitem : ItemInstance) -> void:
	if item != null and item.item_template.stack_size > 1:
		item.disconnect("stack_size_changed", self, "stack_size_changed")
		_stack_counter.hide()
	
	item = pitem
	
	setup_icon()
	
	if item != null and item.item_template.stack_size > 1:
		item.connect("stack_size_changed", self, "stack_size_changed")
		_stack_counter.show()
		stack_size_changed(item)
	
func setup_icon() -> void:
	if (item == null):
		icon_rect.texture = null
	else:
		if (item.get_item_template() == null):
			icon_rect.texture = null
			return
			
		if item.item_template.use_spell != null:
			var spell : Spell = item.item_template.use_spell
			spell_id = spell.spell_id
			has_gcd = spell.cooldown_global_cooldown
		else:
			spell_id = 0
			has_gcd = false
			
		icon_rect.texture = item.item_template.icon
		
		
	
func _on_button_pressed() -> void:
	#if spell_id != 0:
	#	player.crequest_spell_cast(button_entry.item_id)
	pass
		
func set_button_entry_data(ii : ItemInstance) -> void:
	if item != null and item.item_template.stack_size > 1:
		item.disconnect("stack_size_changed", self, "stack_size_changed")
		_stack_counter.hide()
	
	item = ii
	
	setup_icon()
	
	if item != null and item.item_template.stack_size > 1:
		item.connect("stack_size_changed", self, "stack_size_changed")
		_stack_counter.show()
		stack_size_changed(item)
	
func stack_size_changed(ii : ItemInstance) -> void:
	_stack_counter.text = str(ii.stack_size)
	
func get_drag_data(pos: Vector2) -> Object:
	if item == null:
		return null

	var tr = TextureRect.new()
	tr.texture = icon_rect.texture
	tr.expand = true
	
	tr.rect_size = icon_rect.rect_size
	set_drag_preview(tr)

	var esd = ESDragAndDrop.new()

	esd.origin = self
	esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM
	esd.item_id = slot_id
	
	setup_icon()

	return esd

func can_drop_data(pos, data) -> bool:
	return (data.is_class("ESDragAndDrop") and (data.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM or
			 data.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM))


func drop_data(pos, esd) -> void:
	if esd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM:
		player.crequest_item_swap(slot_id, esd.item_id)
		setup_icon()
	elif esd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM:
		player.crequest_equip(esd.item_id, slot_id)
		setup_icon()

func set_slot_id(pslot_id : int) -> void:
	slot_id = pslot_id

func set_player(p_player: Entity) -> void:
	if not player == null:
		player.disconnect("ccooldown_added", self, "_ccooldown_added")
		player.disconnect("ccooldown_removed", self, "_ccooldown_removed")
		
		player.disconnect("cgcd_started", self, "_cgcd_started")
		player.disconnect("cgcd_finished", self, "_cgcd_finished")
		
		player = null

	player = p_player

	if player == null:
		return

#	for i in range(player.getc_cooldown_count()):
#		var cooldown : Cooldown = player.getc_cooldown(i)

	player.connect("ccooldown_added", self, "_ccooldown_added")
	player.connect("ccooldown_removed", self, "_ccooldown_removed")
	
	player.connect("cgcd_started", self, "_cgcd_started")
	player.connect("cgcd_finished", self, "_cgcd_finished")


func _ccooldown_added(cooldown : Cooldown) -> void:
	if cooldown.spell_id == spell_id:
		cd = cooldown
		set_process(true)
		show_cooldown_timer(cooldown.remaining)

func _ccooldown_removed(cooldown : Cooldown) -> void:
	if cooldown.spell_id == spell_id:
		cd = null
	
func _cgcd_started(value :float) -> void:
	if not has_gcd:
		return
	
	gcd = value
	show_cooldown_timer(value)
	set_process(true)
	
func _cgcd_finished() -> void:
	gcd = 0
	
func _pressed():
	if _tooltip != null and item != null:
		var pos : Vector2 = rect_global_position
		pos.x += rect_size.x
		
		_tooltip.set_item(item)
		_tooltip.popup(Rect2(pos, _tooltip.rect_size))
#		_tooltip.pac
	
func set_tooltip_node(tooltip : Popup) -> void:
	_tooltip = tooltip
