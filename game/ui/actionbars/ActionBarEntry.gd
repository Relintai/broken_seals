extends Button

# Copyright (c) 2019 Péter Magyar
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

export (NodePath) var button_path : NodePath
export (NodePath) var icon_path : NodePath
export (NodePath) var cooldown_indicator_path : NodePath
export (NodePath) var cooldown_text_path : NodePath
export (NodePath) var keybind_text_path : NodePath

var button : Button
var icon_rect : TextureRect
var cooldown_indicator : TextureProgress
var cooldown_text : Label
var keybind_text : Label

var button_entry : ActionBarButtonEntry
var player : Entity

var spell_id : int = 0
var spell_type : int = 0

var cd : Cooldown = null
var categ_cd : CategoryCooldown = null

var has_gcd : bool = false
var gcd : float = 0.0

func _ready() -> void:
	button = get_node(button_path) as Button
	icon_rect = get_node(icon_path) as TextureRect
	
	cooldown_indicator = get_node(cooldown_indicator_path) as TextureProgress
	cooldown_text = get_node(cooldown_text_path) as Label
	keybind_text = get_node(keybind_text_path) as Label
	
	button.connect("pressed", self, "_on_button_pressed")

func _exit_tree():
	if icon_rect.texture != null:
		ThemeAtlas.unref_texture(icon_rect.texture)

func _process(delta : float) -> void:
	if cd == null and categ_cd == null and gcd < 0.001:
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
		
	if categ_cd != null and categ_cd.remaining > value:
		value = categ_cd.remaining
	
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

func set_button_entry(action_bar_button_entry: ActionBarButtonEntry, p_player: Entity) -> void:
	player = p_player

	button_entry = action_bar_button_entry
	
	var iea : InputEventAction = InputEventAction.new()
	
	var action_name : String = "actionbar_" + str(action_bar_button_entry.action_bar_id) + "_" + str(action_bar_button_entry.slot_id)
	
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
		
	var action_list : Array = InputMap.get_action_list(action_name)
	
	for action in action_list:
		if action is InputEventKey:
			var s : String = ""
			
			if action.shift:
				s += "S-"
				
			if action.alt:
				s += "A-"
			
			if action.control:
				s += "C-"
				
			if action.command:
				s += "Co-"
			
			if action.meta:
				s += "M-"
			
			s += char(action.scancode)
			
			keybind_text.text = s
	
	iea.action = action_name
	iea.pressed = true
	var sc : ShortCut = ShortCut.new()
	sc.shortcut = iea
	shortcut = sc
	
	setup_icon()
	
func setup_icon() -> void:
	if (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_NONE):
		if icon_rect.texture != null:
			ThemeAtlas.unref_texture(icon_rect.texture)
		
		icon_rect.texture = null
	elif (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_SPELL):
		if (button_entry.item_id == 0):
			if icon_rect.texture != null:
				ThemeAtlas.unref_texture(icon_rect.texture)
		
			icon_rect.texture = null
			return
			
		if icon_rect.texture != null:
			ThemeAtlas.unref_texture(icon_rect.texture)
			icon_rect.texture = null
			
		var spell = Entities.get_spell(button_entry.item_id)
		
		if spell.icon != null:
			icon_rect.texture = ThemeAtlas.add_texture(spell.icon)
#			icon_rect.texture = spell.icon
		
		spell_id = spell.id
		spell_type = spell.spell_type
		has_gcd = spell.cooldown_global_cooldown
	
func _on_button_pressed() -> void:
	if (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_SPELL):
		if (button_entry.item_id == 0):
			return
			
		player.crequest_spell_cast(button_entry.item_id)
		
func set_button_entry_data(type: int, item_id: int) -> void:
	button_entry.type = type
	button_entry.itekm_id = item_id

	setup_icon()
	
func get_drag_data(pos: Vector2) -> Object:
	if (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_NONE):
		return null
		
	if player.actionbar_locked:
		return null

	var tr = TextureRect.new()
	tr.texture = icon_rect.texture
	tr.expand = true
	
	tr.rect_size = icon_rect.rect_size
	set_drag_preview(tr)

	var esd = ESDragAndDrop.new()
	
	if (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_SPELL):
		esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_SPELL
	elif (button_entry.type == ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_ITEM):
		esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_ITEM

	esd.item_id = button_entry.item_id

	button_entry.type = ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_NONE
	button_entry.item_id = 0
	
#	Profiles.save()
	
	setup_icon()

	return esd

func can_drop_data(pos, data) -> bool:
	return data.is_class("ESDragAndDrop")


func drop_data(pos, esd) -> void:
	if (esd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_SPELL):
		button_entry.type = ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_SPELL
	elif (esd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_ITEM):
		button_entry.type = ActionBarButtonEntry.ACTION_BAR_BUTTON_ENTRY_TYPE_ITEM

	button_entry.item_id = esd.item_id

	setup_icon()
	
func set_player(p_player: Entity) -> void:
	if not player == null:
		player.disconnect("ccooldown_added", self, "_ccooldown_added")
		player.disconnect("ccooldown_removed", self, "_ccooldown_removed")
		player.disconnect("ccategory_cooldown_added", self, "_ccategory_cooldown_added")
		player.disconnect("ccategory_cooldown_removed", self, "_ccategory_cooldown_removed")
		
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
	player.connect("ccategory_cooldown_added", self, "_ccategory_cooldown_added")
	player.connect("ccategory_cooldown_removed", self, "_ccategory_cooldown_removed")
	
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
	
func _ccategory_cooldown_added(cooldown : CategoryCooldown) -> void:
	if cooldown.category_id == spell_type:
		categ_cd = cooldown
		set_process(true)
		show_cooldown_timer(cooldown.remaining)
	
func _ccategory_cooldown_removed(cooldown : CategoryCooldown) -> void:
	if cooldown.category_id == spell_type:
		categ_cd = null
		
	
func _cgcd_started(value :float) -> void:
	if not has_gcd:
		return
	
	gcd = value
	show_cooldown_timer(value)
	set_process(true)
	
func _cgcd_finished() -> void:
	gcd = 0
